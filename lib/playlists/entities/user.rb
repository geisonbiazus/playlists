module Playlists
  module Entities
    class User
      attr_accessor :id, :first_name, :last_name, :email, :username

      def initialize(id: nil,
                     first_name: '',
                     last_name: '',
                     email: '',
                     username: '')
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.username = username
      end

      def ==(other)
        self.class == other.class &&
          id == other.id &&
          first_name == other.first_name &&
          last_name == other.last_name &&
          email == other.email &&
          username == other.username
      end
    end
  end
end
