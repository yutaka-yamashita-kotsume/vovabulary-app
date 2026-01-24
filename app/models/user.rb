class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  # これを追加！
  has_many :words, dependent: :destroy
end
