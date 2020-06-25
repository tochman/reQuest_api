# frozen_string_literal: true

class Api::MyRequest::QuestsController < ApplicationController
  before_action :authenticate_user!, only: %i[index show]
  def index
    quests = Request.where(helper: current_user).order('id DESC')
    if quests == []
      render json: { message: 'There are no quests to show' }, status: 404
    else
      render json: quests, each_serializer: MyRequest::Quest::IndexSerializer, root: 'quests'
    end
  end

  def show
    quest = Request.find(params[:id])
    quest.validate_quester(current_user)
    render json: quest, serializer: MyRequest::Quest::ShowSerializer, root: 'quest'
  end
end
