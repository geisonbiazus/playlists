require 'spec_helper'

RSpec.describe Playlists::Services::ImportTracksService do
  let(:repository) { InMemoryTrackRepository.new }
  let(:service) { described_class.new(repository) }

  describe '#run' do
    context 'with a tracks CSV' do
      let(:csv) do
        "ID,Title,Interpret,Album,track,year,genre\n" \
        "1,Rolling In the Deep,Adele,21,1,2011,Pop\n" \
        "2,Rumour Has It,Adele,21,2,2011,Pop\n"
      end

      let(:track_1) do
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

      let(:track_2) do
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

      it 'parses the CSV and stores the tracks' do
        service.run(csv)
        expect(repository.all).to eq [track_1, track_2]
      end
    end

    context 'with duplicated ids' do
      let(:csv) do
        "ID,Title,Interpret,Album,track,year,genre\n" \
        "1,Rolling In the Deep,Adele,21,1,2011,Pop\n" \
        "1,Rumour Has It,Adele,21,2,2011,Pop\n"
      end

      let(:track_2) do
        Playlists::Entities::Track.new(
          id: 1,
          title: 'Rumour Has It',
          interpret: 'Adele',
          album: '21',
          track: '2',
          year: '2011',
          genre: 'Pop'
        )
      end

      it 'updates the record' do
        service.run(csv)
        expect(repository.all).to eq [track_2]
      end
    end
  end
end
