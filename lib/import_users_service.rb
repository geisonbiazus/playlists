require 'csv'

class ImportUsersService
  def initialize(user_repository)
    @user_repository = user_repository
  end

  def run(csv)
    CSV.parse(csv, headers: true) do |line|
      add_user(line)
    end
  end

  private

  def add_user(line)
    user = new_user(line)
    @user_repository.create(user)
  rescue UserAlreadyExistsError
    @user_repository.update(user)
  end

  def new_user(line)
    User.new(id: line[0].to_i,
             first_name: line[1],
             last_name: line[2],
             email: line[3],
             username: line[4])
  end
end

class UserAlreadyExistsError < StandardError; end
