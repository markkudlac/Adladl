class Client < ActiveRecord::Base
  belongs_to :admin
  has_many :adverts, dependent: :destroy
  has_many :icons, dependent: :destroy
  has_many :landings, dependent: :destroy
end