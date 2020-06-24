RSpec.describe 'POST /message users can post messages' do
  let(:requester) { create(:user, email: 'requester@mail.com') }
  let(:req_creds) { requester.create_new_auth_token }
  let(:req_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(req_creds) }

  let(:helper) { create(:user) }
  let(:helper_credentials) { helper.create_new_auth_token }
  let(:helper_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(helper_credentials) }

  let(:third_user) { create(:user) }
  let(:third_user_credentials) { third_user.create_new_auth_token }
  let(:third_user_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(third_user_credentials) }
  
  let(:request) { create(:request, requester: requester) }
  let(:offer) { create(:offer, request: request, helper: helper) }

  let(:message) { create(:message, conversation: offer.conversation, sender) }


end