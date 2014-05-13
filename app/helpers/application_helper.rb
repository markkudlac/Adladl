module ApplicationHelper
  
  def geturl
    
    if Rails.env.production? then
      url =  "http://www.adladl.com"
    else 
      url = request.original_url.match(/^.*000/)  #look for port like :3000
    end
    
    return url
    
  end
  
end
