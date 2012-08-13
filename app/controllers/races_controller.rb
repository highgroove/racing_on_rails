class RacesController < ApplicationController

  # Show Races for a Category
  # === Params
  # * id: Category ID
  # === Assigns
  # * races
  # * category
  def index
    if params[:event_id]
      @event = Event.includes(:races).find(params[:event_id])
      unless is_mobile?
        redirect_to event_results_path(@event)
      end
    else
      if is_mobile?
        redirect_to :mobile => 0
      else
        @category = Category.find(params[:category_id])
      end
    end
  end
  
  def show
    @race = Race.find(params[:id])
    unless is_mobile?
      redirect_to event_results_path(@race.event)
    end
  end
end
