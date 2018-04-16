class FeedsController < ApplicationController
  def index
    ActionController::Parameters.permit_all_parameters = true
    @feeds = Feed.all
  end

  def show
    name = params[:name]
    @feed = name ? Feed.find_by_name(name) : nil
  end
end
