defmodule Trans.Chat do
    #TODO: show pieces that have been taken from the board

    def new() do
    %{
        messages: [],
        players: [],
    }
    end

    def client_view(chat, usser) do
    %{
        messages: chat.messages,
        players: chat.players,
    }
    end

end