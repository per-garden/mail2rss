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
    Rails.application.config.mailman[:bodies] = []
    Rails.application.config.mailman[:body_pre_filter] = ''
  end

  it 'stores any message if no restrictions' do
    Pony.mail(@mail)
    sleep(Rails.application.config.mailman[:poll_interval].to_i * 2)
    expect(Message.first.body).to eq(@mail[:body])
  end

  it 'stores message complying with restrictions' do
    sender = "#{@mail[:from]}"
    subject = "#{@mail[:subject]}"
    Rails.application.config.mailman[:senders] = [sender]
    Rails.application.config.mailman[:subjects] = [subject]
    Pony.mail(@mail)
    sleep(Rails.application.config.mailman[:poll_interval].to_i * 2)
    expect(Message.first.body).to eq(@mail[:body])
  end

  it 'it does not store message if sender is not on the non-empty list of senders' do
    sender = "not_#{@mail[:from]}"
    Rails.application.config.mailman[:senders] = [sender]
    Pony.mail(@mail)
    sleep(Rails.application.config.mailman[:poll_interval].to_i * 2)
    expect(Message.first ? Message.first.body : '').not_to eq(@mail[:body])
  end

  it 'it does not store message if subject is not on the non-empty list of subjects' do
    subject = "not_#{@mail[:subject]}"
    Rails.application.config.mailman[:subjects] = [subject]
    Pony.mail(@mail)
    sleep(Rails.application.config.mailman[:poll_interval].to_i * 2)
    expect(Message.first ? Message.first.body : '').not_to eq(@mail[:body])
  end

  it 'stores message if its body contains required string' do
    body = "#{@mail[:body]}"
    Rails.application.config.mailman[:bodies] = [body[0..5]]
    Pony.mail(@mail)
    sleep(Rails.application.config.mailman[:poll_interval].to_i * 2)
    expect(Message.first.body).to eq(@mail[:body])
  end

  it 'does not store message if its body does not contain required string' do
    body = "#{@mail[:body]}"
    Rails.application.config.mailman[:bodies] = [body[0..5].reverse]
    Pony.mail(@mail)
    sleep(Rails.application.config.mailman[:poll_interval].to_i * 2)
    expect(Message.first ? Message.first.body : '').not_to eq(@mail[:body])
  end

  it 'only stores message text after non-empty filter string' do
    body = "#{@mail[:body]}"
    filter = body[0..5]
    Rails.application.config.mailman[:body_pre_filter] = filter
    Pony.mail(@mail)
    sleep(Rails.application.config.mailman[:poll_interval].to_i * 2)
    expect(Message.first.body).not_to include(filter)
  end

  it 'stores one message for each accepted email' do
    Pony.mail(@mail)
    @mail[:subject] = Faker::Hacker.adjective.capitalize + ' ' + Faker::Hacker.noun
    @mail[:body] = Faker::Hacker.say_something_smart
    Pony.mail(@mail)
    sleep(Rails.application.config.mailman[:poll_interval].to_i * 2)
    expect(Message.count).to eq 2
  end

  it 'only stores the configured maximum number of messages' do
    Rails.application.config.messages[:count] = 2
    Pony.mail(@mail)
    @mail[:subject] = Faker::Hacker.adjective.capitalize + ' ' + Faker::Hacker.noun
    @mail[:body] = Faker::Hacker.say_something_smart
    Pony.mail(@mail)
    @mail[:subject] = Faker::Hacker.adjective.capitalize + ' ' + Faker::Hacker.noun
    @mail[:body] = Faker::Hacker.say_something_smart
    Pony.mail(@mail)
    sleep(Rails.application.config.mailman[:poll_interval].to_i * 2)
    expect(Message.count).to eq 2
  end

  after(:each) do
    Message.destroy_all
  end

  after(:all) do
    @smtp_server.kill
    @pop_server.kill
  end
end
