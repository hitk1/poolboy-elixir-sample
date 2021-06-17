defmodule Hackernews.PoolWorker do
  require Logger
  use GenServer

  alias Hackernews.Repo
  alias Hackernews.Repositories.Storie, as: StorieRepo

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:request_stories, storie_id}, _from, state) do
    response =
      "https://hacker-news.firebaseio.com/v0/item/#{storie_id}.json?print=pretty"
      |> HTTPoison.get!()

    case response do
      %HTTPoison.Response{} ->
        storie = response.body |> Poison.decode!()
        create_storie(storie)

        {:reply, storie, state}

      _ ->
        Logger.info("caiu aqui")
        {:reply, nil, state}
    end
  end

  defp create_storie(storie) do
    StorieRepo.changeset(storie)
    |> Repo.insert!()
  end
end
