class UserMailer < ActionMailer::Base
  default from: "noreply@adladl.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.followup.subject
  #
  def followup fname, email
    @fname = fname

    mail to: email, subject: "Follow up"
  end
end
