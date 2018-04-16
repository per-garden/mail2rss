require 'rails_helper'

RSpec.describe FeedsController, type: :controller do

  it 'routes to list of feeds index' do
    expect(get: root_url).to route_to(controller: 'feeds', action: 'index')
  end

  it 'routes to specific feed' do
    
  end

end
