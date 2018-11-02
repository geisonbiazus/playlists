module Playlists
  module Services
    class ListPlaylistsFromUserService
      def initialize(playlist_repository)
        @playlist_repository = playlist_repository
      end

      def run(user_id)
        @playlist_repository.find_all_by_user_id(user_id)
      end
    end
  end
end
