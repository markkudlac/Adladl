class ClientsController < ApplicationController

before_action :authenticate_admin!

  def show
#    puts "admin id : #{current_admin_id}"
    
    @client = Client.where(admin_id: current_admin.id)[0]
    
  end
  
  def create
    upload = client_params(params)[:ad_image]
    
    encd_str = Base64.encode64(File.read(upload.path()))
      
    render :json => {
            file: upload.original_filename,
            mime: upload.content_type,
            ad_image: encd_str
          }
  end
  
  
  private
  
  def client_params(xparams)
#    puts "PARAMS PASSED : #{xparams}"
     xparams = xparams.require(:client) if xparams[:client]
   
      xparams.permit(:ad_image, :firstname)
  end
end