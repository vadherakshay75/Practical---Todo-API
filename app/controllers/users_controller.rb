# frozen_string_literal: true

# users controller
class UsersController < ApplicationController
  before_action :set_user, only: :show

  def create
    @user = User.new(user_params)
    if @user.save
      render_json(
        { todo: @todo, message: I18n.t('resource.created.success', resource: 'User') }, :created
      )
    else
      render_json({ errors: user.errors.full_messages }, :unprocessable_entity)
    end
  end

  def show
    render_json(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
