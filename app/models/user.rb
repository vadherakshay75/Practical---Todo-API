# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  acts_as_token_authenticatable

  delegate :id, to: :user, allow_nil: true, prefix: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  has_many :todos
  after_create :send_welcome_email
  before_save :validate_user

  def validate_user
    errors.add('must be in lower case.') unless email == email.downcase
  end

  def completed_todos
    todos.map { |todo| todo if todo.all_items_completed? }.compact
  end

  def send_welcome_email
    # TODO: For testing/practical purpose, It's deliver_now, it must be deliver_later
    UserMailer.send_welcome_email(self).deliver_now
  end
end
