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

  it 'fetches email' do
    Pony.mail(@mail)
    sleep(Rails.application.config.mailman[:poll_interval].to_i * 2)
    expect(Message.instance.body).to eq(@mail[:body])
  end

  after(:all) do
    @smtp_server.kill
    @pop_server.kill
  end
end
