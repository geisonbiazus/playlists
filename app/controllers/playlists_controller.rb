class PlaylistsController < ApplicationController
  def import
    if params[:file]
      import_playlists_service.run(params[:file].tempfile)
      flash[:notice] = 'File imported successfully'
    else
      flash[:error] = 'File is required'
    end
    redirect_to users_path
  end

  def user_repository
    @user_repository ||= ActiveRecordUserRepository.new
  end

  def track_repository
    @track_repository ||= ActiveRecordTrackRepository.new
  end

  def playlist_repository
    @playlist_repository ||= ActiveRecordPlaylistRepository.new
  end

  private

  def import_playlists_service
    @import_playlists_service ||= Playlists::Services::ImportPlaylistsService.new(
      user_repository, track_repository, playlist_repository
    )
  end
end
