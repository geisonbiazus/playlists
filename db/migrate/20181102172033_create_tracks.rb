class CreateTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :tracks do |t|
      t.string :title
      t.string :interpret
      t.string :album
      t.string :track
      t.string :year
      t.string :genre

      t.timestamps
    end
  end
end
