class Tweet < ActiveRecord::Base
  
  @@consumer_key = "qM8La58kK4wzBMc8dLLOqA"
  @@consumer_secret = "GFZHLv8dynCRhTPnpSLOuvhXMu8xhKLRtOwF9Pnw"
  @@access_token = "1853762354-V4FPXhf9c9Db659XXO2JPvR0XsAUWcKy89tcILX"
  @@access_secret = "K2FuY1zDaSKno5RSz0uLWqtD8Hn3iPUSdvEOfHx8FiKao"
  
  
  def self.initialize_client
    client = Twitter::REST::Client.new do  |config|
      config.consumer_key        = @@consumer_key
      config.consumer_secret     = @@consumer_secret
      config.access_token        = @@access_token
      config.access_token_secret = @@access_secret
    end
    return client
  end
  
  
  def self.stream(tag)
    client = Tweet.initialize_client
    tweets = []
    urls = []
    twitter_api_result = client.search(tag, :result_type => "recent").take(10)
    
    twitter_api_result.each do |tweet|
      extract_urls(urls, tweet.uris)
      tweet = Tweet.process_tweet(tweet)
      tweets << tweet
    end
    return {"tweets" => tweets, "short_urls" => urls }
  end
  
  
  def self.process_tweet(tweet)
    result = {}
    tags = Tweet.extract_tags(tweet.hashtags)
    processed_tweet = {"created_at" => tweet.created_at, "user" => tweet.user.screen_name, 
                       "text" => tweet.text, "tags" => tags}
  end
  
  
  def self.extract_urls(urls, tweet_uris)
    tweet_uris.each do |entity|
      urls << entity.attrs[:url]
    end
    return urls
  end
  
  
  def self.extract_tags(hashtags)
    tags = []
    hashtags.each do |entity|
      tags << entity.attrs[:text]
    end
    return tags
  end
  
  
  def self.link_list(tweets)
    links = {}
    tweets.each do |tweet|
      tweet["links"].each do |link|
        links[link] = links[link] ? links[link] + 1 : 1    
      end
    end
    links = Hash[links.sort_by{|k, v| v}.reverse]
    return links
  end
  
  
  def self.tag_list(tweets)
    tags = {}
    tweets.each do |tweet|
      tweet["tags"].each do |tag|
        tag = tag.downcase
        tags[tag] = tags[tag] ? tags[tag] + 1 : 1
      end
    end
    return tags
  end


  # TODO: check http://longurl.org/api
  # Currently, we use expandurl.appspot.com api
  def self.find_link(text)
    links = text.scan(/http\S*\b/)
    unshorten_links = []
    links.each do |link|
      link = URI::encode(link)
      print "LINK: " + link + "\n"
#      uri = URI.parse('http://expandurl.appspot.com/expand?url=' + link)
#      http = Net::HTTP.new(uri.host, uri.port)
#      request = Net::HTTP::Get.new(uri.request_uri)
#      response = http.request(request)
#      response = JSON.parse(response.body)
#      unshorten_links << response["end_url"]
      unshorten_links << link
    end
    return unshorten_links
  end
  
  
  def self.find_tags(text)
    tags = text.scan(/#\S*\b/)
    cleaned_tags = []
    tags.each do |tag|
      cleaned_tags << tag.downcase
    end
    return cleaned_tags
  end
  
end
