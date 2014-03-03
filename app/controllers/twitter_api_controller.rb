class TwitterApiController < ApplicationController
 
  def index
  end

  def search
    @search_tag = params[:search_tag]
    @tweets = Tweet.stream(@search_tag) if @search_tag
    @tweets ||= []
  end
end
