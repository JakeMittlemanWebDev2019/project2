defmodule TransWeb.ChatsChannel do
    use TransWeb, :channel
  
    alias Trans.Chat
    alias Trans.BackupAgent
  
    intercept ["update"]
  
    def join("chats:" <> name, payload, socket) do
      if authorized?(payload) do
        Trans.ChatServer.start(name)
        chat = Trans.ChatServer.peek(name, socket.assigns[:user])
  
        # chat = BackupAgent.get(name) || Chat.new()
  
        socket = socket
        |> assign(:chat, chat)
        |> assign(:name, name)
        BackupAgent.put(name, chat)
        {:ok, %{"join" => name, "chat" => Chat.client_view(chat, socket.assigns[:user])}, socket}
      else
        {:error, %{reason: "unauthorized"}}
      end
    end
  
    # def handle_in("click", %{"i" => i, "j" => j}, socket) do
    #     name = socket.assigns[:name]
    #     user = socket.assigns[:user]
  
    #     chat = Trans.ChatServer.move_piece(name, user, i, j)
  
    #     # chat = Chat.move_piece(chat, i, j)
  
    #     socket = assign(socket, :chat, chat)
    #     BackupAgent.put(name, chat)
    #     broadcast!(socket, "update", %{chat: chat})
    #     {:reply, {:ok, %{ "chat" => Chat.client_view(chat, user)}}, socket}
    # end
  
    # def handle_in("reset", _payload, socket) do
    #     name = socket.assigns[:name]
  
    #     chat = Trans.ChatServer.reset_chat(name)
    #     # Chat.reset_chat()
    #     socket = assign(socket, :chat, chat)
    #     BackupAgent.put(name, chat)
    #     {:reply, {:ok, %{ "chat" => Chat.client_view(chat, socket.assigns[:user])}}, socket}
    # end
  
    def handle_in("chat", %{"message" => message}, socket) do
      name = socket.assigns[:name]
      user = socket.assigns[:user]
      broadcast!(socket, "new message", %{message: message, user: user})
      {:noreply, socket}
    end
  
    def handle_out("update", payload, socket) do
      push(socket, "update", %{ "chat" => Chat.client_view(payload.chat, socket.assigns[:user]) })
      {:noreply, socket}
    end
  
    # Add authorization logic here as required.
    def authorized?(_payload) do
      true
    end
  end
  