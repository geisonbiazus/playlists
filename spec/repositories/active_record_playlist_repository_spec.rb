require 'rails_helper'

RSpec.describe ActiveRecordPlaylistRepository do
  let(:repository) { described_class.new }
  let(:user_repository) { ActiveRecordUserRepository.new }
  let(:track_repository) { ActiveRecordTrackRepository.new }

  let(:user) { Playlists::Entities::User.new(id: 1) }
  let(:track_1) { Playlists::Entities::Track.new(id: 1) }
  let(:track_2) { Playlists::Entities::Track.new(id: 2) }

  let(:playlist) do
    Playlists::Entities::Playlist.new(
      id: 1,
      user: user,
      name: '1_playlist_1',
      tracks: [track_1, track_2]
    )
  end

  let(:another_playlist) do
    Playlists::Entities::Playlist.new(
      id: 2,
      user: user,
      name: '1_playlist_1',
      tracks: [track_2]
    )
  end

  before do
    user_repository.create(user)
    track_repository.create(track_1)
    track_repository.create(track_2)
  end

  describe '#create' do
    it 'creates a playlist' do
      expect do
        repository.create(playlist)
      end.to change(Playlist, :count).by(1)
    end

    it 'creates the playlist with the given arguments' do
      repository.create(playlist)
      created_playlist = Playlist.last
      expect(created_playlist.id).to eq playlist.id
      expect(created_playlist.user_id).to eq playlist.user.id
      expect(created_playlist.name).to eq playlist.name
      expect(created_playlist.tracks.pluck(:id)).to eq playlist.tracks.map(&:id)
    end

    context 'when a playlist with the same id already exist' do
      before do
        repository.create(playlist)
      end

      it 'raises PlaylistAlreadyExistsError' do
        expect do
          repository.create(playlist)
        end.to raise_error(Playlists::Repositories::PlaylistRepository::PlaylistAlreadyExistsError)
      end
    end
  end

  describe '#update' do
    before do
      Playlist.create(id: playlist.id, user_id: playlist.user.id)
    end

    it 'updates the playlist' do
      repository.update(playlist)
      updated_playlist = Playlist.last

      expect(updated_playlist.id).to eq playlist.id
      expect(updated_playlist.user_id).to eq playlist.user.id
      expect(updated_playlist.name).to eq playlist.name
      expect(updated_playlist.name).to eq playlist.name
      expect(updated_playlist.tracks.pluck(:id)).to eq playlist.tracks.map(&:id)
    end
  end

  describe '#all' do
    before do
      repository.create(playlist)
      repository.create(another_playlist)
    end

    it 'returns all playlists' do
      expect(repository.all).to eq [playlist, another_playlist]
    end
  end

  describe '#find_all_by_user_id' do
    it 'returns all playlists for the given user' do
      repository.create(playlist)
      repository.create(another_playlist)

      expect(repository.find_all_by_user_id(user.id)).to eq [playlist, another_playlist]
    end
  end
end
