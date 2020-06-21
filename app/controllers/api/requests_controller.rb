# frozen_string_literal: true

class Api::RequestsController < ApplicationController
  def index
    category = params[:category] || 'all'

    requests = if category == 'all'
                 Request.all.order('id DESC')
               else
                 Request.find(request_params).order('id DESC')
               end

    render json: requests, each_serializer: Request::IndexSerializer
  end

  private

  def request_params
    params.permit(:category)
  end
end
