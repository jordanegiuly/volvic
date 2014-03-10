class TwitterApiController < ApplicationController
  
  def index
  end

  def search
    @search_tag = params[:search_tag] || ""
    search_results = Tweet.stream(@search_tag, 50) if !@search_tag.empty? #TODO: INCLUDE BEGIN RESCUE
    search_results ||= {"tweets" => [], "short_urls" => []}
    @tweets = search_results["tweets"]
    @short_urls = search_results["short_urls"]
    @articles = DiffbotApi.last.response if DiffbotApi.count > 0
  end
  
  
  def show_url
    short_url = params[:short_url] || ""
    resolved_urls = params[:resolved_urls] || []
    article = {"short_url" => short_url, "resolved_url" => short_url, "title" => "", "description" =>"", "image" => "", "author" =>"", "date"=>"", "tags" => [], 
               "type"=>"", "success" => false }
    begin
      resolved_url = resolve_url(short_url)
      article["resolved_url"] = resolved_url
    
      if !(resolved_urls.include?(resolved_url))
        doc = Nokogiri::HTML(open(resolved_url))
        doc.css('meta').each do |meta|
          meta = meta.to_s
          parse_header(meta, article)
        end
        article["title"] = doc.css('title').text if article["title"].empty?
      end
      article["success"] = true
    rescue
      print "\n ERROR with " + short_url + "\n"
    end
    render json: article
  end
  
  
  # Helper
  def resolve_url(short_url)
    resolved_url = short_url
    redirect_count = 0
    while true
      uri = URI.parse(resolved_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      request = Net::HTTP::Get.new(uri.request_uri)
      r = http.request(request)
      break if r['location'].nil?
      break if !(r.code == "301" || r.code == "302")
      break if redirect_count > 5
      redirect_count += 1
      resolved_url = r['location']
    end
    return resolved_url
  end
  
  
  # Helper
  def parse_header(meta, data)
    scan = meta.scan(/<meta ([^=]*)/)
    meta_name = if scan.empty? then "" else scan.first.first end
    return if !((meta_name == "name") || (meta_name == "property") || (meta_name == "itemprop"))
    
    scan = meta.scan(/="([^"]*)"/)
    return if scan.empty?
    key = scan.first.first
    
    scan = meta.scan(/content="([^"]*)/)
    return if scan.empty?
    value = scan.first.first
    
    if key.match(/title/)
      data["title"] = value if data["title"].empty?
      return
    end
    if key.match(/description/)
      data["description"] = value if data["description"].empty?
      return
    end
    if key.match(/image/)
      data["image"] = value if data["image"].empty?
      return
    end
    if key.match(/author/)
      data["author"] = value if data["author"].empty?
      return
    end
    if key.match(/published/i)
      data["date"] = value if data["date"].empty?
      return
    end
    if key.match(/keywords/)
      data["tags"] = value.split(',') if data["tags"].empty?
      return
    end
    if key.match(/type/)
      data["type"] = value if data["type"].empty?
      return
    end
  end
  
end
