class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  if Rails.env.development? || ENV['ADMIN_ADLADL'] == "registerable" then
    devise :registerable
  end
  
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
end
