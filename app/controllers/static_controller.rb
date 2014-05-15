class StaticController < ApplicationController

before_action :authenticate_admin!, :only => [:test]

  def home
  end
  
  def contact
  end
  
  def adunit
  end
  
  def coupons
  end
  
  def test
  end
  
end