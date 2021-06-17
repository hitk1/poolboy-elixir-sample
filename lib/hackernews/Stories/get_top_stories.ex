defmodule Stories.GetTopStories do
  require Logger

  def call() do
    response =
      HTTPoison.get!("https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty")

    case response do
      %HTTPoison.Response{} ->
        stories_id = Poison.decode!(response.body)

        Enum.map(
          stories_id,
          fn id ->
            Task.async(fn ->
              :poolboy.transaction(
                :poolworker,
                fn pid ->
                  GenServer.call(pid, {:request_stories, id})
                end,
                :infinity
              )
            end)
          end
        )
        |> Enum.each(fn task -> Task.await(task, 3_000) |> Logger.info("Finalizado") end)

      _ ->
        Logger.info("nao caiu no case")
    end
  end
end
