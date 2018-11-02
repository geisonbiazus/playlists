module Playlists
  module Repositories
    class PlaylistRepository
      def create(_playlist)
        raise "Not implemented"
      end

      def update(_playlist)
        raise "Not implemented"
      end

      def all
        raise "Not implemented"
      end

      class PlaylistAlreadyExistsError < StandardError; end
    end
  end
end
