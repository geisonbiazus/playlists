class TracksController < ApplicationController
  def import
    if params[:file]
      import_tracks_service.run(params[:file].tempfile)
      flash[:notice] = 'File imported successfully'
    else
      flash[:error] = 'File is required'
    end
    redirect_to users_path
  end

  def track_repository
    @track_repository ||= ActiveRecordTrackRepository.new
  end

  private

  def import_tracks_service
    @import_tracks_service ||= Playlists::Services::ImportTracksService.new(track_repository)
  end
end
