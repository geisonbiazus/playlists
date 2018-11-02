module Playlists
  module Entities
    class Playlist
      attr_accessor :id, :user, :name, :tracks

      def initialize(id: nil, user: nil, name: '', tracks: [])
        self.id = id
        self.user = user
        self.name = name
        self.tracks = tracks
      end

      def ==(other)
        self.class == other.class &&
          id == other.id &&
          user == other.user &&
          name == other.name &&
          tracks == other.tracks
      end
    end
  end
end
