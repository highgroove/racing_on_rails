class ArticlesController < ApplicationController
  def show
    @article = Article.find(params[:id])
    render :layout => !request.xhr?
  end

  def recent_news
    @recent_articles = Article.where(:created_at => Time.now.prev_month()..Time.now, :display => true).order("created_at desc")
  end
end
