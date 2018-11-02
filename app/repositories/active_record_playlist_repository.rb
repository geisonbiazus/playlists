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
    initialize_playlists(Playlist.all)
  end

  def find_all_by_user_id(user_id)
    initialize_playlists(
      Playlist.where(user_id: user_id).includes(:tracks, :user).order(:id)
    )
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

  private

  def initialize_playlists(records)
    records.map { |record| self.class.initialize_playlist(record) }
  end
end
