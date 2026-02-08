class QuizController < ApplicationController
  def index
    # 1. ユーザー自身の単語から、未卒業（3回未満）を抽出
    all_available = Current.user.words.where("consecutive_correct_count < ?", 3)
    
    # 【追加】もし全単語が学習済み（または単語が0件）の場合の特別処理
    if Current.user.words.exists? && all_available.count == 0
      @all_mastered = true # ビューでメッセージを出し分けるためのフラグ
      render :finish and return
    end

    # 2. テストの全問題数を決定（最大5問）
    @total_questions = [all_available.count, 5].min
    
    if @total_questions == 0
      # 単語が1件も登録されていない場合
      redirect_to words_path, notice: "まずは単語を登録しましょう！" and return
    end

    # 3. 現在の何問目かを管理
    session[:quiz_current_index] ||= 1
    @current_index = session[:quiz_current_index]

    # テスト終了時の処理
    if @current_index > @total_questions
      # 1. 表示用のデータを変数に格納する
      @correct_answers = session[:quiz_correct_count] || 0
      @mastered_count = Current.user.words.where("consecutive_correct_count >= ?", 3).count
      @learning_count = Current.user.words.where("consecutive_correct_count < ?", 3).count
      
      session[:quiz_current_index] = nil
      session[:quiz_tested_ids] = nil
      session[:quiz_correct_count] = nil

      render :finish and return
    end

    # 4. 正解を選ぶ（自分の単語から）
    session[:quiz_tested_ids] ||= []
    @correct_word = all_available.where.not(id: session[:quiz_tested_ids]).order("RANDOM()").first
    
    if @correct_word.nil?
      session[:quiz_current_index] = nil
      session[:quiz_tested_ids] = nil
      redirect_to quiz_path and return
    end

    session[:quiz_tested_ids] << @correct_word.id

    # 5. 選択肢（自分の単語から）
    other_choices = Current.user.words.where.not(id: @correct_word.id).order("RANDOM()").limit(3)
    @choices = ([@correct_word] + other_choices).shuffle
    
    session[:quiz_current_index] += 1
  end

  def record_answer
    word = Current.user.words.find(params[:id])
    correct = params[:correct] == "true"

    if correct
      word.increment!(:consecutive_correct_count)
      # --- 正解数をセッションに加算 ---
      session[:quiz_correct_count] ||= 0
      session[:quiz_correct_count] += 1
    else
      word.update(consecutive_correct_count: 0)
    end

    render json: { success: true }
  end

  def reset
    session[:quiz_current_index] = nil
    session[:quiz_tested_ids] = nil
    session[:quiz_correct_count] = nil
    redirect_to quiz_path
  end
end