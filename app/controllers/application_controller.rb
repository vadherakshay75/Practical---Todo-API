# frozen_string_literal: true

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
    render_json({ message: 'Bad request' }, :not_found)
  end

  def record_not_found
    render_json({ message: 'Record not found' }, :not_found)
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
      render_json({ message: 'Invalid credentials' }, :not_found)
    end
  end
end
