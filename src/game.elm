module Game where
import Time
import Ball exposing (..)
import Player exposing (..)
import Bricks exposing (..)
import Constants exposing (..)
import Keyboard

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

updateGame : Game -> Player -> Game
updateGame game player_lcl =
  {game | player = player_lcl}


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
