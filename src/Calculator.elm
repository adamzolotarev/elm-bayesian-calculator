module Calculator (..) where

import Html exposing (..)
import Html.Attributes exposing (..)


--import Html.Events exposing (..)
--import String exposing (toUpper, repeat, trimRight)

import StartApp.Simple as StartApp
import Signal exposing (Address)
import Utils


--MODEL


type alias Model =
  { priorProbability : String
  , hitRate : String
  , falseAlarmRate : String
  , newProbablity : String
  }


bayesResult : Model -> String
bayesResult model =
  let
    hitRate =
      Utils.parseFloat model.hitRate

    priorProbability =
      Utils.parseFloat model.priorProbability

    falseAlarmRate =
      Utils.parseFloat model.falseAlarmRate
  in
    if (isValidModel model) then
      toString
        ((hitRate * priorProbability)
          / (hitRate * priorProbability + (falseAlarmRate * (1 - priorProbability)))
        )
    else
      ""


isValidModel : Model -> Bool
isValidModel model =
  let
    hitRate =
      Utils.parseFloat model.hitRate

    priorProbability =
      Utils.parseFloat model.priorProbability

    falseAlarmRate =
      Utils.parseFloat model.falseAlarmRate
  in
    hitRate > 0 && priorProbability > 0 && falseAlarmRate > 0


initialModel : Model
initialModel =
  { priorProbability = ""
  , hitRate = ""
  , falseAlarmRate = ""
  , newProbablity = ""
  }



-- Update


type Action
  = NoOp
  | UpdateInitialProbability String
  | UpdateHitRate String
  | UpdateFalseAlarmRate String


update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    UpdateInitialProbability probability ->
      { model | priorProbability = probability }

    UpdateHitRate probability ->
      { model | hitRate = probability }

    UpdateFalseAlarmRate probability ->
      { model | falseAlarmRate = probability }



--View


entryForm : Address Action -> Model -> Html
entryForm address model =
  div
    []
    [ input
        [ type' "text"
        , placeholder "0.00"
        , value model.priorProbability
        , autofocus True
        , Utils.onInput address UpdateInitialProbability
        ]
        []
    , input
        [ type' "text"
        , placeholder "0.00"
        , value model.hitRate
        , Utils.onInput address UpdateHitRate
        ]
        []
    , input
        [ type' "text"
        , placeholder "0.00"
        , value model.falseAlarmRate
        , Utils.onInput address UpdateFalseAlarmRate
        ]
        []
    , h2 [] [ text (bayesResult model) ]
    ]


view : Address Action -> Model -> Html
view address initialModel =
  div
    [ id "container" ]
    [ entryForm address initialModel
    ]



--Wire it all together


main : Signal Html
main =
  --initialModel
  --  |> update Sort
  --  |> view
  StartApp.start
    { model = initialModel
    , view = view
    , update = update
    }
