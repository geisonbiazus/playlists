require 'spec_helper'

RSpec.describe Playlists::Services::ImportPlaylistsService do
  let(:user_repository) { InMemoryUserRepository.new }
  let(:track_repository) { InMemoryTrackRepository.new }
  let(:playlist_repository) { InMemoryPlaylistRepository.new }
  let(:service) { described_class.new(user_repository, track_repository, playlist_repository) }

  describe '#run' do
    let(:csv) do
      "id,user_id,name,mp3_ids\n" \
      "1,1,1_playlist_1,\"1,2\"\n" \
      "2,1,1_playlist_2,\"2\"\n"
    end

    let(:user) { Playlists::Entities::User.new(id: 1) }
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

    before do
      user_repository.create(user)
      track_repository.create(track_1)
      track_repository.create(track_2)
    end

    it 'imports the playlists and assign the tracks' do
      service.run(csv)
      expect(playlist_repository.all).to eq [playlist_1, playlist_2]
    end

    context 'with duplicated playlist' do
      let(:csv) do
        "id,user_id,name,mp3_ids\n" \
        "1,1,1_playlist_1,\"1,2\"\n" \
        "1,1,1_playlist_2,\"2\"\n"
      end

      let(:playlist_2) do
        Playlists::Entities::Playlist.new(
          id: 1,
          user: user,
          name: '1_playlist_2',
          tracks: [track_2]
        )
      end

      it 'updates the playlist' do
        service.run(csv)
        expect(playlist_repository.all).to eq [playlist_2]
      end
    end

    context 'when user is not found' do
      let(:csv) do
        "id,user_id,name,mp3_ids\n" \
        "1,1,1_playlist_1,\"1,2\"\n" \
        "1,2,1_playlist_2,\"2\"\n"
      end

      it 'ignores the playlist' do
        service.run(csv)
        expect(playlist_repository.all).to eq [playlist_1]
      end
    end

    context 'when tracks is not found' do
      let(:csv) do
        "id,user_id,name,mp3_ids\n" \
        "1,1,1_playlist_1,\"1,3\"\n" \
        "2,1,1_playlist_2,\"3\"\n"
      end

      let(:playlist_1) do
        Playlists::Entities::Playlist.new(
          id: 1,
          user: user,
          name: '1_playlist_1',
          tracks: [track_1]
        )
      end

      let(:playlist_2) do
        Playlists::Entities::Playlist.new(
          id: 2,
          user: user,
          name: '1_playlist_2',
          tracks: []
        )
      end

      it 'ignores the track' do
        service.run(csv)
        expect(playlist_repository.all).to eq [playlist_1, playlist_2]
      end
    end
  end
end
