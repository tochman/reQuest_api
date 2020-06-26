class Api::MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    message = Offer.find(params[:offer_id]).conversation
         .messages.create(content: params[:content], sender: current_user)
    if message.persisted?
      # ActionCable.server.broadcast("offer_conversation_#{params[:offer_id]}", message: message.content )
      render status: :created
    else
      render_error_message(message.errors)
    end
  end
end
