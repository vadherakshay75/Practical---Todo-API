# frozen_string_literal: true

class Todo < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :destroy
  validates :title, presence: true, length: { maximum: 120 }
  validates :description, length: { maximum: 160 }
  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

  def all_items_completed?
    items.all?(&:is_completed)
  end

  def self.last_month_todos_of_user(user_id)
    where(
      created_at: Date.today.beginning_of_month - 1.month..Date.today.beginning_of_month,
      user_id: user_id
    )
  end
end
