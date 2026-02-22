class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def new
  end

  def create
    # ユーザー認証を試みる
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to root_path, notice: "ログインしました！"
    else
      # 失敗した場合、alert メッセージを設定して再表示
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません。"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, notice: "ログアウトしました。"
  end

  def guest_login
  # guest@example.com というユーザーがいなければ作成、あれば取得
  user = User.find_or_create_by!(email_address: "guest@example.com") do |u|
    u.password = SecureRandom.hex(10)
    # 必要なら、ここで初期サンプル単語をいくつか作成する
  end
  
  start_new_session_for user
  redirect_to root_path, notice: "ゲストとしてログインしました。一部の機能が試せます。"
end
end