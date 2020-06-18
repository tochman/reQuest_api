class AddRewardToRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :reward, :integer
  end
end
