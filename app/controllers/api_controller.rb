class ApiController < ApplicationController
  
  def getads
    ads = Advert.where("id > ?", params[:lastid])
    render :json => ads
  end
  
end
