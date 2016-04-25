module Player where
import Object exposing (..)
import Constants exposing (..)

type alias Player =
  Object {score : Int}


-- player -> determines the position of the paddle
makePlayer : Float -> Player
makePlayer x =
  {x=x, y=10 - halfHeight, vy=0.0, vx=0.0,score=0}
