class Admin::DisciplinesController < Admin::AdminController

  before_filter :require_administrator
  layout "admin/application"

  def new
    @discipline = Discipline.new
  end

  def index
    @disciplines = Discipline.all(:order => :name)
  end
  
  def edit
    @discipline = Discipline.find(params[:id])
  end

  def update
    @discipline = Discipline.find(params[:id])
    
    if @discipline.update_attributes(params[:discipline])
      expire_cache
      flash[:notice] = 'Discipline was successfully updated.'
      redirect_to admin_disciplines_url
    else
      render :edit
    end
  end


  def create
    @discipline = Discipline.new(params[:discipline])

    if @discipline.save
      expire_cache
      flash[:notice] = "Discipline saved."
      redirect_to admin_disciplines_url
    else
      render :new
    end
  end

  def destroy
    expire_cache
    @discipline = Discipline.find(params[:id])
    @discipline.destroy
    redirect_to admin_disciplines_path
  end
  
end
