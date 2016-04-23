module BreakoutTest where

-- import String
import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Breakout exposing(..)
import Color

import ElmTest exposing (..)


bricks : Bricks
bricks =
  [{x=21-Breakout.halfWidth, y=Breakout.halfHeight-7, vy=0, vx = 0, color = Color.green}]

d : List Form
d =
  displayBricks bricks [(rect 40 10)]

tests : Test
tests =
    suite "A Test Suite"
        [ test "createBricks" (assertEqual createBricks [])
        , test "displayBricks" (assertEqual d [])
        ]


main : Element
main =
    elementRunner tests
