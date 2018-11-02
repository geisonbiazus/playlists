require 'rails_helper'

RSpec.describe Playlists::Services::ListUsersService do
  let(:repository) { InMemoryUserRepository.new }
  let(:service) { described_class.new(repository) }

  describe '#run' do
    let(:user_1) { Playlists::Entities::User.new(id: 1, username: 'user1') }
    let(:user_2) { Playlists::Entities::User.new(id: 2, username: 'user2') }

    it 'returns all the users' do
      repository.create(user_1)
      repository.create(user_2)

      expect(service.run).to eq [user_1, user_2]
    end
  end
end
