class Word < ApplicationRecord
  belongs_to :user, optional: true
  
  # ステータスをわかりやすく管理
  enum :status, { learning: 0, mastered: 1 }
end
