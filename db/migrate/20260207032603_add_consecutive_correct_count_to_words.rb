class AddConsecutiveCorrectCountToWords < ActiveRecord::Migration[7.1]
  def change
    add_column :words, :consecutive_correct_count, :integer, default: 0
  end
end