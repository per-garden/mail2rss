require 'spec_helper'

describe 'messages/index.rss.builder', type: :view do
  context "with 1 message" do
    before(:each) do
      # Must be named exactly @messages as in view rendered!
      @messages = [create(:message)]
    end

    it 'renders message as rss' do
      render
      expect(rendered).to include('<rss version="2.0">')
      expect(rendered).to include("<title>#{@messages.first.subject}</title>")
      expect(rendered).to include("<author>#{@messages.first.from}</author>")
      expect(rendered).to include("<pubDate>#{@messages.first.updated_at.to_s(:rfc822)}</pubDate>")
      expect(rendered).to include("<description>#{@messages.first.body}</description>")
    end

    after(:each) do
      Message.destroy_all
    end
  end
end
