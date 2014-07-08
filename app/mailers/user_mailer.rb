class UserMailer < ActionMailer::Base
  default from: "noreply@adladl.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.followup.subject
  #
  def followup advert_id, fname, email
    @fname = fname
    subject = "Follow Up"
    
    begin
      advert = Advert.find(advert_id)
      @href = advert.urlhref
      
      mimetype = advert.filename.split('.')
      mimetype = mimetype[mimetype.length-1]
      @srcb64 = "data:image/"+ mimetype +";base64,"+advert.image
      
      @src = "http://www.adladl.com/api/getimage/#{advert.id}/#{advert.filename}"
      
      if (!advert.descript.nil? && advert.descript.length > 0) then
        subject = advert.descript
      end
      
    rescue
      @href = "#"
      @srcb64 = ""
      @src = ""
    end
    
    mail to: email, subject: subject
  end
end
