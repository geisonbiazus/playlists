module Playlists
  module Entities
    class Track
      attr_accessor :id, :title, :interpret, :album, :track, :year, :genre

      def initialize(id: 0,
                     title: '',
                     interpret: '',
                     album: '',
                     track: '',
                     year: '',
                     genre: '')
        self.id = id
        self.title = title
        self.interpret = interpret
        self.album = album
        self.track = track
        self.year = year
        self.genre = genre
      end

      def ==(other)
        self.class == other.class &&
          id == other.id &&
          title == other.title &&
          interpret == other.interpret &&
          album == other.album &&
          track == other.track &&
          year == other.year &&
          genre == other.genre
      end
    end
  end
end
