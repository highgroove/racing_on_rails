class ArticlesController < ApplicationController


  def show
    @article = Article.find(params[:id])
    render :layout => !request.xhr?
  end

  def recent_news
    @recent_articles = Article.where(:display => true).order("created_at desc").first(10)
  end

  def index
    @articles = Article.where(:display => true).order("created_at desc")

#    if is_mobile?
 #     render :index, :locals=>{:articles => @articles}
#    end

    
    
  end
end
