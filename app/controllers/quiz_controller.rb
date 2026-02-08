class QuizController < ApplicationController
  def index
    # 1. 【修正】現在のユーザーの単語の中から、卒業していないものを抽出
    all_available = Current.user.words.where("consecutive_correct_count < ?", 3)
    
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
      session[:quiz_tested_ids] = nil
      render :finish and return
    end

    # 4. 「まだこの回で出題していない単語」から正解を選ぶ
    session[:quiz_tested_ids] ||= []
    @correct_word = all_available.where.not(id: session[:quiz_tested_ids]).order("RANDOM()").first
    
    # 【万が一のガード】もし単語が取れなかったらリセットして終了（削除直後などの対策）
    if @correct_word.nil?
      session[:quiz_current_index] = nil
      session[:quiz_tested_ids] = nil
      redirect_to words_path, notice: "問題の準備ができませんでした。単語を登録してください。" and return
    end

    session[:quiz_tested_ids] << @correct_word.id

    # 5. 【修正】選択肢も「現在のユーザーの単語」から取得
    other_choices = Current.user.words.where.not(id: @correct_word.id).order("RANDOM()").limit(3)
    @choices = ([@correct_word] + other_choices).shuffle
    
    session[:quiz_current_index] += 1
  end

  def reset
    session[:quiz_current_index] = nil
    session[:quiz_tested_ids] = nil
    redirect_to quiz_path
  end
end