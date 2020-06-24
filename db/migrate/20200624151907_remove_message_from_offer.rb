class RemoveMessageFromOffer < ActiveRecord::Migration[6.0]
  def change
    remove_column :offers, :message
  end
end
