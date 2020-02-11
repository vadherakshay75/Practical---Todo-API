# frozen_string_literal: true

# sessions controller
class SessionsController < ApplicationController
  before_action :user_exists?, only: :create

  def create
    if @user&.authenticate(params[:password])
      render_json(user: @user, message: I18n.t('login_success'))
    else
      render_json({ message: I18n.t('invalid_details') }, :unprocessable_entity)
    end
  end

  private

  def user_exists?
    @user = User.find_by_email(params[:email])
    return if @user.present?

    render_json({ message: I18n.t('user_not_found') }, :not_found)
  end
end
