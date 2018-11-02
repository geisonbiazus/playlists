require 'csv'

module Playlists
  module Services
    class ImportUsersService
      def initialize(user_repository)
        @user_repository = user_repository
      end

      def run(csv)
        CSV.parse(csv, headers: true) do |line|
          user = new_user(line)
          add_or_update_user(user)
        end
      end

      private

      def add_or_update_user(user)
        @user_repository.create(user)
      rescue Repositories::UserRepository::UserAlreadyExistsError
        @user_repository.update(user)
      end

      def new_user(line)
        Entities::User.new(id: line[0].to_i,
                           first_name: line[1],
                           last_name: line[2],
                           email: line[3],
                           username: line[4])
      end
    end
  end
end
