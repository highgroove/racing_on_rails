class ArticlesController < ApplicationController
#  if is_mobile?
#    layout "mobile/layouts/application"
#  end

  def show
    @article = Article.find(params[:id])
 #   render :layout => !request.xhr?
  end

  def recent_news
    @recent_articles = Article.where(:display => true).order("created_at desc").first(15)
  end

  def index
    @tags = Tag.all(:order => :name)

    if params[:tag]
      @articles = Article.tagged_with(params[:tag]).where(:display => true).order("created_at desc")
    elsif params[:results]
      @articles = Article.where("display = ? AND results = ?", true, true).order("created_at desc")
    else
      @articles = Article.where(:display => true).order("created_at desc")
    end
  end

  def feed
    @articles = Article.all(:select => "title, body, created_at", :display => true, :order => "posted_at DESC", :limit => 20)
    
    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end

  
  
end
