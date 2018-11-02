class ActiveRecordTrackRepository < Playlists::Repositories::TrackRepository
  def create(track)
    Track.create(
      identifier: track.id,
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
    record = Track.find_by(identifier: track.id)
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
    Track.all.map { |record| initialize_track(record) }
  end

  private

  def initialize_track(record)
    Playlists::Entities::Track.new(
      id: record.identifier,
      title: record.title,
      interpret: record.interpret,
      album: record.album,
      track: record.track,
      year: record.year,
      genre: record.genre
    )
  end
end
