class ApiController < ApplicationController
  
  def getads
    begin
      ad_ids = AdList.joins(:device).where("devices.tag = ?", api_params(params)[:tag])
      
      if (ad_ids.length == 0) then
        ad_ids = [0]    #This is a bit dumb but works
      else
        ad_ids = ad_ids.pluck(:advert_id)
      end
      
      ads = Advert.where("id > ? AND id NOT IN ( ? )",
      api_params(params)[:lastid], ad_ids).limit(20)
      
      render :json => ads
    
    rescue
      render :json => {rtn: false}    #db error
    end
  end
  
  
  def exclude
    set_ex_keep 0
  end
  
  
  def keep
    set_ex_keep 1
  end
  
  
  def clearads
    begin
#      puts "clear ads for #{api_params(params)[:tag]}"
      
      Device.destroy_all(tag: api_params(params)[:tag])
      device = Device.create(:tag => api_params(params)[:tag], :instruct_cnt => -1)
      render :json => {rtn: true}
    rescue
      render :json => {rtn: false}    #db error
    end
  end
  
  
  #########   For Coupons
  
  
  def get_kept_coupons
    get_kept "CO"
  end
  
  
  def get_kept_ads
    get_kept "AD"
  end
  
  
  def get_instruct
    device = Device.where(tag: api_params(params)[:tag])
    
    if device.length == 0 then
      device = Device.create(:tag => api_params(params)[:tag])
    else
      device = device[0]
    end
      
    if device.instruct_cnt >= 0 then
      render :json => {rtn: true}
      device.update(instruct_cnt: device.instruct_cnt + 1)
    else
      render :json => {rtn: false}
    end
  end
  
  
  def set_instruct
    device = Device.where(tag: api_params(params)[:tag])
    
    if device.length == 1 then
      device[0].update(instruct_cnt: api_params(params)[:cnt])
      render :json => {rtn: true}
    else
      render :json => {rtn: false}
    end
  end
  
  
  def formupload
#    puts "formupload for #{params[:firstname]}"

    UserMailer.followup(params[:firstname], params[:email]).deliver
    render :json => {id: api_params(params)[:id].to_i}
  end
  
  
  private 
  
    def set_ex_keep xcode
      begin
        device = Device.where(tag: api_params(params)[:tag])
  
        if device.length == 0 then 
          device = Device.create(:tag => api_params(params)[:tag])
        else
          device = device[0]
        end
  
        device.ad_lists.create(:advert_id => api_params(params)[:advert_id],
            :action => xcode)
        render :json => {rtn: true}
      
      rescue
        render :json => {rtn: false}
      end
    end
  
  
    def get_kept adtype
      begin
        ad_ids = AdList.joins(:device).joins(:advert).select("urlimg, urlhref, adverts.id").
          where("devices.tag = ? AND action = 1 AND adtype = ?",
         api_params(params)[:tag], adtype)
      
        render :json => ad_ids
  
      rescue
        render :json => {rtn: false}
      end
    end
    
    

    def api_params(xparams)
  #    puts "PARAMS PASSED : #{xparams}"
  #     xparams = xparams.require(:resolver) if xparams[:resolver]
     
        xparams.permit(:tag, :advert_id, :lastid, :cnt, :id)
    end
end
