require "net/http"
require "uri"
require "json"

class WordsController < ApplicationController
  before_action :set_word, only: %i[ show edit update destroy ]

  # GET /words or /words.json
  def index
    @words = Current.user.words
  end

  def home
    # トップ画面（Dashboard）用のアクション（新設）
    # ここでは特にデータを使わないので空でもOK
  end

  # GET /words/1 or /words/1.json
  def show
  end

  # GET /words/new
  def new
    @word = Current.user.words.new
  end

  # GET /words/1/edit
  def edit
  end

  # POST /words or /words.json
  def create
    @word = Current.user.words.new(word_params)

    # 意味(meaning)が空で、単語(original_text)が入っている場合のみAIに聞く
    if @word.original_text.present? && (@word.meaning.blank? || @word.meaning == "")
      @word.meaning = fetch_ai_meaning(@word.original_text)
    end

    if @word.save
      redirect_to words_path, notice: "単語を登録しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /words/1 or /words/1.json
  def update
    # 送信されたパラメータを取得
    attrs = word_params.to_h

    # 意味(meaning)が空で、単語(original_text)が入っている場合、AIに再翻訳させる
    if attrs["original_text"].present? && attrs["meaning"].blank?
      attrs["meaning"] = fetch_ai_meaning(attrs["original_text"])
    end

    respond_to do |format|
      if @word.update(attrs) # 翻訳後のパラメータで更新
        format.html { redirect_to words_path, notice: "単語を更新しました！" } # indexに戻る方が使いやすいかもしれません
        format.json { render :show, status: :ok, location: @word }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1 or /words/1.json
  def destroy
    @word = Current.user.words.find(params[:id])
    @word.destroy!

    respond_to do |format|
      format.html { redirect_to words_url, notice: "Word was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  skip_before_action :verify_authenticity_token, only: [:record_answer]

  def record_answer
    @word = Current.user.words.find(params[:word_id])
    
    # isCorrect が true または "true" の場合にカウントアップ
    if params[:correct] == true || params[:correct] == "true"
      @word.increment!(:consecutive_correct_count)
    else
      # 間違えたらリセット
      @word.update(consecutive_correct_count: 0)
    end

    render json: { status: "ok", count: @word.consecutive_correct_count }
  rescue => e
    render json: { status: "error", message: e.message }, status: :unprocessable_entity
  end

  private
  def set_word
    @word = Word.find(params[:id])
  end

   def fetch_ai_meaning(text)
  api_key = "6906a107-fe48-4ec0-b9f4-6589dd22aab1:fx"
  uri = URI.parse("https://api-free.deepl.com/v2/translate")

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
# ヘッダーに認証情報を載せる（最新の仕様）
  request = Net::HTTP::Post.new(uri.path)
  request["Authorization"] = "DeepL-Auth-Key #{api_key}"
  request.set_form_data({
    text: text,
    target_lang: "JA"
  })

  response = http.request(request)
  result = JSON.parse(response.body)

  if response.code == "200"
    result["translations"][0]["text"]
  else
    # 失敗した場合、理由を表示
    "DeepLエラー: #{result['message'] || response.code}"
  end
rescue => e
  "例外エラー: #{e.message}"
end

  def word_params
    params.require(:word).permit(:original_text, :meaning)
  end

end
