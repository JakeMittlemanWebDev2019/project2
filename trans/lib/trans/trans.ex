defmodule Trans.Chat do
    #TODO: show pieces that have been taken from the board

    def new() do
    %{
        messages: [],
        players: [],
        languageMap: makeLanguageMap(),
    }
    end

    def client_view(chat, user) do
    %{
        messages: chat.messages,
        players: chat.players,
        languageMap: chat.languageMap,
    }
    end

    def makeLanguageMap() do
        Enum.map(Trans.API.getLanguageObjects, fn obj ->
            {obj.name, obj.language}
        end)
        |> Enum.into(%{})
    end

end