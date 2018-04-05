require 'rails_helper'
require 'helpers/messages_spec_helper'

include MessagesSpecHelper

RSpec.describe Message, type: :model do
  before(:each) do
    build_message
  end

  it "has a valid instance" do
    expect(Message.instance).to be_valid
  end

  after(:each) do
    Message.instance.destroy!
  end

end
