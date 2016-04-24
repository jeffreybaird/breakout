module Ball where

import Object exposing (..)
import Player exposing (..)
import Bricks exposing (..)


type alias Ball =
  Object {}



isTrue : Bool -> Bool
isTrue x =
  x == True

withinBrick : Ball -> Brick -> Bool
withinBrick ball brick =
  near ball.x 30 brick.x && near ball.y 16 brick.y


ballWithinBricks : Ball -> Bricks -> Bool
ballWithinBricks  ball bricks=
  List.any isTrue <|
    List.map (withinBrick ball) bricks


stepV : Float -> Bool -> Bool -> Float
stepV v lowerCollision upperCollision =
  if lowerCollision then abs v
  else if upperCollision then 0 - abs v
  else v

near : Float -> Float -> Float -> Bool
near object1 distance object2 =
  object2 >= object1 - distance && object2 <= object1 + distance

-- Is the ball within the paddle?

within : Ball -> Player -> Bool
within ball player =
  near player.x 8 ball.x && near player.y 20 ball.y
