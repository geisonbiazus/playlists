require 'rails_helper'

RSpec.describe TracksController, type: :controller do
  include ActionDispatch::TestProcess::FixtureFile
  render_views

  let(:repository) { @controller.track_repository }

  describe 'POST import' do
    context 'with a csv file' do
      let(:csv) do
        "ID,Title,Interpret,Album,track,year,genre\n" \
        "1,Rolling In the Deep,Adele,21,1,2011,Pop\n" \
        "2,Rumour Has It,Adele,21,2,2011,Pop\n"
      end

      let(:csv_file) do
        file = Tempfile.new('tracks.csv')
        file.write(csv)
        file.rewind
        file
      end

      let(:uploaded_file) { fixture_file_upload(csv_file.path) }

      before do
        post :import, params: { file: uploaded_file }
      end

      after do
        csv_file.close
        csv_file.unlink
      end

      it 'imports a tracks CSV file' do
        expect(repository.all.length).to eq 2
      end

      it 'shows success message' do
        expect(flash[:notice]).to eq('File imported successfully')
      end
    end

    context 'withoud a csv file' do
      it 'shows a validation message' do
        post :import
        expect(flash[:error]).to eq('File is required')
      end
    end
  end
end
