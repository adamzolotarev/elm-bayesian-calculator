module Utils exposing (..)

import String exposing (toInt)
import Html exposing (Attribute)
import Html.Events exposing (on, targetValue)

parseInt : String -> Int
parseInt string =
  case String.toInt string of
    Ok value ->
      value

    Err error ->
      0


parseFloat : String -> Float
parseFloat string =
  case String.toFloat string of
    Ok value ->
      value

    Err error ->
      0
