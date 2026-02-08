class RegistrationsController < ApplicationController
  allow_unauthenticated_access
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      start_new_session_for @user
      redirect_to root_path, notice: "会員登録が完了しました！"
    else
      # 理由を詳しく取得（メール重複など）
      error_message = @user.errors.full_messages.join(" / ")
      flash.now[:alert] = "登録できませんでした: #{error_message}"
      
      # URLが /registrations になったまま new 画面を表示する
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # フォームのデータ構造に合わせて require(:user) を入れる
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end