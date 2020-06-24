class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.belongs_to :conversation, null: false, foreign_key: true
      t.text :content, null: false
      t.belongs_to :sender, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
