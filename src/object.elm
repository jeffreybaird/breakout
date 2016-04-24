module Object where

import Graphics.Collage exposing (..)
import Color

type alias Object a =
  { a |
      x  : Float
    , y  : Float
    , vx : Float
    , vy : Float
  }




displayObj : Object a -> Shape -> Color.Color -> Form
displayObj obj shape shapeColor =
    move (obj.x, obj.y) (filled shapeColor shape)


createShapes: Int -> Shape -> List Shape -> List Shape
createShapes n shape shapes =
  if n == 0 then shapes
  else List.append shapes [shape]
