class Client < ActiveRecord::Base
  belongs_to :admin
  has_many :adverts, dependent: :destroy
  has_many :icons, dependent: :destroy
  
end