defmodule Trans.API do

  alias GoogleApi.Translate.V2
  alias Goth.Token
  alias GoogleApi.Translate.V2.Api.Translations
  alias GoogleApi.Translate.V2.Api.Languages

  def getConn() do
    url = "https://www.googleapis.com/auth/cloud-translation"
    {:ok, token} = Token.for_scope(url)
    V2.Connection.new(token.token)
  end

  def translate(language, message) do
    conn = getConn()
    {:ok, result} = Translations.language_translations_list(conn, message, language)
    resource = hd result.translations
    resource.translatedText
  end

  def detectLanguage(message) do
    conn = getConn()
    {:ok, result} = Translations.language_translations_list(conn, message, "en")
    resource = hd result.translations
    resource.detectedSourceLanguage  
  end

  def getLanguages() do
    conn = getConn()
    {:ok, result} = Languages.language_languages_list(conn, [target: "en"])
    Enum.map(result.languages, fn resource -> 
      resource.name
    end)
  end

  def getLanguageObjects() do
    conn = getConn()
    {:ok, result} = Languages.language_languages_list(conn, [target: "en"])
    result.languages
  end
end