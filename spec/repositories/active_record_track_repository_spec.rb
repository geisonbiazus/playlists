require 'rails_helper'

RSpec.describe ActiveRecordTrackRepository do
  let(:repository) { described_class.new }

  let(:track) do
    Playlists::Entities::Track.new(
      id: 1,
      title: 'Rolling In the Deep',
      interpret: 'Adele',
      album: '21',
      track: '1',
      year: '2011',
      genre: 'Pop'
    )
  end

  describe '#create' do
    it 'creates a track' do
      expect {
        repository.create(track)
      }.to change(Track, :count).by(1)
    end

    it 'creates the track with the given arguments' do
      repository.create(track)
      created_track = Track.last
      expect(created_track.id).to eq track.id
      expect(created_track.title).to eq track.title
      expect(created_track.interpret).to eq track.interpret
      expect(created_track.album).to eq track.album
      expect(created_track.track).to eq track.track
      expect(created_track.year).to eq track.year
      expect(created_track.genre).to eq track.genre
    end

    context 'when a track with the same id already exist' do
      before do
        Track.create(id: track.id)
      end

      it 'raiser TrackAlreadyExistsError' do
        expect {
          repository.create(track)
        }.to raise_error(Playlists::Repositories::TrackRepository::TrackAlreadyExistsError)
      end
    end
  end

  describe '#update' do
    before do
      Track.create(id: track.id)
    end

    it 'updates the track' do
      repository.update(track)
      updated_track = Track.last

      expect(updated_track.id).to eq track.id
      expect(updated_track.title).to eq track.title
      expect(updated_track.interpret).to eq track.interpret
      expect(updated_track.album).to eq track.album
      expect(updated_track.track).to eq track.track
      expect(updated_track.year).to eq track.year
      expect(updated_track.genre).to eq track.genre
    end
  end

  describe '#all' do
    let(:another_track) do
      Playlists::Entities::Track.new(
        id: 2,
        title: 'Rumour Has It',
        interpret: 'Adele',
        album: '21',
        track: '2',
        year: '2011',
        genre: 'Pop'
      )
    end

    before do
      repository.create(track)
      repository.create(another_track)
    end

    it 'returns all tracks' do
      expect(repository.all).to eq [track, another_track]
    end
  end
end
