class Relationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :following_id
      t.integer :followed_id
      t.timestamps null: false
    end
  end
end
