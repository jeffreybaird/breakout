module Ball where

import Object exposing (..)
import Time
import Player exposing (..)
import Constants exposing (..)


type alias Ball =
  Object {}

stepBall : Time.Time -> Ball -> Player -> Ball
stepBall time ({x,y,vx,vy} as ball) player =
      stepObj time
          { ball |
            vy =
              stepV vy (ball `within` player) (y > halfHeight - 7),
            vx =
              stepV vx (x < 7-halfWidth) (x > halfWidth-7)
        }

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
