# frozen_string_literal: true

class Api::MyRequest::QuestsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  def index; end
end
