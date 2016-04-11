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


isGoodRate : String -> Bool
isGoodRate rate =
  rate /= "." && Utils.parseFloat rate > 0


isValidModel : Model -> Bool
isValidModel model =
  isGoodRate model.hitRate
    && isGoodRate model.priorProbability
    && isGoodRate model.falseAlarmRate


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


explanations : List String
explanations =
  [ "5% of people have cancer - put .05 into 'Prior Probability'"
  , "Cancer test has 80% chance of producing a correct result  - put 0.8 into 'Hit Rate'"
  , "Cancer test has 20% chance of producing a false positive  - put 0.2 into 'False Alarm Rate'"
  ]


explanation : Html
explanation =
  div
    []
    [ h3 [] [ text "Explanation" ]
    , explanationsItems
    ]


explanationsItems : Html
explanationsItems =
  ul
    []
    (List.map (\l -> li [] [ text l ]) explanations)


priorProbabilityItem : Address Action -> Model -> List Html
priorProbabilityItem address model =
  [ label
      [ for "priorProbability", class "col-md-3 control-label" ]
      [ text "Prior Probability" ]
  , div
      [ class "col-md-9" ]
      [ input
          [ type' "text"
          , placeholder "0.00"
          , value model.priorProbability
          , id "priorProbability"
          , autofocus True
          , Utils.onInput address UpdateInitialProbability
          ]
          []
      ]
  ]


hitRateItem : Address Action -> Model -> List Html
hitRateItem address model =
  [ label
      [ for "hitRate", class "col-md-3 control-label" ]
      [ text "Hit Rate" ]
  , div
      [ class "col-md-9" ]
      [ input
          [ type' "text"
          , placeholder "0.00"
          , value model.hitRate
          , id "hitRate"
          , autofocus True
          , Utils.onInput address UpdateHitRate
          ]
          []
      ]
  ]


falseAlarmItem : Address Action -> Model -> List Html
falseAlarmItem address model =
  [ label
      [ for "falseAlarmRate", class "col-md-3 control-label" ]
      [ text "False Alarm Rate" ]
  , div
      [ class "col-md-9" ]
      [ input
          [ type' "text"
          , placeholder "0.00"
          , value model.falseAlarmRate
          , id "falseAlarmRate"
          , autofocus True
          , Utils.onInput address UpdateFalseAlarmRate
          ]
          []
      ]
  ]


header : Html
header =
  h1 [] [ text "Bayesian Calculator" ]


formGroupItem : List Html -> Html
formGroupItem body =
  div
    [ class "form-group" ]
    body


resultItem : Address Action -> Model -> List Html
resultItem address model =
  [ label
      [ for "bayesResult", class "col-md-3 control-label" ]
      [ text "New Probability" ]
  , div
      [ class "col-md-9" ]
      [ span [] [ text (bayesResult model) ]
      ]
  ]


entryForm : Address Action -> Model -> Html
entryForm address model =
  div
    [ class "form-horizontal" ]
    [ formGroupItem (priorProbabilityItem address model)
    , formGroupItem (hitRateItem address model)
    , formGroupItem (falseAlarmItem address model)
    , formGroupItem (resultItem address model)
    ]


view : Address Action -> Model -> Html
view address initialModel =
  div
    [ id "container", class "col-md-4 col-md-offset-4" ]
    [ header
    , entryForm address initialModel
    , explanation
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
