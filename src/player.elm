module Player where
import Object exposing (..)
import Constants exposing (..)
import Time

type alias Player =
  Object {score : Int}


-- player -> determines the position of the paddle
makePlayer : Float -> Player
makePlayer x =
  {x=x, y=10 - halfHeight, vy=0.0, vx=0.0,score=0}


stepPlayer : Time.Time -> Int -> Player -> Player
stepPlayer time direction player =
    let player' = stepObj time { player | vx = toFloat direction* 300 }
        x'      = clamp (22-halfWidth) (halfWidth-22) player'.x
        score'  = player.score + 1

    in
      { player' | x = x', score = score' }
