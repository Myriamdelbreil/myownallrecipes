class ApplicationController < ActionController::Base
  private

  def safe_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
