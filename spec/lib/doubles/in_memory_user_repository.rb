class InMemoryUserRepository < Playlists::Repositories::UserRepository
  def initialize
    @data = {}
  end

  def find_by_id(id)
    @data[id]
  end

  def create(user)
    if @data[user.id]
      raise Playlists::Repositories::UserRepository::UserAlreadyExistsError
    end
    @data[user.id] = user
  end

  def update(user)
    @data[user.id] = user
  end

  def all
    @data.values
  end
end
