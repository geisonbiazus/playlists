class InMemoryTrackRepository < Playlists::Repositories::TrackRepository
  def initialize
    @data = {}
  end

  def create(track)
    if @data[track.id]
      raise Playlists::Repositories::TrackRepository::TrackAlreadyExistsError
    end
    @data[track.id] = track
  end

  def update(track)
    @data[track.id] = track
  end

  def all
    @data.values
  end
end
