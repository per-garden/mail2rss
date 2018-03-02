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
          sender = message.from.first
          subject = message.subject
          if (Rails.application.config.mailman[:senders].empty? || Rails.application.config.mailman[:senders].include?(sender)) && (Rails.application.config.mailman[:subjects].empty? || Rails.application.config.mailman[:subjects].include?(subject))
            begin
              m = Message.instance
              m.from = sender
              m.to = message.to.first
              m.subject = subject
              m.body = message.body.encoded
              m.save!
            rescue Exception => e
              Mailman.logger.error "Exception occurred while receiving message:n#{message}"
              Mailman.logger.error [e, *e.backtrace].join("n")
            end
          end
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

end
