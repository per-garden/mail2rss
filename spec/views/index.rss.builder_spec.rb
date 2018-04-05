require 'spec_helper'
require 'helpers/messages_spec_helper'

include MessagesSpecHelper

describe 'messages/index.rss.builder', type: :view do
  context "with 1 message" do
    before(:each) do
      # Must be named exactly @message as in view rendered!
      @message = build_message
    end

    it 'renders message as rss' do
      render
      expect(rendered).to include('<rss version="2.0">')
      expect(rendered).to include("<title>#{@message.subject}</title>")
      expect(rendered).to include("<author>#{@message.from}</author>")
      expect(rendered).to include("<pubDate>#{@message.updated_at.to_s(:rfc822)}</pubDate>")
      expect(rendered).to include("<description>#{@message.body}</description>")
    end

    after(:each) do
      @message.destroy!
    end
  end
end
