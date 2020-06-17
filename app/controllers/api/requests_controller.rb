# frozen_string_literal: true

class Api::RequestsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    request = current_user.requests.create(request_params)
    if request.persisted?
      render json: { message: 'Your reQuest was successfully created!', id: request.id }
    else
      render json: { message: request.errors.messages.to_a.flatten.join(' ').capitalize }, status: 422
    end
  rescue ActionController::UnpermittedParameters => e
    render json: { message: e.message }, status: 422
  end

  def index
    requests = Request.all.order('id DESC')
    render json: requests, each_serializer: Request::IndexSerializer
  end

  private

  def request_params
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
    params.permit(:title, :description)
  end
end
