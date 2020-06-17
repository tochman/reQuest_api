# frozen_string_literal: true

class AddKarmaPointsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :karma_points, :integer, default: 100
  end
end
