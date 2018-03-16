import Html exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Debug exposing (..)
 
 
main : Program Never Model Msg
main = Html.program { init = init, view = view, update = update , subscriptions = subscriptions   }
 
type alias Model = { counter : Int }
 
initialModel: Model
initialModel = Model 0
 
init: (Model, Cmd Msg)
init = (initialModel, Cmd.none)
 
type Msg = Get | Set | FetchCount (Result Http.Error Int) | ResetCount (Result Http.Error Int)
 
view: Model -> Html Msg
view model =
    div []
        [
        button [onClick Get] [text "Get"],
        button [onClick Set] [text "Set"],
        h2[] [text (toString model.counter)]
    ]
 
update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Get ->
            (model, fetchCount)
        Set ->
            (model, resetCount)
        ResetCount result ->
            case (log "result" result) of
                Ok _ ->
                    ({model | counter = 1}, Cmd.none)
                Err _ ->
                    (model, Cmd.none)
        FetchCount result ->
            case (log "result" result) of
                Ok val ->
                    ({model | counter = val}, Cmd.none)
                Err _ ->
                    (model, Cmd.none)
 
fetchCount: Cmd Msg
fetchCount =
    let
        url = "http://localhost:5050/counter"
        request = Http.get url counterDecoder
    in
        Http.send FetchCount request
 
resetCount: Cmd Msg
resetCount =
    let
        url = "http://localhost:5050/counter/1"
        request = Http.post url Http.emptyBody Decode.int