class DictionaryService
  def self.fetch_meaning(word)
    url = "https://api.dictionaryapi.dev/api/v2/entries/en/#{word}"
    response = Faraday.get(url)

    return nil unless response.success?

    data = JSON.parse(response.body)
    # 最初の意味（definition）を取得して日本語に翻訳（※簡易的に最初の定義を返す）
    # 本格的な和訳にはDeepL等が必要ですが、まずはデータが取れるか確認します
    data.first["meanings"].first["definitions"].first["definition"]
  rescue
    nil
  end
end
