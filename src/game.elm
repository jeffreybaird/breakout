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
    space  : Bool
  , paddle : Int
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

remove :Ball -> Brick -> Bool
remove ball brick =
  let
   b = Debug.watch "Ball" [ball.x, ball.y]
  in
    if withinBrick ball brick then True
    else brick.hit

move: Brick -> Float
move brick =
  if brick.hit then gameHeight + 1000
  else brick.x

stepObj : Time.Time -> Object a -> Object a
stepObj t ({x,y,vx,vy} as obj) =
    { obj |
        x = x + vx * t,
        y = y + vy * t
    }

stepBricks : Bricks -> Ball -> Bricks
stepBricks bricks ball =
  let
    xy : Brick -> List Float
    xy brick =
      [brick.x, brick.y]
    brs = Debug.watch "Bricks Hit" (List.map .hit bricks)
    b = Debug.watch "Ball Within Bricks" (List.map (withinBrick ball ) bricks)
    a = Debug.watch "Hit" (List.map (remove ball) bricks)
  in
    List.map (stepBrick ball) bricks


stepBrick : Ball -> Brick -> Brick
stepBrick ball brick =
  { brick | hit = (remove ball brick), x = (move brick)}

defaultGame : Game
defaultGame =
    {
      ball    = {x=0, y=0, vy=-100, vx=100}
    , state   = Pause
    , player = makePlayer(gameHeight)
    , bricks = createBricks
  }

input : Signal Input
input =
  Signal.sampleOn delta <|
    Signal.map3 Input
      Keyboard.space
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

outOfPlayArea : Ball -> Bool
outOfPlayArea ball =
  if ball.y < 5 - halfHeight then True
  else False

stepGame : Input -> Game -> Game
stepGame input game =
  let
    {space, paddle,delta} = input
    {ball, state,player, bricks} = game
    bricks' = stepBricks bricks ball
    player' = stepPlayer delta paddle player
    ball' =
        if state == Pause
            then ball
            else stepBall delta ball player bricks
    state' =
        if space then Play
        else if outOfPlayArea ball then Pause
        else state
  in
    {game | player = player', ball = ball', bricks = bricks', state = state'}

gameState : Signal Game
gameState =
    Signal.foldp stepGame defaultGame input
