require 'rails_helper'

RSpec.describe ActiveRecordUserRepository do
  let(:repository) { described_class.new }

  let(:user) do
    Playlists::Entities::User.new(
      id: 1,
      first_name: 'Susan',
      last_name: 'Gomez',
      email: 'sgomez0@cpanel.net',
      username: 'sgomez0'
    )
  end

  describe '#create' do

    it 'creates a user' do
      expect {
        repository.create(user)
      }.to change(User, :count).by(1)
    end

    it 'creates the user with the given arguments' do
      repository.create(user)
      created_user = User.last
      expect(created_user.identifier).to eq user.id
      expect(created_user.first_name).to eq user.first_name
      expect(created_user.last_name).to eq user.last_name
      expect(created_user.email).to eq user.email
      expect(created_user.username).to eq user.username
    end

    context 'when an user iwht the same identifier already exist' do
      before do
        User.create(identifier: user.id)
      end

      it 'raiser UserAlreadyExistsError' do
        expect {
          repository.create(user)
        }.to raise_error(Playlists::Repositories::UserRepository::UserAlreadyExistsError)
      end
    end
  end

  describe '#update' do
    before do
      User.create(identifier: user.id)
    end

    it 'updates the user' do
      repository.update(user)
      updated_user = User.last

      expect(updated_user.identifier).to eq user.id
      expect(updated_user.first_name).to eq user.first_name
      expect(updated_user.last_name).to eq user.last_name
      expect(updated_user.email).to eq user.email
      expect(updated_user.username).to eq user.username
    end
  end

  describe '#all' do
    let(:another_user) do
      Playlists::Entities::User.new(
        id: 2,
        first_name: 'Betty',
        last_name: 'Crawford',
        email: 'bcrawford1@google.com.au',
        username: 'bcrawford1'
      )
    end

    before do
      repository.create(user)
      repository.create(another_user)
    end

    it 'returns all users' do
      expect(repository.all).to eq [user, another_user]
    end
  end
end
