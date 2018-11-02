module Playlists
  module Services
    class ImportPlaylistsService
      def initialize(user_repository, track_repository, playlist_repository)
        @user_repository = user_repository
        @track_repository = track_repository
        @playlist_repository = playlist_repository
      end

      def run(csv)
        CSV.parse(csv, headers: true) do |line|
          playlist = new_playlist(line)
          add_or_update_playlist(playlist) if playlist.user
        end
      end

      private

      def new_playlist(line)
        Playlists::Entities::Playlist.new(
          id: line[0].to_i,
          user: @user_repository.find_by_id(line[1].to_i),
          name: line[2],
          tracks: @track_repository.find_all_by_id(line[3].split(',').map(&:to_i))
        )
      end

      def add_or_update_playlist(playlist)
        @playlist_repository.create(playlist)
      rescue Playlists::Repositories::PlaylistRepository::PlaylistAlreadyExistsError
        @playlist_repository.update(playlist)
      end
    end
  end
end
