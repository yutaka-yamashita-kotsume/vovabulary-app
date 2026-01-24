class CreateStudyLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :study_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.date :studied_on, null: false
      t.integer :answers_count, default: 0, null: false   # デフォルト0
      t.boolean :is_goal_achieved, default: false, null: false # デフォルトfalse

      t.timestamps
    end
    # 同じ日に1人1つだけログを持つようにユニーク制約をつけるのがおすすめ
    add_index :study_logs, [:user_id, :studied_on], unique: true
  end
end