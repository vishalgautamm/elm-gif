module Main exposing (..)

-- We'll need to import some modules for later

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode as Json exposing (..)


-- MODEL


type alias Model =
    { topic : String, gifUrl : String }


init : String -> ( Model, Cmd Msg )
init topic =
    let
        waitingUrl =
            "https://i.imgur.com/i6eXrfS.gif"
    in
        ( Model topic waitingUrl
        , getRandomGif topic
        )



-- UPDATE


type Msg
    = RequestMore
    | NewGif (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestMore ->
            ( model, getRandomGif model.topic )

        NewGif (Ok msg) ->
            ( { model | gifUrl = msg }, Cmd.none )

        NewGif (Err _) ->
            ( model, Cmd.none )


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic

        request =
            Http.get url decodeGifUrl
    in
        Http.send NewGif request


decodeGifUrl : Json.Decoder String
decodeGifUrl =
    Json.at [ "data", "image_url" ] Json.string



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text model.topic ]
        , div []
            [ img [ src model.gifUrl ] [] ]
        , button [ onClick RequestMore ] [ text "Moar pls" ]
        ]



-- MAIN


main =
    Html.program
        { init = init "cats"
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
