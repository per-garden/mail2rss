class MessagesController < ApplicationController
  def index
    ActionController::Parameters.permit_all_parameters = true
    @message = Message.instance
    respond_to do |format|
      format.rss { render layout: false }
    end
  end
end
