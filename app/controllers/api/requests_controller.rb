# frozen_string_literal: true

class Api::RequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    request = current_user.requests.create(request_params)
    if request.persisted?
      render json: { message: 'Your reQuest was successfully created!', id: request.id }
    else
      render_error_message(request.errors)
    end
  end

  private

  def render_error_message(errors)
    if errors.full_messages.one?
      error_message = errors.full_messages.first
    else
      second_error = errors.full_messages[1].split.first
      error_message = errors.full_messages.first.insert(0, "#{second_error}, ")
    end
    render json: { message: error_message }, status: 422
  end

  def request_params
    params.permit(:title, :description, :reward)
  end
end
