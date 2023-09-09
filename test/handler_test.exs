defmodule HandlerTest do
  use ExUnit.Case

  test "GET /wildthings" do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: curl/7.43.0\r
    Accept: */*\r
    \r
    """

    response = Servy.Handler.handle(request)

    assert response == """
           HTTP/1.1 200 OK\r
           content-type: text/html\r
           content-length: 20\r
           \r
           Bears, Lions, Tigers
           """
  end

  test "GET /bears" do
    request = """
    GET /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: curl/7.43.0\r
    Accept: */*\r
    \r
    """

    response = Servy.Handler.handle(request)

    assert response == """
           HTTP/1.1 200 OK\r
           content-type: text/html\r
           content-length: 312\r
           \r
           <h1>All the bears</h1>
           <ul>

             <li>Brutus - Grizzly</li>

             <li>Iceman - Polar</li>

             <li>Kenai - Grizzly</li>

             <li>Paddington - Brown</li>

             <li>Roscoe - Panda</li>

             <li>Rosie - Black</li>

             <li>Scarface - Grizzly</li>

             <li>Smokey - Black</li>

             <li>Snow - Polar</li>

             <li>Teddy - Brown</li>

           </ul>

           """
  end

  test "GET /bigfoot" do
    request = """
    GET /bigfoot HTTP/1.1\r
    Host: example.com\r
    User-Agent: curl/7.43.0\r
    Accept: */*\r
    \r
    """

    response = Servy.Handler.handle(request)

    assert response == """
           HTTP/1.1 404 Not Found\r
           content-type: text/html\r
           content-length: 16\r
           \r
           No /bigfoot here
           """
  end

  test "GET /bears/1" do
    request = """
    GET /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: curl/7.43.0\r
    Accept: */*\r
    \r
    """

    response = Servy.Handler.handle(request)

    assert response == """
           HTTP/1.1 200 OK\r
           content-type: text/html\r
           content-length: 70\r
           \r
           <h1>Show bear</h1>
           <p>Is Teddy hibernating? <strong>true</strong></p>

           """
  end

  test "GET /wildlife" do
    request = """
    GET /wildlife HTTP/1.1\r
    Host: example.com\r
    User-Agent: curl/7.43.0\r
    Accept: */*\r
    \r
    """

    response = Servy.Handler.handle(request)

    assert response ==
             """
             HTTP/1.1 200 OK\r
             content-type: text/html\r
             content-length: 20\r
             \r
             Bears, Lions, Tigers
             """
  end

  test "GET /about" do
    request = """
    GET /about HTTP/1.1\r
    Host: example.com\r
    User-Agent: curl/7.43.0\r
    Accept: */*\r
    \r
    """

    response = Servy.Handler.handle(request)

    assert response == """
           HTTP/1.1 200 OK\r
           content-type: text/html\r
           content-length: 152\r
           \r
           <!DOCTYPE html>
           <html lang="en">
             <head>
               <meta charset="UTF-8" />
               <title>about</title>
             </head>
             <body>
               <h1>about</h1>
             </body>
           </html>

           """
  end

  test "POST /bears" do
    request = """
    POST /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: curl/7.43.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    name=Baloo&type=Brown\r
    """

    response = Servy.Handler.handle(request)

    assert response == """
           HTTP/1.1 201 Created\r
           content-type: text/html\r
           content-length: 32\r
           \r
           Created a Brown bear named Baloo
           """
  end
end
