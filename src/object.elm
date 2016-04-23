module Object where

import Graphics.Collage exposing (..)
import Color
import Time

type alias Object a =
  { a |
      x  : Float
    , y  : Float
    , vx : Float
    , vy : Float
  }

stepObj : Time.Time -> Object a -> Object a
stepObj t ({x,y,vx,vy} as obj) =
    { obj |
        x = x + vx * t,
        y = y + vy * t
    }


displayObj : Object a -> Shape -> Color.Color -> Form
displayObj obj shape shapeColor =
    move (obj.x, obj.y) (filled shapeColor shape)


createShapes: Int -> Shape -> List Shape -> List Shape
createShapes n shape shapes =
  if n == 0 then shapes
  else List.append shapes [shape]
