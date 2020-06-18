# frozen_string_literal: true

class Api::MyRequest::RequestsController < ApplicationController
  before_action :authenticate_user!, only: %i[update]

  def update
    request = Request.find(request_params[:id])
    request.is_requested_by?(current_user) && request.send("#{request_params[:activity]}!".to_sym)
    render json: {
      message: 'Request completed!'
    }
  rescue StandardError => e
    render json: {
      message: "Something went wrong: #{request.errors.any? ? request.errors.full_messages.to_sentence : e.message} "
    }, status: 422
  end

  private

  def request_params
    params.permit(:activity, :id)
  end
end
