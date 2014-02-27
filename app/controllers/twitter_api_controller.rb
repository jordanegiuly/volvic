class TwitterApiController < ApplicationController
  
  def index
    @tweets = Tweet.stream
    @links = Tweet.link_list(@tweets)
    @tags = Tweet.tag_list(@tweets)
  end
end
