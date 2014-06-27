class ClientsController < ApplicationController

before_action :authenticate_admin!

  def show
#    puts "admin id : #{current_admin_id}"
    
    @client = Client.where(admin_id: current_admin.id)[0]
    
  end
  
  def create

  end
  
  
  private
  
  def client_params(xparams)
#    puts "PARAMS PASSED : #{xparams}"
     xparams = xparams.require(:client) if xparams[:client]
   
      xparams.permit(:company, :firstname)
  end
end