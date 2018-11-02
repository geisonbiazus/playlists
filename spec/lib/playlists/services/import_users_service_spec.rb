require 'rails_helper'

RSpec.describe Playlists::Services::ImportUsersService do
  let(:repository) { InMemoryUserRepository.new }
  let(:service) { described_class.new(repository) }

  describe '#run' do
    context 'with a users CSV' do
      let(:csv) do
        "id,first_name,last_name,email,user_name\n" \
        "1,Susan,Gomez,sgomez0@cpanel.net,sgomez0\n" \
        "2,Betty,Crawford,bcrawford1@google.com.au,bcrawford1\n"
      end

      let(:susan) do
        Playlists::Entities::User.new(
          id: 1,
          first_name: 'Susan',
          last_name: 'Gomez',
          email: 'sgomez0@cpanel.net',
          username: 'sgomez0'
        )
      end

      let(:betty) do
        Playlists::Entities::User.new(
          id: 2,
          first_name: 'Betty',
          last_name: 'Crawford',
          email: 'bcrawford1@google.com.au',
          username: 'bcrawford1'
        )
      end

      it 'parses the CSV and stores the users' do
        service.run(csv)
        expect(repository.all).to eq [susan, betty]
      end
    end

    context 'with duplicated ids' do
      let(:csv) do
        "id,first_name,last_name,email,user_name\n" \
        "1,Susan,Gomez,sgomez0@cpanel.net,sgomez0\n" \
        "1,Betty,Crawford,bcrawford1@google.com.au,bcrawford1\n"
      end

      let(:betty) do
        Playlists::Entities::User.new(
          id: 1,
          first_name: 'Betty',
          last_name: 'Crawford',
          email: 'bcrawford1@google.com.au',
          username: 'bcrawford1'
        )
      end

      it 'updates the record' do
        service.run(csv)
        expect(repository.all).to eq [betty]
      end
    end
  end
end
