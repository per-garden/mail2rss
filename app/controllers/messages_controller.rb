class MessagesController < ApplicationController
  def index
    ActionController::Parameters.permit_all_parameters = true
    @messages = Message.all
    respond_to do |format|
      format.rss { render layout: false }
    end
  end
end
