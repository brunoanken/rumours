defmodule Rumours.Token do
  @moduledoc """
  Handles creating and validating tokens.
  """

  alias Rumours.Accounts.User

  # max_age defaults to one day
  def generate_new_account_token(%User{id: user_id}, max_age \\ 86_400) do
    {:ok,
     Phoenix.Token.sign(
       RumoursWeb.Endpoint,
       Application.get_env(:rumours, :token)[:new_account_salt],
       user_id,
       max_age: max_age
     )}
  end

  def verify_new_account_token(token, max_age \\ 86_400) do
    Phoenix.Token.verify(
      RumoursWeb.Endpoint,
      Application.get_env(:rumours, :token)[:new_account_salt],
      token,
      max_age: max_age
    )
  end
end
