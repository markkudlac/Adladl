class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_one :client, dependent: :destroy
  
  after_create :add_client
   
  if Rails.env.development? || ENV['ADMIN_ADLADL'] == "registerable" then
    devise :registerable
  end
  
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
         
  private
  
  def add_client
    Client.create(admin_id: id, apikey: "apikey_"+id.to_s, company: "Testy Co Ltd.")
  end
end
