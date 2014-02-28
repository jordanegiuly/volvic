class TwitterApiController < ApplicationController
  
  def index
  end
  
  def search
    @search_tag = params[:search_tag]
    @tweets = Tweet.stream
    @links = Tweet.link_list(@tweets)
    @tags = Tweet.tag_list(@tweets)
    # render stream: true
  end
end
