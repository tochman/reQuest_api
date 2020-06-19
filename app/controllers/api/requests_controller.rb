# frozen_string_literal: true

class Api::RequestsController < ApplicationController
  def index
    requests = Request.all.order('id DESC')
    render json: requests, each_serializer: Request::IndexSerializer
  end
end
