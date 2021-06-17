defmodule Hackernews.Repositories.Storie do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_params [:by, :descendants, :key, :score, :time, :title, :type, :url]

  schema "stories" do
    field(:by, :string)
    field(:descendants, :integer)
    field(:key, :integer)
    field(:score, :integer)
    field(:time, :integer)
    field(:title, :string)
    field(:type, :string)
    field(:url, :string)

    timestamps()
  end

  def changeset(%{"id" => key} = params) do
    params = Map.put(params, "key", key)

    %__MODULE__{}
    |> cast(params, @required_params)
  end
end
