describe MessagesController, :type => :controller do 
  describe "GET" do

    it 'routes to messages index' do
      expect(get: root_url).to route_to(controller: 'messages', action: 'index', format: 'rss')
    end

  end
end
