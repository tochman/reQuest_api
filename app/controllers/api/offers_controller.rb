# frozen_string_literal: true

class Api::OffersController < ApplicationController
  before_action :authenticate_user!

  def create
    offer = Offer.create(check_and_lump_parameters)
    if offer.persisted?
      render json: { message: 'Your offer has been sent!' }
    else
      render json: { message: offer.errors.messages.to_a.flatten.join(' ').capitalize }, status: 422
    end
  rescue StandardError => e
    render json: { message: e.message }, status: 422
  end

  private

  def check_and_lump_parameters
    target_request = Request.find(params[:request_id])
    if target_request.requester == current_user
      raise StandardError, 'You cannot offer help on your own request!'
    end

    { helper: current_user, request: target_request, message: params[:message] }
  end
d
