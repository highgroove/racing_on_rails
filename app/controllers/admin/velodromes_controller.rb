# All succcessful edit expire cache.
 class Admin::VelodromesController < Admin::AdminController
  before_filter :require_administrator
  layout "admin/application"

  def index
    @velodromes = Velodrome.all( :order => "name")
  end
  
  def new
    @velodrome = Velodrome.new
    render :action => "edit"
  end
  
  def create
    expire_cache
    @velodrome = Velodrome.create(params[:velodrome])
    
    if @velodrome.errors.empty?
      flash[:notice] = "Created #{@velodrome.name}"
      return redirect_to(new_admin_velodrome_path)
    end
    render(:template => 'admin/velodromes/edit')
  end
  
  def edit
    @velodrome = Velodrome.find(params[:id])
  end
  
  def update
    expire_cache
    @velodrome = Velodrome.find(params[:id])
    
    if @velodrome.update_attributes(params[:velodrome])
      flash[:notice] = "Updated #{@velodrome.name}"
      return redirect_to(edit_admin_velodrome_path(@velodrome))
    end
    render(:template => 'admin/velodromes/edit')
  end

  def update_attribute
    respond_to do |format|
      format.js {
        @velodrome = Velodrome.find(params[:id])
        @velodrome.send "#{params[:name]}=", params[:value]
        @velodrome.save!
        expire_cache
        render :text => @velodrome.send(params[:name]), :content_type => "text/html"
      }
    end
  end

  def destroy
    @velodrome = Velodrome.find(params[:id])
    flash[:notice] = "Deleted #{@velodrome.name}"
    @velodrome.destroy
    redirect_to(admin_velodromes_path)
    expire_cache
  end
end
