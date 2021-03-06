class ApiController < ApplicationController
  
  def getads
    begin
      ad_ids = AdList.joins(:device).where("devices.tag = ?", api_params(params)[:tag])
    
      if (ad_ids.length == 0) then
        ad_ids = [0]    #This is a bit dumb but works
      else
        ad_ids = ad_ids.pluck(:advert_id)
      end
      
# This is a bit dumb but could not get param to pass properly on multiple items to exec
      adstr = ad_ids.to_s
      adstr = adstr.slice(1, adstr.length-2)

# Building the string to get around parameter difs with PostGress
      
      qrystr = "SELECT adverts.id, adverts.filename, adverts.urlhref, adverts.adtype, " +
      "adverts.image, landings.zipfile, landings.zipname FROM adverts " +
      "LEFT OUTER JOIN landings ON landings.id = adverts.landing_id " + 
      "WHERE adverts.id > " + api_params(params)[:lastid] + 
      " AND adverts.id NOT IN ( " + adstr + " ) LIMIT 20"

#      puts "QRYSTR : #{qrystr}"
      if Rails.env.production? then     # For PostGresql
        conn = ActiveRecord::Base.connection.raw_connection
        conn.prepare('pg_ads', qrystr) 
        ads = conn.exec_prepared('pg_ads')
        conn.exec('DEALLOCATE pg_ads')
      else
        ads = ActiveRecord::Base.connection.raw_connection.prepare(qrystr) 
        ads = ads.execute()
      end
#      ads = Advert.where("adverts.id > ? AND adverts.id NOT IN ( ? )",
#      api_params(params)[:lastid], ad_ids).limit(20)
      
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
    puts "formupload for #{params[:adl_id]}"

    UserMailer.followup(params[:adl_id], params[:firstname],  
      params[:email]).deliver
    render :json => {uploads_id: api_params(params)[:uploads_id].to_i}
  end
  
  
  def fillnotify
    advert = Advert.where(id: api_params(params)[:id])
    
    if advert.length == 1 then
      icon = Icon.find_by_id(advert[0].icon_id)   #do this so no exception thrown
      if icon.nil? then
        defpath = view_context.asset_path "defaulticon.gif"
        if Rails.env.development? then
          defpath = "app/assets/images/defaulticon.gif"
        end
        encd_str = Base64.encode64(File.read(defpath))
      else
        encd_str = icon.image
      end
      
      render :json => {urlhref: advert[0].urlhref, descript: advert[0].descript,
        advert_id: advert[0].id, uploads_id: api_params(params)[:uploads_id].to_i, icon: encd_str}
    else
      render :json => {rtn: false}
    end
  end
  
  
  def getimage
    advert = Advert.where(id: api_params(params)[:id])
    if advert.length == 1 then
      decd_str = Base64.decode64(advert[0].image)
      mimetype = advert[0].filename.split('.')
      mimetype = mimetype[mimetype.length-1]
    else
      decd_str = File.read("app/assets/images/defaulticon.gif")
      mimetype = "gif"
    end
    
    send_data decd_str, type: 'image/'+mimetype, disposition: 'inline'

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
     
        xparams.permit(:tag, :advert_id, :lastid, :cnt, :id, :uploads_id)
    end
end
