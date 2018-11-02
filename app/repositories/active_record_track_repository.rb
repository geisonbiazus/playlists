class ActiveRecordTrackRepository < Playlists::Repositories::TrackRepository
  def find_all_by_id(ids)
    Track.where(id: ids).map do |record|
      self.class.initialize_track(record)
    end
  end

  def create(track)
    Track.create(
      id: track.id,
      title: track.title,
      interpret: track.interpret,
      album: track.album,
      track: track.track,
      year: track.year,
      genre: track.genre
    )
  rescue ActiveRecord::RecordNotUnique
    raise Playlists::Repositories::TrackRepository::TrackAlreadyExistsError
  end

  def update(track)
    record = Track.find(track.id)
    record.update(
      title: track.title,
      interpret: track.interpret,
      album: track.album,
      track: track.track,
      year: track.year,
      genre: track.genre
    )
  end

  def all
    Track.all.map { |record| self.class.initialize_track(record) }
  end

  def self.initialize_track(record)
    Playlists::Entities::Track.new(
      id: record.id,
      title: record.title,
      interpret: record.interpret,
      album: record.album,
      track: record.track,
      year: record.year,
      genre: record.genre
    )
  end
end
