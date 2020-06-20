# frozen_string_literal: true

class Api::MyRequest::RequestsController < ApplicationController
  before_action :authenticate_user!, only: %i[index show create update]
  before_action :karma?, only: [:create]
  rescue_from ArgumentError, with: :render_error_message
  rescue_from StandardError, with: :render_error_message

  def index
    requests = Request.where(requester: current_user).order('id DESC')
    if requests == []
      render json: { message: 'There are no reQuests to show' }, status: 404
    else
      render json: requests, each_serializer: MyRequest::Request::IndexSerializer
    end
 end

  def show
    request = Request.find(show_params[:id])
    request.is_requested_by?(current_user)
    render json: request, serializer: MyRequest::Request::ShowSerializer
  end

  def create
    request = current_user.requests.create(create_params)
    if request.persisted?
      karma_left = update_karma
      render json: { message: 'Your reQuest was successfully created!', id: request.id, karma_points: karma_left }
    else
      render_error_message(request.errors)
    end
  end

  def update
    request = Request.find(update_params[:id])
    request.is_requested_by?(current_user) && request.send("#{update_params[:activity]}!".to_sym)
    render json: { message: 'reQuest completed!' }
  end

  private

  def update_karma
    Api::KarmaPointsController.update_karma(create_params, current_user)
  end

  def karma?
    unless (current_user.karma_points - create_params[:reward].to_i >= 0)
      render json: { message: 'You dont have enough karma points' }, status: 422
    end
  end

  def render_error_message(errors)
    if !errors.class.method_defined?(:full_messages)
      error_message = errors.message
    else
      error_message = errors.full_messages.to_sentence
    end

    render json: { message: error_message }, status: 422
  end

  def show_params
    params.permit(:id)
  end

  def create_params
    params.permit(:title, :description, :reward, :category)
  end

  def update_params
    params.permit(:activity, :id)
  end
end
