# frozen_string_literal: true

class Api::RequestsController < ApplicationController
  def index
    category = params[:category] || 'all'

    requests = if category == 'all'
                 Request.where(status: "pending").order('id DESC')
               else
                 Request.where(*request_params, status: "pending").order('id DESC')
               end

    render json: requests, each_serializer: Request::IndexSerializer, coordinates: check_coordinates
  end

  private

  def request_params
    params.permit(:category)
  end

  def check_coordinates
    ok = params[:coordinates] &&
         params[:coordinates][:lat] &&
         params[:coordinates][:long]
    return nil unless ok
    lat = params[:coordinates][:lat].to_f
    long = params[:coordinates][:long].to_f
    ok = lat >= -90 &&
         lat <= 90 &&
         long >= -180 &&
         long <= 180
    return nil unless ok

    [lat, long]
  end
end
