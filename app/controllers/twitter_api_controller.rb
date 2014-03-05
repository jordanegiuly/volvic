class TwitterApiController < ApplicationController
 
  def index
  end

  def search
    @search_tag = params[:search_tag] || ""
    search_results = Tweet.stream(@search_tag, 50) if !@search_tag.empty?
    search_results ||= {"tweets" => [], "short_urls" => []}
    @tweets = search_results["tweets"]
    @short_urls = search_results["short_urls"]
    @articles = DiffbotApi.last.response
  end
end
