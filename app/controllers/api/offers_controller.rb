class Api::OffersController < ApplicationController
  before_action :authenticate_user!

  def create
    target_request = Request.find(params[:request_id])
    offer = Offer.create(message: params[:message], helper: current_user, request: target_request)
    if offer.persisted?
      render json: { message: 'Your offer has been sent!' }
    else
      render json: { message: offer.errors.messages.to_a.flatten.join(' ').capitalize }, status: 422
    end
  rescue ActionController::UnpermittedParameters => e
    binding.pry
    render json: { message: e.message }, status: 422
  end
end
