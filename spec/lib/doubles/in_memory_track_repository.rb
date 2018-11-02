class InMemoryTrackRepository < Playlists::Repositories::TrackRepository
  def initialize
    @data = {}
  end

  def find_all_by_id(ids)
    ids.map { |id| @data[id] }.compact
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
