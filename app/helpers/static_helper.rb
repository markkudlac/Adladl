module StaticHelper
  
  def geturl
    
    if Rails.env.production? then
      url =  "http://www.adladl.com"
    else 
      url = request.original_url.match(/^.*000/)
    end
    
    return url
    
  end
end
