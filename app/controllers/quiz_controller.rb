class QuizController < ApplicationController
  def index
    # 1. 卒業していない単語（正解数3未満）を抽出
    all_available = Word.where("consecutive_correct_count < ?", 3)
    
    # 2. テストの全問題数を決定（最大5問）
    @total_questions = [all_available.count, 5].min
    
    if @total_questions == 0
      session[:quiz_tested_ids] = nil
      render :finish and return
    end

    # 3. 現在の何問目かを管理
    session[:quiz_current_index] ||= 1
    @current_index = session[:quiz_current_index]

    if @current_index > @total_questions
      session[:quiz_current_index] = nil
      session[:quiz_tested_ids] = nil # 出題済みリストもリセット
      render :finish and return
    end

    # 4. 「まだこの回で出題していない単語」から正解を選ぶ
    session[:quiz_tested_ids] ||= []
    @correct_word = all_available.where.not(id: session[:quiz_tested_ids]).order("RANDOM()").first
    
    # 出題済みリストに追加
    session[:quiz_tested_ids] << @correct_word.id

    # 5. 選択肢の作成（正解以外の3つを全単語からランダムに取得）
    other_choices = Word.where.not(id: @correct_word.id).order("RANDOM()").limit(3)
    @choices = ([@correct_word] + other_choices).shuffle
    
    session[:quiz_current_index] += 1
  end

  # resetアクションも修正（出題済みリストを消す）
  def reset
    session[:quiz_current_index] = nil
    session[:quiz_tested_ids] = nil
    redirect_to quiz_path
  end

  # record_answer はそのままでOK
end