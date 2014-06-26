class StaticController < ApplicationController

before_action :authenticate_admin!, :only => [:test]

  def home
  end
  
  def contact
  end
  
  def adunit
    @devicetag = params[:tag]
    
    if (params[:prize] == "p") then
      @prizemode = true
    else
      @prizemode = false
    end
  end
  
  def coupons
    @devicetag = params[:tag]
  end
  
  def test
     puts "Current user is #{current_admin.email}"
     
    if !current_admin.email.include?("adladl.com") then
      render :template => "static/home"
    end
  end
  
end
