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
import String

-- View

txt : (Text.Text -> Text.Text) -> String -> Graphics.Element.Element
txt f = leftAligned << f << Text.monospace << Text.color textIvory << Text.fromString


display : (Int, Int) -> Game -> Graphics.Element.Element
display (w,h) {ball,state,player, bricks} =
    let scores : Graphics.Element.Element
        scores =
          if outOfPlayArea ball then txt (Text.height 0) ""
          else
            toString player.score
              |> txt (Text.height 50)

        gameOverText : Graphics.Element.Element
        gameOverText =
          if outOfPlayArea ball then
            String.join "" ["Game Over  ", (toString player.score)]
              |> txt (Text.height 50)
          else
            toString ""
              |> txt (Text.height 0)

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
          , toForm scores
           |> move (-20, 0)
          , toForm gameOverText
            |> move (-40,0)
          ] brickDisplay

    in
      container w h middle <|
      collage gameWidth gameHeight displayObjects


main : Signal Graphics.Element.Element
main =
    Signal.map2 display Window.dimensions gameState
