class AddCategoryToRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :category, :integer, default: 0
  end
end
