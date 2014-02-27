class TwitterApiController < ApplicationController
  
  def index
  end
  
  def search
    @tweets = Tweet.stream
    @links = Tweet.link_list(@tweets)
    @tags = Tweet.tag_list(@tweets)
  end
end
