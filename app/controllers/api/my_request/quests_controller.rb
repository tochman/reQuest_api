# frozen_string_literal: true

class Api::MyRequest::QuestsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  def index
    quests = Request.where(helper: current_user).order('id DESC')
    if quests == []
      render json: { message: 'There are no quests to show' }, status: 404
    else
      render json: quests, each_serializer: MyRequest::Quest::IndexSerializer, root: 'quests'
    end
  end
end
