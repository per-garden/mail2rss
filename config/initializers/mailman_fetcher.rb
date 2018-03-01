unless File.basename($0) == 'rake'
  Mailman.config.poll_interval = Rails.application.config.mailman[:poll_interval]
  Mailman.config.pop3 = Rails.application.config.mailman[:pop3]
  MailmanFetchJob.start

  at_exit do
    MailmanFetchJob.shutdown
  end
end
