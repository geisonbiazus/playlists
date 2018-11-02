module Playlists
  module Repositories
    class UserRepository
      def create(_user)
        raise "Not implemented"
      end

      def update(_user)
        raise "Not implemented"
      end

      def all
        raise "Not implemented"
      end

      class UserAlreadyExistsError < StandardError; end
    end
  end
end
