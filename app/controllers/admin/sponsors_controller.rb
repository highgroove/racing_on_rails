class Admin::SponsorsController < Admin::AdminController
  layout "admin/application"
  before_filter :require_administrator

  def index
=begin
    if params[:sponsor_category_id].nil?
      @sponsors = Sponsor.all( :order => "name")
    else
      @sponsors = Sponsor.all( :conditions => ["sponsor_category_id = ?", params[:sponsor_category_id]], :order => "name")
      params[:sponsor_category_id] = nil
    end
=end
    @sponsors = Sponsor.all
  end

  def show
    @sponsor = Sponsor.find(params[:id])
  end

  def new
    @sponsor = Sponsor.new
#    @sponsor_category = SponsorCategory.first
 #   5.times { @sponsor.assets.build }
  end

  def edit
    @sponsor = Sponsor.find(params[:id])
  #  5.times { @sponsor.assets.build }
  end

  def create
    @sponsor = Sponsor.new(params[:sponsor])

    if @sponsor.save
      expire_cache
      flash[:notice] = 'Sponsor was successfully created.'
      redirect_to admin_sponsors_url
    else
      render :new
    end
  end

  def update
    @sponsor = Sponsor.find(params[:id])

    if @sponsor.update_attributes(params[:sponsor])
      expire_cache
      flash[:notice] = 'Sponsor was successfully updated.'
      redirect_to admin_sponsors_url
    else
      render :edit
    end
  end

  def destroy
    expire_cache
    @sponsor = Sponsor.find(params[:id])
    @sponsor.destroy
    redirect_to admin_sponsors_url
  end
end
