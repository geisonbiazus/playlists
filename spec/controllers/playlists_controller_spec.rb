require 'rails_helper'

RSpec.describe PlaylistsController, type: :controller do
  include ActionDispatch::TestProcess::FixtureFile
  render_views

  let(:playlist_repository) { @controller.track_repository }
  let(:track_repository) { @controller.track_repository }
  let(:user_repository) { @controller.user_repository }

  describe 'POST import' do
    context 'with a csv file' do
      let(:csv) do
        "id,user_id,name,mp3_ids\n" \
        "1,1,1_playlist_1,\"1,2\"\n" \
        "2,1,1_playlist_2,\"2\"\n"
      end

      let(:user) { Playlists::Entities::User.new(id: 1) }
      let(:track_1) { Playlists::Entities::Track.new(id: 1) }
      let(:track_2) { Playlists::Entities::Track.new(id: 2) }

      let(:csv_file) do
        file = Tempfile.new('playlists.csv')
        file.write(csv)
        file.rewind
        file
      end

      let(:uploaded_file) { fixture_file_upload(csv_file.path) }

      before do
        user_repository.create(user)
        track_repository.create(track_1)
        track_repository.create(track_2)

        post :import, params: { file: uploaded_file }
      end

      after do
        csv_file.close
        csv_file.unlink
      end

      it 'imports a playlists CSV file' do
        expect(playlist_repository.all.length).to eq 2
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
