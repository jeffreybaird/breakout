module BricksTest where
import ElmTest exposing (..)
import Graphics.Element exposing (..)
import Bricks exposing (..)
import Color
import Constants


bricks : Bricks
bricks =
  [{x=21-Constants.halfWidth, y=Constants.halfHeight-7, vy=0, vx = 0, color = Color.green}]

tests : Test
tests =
    suite "A Test Suite"
        [ test "createBricks" (assertEqual createBricks [])
        ]

main : Element
main =
    elementRunner tests
