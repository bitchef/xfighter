defmodule Xfighter.API do
  alias Xfighter.Exception.ConnectionError
  alias Xfighter.Exception.InvalidJSON
  alias Xfighter.Exception.RequestError
  alias Xfighter.Exception.UnhandledAPIResponse

  use HTTPoison.Base

  defp process_url(path) do
    "https://api.stockfighter.io/ob/api" <> path
  end

  defp process_request_headers(headers) do
    api_key = Application.get_env(:xfighter, :api_key)

    headers
    |> Dict.put(:"X-Starfighter-Authorization", api_key)
  end

  def request(:get, path) do
    case get(path) do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} -> {status_code, body}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end
  def request(:delete, path) do
    case delete(path) do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} -> {status_code, body}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end
  def request(:post, path, body) do
    case post(path, body) do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} -> {status_code, body}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end


  def decode_response({:error, reason}, _options), do: raise ConnectionError, message: reason
  def decode_response({200, body}, options) do
    options = options |> Keyword.put(:keys, :atoms)

    case Poison.decode(body, options) do
      {:ok, object} -> object
      {:error, _} -> raise InvalidJSON, message: body
    end
  end
  def decode_response({status_code, body}, _options) do
    raise RequestError, message: "Error #{status_code}:  #{body}"
  end
  def decode_response(_response, _options), do: raise UnhandledAPIResponse

end
