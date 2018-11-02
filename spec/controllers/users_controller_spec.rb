require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  render_views

  let(:repository) { @controller.user_repository }

  describe "GET #index" do
    let(:user_1) { Playlists::Entities::User.new(id: 1, username: 'user1') }
    let(:user_2) { Playlists::Entities::User.new(id: 2, username: 'user2') }

    before do
      repository.create(user_1)
      repository.create(user_2)

      get :index
    end

    it 'returns success status' do
      expect(response).to be_success
    end

    it 'lists all users' do
      expect(response.body).to include(user_1.username)
      expect(response.body).to include(user_2.username)
    end
  end
end
