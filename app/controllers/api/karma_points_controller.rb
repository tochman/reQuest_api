# frozen_string_literal: true

class Api::KarmaPointsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: { karma_points: current_user.karma_points }
  end
end
