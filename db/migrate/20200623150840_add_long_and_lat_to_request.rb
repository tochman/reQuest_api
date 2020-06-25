class AddLongAndLatToRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :long, :float, null: false
    add_column :requests, :lat, :float, null: false
  end
end
