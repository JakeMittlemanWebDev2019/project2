defmodule TransWeb.ChatsChannel do
    use TransWeb, :channel
  
    alias Trans.Chat
    alias Trans.BackupAgent
  
    intercept ["update"]

    # Send a message and list of languages to channel
    # send list of languages to server to get map of translations
    # send map of translations and user language to "client_vew"
        # in a handle-out call which will work for each user
  
    def join("chats:" <> name, payload, socket) do
      if authorized?(payload) do
        Trans.ChatServer.start(name)
        lang = Trans.Users.get_user_by_username(socket.assigns[:user])
        lang = lang.default_lang
        chat = Trans.ChatServer.peek(name, socket.assigns[:user], lang)
  
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
  
    # def handle_in("chat", %{"message" => message}, socket) do
    #   name = socket.assigns[:name]
    #   user = socket.assigns[:user]
    #   # Auto-detect the language and IO.puts() it
    #   broadcast!(socket, "new message", %{message: message, user: user})
    #   {:noreply, socket}
    # end

    def handle_in("chat", %{"message" => message}, socket) do
      name = socket.assigns[:name]
      user = socket.assigns[:user]
      # Auto-detect the language and IO.puts() it

      userLang = Trans.Users.get_user_by_username(user)
      userLang = userLang.default_lang

      chat = Trans.ChatServer.peek(socket.assigns[:name], socket.assigns[:user], userLang)
      translations = Chat.doTranslations(chat, message, chat.currLangs)

      # get 
      broadcast!(socket, "update", %{user: user, translations: translations, chat: chat})
      {:noreply, socket}
    end

    def handle_in("photo", %{"photo" => photo}, socket) do
      name = socket.assigns[:name]
      user = socket.assigns[:user]
      
      broadcast!(socket, "new_photo", %{message: photo, user: user})
      {:noreply, socket}
    end
  
    def handle_out("update", payload, socket) do
      # get user language
      user = socket.assigns[:user]
      userLang = Trans.Users.get_user_by_username(user)
      userLang = userLang.default_lang

      # get map of languages
      translations = payload.translations

      message = translations[userLang]

      # get translated message
      push(socket, "update", %{ "chat" => Chat.client_view(payload.chat, socket.assigns[:user]),
                            "user" => payload.user,
                            "message" => message })
      {:noreply, socket}
    end
  
    # Add authorization logic here as required.
    def authorized?(_payload) do
      true
    end
  end
  