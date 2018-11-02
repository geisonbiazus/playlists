module Playlists
  module Repositories
    class TrackRepository
      def create(_track)
        raise "Not implemented"
      end

      def update(_track)
        raise "Not implemented"
      end

      def all
        raise "Not implemented"
      end

      class TrackAlreadyExistsError < StandardError; end
    end
  end
end
