# frozen_string_literal: true

class Api::RequestsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :karma?, only: [:create]

  def create
    request = current_user.requests.create(request_params)
    if request.persisted?
      render json: { message: 'Your reQuest was successfully created!', id: request.id }
    else
      render_error_message(request.errors)
    end
  end

  def index
    requests = Request.all
    render json: { requests: requests.map { |req| Request::IndexSerializer.new(req) } }
  end

  private

  def karma?
    unless (current_user.karma_points - request_params[:reward].to_i).positive? || (current_user.karma_points - request_params[:reward].to_i == 0)
      render json: { message: 'You dont have enough karma points' }, status: 422
    end
  end

  def render_error_message(errors)
    if errors.full_messages.one?
      error_message = errors.full_messages.to_sentence
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
