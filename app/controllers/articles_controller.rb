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
    @articles = Article.where(:display => true).order("created_at desc")
  end

  def feed
    @articles = Article.all(:select => "title, body, created_at", :display => true, :order => "posted_at DESC", :limit => 20)

    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end
end
