class DemoController < ApplicationController
  
  def brand
    @page_title = "My brand page"
  end
  
  def media
    @page_title = "A media page"
  end
  
  def author
    @page_title = "An author page"
  end
  
  def keyword
    @page_title = "A keyword page"
  end
  
end
