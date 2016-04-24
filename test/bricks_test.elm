module BricksTest where
import ElmTest exposing (..)
import Graphics.Element exposing (..)
import Bricks exposing (..)
import Color
import Constants


brick : Brick
brick = {x=21-Constants.halfWidth, y=Constants.halfHeight-7, vy=0, vx = 0, color = Color.green}

bricks : Bricks
bricks =
  [brick]

tests : Test
tests =
    suite "A Test Suite"
        [ test "createBricks" (assertEqual (createSubsequentBricks 1 brick bricks) [{ x = -213, y = 193, vy = 0, vx = 0, color = Color.green},{ x = -279, y = 193, vy = 0, vx = 0, color = Color.green }])
        ]

main : Element
main =
    elementRunner tests
