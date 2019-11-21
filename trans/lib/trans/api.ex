defmodule Trans.API do

  alias GoogleApi.Translate.V2
  alias Goth.Token
  alias GoogleApi.Translate.V2.Api.Translations


  def translate(target, message) do
    url = "https://www.googleapis.com/auth/cloud-translation"
    {:ok, token} = Token.for_scope(url)
    conn = V2.Connection.new(token.token)
    {:ok, result} = Translations.language_translations_list(conn, message, target)
    resource = hd result.translations
    resource.translatedText
  end

  def detectLanguage(message) do
    url = "https://www.googleapis.com/auth/cloud-translation"
    {:ok, token} = Token.for_scope(url)
    conn = V2.Connection.new(token.token)
    {:ok, result} = Translations.language_translations_list(conn, message, "en")
    resource = hd result.translations
    resource.detectedSourceLanguage  
  end

end