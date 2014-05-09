class Device < ActiveRecord::Base
  has_many :ad_lists, dependent: :destroy
  
end