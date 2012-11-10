class ArticlesController < ApplicationController
#  if is_mobile?
#    layout "mobile/layouts/application"
#  end

#  require "html_truncator"
  
  def show
    @article = Article.find(params[:id])
 #   render :layout => !request.xhr?
  end

  def recent_news
    @recent_articles = Article.where(:display => true).order("created_at desc").first(10)
  end

  def index

    @articles = Article.where(:display => true).order("created_at desc")

  end
end
