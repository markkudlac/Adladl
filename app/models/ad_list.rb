class AdList < ActiveRecord::Base
  belongs_to :device
  belongs_to :advert
end