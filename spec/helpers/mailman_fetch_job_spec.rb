require 'spec_helper'
require 'smtp_server'
require 'pop_server'

describe MailmanFetchJob, :type => :helper do
  before(:all) do
    $log = Logger.new('log/post_office.log')
    smtp = Rails.application.config.post_office[:smtp]
    @smtp_server = Thread.new{ SMTPServer.new(smtp) }
    @pop_server = Thread.new{ POPServer.new(Rails.application.config.mailman[:pop3][:port]) }
    @mail = {}
    @mail[:to] = Faker::Internet.email
    @mail[:from] = Faker::Internet.email
    @mail[:subject] = Faker::Hacker.adjective.capitalize + ' ' + Faker::Hacker.noun
    @mail[:body] = Faker::Hacker.say_something_smart
    @mail[:via] = 'smtp'
    @mail[:via_options] = {address: 'localhost', port: smtp}
  end

  before(:each) do
    Rails.application.config.mailman[:senders] = []
    Rails.application.config.mailman[:subjects] = []
  end

  it 'stores any message if no restrictions' do
    Pony.mail(@mail)
    sleep(Rails.application.config.mailman[:poll_interval].to_i * 2)
    expect(Message.instance.body).to eq(@mail[:body])
  end

  it 'stores message complying with restrictions' do
    sender = "#{@mail[:from]}"
    subject = "#{@mail[:subject]}"
    Rails.application.config.mailman[:senders] = [sender]
    Rails.application.config.mailman[:subjects] = [subject]
    Pony.mail(@mail)
    sleep(Rails.application.config.mailman[:poll_interval].to_i * 2)
    expect(Message.instance.body).to eq(@mail[:body])
  end

  it 'it does not store message if sender is not on the non-empty list of senders' do
    sender = "not_#{@mail[:from]}"
    Rails.application.config.mailman[:senders] = [sender]
    Pony.mail(@mail)
    sleep(Rails.application.config.mailman[:poll_interval].to_i * 2)
    expect(Message.instance.body).not_to eq(@mail[:body])
  end

  it 'it does not store message if subject is not on the non-empty list of subjects' do
    subject = "not_#{@mail[:subject]}"
    Rails.application.config.mailman[:subjects] = [subject]
    Pony.mail(@mail)
    sleep(Rails.application.config.mailman[:poll_interval].to_i * 2)
    expect(Message.instance.body).not_to eq(@mail[:body])
  end

  after(:each) do
    Message.instance.destroy!
  end

  after(:all) do
    @smtp_server.kill
    @pop_server.kill
  end
end
