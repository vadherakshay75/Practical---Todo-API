# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :todo
  validates :title, presence: true, length: { maximum: 120 }
end
