module Breakout where

import Time
import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Window
import Color exposing (rgb)
import Text
import Keyboard

-- representation of the Game

type alias Bricks = List

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
  }

type alias Object a =
  { a |
      x  : Float
    , y  : Float
    , vx : Float
    , vy : Float
  }

type alias Ball =
  Object {}

type alias Player =
  Object {score : Int}

-- Model

-- player -> determines the position of the paddle
makePlayer : Float -> Player
makePlayer x =
  {x=x, y=10 - halfHeight, vy=0.0, vx=0.0,score=0}


-- Track the passage of Time
delta : Signal Time.Time
delta = Signal.map Time.inSeconds (Time.fps 35)

defaultGame : Game
defaultGame =
    {
      ball    = {x=0, y=0, vy=-100, vx=100}
    , state   = Play
    , player = makePlayer(gameHeight)
  }

input : Signal Input
input =
  Signal.sampleOn delta <|
    Signal.map2 Input
      (Signal.map .x Keyboard.arrows)
      delta

-- Update

stepObj : Time.Time -> Object a -> Object a
stepObj t ({x,y,vx,vy} as obj) =
    { obj |
        x = x + vx * t,
        y = y + vy * t
    }

near : Float -> Float -> Float -> Bool
near object1 distance object2 =
  object2 >= object1 - distance && object2 <= object1 + distance

-- Is the ball within the paddle?

within : Ball -> Player -> Bool
within ball player =
  near player.x 8 ball.x && near player.y 20 ball.y

stepPlayer : Time.Time -> Int -> Player -> Player
stepPlayer time direction player =
    let player' = stepObj time { player | vx = toFloat direction* 300 }
        x'      = clamp (22-halfWidth) (halfWidth-22) player'.x
        score'  = player.score + 1

    in
      { player' | x = x', score = score' }

updateGame : Game -> Player -> Game
updateGame game player_lcl =
  {game | player = player_lcl}

stepV : Float -> Bool -> Bool -> Float
stepV v lowerCollision upperCollision =
  if lowerCollision then abs v
  else if upperCollision then 0 - abs v
  else v

stepBall : Time.Time -> Ball -> Player -> Ball
stepBall time ({x,y,vx,vy} as ball) player =
      stepObj time
          { ball |
            vy =
              stepV vy (ball `within` player) (y > halfHeight - 7),
            vx =
              stepV vx (x < 7-halfWidth) (x > halfWidth-7)
        }

stepGame : Input -> Game -> Game
stepGame input game =
  let
    {paddle,delta} = input
    {ball, state,player} = game
    player' = stepPlayer delta paddle player
    ball' =
        if state == Pause
            then ball
            else stepBall delta ball player
  in
    {game | player = player', ball = ball'}

gameState : Signal Game
gameState =
    Signal.foldp stepGame defaultGame input

-- View

(gameWidth,gameHeight) = (600,400)
(halfWidth,halfHeight) = (300,200)

displayObj : Object a -> Shape -> Form
displayObj obj shape =
    move (obj.x, obj.y) (filled Color.white shape)

breakoutCharcoal : Color.Color
breakoutCharcoal = rgb 54 69 79

textIvory : Color.Color
textIvory = rgb 255 255 240

txt : (Text.Text -> Text.Text) -> String -> Graphics.Element.Element
txt f = leftAligned << f << Text.monospace << Text.color textIvory << Text.fromString


display : (Int, Int) -> Game -> Graphics.Element.Element
display (w,h) {ball,state,player} =
    let scores : Graphics.Element.Element
        scores =
            toString ball.y
              |> txt (Text.height 50)
    in
      container w h middle <|
      collage gameWidth gameHeight
       [ filled breakoutCharcoal   (rect gameWidth gameHeight)
       , displayObj ball    (oval 15 15)
       , displayObj player (rect 40 10)
       ]


main : Signal Graphics.Element.Element
main =
    Signal.map2 display Window.dimensions gameState
