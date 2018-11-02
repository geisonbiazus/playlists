require 'spec_helper'

RSpec.describe Playlists::Services::ListPlaylistsFromUserService do
  let(:repository) { InMemoryPlaylistRepository.new }
  let(:service) { described_class.new(repository) }

  describe '#run' do
    let(:user) { Playlists::Entities::User.new(id: 1) }
    let(:another_user) { Playlists::Entities::User.new(id: 2) }
    let(:track_1) { Playlists::Entities::Track.new(id: 1) }
    let(:track_2) { Playlists::Entities::Track.new(id: 2) }

    let(:playlist_1) do
      Playlists::Entities::Playlist.new(
        id: 1,
        user: user,
        name: '1_playlist_1',
        tracks: [track_1, track_2]
      )
    end

    let(:playlist_2) do
      Playlists::Entities::Playlist.new(
        id: 2,
        user: user,
        name: '1_playlist_2',
        tracks: [track_2]
      )
    end

    let(:playlist_3) do
      Playlists::Entities::Playlist.new(
        id: 3,
        user: another_user,
        name: '1_playlist_2',
        tracks: [track_2]
      )
    end

    before do
      repository.create(playlist_1)
      repository.create(playlist_2)
      repository.create(playlist_3)
    end

    it 'returns a list of the playlists of the given user_id' do
      expect(service.run(user.id)).to eq [playlist_1, playlist_2]
    end
  end
end
