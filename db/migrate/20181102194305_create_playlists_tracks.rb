class CreatePlaylistsTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :playlists_tracks do |t|
      t.belongs_to :playlist, index: true
      t.belongs_to :track, index: true
    end

    add_foreign_key :playlists_tracks, :playlists
    add_foreign_key :playlists_tracks, :tracks
  end
end
