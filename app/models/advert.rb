class Advert < ActiveRecord::Base
  has_many :ad_lists, dependent: :destroy
  belongs_to :client
end