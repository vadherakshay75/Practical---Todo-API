# frozen_string_literal: true

class Todo < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :destroy
  validates :title, presence: true, length: { maximum: 120 }
  validates :description, length: { maximum: 160 }
  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true
end
