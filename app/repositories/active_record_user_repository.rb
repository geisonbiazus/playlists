class ActiveRecordUserRepository < Playlists::Repositories::UserRepository
  def find_by_id(id)
    self.class.initialize_user(User.find(id))
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def create(user)
    User.create(
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      username: user.username
    )
  rescue ActiveRecord::RecordNotUnique
    raise Playlists::Repositories::UserRepository::UserAlreadyExistsError
  end

  def update(user)
    record = User.find(user.id)
    record.update(
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      username: user.username
    )
  end

  def all
    User.all.order(:id).map { |record| self.class.initialize_user(record) }
  end

  def self.initialize_user(record)
    Playlists::Entities::User.new(
      id: record.id,
      first_name: record.first_name,
      last_name: record.last_name,
      email: record.email,
      username: record.username
    )
  end
end
