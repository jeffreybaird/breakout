module Breakout where

import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Window
import Color exposing (rgb)
import Text
import Object exposing (..)
import Constants exposing (..)
import Bricks exposing (..)
import Game exposing (..)

-- View

txt : (Text.Text -> Text.Text) -> String -> Graphics.Element.Element
txt f = leftAligned << f << Text.monospace << Text.color textIvory << Text.fromString


display : (Int, Int) -> Game -> Graphics.Element.Element
display (w,h) {ball,state,player, bricks} =
    let scores : Graphics.Element.Element
        scores =
            toString ball.y
              |> txt (Text.height 50)
        shapes : List Shape
        shapes =
          createShapes 10 (rect 60 10) []

        brickDisplay: List Form
        brickDisplay =
          displayBricks bricks shapes

        displayObjects: List Form
        displayObjects =
          List.append [ filled breakoutCharcoal   (rect gameWidth gameHeight)
          , displayObj ball (oval 15 15) Color.white
          , displayObj player (rect 40 10) Color.white
          ] brickDisplay

    in
      container w h middle <|
      collage gameWidth gameHeight displayObjects


main : Signal Graphics.Element.Element
main =
    Signal.map2 display Window.dimensions gameState
