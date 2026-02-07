class QuizController < ApplicationController
  def index
    # クイズの全問題数を設定
    @total_questions = [Word.count, 5].min

    # セッションの初期化（初回アクセス時のみ1をセット）
    session[:quiz_current_index] ||= 1
    @current_index = session[:quiz_current_index]

    # 終了判定
    if @current_index > @total_questions
      session[:quiz_current_index] = nil
      render :finish and return
    end

    # 出題単語の選定
    @words = Word.order("RANDOM()").limit(4)
    @correct_word = @words.sample
    @choices = @words.shuffle
    
    # 次回アクセス用にカウントを1増やす（ここがポイント）
    session[:quiz_current_index] += 1
  end

  def reset
    session[:quiz_current_index] = nil
    redirect_to quiz_path
  end
end