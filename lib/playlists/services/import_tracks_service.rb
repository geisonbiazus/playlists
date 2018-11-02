module Playlists
  module Services
    class ImportTracksService
      def initialize(track_repository)
        @track_repository = track_repository
      end

      def run(csv)
        CSV.parse(csv, headers: true) do |line|
          track = new_track(line)
          add_or_update_track(track)
        end
      end

      private

      def add_or_update_track(track)
        @track_repository.create(track)
      rescue Repositories::TrackRepository::TrackAlreadyExistsError
        @track_repository.update(track)
      end

      def new_track(line)
        Entities::Track.new(id: line[0].to_i,
                            title: line[1],
                            interpret: line[2],
                            album: line[3],
                            track: line[4],
                            year: line[5],
                            genre: line[6])
      end
    end
  end
end
