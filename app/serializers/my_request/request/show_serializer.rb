class MyRequest::Request::ShowSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :reward, :offers

  def offers
    offer_uids = []
    object.offers.each do |offer|
      helper = User.find(offer.helper_id)
      offer_uids << helper.uid
    end
    
    return offer_uids
  end
end