module BallTest where
import ElmTest exposing (..)
import Graphics.Element exposing (..)
import Time
import Ball exposing (near, within)
import Player exposing (..)

testNear : Bool
testNear = near 2.0 1.0 2.0

delta : Signal Time.Time
delta = Signal.map Time.inSeconds (Time.fps 35)

player : Player
player ={x=400, y=-190, vy=0.0, vx=0.0,score=0}

ball : Ball.Ball
ball = {x=399, y=-185, vy=0.0, vx=0.0}

testWithin : Bool
testWithin = within ball player

stepV : Float
stepV =
  Ball.stepV -1.0 True True

stepBall: Ball.Ball
stepBall =
  Ball.stepBall 1.0 ball player



tests : Test
tests =
    suite "A Test Suite"
            [ test "near" (assertEqual testNear True)
            , test "within" (assertEqual testWithin True)
            , test "stepV" (assertEqual stepV 1.0)
            , test "stepBall" (assertEqual stepBall ball)
            ]

main : Element
main =
    elementRunner tests
