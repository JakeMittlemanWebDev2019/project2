defmodule Trans.ChatServer do
    use GenServer
  
    def reg(name) do
      {:via, Registry, {Trans.ChatReg, name}}
    end
  
    def start(name) do
      spec = %{
        id: __MODULE__,
        start: {__MODULE__, :start_link, [name]},
        restart: :permanent,
        type: :worker
      }
      Trans.ChatSup.start_child(spec)
    end
  
    def start_link(name) do
      chat = Trans.BackupAgent.get(name) || Trans.Chat.new()
      GenServer.start_link(__MODULE__, chat, name: reg(name))
    end

    def reset_chat(name) do
        GenServer.call(reg(name), {:reset, name})
    end

    def peek(name, user, lang) do
        GenServer.call(reg(name), {:peek, name, user, lang})
    end

  
    # Implementation
  
    def init(chat) do
      {:ok, chat}
    end
  
    def handle_call({:click, name, user, i, j}, _from, chat) do
      chat = Trans.Chat.move_piece(chat, user, i, j)
      Trans.BackupAgent.put(name, chat)
      {:reply, chat, chat}
    end
  
    def handle_call({:reset, name}, _from, chat) do
      chat = Trans.Chat.reset_chat()
      Trans.BackupAgent.put(name, chat)
      {:reply, chat, chat}
    end

    def handle_call({:peek, name, user, lang}, _from, chat) do
      if (!Enum.member?(chat.currLangs, lang)) do
        chat = Map.merge(chat, %{currLangs: (chat.currLangs ++ [lang])})
        Trans.BackupAgent.put(name, chat)
        {:reply, chat, chat}
      else
        {:reply, chat, chat}
      end
    end
  end