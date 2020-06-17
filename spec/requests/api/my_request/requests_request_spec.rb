require 'rails_helper'

RSpec.describe "Api::MyRequest::Requests", type: :request do

  describe "GET /update" do
    it "returns http success" do
      get "/api/my_request/requests/update"
      expect(response).to have_http_status(:success)
    end
  end

end
