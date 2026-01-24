class CreateWords < ActiveRecord::Migration[8.1]
  def change
    create_table :words do |t|
      t.references :user, null: false, foreign_key: true # ユーザー紐付け
      t.string :original_text, null: false             # 英単語 (nameから変更)
      t.text :meaning                                  # 日本語訳 (definitionから変更)
      t.integer :correct_count, default: 0, null: false # 正解数
      t.integer :status, default: 0, null: false        # 0:学習中, 1:卒業
      t.datetime :last_tested_at                       # 最終回答日時

      t.timestamps
    end
  end
end