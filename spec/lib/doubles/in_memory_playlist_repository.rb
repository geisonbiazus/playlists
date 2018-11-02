class InMemoryPlaylistRepository < Playlists::Repositories::PlaylistRepository
  def initialize
    @data = {}
  end

  def create(playlist)
    if @data[playlist.id]
      raise Playlists::Repositories::PlaylistRepository::PlaylistAlreadyExistsError
    end
    @data[playlist.id] = playlist
  end

  def update(playlist)
    @data[playlist.id] = playlist
  end

  def all
    @data.values
  end

  def find_all_by_user_id(user_id)
    @data.values.find_all do |playlist|
      playlist.user.id == user_id
    end
  end
end
