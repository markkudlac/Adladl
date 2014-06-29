class Advert < ActiveRecord::Base
  has_many :ad_lists, dependent: :destroy
  has_one :landing
  
  belongs_to :client
end