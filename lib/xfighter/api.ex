defmodule Xfighter.API do
  alias Xfighter.Exception.ConnectionError
  alias Xfighter.Exception.RequestError
  alias Xfighter.Exception.UnhandledAPIResponse

  use HTTPoison.Base

  defp process_url(fragment) do
    "https://api.stockfighter.io/ob/api" <> fragment
  end

  defp process_request_headers(headers) do
    api_key = Application.get_env(:xfighter, :api_key)

    headers
    |> Dict.put(:"X-Starfighter-Authorization", api_key)
  end

  defp process_response_body(body) do
    case Poison.decode(body, keys: :atoms) do
      {:ok, json} -> json
      {:error, _} -> raise ConnectionError, message: body
    end
  end

  def request(:get, url) do
    case get(url) do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} -> {status_code, body}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end
  def request(:delete, url) do
    case delete(url) do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} -> {status_code, body}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end
  def request(:post, url, body) do
    case post(url, body) do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} -> {status_code, body}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end

  def parse_response({_status_code, resp=%{:ok => true}}), do: resp
  def parse_response({status_code, %{:ok => false, :error => reason}}) do
    raise RequestError, message: "Error #{status_code}:  #{reason}"
  end
  def parse_response({:error, reason}), do: raise ConnectionError, message: reason
  def parse_response(_), do: raise UnhandledAPIResponse

end
