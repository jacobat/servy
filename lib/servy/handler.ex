defmodule Servy.Handler do

  alias Servy.Conv

  @moduledoc "Handles HTTP requests"

  @pages_path Path.expand("../../pages", __DIR__)

  @doc "Transforms the request into a response."
  def handle(request) do
    request
    |> Servy.Parser.parse
    |> Servy.Plugins.rewrite_path
    |> IO.inspect
    |> route
    |> Servy.Plugins.track
    |> format_response
  end

  def route(%Conv{ method: "GET", path: "/wildthings" } = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%Conv{ method: "GET", path: "/bears" } = conv) do
    %{ conv | status: 200, resp_body: "Teddy, Smokey, Paddington" }
  end

  def route(%Conv{ method: "GET", path: "/bears/new" } = conv) do
    Path.expand("../../pages", __DIR__)
    |> Path.join("form.html")
    |> File.read
    |> Servy.FileHandler.handle_file(conv)
  end

  def route(%Conv{ method: "GET", path: "/bears/" <> id } = conv) do
    %{ conv | status: 200, resp_body: "Bear #{id}" }
  end

  def route(%Conv{ method: "GET", path: "/about" } = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read
    |> Servy.FileHandler.handle_file(conv)
  end

  def route(%Conv{ path: path } = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!" }
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

# GET /wildthings

# request = """
# GET /wildthings HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*
#
# """
#
# response = Servy.Handler.handle(request)
# IO.puts response

# # GET /bears
#
# request = """
# GET /bears HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*
#
# """
# response = Servy.Handler.handle(request)
# IO.puts response

#
# # GET /bigfoot
#
# request = """
# GET /bigfoot HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*
#
# """
# response = Servy.Handler.handle(request)
# IO.puts response
#
# # GET /bears/1
#
# request = """
# GET /bears/1 HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*
#
# """
# response = Servy.Handler.handle(request)
# IO.puts response
#
# # GET /wildlife
#
# request = """
# GET /wildlife HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*
#
# """

#
# # GET /about
#
request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
#
response = Servy.Handler.handle(request)
IO.puts response
