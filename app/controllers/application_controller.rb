# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  around_action :check_for_unpermitted_params
  rescue_from ActionController::UnpermittedParameters, with: :unpermitted_parameters

  private

  def check_for_unpermitted_params
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def unpermitted_parameters(e)
    render json: { message: e.message }, status: 422
  end
end
