# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :title
      t.boolean :is_completed
      t.references :todo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
