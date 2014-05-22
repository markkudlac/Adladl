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
  end
  
end
