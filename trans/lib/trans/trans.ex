defmodule Trans.Chat do
    #TODO: show pieces that have been taken from the board

    alias Trans.API

    def new() do
    %{
        messages: [],
        players: [],
        languageMap: makeLanguageMap(),
        currLangs: [],
    }
    end

    def client_view(chat, user) do
    %{
        messages: chat.messages,
        players: chat.players,
        languageMap: chat.languageMap,
        currLangs: chat.currLangs,
    }
    end

    def add_message(chat, user, message) do
        %{
            messages: chat.messages ++ [message],
            players: chat.players,
            languageMap: chat.languageMap,
            currLangs: chat.currLangs,
        }
    end

    def makeLanguageMap() do
        Enum.map(Trans.API.getLanguageObjects, fn obj ->
            {obj.name, obj.language}
        end)
        |> Enum.into(%{})
    end

    def doTranslations(chat, message, languages) do
        # languages = "english", "spanish", etc.
        Enum.map(languages, fn language -> 
            {language, API.translate(chat.languageMap[language], message)}
        end)
        |> Enum.into(%{})
    end
end