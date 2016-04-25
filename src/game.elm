module Game where
import Time
import Ball exposing (..)
import Player exposing (..)
import Bricks exposing (..)
import Constants exposing (..)
import Keyboard
import Object exposing (..)
import Time

type State = Play | Pause

type alias Input =
  {
    paddle : Int
  , delta  : Time.Time
}

type alias Game =
  {
    ball    : Ball
  , state   : State
  , player  : Player
  , bricks  : Bricks
  }

-- Track the passage of Time
delta : Signal Time.Time
delta = Signal.map Time.inSeconds (Time.fps 35)

remove : Brick -> Ball -> Float
remove brick ball =
  let
   b = Debug.watch "Ball" [ball.x, ball.y]
   br = Debug.watch "Brick" [brick.x, brick.y]
  in
    if withinBrick ball brick then 1000.0 - gameHeight
    else brick.x

stepObj : Time.Time -> Object a -> Object a
stepObj t ({x,y,vx,vy} as obj) =
    { obj |
        x = x + vx * t,
        y = y + vy * t
    }

stepBricks : Time.Time -> Bricks -> Ball -> Bricks
stepBricks time bricks ball =
  let
    xy : Brick -> List Float
    xy brick =
      [brick.x, brick.y]
    brs = Debug.watch "Bricks" (List.map (withinBrick ball) bricks)
    br = Debug.watch "Bricks X,Y" (List.map xy bricks)
  in
    List.map (stepBrick time ball) bricks


stepBrick : Time.Time -> Ball -> Brick -> Brick
stepBrick time ball ({x,y,vx,vy} as brick) =
  stepObj time
    { brick |
      x =
        remove brick ball
  }

defaultGame : Game
defaultGame =
    {
      ball    = {x=0, y=0, vy=-100, vx=100}
    , state   = Play
    , player = makePlayer(gameHeight)
    , bricks = createBricks
  }

input : Signal Input
input =
  Signal.sampleOn delta <|
    Signal.map2 Input
      (Signal.map .x Keyboard.arrows)
      delta

-- Update
stepBall : Time.Time -> Ball -> Player -> Bricks -> Ball
stepBall time ({x,y,vx,vy} as ball) player bricks =
  let
    bwb = List.any isTrue <| List.map (withinBrick ball) bricks
    d = Debug.watch "BWB" bwb
  in
    stepObj time
          { ball |
            vy =
              stepV vy (ball `within` player)((y > halfHeight - 7)|| bwb ),
            vx =
              stepV vx (x < 7-halfWidth) (x > halfWidth-7)
        }

stepPlayer : Time.Time -> Int -> Player -> Player
stepPlayer time direction player =
    let player' = stepObj time { player | vx = toFloat direction* 300 }
        x'      = clamp (22-halfWidth) (halfWidth-22) player'.x
        score'  = player.score + 1

    in
      { player' | x = x', score = score' }


stepGame : Input -> Game -> Game
stepGame input game =
  let
    {paddle,delta} = input
    {ball, state,player, bricks} = game
    bricks' = stepBricks delta bricks ball
    player' = stepPlayer delta paddle player
    ball' =
        if state == Pause
            then ball
            else stepBall delta ball player bricks
  in
    {game | player = player', ball = ball'}

gameState : Signal Game
gameState =
    Signal.foldp stepGame defaultGame input
