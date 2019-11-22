defmodule Trans.Chat do
    #TODO: show pieces that have been taken from the board

    def new() do
    %{
        messages: [],
        players: [],
        langs: [],
    }
    end

    def client_view(chat, user) do
    %{
        messages: chat.messages,
        players: chat.players,
        langs: chat.langs,
    }
    end

    def translateMessage(message) do
        
        
    end

end