defmodule Golos.FollowApi do
  def call(method, params) do
    Golos.call(["follow", method, params])
  end

  @doc """
  Get followers. Accepts account, starting follower, follow type (blog, ignore), limit of results.
  Returns followers in ascending alphabetical order.

  Example response:
  ```
  %{"follower" => "aim", "following" => "academy",
            "id" => "8.0.21098", "what" => ["blog"]},
  %{"follower" => "aleco", "following" => "academy",
            "id" => "8.0.20183", "what" => ["blog"]},
     %{...}, ...] ```
  """
  @spec get_followers(String.t(), String.t(), String.t(), integer) :: {:ok, [map]} | {:error, any}
  def get_followers(account, start_follower, follow_type, limit) do
    call("get_followers", [account, start_follower, follow_type, limit])
  end

  @doc """
  Get followings. Accepts account, starting following, follow type (blog, ignore), limit of results.
  Returns followings in ascending alphabetical order.

  Example response is the same as in get_followers.
  """
  @spec get_following(String.t(), String.t(), String.t(), integer) :: {:ok, [map]} | {:error, any}
  def get_following(account, start_follower, follow_type, limit) do
    call("get_following", [account, start_follower, follow_type, limit])
  end
end
