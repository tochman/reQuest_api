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
      actual_error = []
      errors.full_messages.each { |message| actual_error << message.split.first }
      error = errors.full_messages.first.split(' ')[1..-1].join(' ')
      error_message = error.insert(0, "#{actual_error.join(', ')} ")

    end
    render json: { message: error_message }, status: 422
  end

  def request_params
    params.permit(:title, :description, :reward)
  end
end
