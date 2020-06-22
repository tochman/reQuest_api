# frozen_string_literal: true

class Api::KarmaPointsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: { karma_points: current_user.karma_points }
  end

  def self.update_karma(request, user)
    user.karma_points -= request[:reward].to_i
    user.save
    return user.karma_points
  end
end
