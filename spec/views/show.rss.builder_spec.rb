require 'spec_helper'

describe 'feeds/show.rss.builder', type: :view do
  context "with 1 message" do
    before(:each) do
      @feed  = create(:feed)
      @feed.messages << create(:message)
    end

    it 'renders feed containing message as rss' do
      render
      expect(rendered).to include('<rss version="2.0">')
      expect(rendered).to include("<title>#{@feed.messages.first.subject}</title>")
      expect(rendered).to include("<author>#{@feed.messages.first.from}</author>")
      expect(rendered).to include("<pubDate>#{@feed.messages.first.updated_at.to_s(:rfc822)}</pubDate>")
      expect(rendered).to include("<description>#{@feed.messages.first.body}</description>")
    end

    after(:each) do
      @feed.destroy
    end
  end
end
