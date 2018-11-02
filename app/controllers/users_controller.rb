class UsersController < ApplicationController
  def index
    @users = list_user_service.run
  end

  def import
    if params[:file]
      import_users_service.run(params[:file].tempfile)
      flash[:notice] = 'File imported successfully'
    else
      flash[:error] = 'File is required'
    end
    redirect_to users_path
  end

  def playlists
    @playlists = list_playlists_from_user_service.run(params[:id])
  end

  def user_repository
    @user_repository ||= ActiveRecordUserRepository.new
  end

  def playlist_repository
    @playlist_repository ||= ActiveRecordPlaylistRepository.new
  end

  private

  def import_users_service
    @import_users_service ||= Playlists::Services::ImportUsersService.new(user_repository)
  end

  def list_user_service
    @user_service ||= Playlists::Services::ListUsersService.new(user_repository)
  end

  def list_playlists_from_user_service
    @list_playlists_from_user_service = Playlists::Services::ListPlaylistsFromUserService.new(playlist_repository)
  end
end
