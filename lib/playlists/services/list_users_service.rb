module Playlists
  module Services
    class ListUsersService
      def initialize(user_repository)
        @user_repository = user_repository
      end

      def run
        @user_repository.all
      end
    end
  end
end
