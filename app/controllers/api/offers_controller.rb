# frozen_string_literal: true

class Api::OffersController < ApplicationController
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :render_offer_error

  def create
    offer = current_user.offers.create(offer_parameters)
    if offer.persisted?
      offer.append_message(params[:message]) if params[:message]
      render json: { message: 'Your offer has been sent!' }
    else
      render json: { message: offer.errors.full_messages.join('. ') }, status: 422
    end
  rescue StandardError => e
    render json: { message: e.message }, status: 422
  end

  def update
    if params[:activity] === "accepted" || params[:activity] === "declined"
      offer = Offer.find(params[:id])
      offer.update(status: params[:activity])
      render json: { offer: offer.id, message: "You #{offer.status} help from #{offer.helper.uid}" }
    else
      render_offer_error('The activty is not valid')
    end
  rescue StandardError => e
    render_offer_error(e)
  end

  def show
    offer = current_user.offers.find(params[:id])
    render json: { offer: offer, status_message: set_status_message(offer.status) }
  end

  private

  def set_status_message(activity)
    case activity
    when 'pending'
      'Your offer is pending'
    when 'accepted'
      'Your offer has been accepted'
    when 'declined'
      'Your offer has been declined'
    end
  end

  def render_offer_error(error)
    error_message = error.try(:message) || error
    render json: { error_message: error_message }, status: 500
  end

  def offer_parameters
    params.permit(:request_id)
  end
end
