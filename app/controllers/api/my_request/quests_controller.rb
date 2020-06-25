# frozen_string_literal: true

class Api::MyRequest::QuestsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    pending = current_user.offers.where(status: 'pending').map(&:request)
    accepted_and_completed = current_user.offers.where(status: 'accepted').map(&:request)
    quests = pending + accepted_and_completed

    if quests.empty?
      render json: { message: 'There are no quests to show' }, status: 404
    else
      render json: quests, each_serializer: MyRequest::Quest::IndexSerializer, root: 'quests'
    end
  end
end
