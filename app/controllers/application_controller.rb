# frozen_string_literal: true

# application controller
class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :authenticate_user_from_token!, unless: -> { %w[sessions users].include?(controller_name) }

  def paginate(data)
    data.page(params[:page]).per(10)
  end

  def api_current_user(user)
    @api_current_user ||= user
  end

  def rescue_404
    render_json({ message: I18n.t('bad_request') }, :not_found)
  end

  def record_not_found
    render_json({ message: I18n.t('record_not_found') }, :not_found)
  end

  def render_json(object, status = :ok)
    render json: object, status: status
  end

  def authenticate_user_from_token!
    token = request.headers['token']
    user = token.present? && User.find_by_authentication_token(token)
    if user
      api_current_user(user)
    else
      render_json({ message: I18n.t('invalid_details') }, :not_found)
    end
  end
end
