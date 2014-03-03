class TwitterApiController < ApplicationController
 
  def index
  end

  def search
    @search_tag = params[:search_tag]
    @tweets = Tweet.stream(@search_tag) if @search_tag
    @tweets ||= []
    @tweets_json = @tweets.to_json
    @diffbot_api_response = JSON.parse(DiffbotApi.first.response)
  end
end
