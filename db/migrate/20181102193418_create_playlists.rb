class CreatePlaylists < ActiveRecord::Migration[5.2]
  def change
    create_table :playlists do |t|
      t.belongs_to :user, index: true
      t.string :name

      t.timestamps
    end

    add_foreign_key :playlists, :users
  end
end
