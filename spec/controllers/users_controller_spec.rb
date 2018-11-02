require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include ActionDispatch::TestProcess::FixtureFile
  render_views

  let(:user_repository) { @controller.user_repository }

  describe "GET #index" do
    let(:user_1) { Playlists::Entities::User.new(id: 1, username: 'user1') }
    let(:user_2) { Playlists::Entities::User.new(id: 2, username: 'user2') }

    before do
      user_repository.create(user_1)
      user_repository.create(user_2)

      get :index
    end

    it 'returns success status' do
      expect(response).to have_http_status(:success)
    end

    it 'lists all users' do
      expect(response.body).to include(user_1.username)
      expect(response.body).to include(user_2.username)
    end
  end

  describe 'POST import' do
    context 'with a csv file' do
      let(:csv) do
        "id,first_name,last_name,email,user_name\n" \
        "1,Susan,Gomez,sgomez0@cpanel.net,sgomez0\n" \
        "2,Betty,Crawford,bcrawford1@google.com.au,bcrawford1\n"
      end

      let(:csv_file) do
        file = Tempfile.new('users.csv')
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

      it 'imports a users CSV file' do
        expect(user_repository.all.length).to eq 2
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

  describe 'GET playlists' do
    let(:playlist_repository) { @controller.playlist_repository }
    let(:user) { Playlists::Entities::User.new(id: 1, first_name: 'User') }

    let(:playlist_1) do
      Playlists::Entities::Playlist.new(
        id: 1,
        user: user,
        name: '1_playlist_1'
      )
    end

    let(:playlist_2) do
      Playlists::Entities::Playlist.new(
        id: 2,
        user: user,
        name: '1_playlist_1'
      )
    end

    before do
      user_repository.create(user)
      playlist_repository.create(playlist_1)
      playlist_repository.create(playlist_2)
    end

    it 'lists all playlists of the given user id' do
      get :playlists, params: { id: user.id }
      expect(response.body).to include(playlist_1.name)
      expect(response.body).to include(playlist_2.name)
    end
  end
end
