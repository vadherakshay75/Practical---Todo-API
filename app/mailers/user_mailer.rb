# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def send_welcome_email(user)
    @user = user
    mail(to: user.email, subject: 'Welcome to TODO')
  end
end
