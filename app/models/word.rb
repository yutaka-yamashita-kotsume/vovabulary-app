class Word < ApplicationRecord
  belongs_to :user
  # ステータスをわかりやすく管理
  enum :status, { learning: 0, mastered: 1 }
end
