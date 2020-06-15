class CreateQuests < ActiveRecord::Migration[6.0]
  def change
    create_table :quests do |t|
      t.string :title, :null => false
      t.text :description, :null => false
      t.belongs_to :requester, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
