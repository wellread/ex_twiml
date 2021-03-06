defmodule ExTwimlTest do
  use ExUnit.Case, async: false
  import ExTwiml

  test "can render the <Gather> verb" do
    markup = twiml do
      gather digits: 3 do
        text "Phone Number"
      end
    end

    assert_twiml markup, "<Gather digits=\"3\">Phone Number</Gather>"
  end

  test "can render the <Gather> verb without any options" do
    markup = twiml do
      gather do
        text "Phone Number"
      end
    end

    assert_twiml markup, "<Gather>Phone Number</Gather>"
  end

  test "can render the <Say> verb" do
    markup = twiml do
      say "Hello there!", voice: "woman"
    end

    assert_twiml markup, "<Say voice=\"woman\">Hello there!</Say>"
  end

  test "can render the <Record> verb" do
    markup = twiml do
      record finish_on_key: "#", transcribe: true
    end

    assert_twiml markup, "<Record finishOnKey=\"#\" transcribe=\"true\" />"
  end

  test "can render the <Number> verb" do
    markup = twiml do
      number "1112223333"
    end

    assert_twiml markup, "<Number>1112223333</Number>"
  end

  test "can render the <Play> verb" do
    markup = twiml do
      play "https://api.twilio.com/cowbell.mp3", loop: 10
    end

    assert_twiml markup, "<Play loop=\"10\">https://api.twilio.com/cowbell.mp3</Play>"
  end

  test "can render the <Sms> verb" do
    markup = twiml do
      sms "Hello world!", from: "1112223333", to: "2223334444"
    end

    assert_twiml markup, "<Sms from=\"1112223333\" to=\"2223334444\">Hello world!</Sms>"
  end

  test "can render the <Dial> verb" do
    markup = twiml do
      dial action: "/calls/new" do
        number "1112223333"
      end
    end

    assert_twiml markup, "<Dial action=\"/calls/new\"><Number>1112223333</Number></Dial>"
  end

  test "can render the <Sip> verb" do
    markup = twiml do
      sip "sip:test@example.com", username: "admin", password: "123"
    end 

    assert_twiml markup, "<Sip username=\"admin\" password=\"123\">sip:test@example.com</Sip>"
  end

  test "can render the <Client> verb" do
    markup = twiml do
      client "Daniel"
      client "Bob"
    end

    assert_twiml markup, "<Client>Daniel</Client><Client>Bob</Client>"
  end

  test "can render the <Conference> verb" do
    markup = twiml do
      conference "Friendly Conference", end_conference_on_exit: true
    end

    assert_twiml markup, "<Conference endConferenceOnExit=\"true\">Friendly Conference</Conference>"
  end

  test "can render the <Queue> verb" do
    markup = twiml do
      queue "support", url: "about_to_connect.xml"
    end

    assert_twiml markup, "<Queue url=\"about_to_connect.xml\">support</Queue>"
  end

  test "can render the <Enqueue> verb" do
    markup = twiml do
      enqueue "support", wait_url: "wait-music.xml"
    end

    assert_twiml markup, "<Enqueue waitUrl=\"wait-music.xml\">support</Enqueue>"
  end

  test "can render the <Leave> verb" do
    markup = twiml do
      leave
    end

    assert_twiml markup, "<Leave />"
  end

  test "can render the <Hangup> verb" do
    markup = twiml do
      hangup
    end

    assert_twiml markup, "<Hangup />"
  end

  test "can render the <Redirect> verb" do
    markup = twiml do
      redirect "http://example.com", method: "POST"
    end

    assert_twiml markup, "<Redirect method=\"POST\">http://example.com</Redirect>"
  end

  test "can render the <Reject> verb" do
    markup = twiml do
      reject reason: "busy"
    end

    assert_twiml markup, "<Reject reason=\"busy\" />"

    markup = twiml do
      reject
    end

    assert_twiml markup, "<Reject />"
  end

  test "can render the <Pause> verb" do
    markup = twiml do
      pause length: 5
    end

    assert_twiml markup, "<Pause length=\"5\" />"
  end

  test "can render the <Message> verb" do
    markup = twiml do
      message action: "/hello", method: "post" do
      end
    end

    assert_twiml markup, "<Message action=\"/hello\" method=\"post\"></Message>"
  end

  test "can render the <Body> verb" do
    markup = twiml do
      body "Store location: 203"
    end

    assert_twiml markup, "<Body>Store location: 203</Body>"
  end

  test "can render the <Media> verb" do
    markup = twiml do
      media "https://demo.twilio.com/owl.png"
    end

    assert_twiml markup, "<Media>https://demo.twilio.com/owl.png</Media>"
  end

  test "can render with options" do
    {opts, _twiml} = twiml do
      option 1, "hello there!", [menu: :other_menu], [voice: "woman"]
    end

    assert opts == [{1, [menu: :other_menu]}]
  end

  test ".twiml can include Enum loops" do
    {opts, _markup} = twiml do
      Enum.each 1..3, fn(n) ->
        option n, "Press #{n}"
      end
    end

    assert opts == [{1, []}, {2, []}, {3, []}]
  end

  test ".twiml can loop through lists of maps" do
    people = [%{name: "Daniel"}, %{name: "Hunter"}]

    markup = twiml do
      Enum.each people, fn person ->
        say "Hello, #{person.name}!"
      end
    end

    assert_twiml markup, "<Say>Hello, Daniel!</Say><Say>Hello, Hunter!</Say>"
  end

  test ".twiml can 'say' a variable that happens to be a string" do
    some_var = "hello world"
    markup = twiml do
      say some_var
    end

    assert_twiml markup, "<Say>hello world</Say>"
  end

  defp assert_twiml(lhs, rhs) do
    assert lhs == "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response>#{rhs}</Response>"
  end
end
