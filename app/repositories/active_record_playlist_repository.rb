class ActiveRecordPlaylistRepository < Playlists::Repositories::PlaylistRepository
  def create(playlist)
    Playlist.create(
      id: playlist.id,
      user_id: playlist.user.id,
      name: playlist.name,
      tracks: Track.find(playlist.tracks.map(&:id))
    )
  rescue ActiveRecord::RecordNotUnique
    raise Playlists::Repositories::PlaylistRepository::PlaylistAlreadyExistsError
  end

  def update(playlist)
    record = Playlist.find(playlist.id)
    record.update(
      user_id: playlist.user.id,
      name: playlist.name,
      tracks: Track.find(playlist.tracks.map(&:id))
    )
  end

  def all
    Playlist.all.map { |record| self.class.initialize_playlist(record) }
  end

  def self.initialize_playlist(record)
    Playlists::Entities::Playlist.new(
      id: record.id,
      user: ActiveRecordUserRepository.initialize_user(record.user),
      name: record.name,
      tracks: record.tracks.map do |track|
        ActiveRecordTrackRepository.initialize_track(track)
      end
    )
  end
end
