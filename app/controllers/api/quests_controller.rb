class Api::QuestsController < ApplicationController
  before_action :authenticate_user!

  def create
    check_create_params
    current_user.quests.create(title: params[:title], description: params[:description])
  end

  private
  
  def check_create_params
  
  end
end
