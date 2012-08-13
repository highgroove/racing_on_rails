# Public page of all Teams
class TeamsController < ApplicationController
  caches_page :index, :if => Proc.new { |c| !is_mobile? }
  
  def index
    if RacingAssociation.current.show_all_teams_on_public_page?
      @teams = Team.all
    else
      @teams = Team.all( :conditions => { :member => true, :show_on_public_page => true })
    end
    @discipline_names = Discipline.names
    expires_in 1.hour, :public => true
  end
end
