class MailmanFetchJob
  include Celluloid

  @@job = MailmanFetchJob.new

  def self.start
    @@job.async.run
  end

  def self.shutdown
    # Block caller while letting job task finish what it is doing
    @@job.stop
    # Synchronously terminate
    @@job.terminate
  end

  # Work task to be run asynchronously
  def run
    @keep_running = true

    while @keep_running
      Mailman::Application.run do
        default do
          sender = message.from ? message.from.first : ''
          subject = message.subject
          Feed.all.each do |feed|
            if (!feed.senders || feed.senders.empty? || feed.senders.include?(sender)) && (!feed.subjects || feed.subjects.empty? || feed.subjects.include?(subject))
              begin
                body = Mailman::Application.ascii8bit_to_iso88591(message.body.decoded).force_encoding('UTF-8')
                body = body.include?('quoted-printable') ? body.split('quoted-printable')[1] : body
                bodied = !feed.bodies || feed.bodies.empty?
                unless bodied
                  feed.bodies.each do |bd|
                    bodied ||= body.include?(bd)
                  end
                end
                if bodied
                  m = Message.new
                  m.from = sender
                  m.to = message.to.first
                  m.subject = subject.to_s.force_encoding('UTF-8')
                  filter = feed.body_pre_filter
                  if filter.blank?
                    m.body = body
                  else
                    # Message is everything after filter
                    filter = '.*' + filter
                    m.body = body.gsub(/#{filter}/, '')
                  end
                  Message.count < feed.count ? nil : Message.order(created_at: :asc).first.destroy!
                  m.feed = feed
                  m.save!
                end
              rescue Exception => e
                Mailman.logger.error "Exception occurred while receiving message:n#{message}"
                Mailman.logger.error [e, *e.backtrace].join("n")
              end
            end
          end # Feed.all.each
        end
      end
    end
    @running = false
  end

  # Block caller until work task in run method finished
  def stop
    @keep_running = false
    while @running
      #
    end
  end

  Mailman::Application.class_eval do
    # In horrendous encoding hell, expected UTF-8 is in fact ASCII-8BIT
    # Here we assume ISO-8859-1 origin (Western European)
    def self.ascii8bit_to_iso88591(s)
      retval = s.gsub(/.C3.85/, 'ä')
      retval.gsub!(/.C3.84/, 'ä')
      retval.gsub!(/.C3.A5/, 'å')
      retval.gsub!(/.C3.96/, 'ö')
      retval.gsub!(/.C3.9C/, 'ü')
      retval.gsub!(/.C3.89/, 'é')
      retval.gsub!(/.C3.A4/, 'ä')
      retval.gsub!(/.C3.A5/, 'å')
      retval.gsub!(/.C3.B6/, 'ö')
      retval.gsub!(/.C3.BC/, 'ü')
      retval.gsub!(/.C3.A9/, 'é')
      # Drop line breaks
      retval.gsub!(/=\n/, '')
      retval.gsub!(/\n\n/, '')
      retval
    end
  end

end
