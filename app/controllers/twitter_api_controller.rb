class TwitterApiController < ApplicationController
 
  def index    
  end

  def search
    @search_tag = params[:search_tag]
    @tweets = Tweet.stream(@search_tag)
    @links = Tweet.link_list(@tweets)
    @tags = Tweet.tag_list(@tweets)
  end
end
