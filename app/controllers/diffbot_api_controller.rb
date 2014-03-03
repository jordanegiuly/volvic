class DiffbotApiController < ApplicationController
  
  def create
    @diffbot_api_call = DiffbotApi.new(params.permit(:url, :response))
    @diffbot_api_call.save
    redirect_to '/twitter_api/search'
  end
  
end
