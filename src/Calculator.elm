module Calculator exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Utils
import Html.Events as Events


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


type Msg
  = NoOp
  | UpdateInitialProbability String
  | UpdateHitRate String
  | UpdateFalseAlarmRate String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  ( updateModel msg model, Cmd.none )

updateModel : Msg -> Model -> Model
updateModel msg model =
  case msg of
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


explanation : Html a
explanation =
  div
    []
    [ h3 [] [ text "Explanation" ]
    , explanationsItems
    ]


explanationsItems : Html a
explanationsItems =
  ul
    []
    (List.map (\l -> li [] [ text l ]) explanations)


priorProbabilityItem : { a | priorProbability : String } -> List (Html Msg)
priorProbabilityItem model =
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
          , Events.onInput UpdateInitialProbability          
          ]
          []
      ]
  ]


hitRateItem: { a | hitRate : String } -> List (Html Msg)
hitRateItem model =
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
          , Events.onInput UpdateHitRate          
          ]
          []
      ]
  ]


falseAlarmItem : { a | falseAlarmRate : String } -> List (Html Msg)
falseAlarmItem model =
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
          , Events.onInput UpdateFalseAlarmRate          
          ]
          []
      ]
  ]


header : Html a
header =
  h1 [] [ text "Bayesian Calculator" ]


formGroupItem : List (Html a) -> Html a
formGroupItem body =
  div
    [ class "form-group" ]
    body


resultItem: Model -> List (Html a)
resultItem model =
  [ label
      [ for "bayesResult", class "col-md-3 control-label" ]
      [ text "New Probability" ]
  , div
      [ class "col-md-9" ]
      [ span [] [ text (bayesResult model) ]
      ]
  ]


entryForm : Model -> Html Msg
entryForm model =
  div
    [ class "form-horizontal" ]
    [ formGroupItem (priorProbabilityItem model)
    , formGroupItem (hitRateItem model)
    , formGroupItem (falseAlarmItem model)
    , formGroupItem (resultItem model)
    ]

init : (Model, Cmd Msg)  
init = (initialModel, Cmd.none) 

view : Model -> Html Msg
view initialModel =
  div
    [ id "container", class "col-md-4 col-md-offset-4" ]
    [ header
    , entryForm initialModel
    , explanation
    ]



--Wire it all together


main : Program Never
main =  
  Html.program
    { init = init
    , update = update
    , view = view
    , subscriptions = \_ -> Sub.none
    }
