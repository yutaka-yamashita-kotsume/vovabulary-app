require "net/http"
require "uri"
require "json"

class WordsController < ApplicationController
  before_action :set_word, only: %i[ show edit update destroy ]

  # GET /words or /words.json
  def index
    @words = Word.all
  end

  # GET /words/1 or /words/1.json
  def show
  end

  # GET /words/new
  def new
    @word = Word.new
  end

  # GET /words/1/edit
  def edit
  end

  # POST /words or /words.json
  def create
    @word = Word.new(word_params)
    # とりあえず「一番最初のユーザー」をこの単語の持ち主にする
    @word.user = User.first

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
    respond_to do |format|
      if @word.update(word_params)
        format.html { redirect_to @word, notice: "Word was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @word }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1 or /words/1.json
  def destroy
    @word.destroy!

    respond_to do |format|
      format.html { redirect_to words_path, notice: "Word was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
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

    # Only allow a list of trusted parameters through.
    def word_params
      params.expect(word: [ :original_text, :meaning ])
    end
  end
