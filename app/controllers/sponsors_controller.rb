class SponsorsController < ApplicationController

  def show
    if params[:id]
      @sponsor = Sponsor.find(params[:id])
    end
  end
