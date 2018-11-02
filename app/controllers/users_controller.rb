class UsersController < ApplicationController
  def index
    @users = list_user_service.run
  end

  def user_repository
    @user_repository ||= ActiveRecordUserRepository.new
  end

  private

  def list_user_service
    @user_service ||= Playlists::Services::ListUsersService.new(user_repository)
  end
end
