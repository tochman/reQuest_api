class MyRequest::Request::ShowSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :reward, :offers

  def offers
    offers_response = []
    object.offers.each do |offer|
      helper = User.find(offer.helper_id)
      offers_response << { email: helper.email } 
    end
    
    return offers_response
  end
end