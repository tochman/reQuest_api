# frozen_string_literal: true

class AddStatusToRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :status, :integer, default: 0
  end
end
