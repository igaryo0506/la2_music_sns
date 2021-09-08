class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :name
      t.string :artist
      t.string :album
      t.string :comment
      t.string :image_url
      t.string :preview_url
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
