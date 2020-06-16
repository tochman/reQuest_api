# frozen_string_literal: true

class Api::KarmaPointsController < ApplicationController
  before_action :authenticate_user!

  def show
    request = Request.find(params[:id])
    if enought_karma(request.reward)
      render json: { karma_points: true }
    else
      render json: { karma_points: false }, status: 422
    end
  end

  private

  def enought_karma(reward)
    (current_user.karma_points - reward).positive? || (current_user.karma_points - reward) == 0
  end
end
