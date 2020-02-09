# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :user_exists?, only: :create

  def create
    if @user&.authenticate(params[:password])
      render_json(@user)
    else
      render_json({ message: 'Invalid credentials' }, :unprocessable_entity)
    end
  end

  private

  def user_exists?
    @user = User.find_by_email(params[:email])
    return if @user.present?

    render_json({ message: 'User not found' }, :not_found)
  end
end
