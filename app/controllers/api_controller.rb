class ApiController < ApplicationController
  
  def getads
#    ads = Advert.where("id > ?", params[:lastid]).limit(20)
ad_ids = AdList.joins(:device).where("devices.tag = ?", api_params(params)[:tag]).
pluck(:advert_id)
ads = Advert.where("id > ? AND id NOT IN ( ? )",
api_params(params)[:lastid], ad_ids).limit(20)
    render :json => ads
  end
  
  def exclude

    begin
      device = Device.where(tag: api_params(params)[:tag])
    
      if device.length == 0 then 
        device = Device.create(:tag => api_params(params)[:tag])
      else
        device = device[0]
      end
    
      device.ad_lists.create(:advert_id => api_params(params)[:advert_id],
          :action => 0)
      render :json => {rtn: true}
    
    rescue
      render :json => {rtn: false}
    end
  end
  
  def keep
#    ads = Advert.where("id > ?", params[:id])
    render :json => {rtn: true}
  end
  
  def api_params(xparams)
#    puts "PARAMS PASSED : #{xparams}"
#     xparams = xparams.require(:resolver) if xparams[:resolver]
     
      xparams.permit(:tag, :advert_id, :lastid)
  end
end
