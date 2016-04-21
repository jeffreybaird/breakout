module Breakout where

import Time
import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Window
import Color exposing (rgb)
import Text
import Keyboard

-- representation of the Game

type alias Bricks = List Brick

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

type alias Brick =
  Object {color : Color.Color}

-- Model

-- player -> determines the position of the paddle
makePlayer : Float -> Player
makePlayer x =
  {x=x, y=10 - halfHeight, vy=0.0, vx=0.0,score=0}

makeBrick : Float -> Brick
makeBrick x =
  {x=x, y=halfHeight-7, vy=0, vx = 0, color=Color.green}



-- Track the passage of Time
delta : Signal Time.Time
delta = Signal.map Time.inSeconds (Time.fps 35)

defaultGame : Game
defaultGame =
    {
      ball    = {x=0, y=0, vy=-100, vx=100}
    , state   = Play
    , player = makePlayer(gameHeight)
    , bricks = createBreaks
  }


firstBrick : Bricks
firstBrick =
  [{x=21-halfWidth, y=halfHeight-7, vy=0, vx = 0, color = Color.green}]


initBrick: Brick
initBrick = makeBrick(31-halfWidth)

newBricks: Bricks
newBricks = initBrick :: []


createBreaks : Bricks
createBreaks  =
  createSubsequentBricks 10 initBrick newBricks
  

createSubsequentBricks : Int -> Brick -> Bricks -> Bricks
createSubsequentBricks numberOfBricksLeft brick bricks =
  let
    nextBrick: Brick
    nextBrick = makeBrick(brick.x + 31)

    newBricks: Bricks
    newBricks = nextBrick :: bricks

    num : Int
    num = numberOfBricksLeft-1
  in
    if numberOfBricksLeft == 0 then bricks
    else
      createSubsequentBricks num nextBrick newBricks

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

displayBricks : Bricks -> List Shape -> List Form
displayBricks bricks shapes =
  let
    brickColors : List Color.Color
    brickColors = List.map .color bricks
  in
    List.map3 displayObj bricks shapes brickColors

createShapes: Int -> Shape -> List Shape -> List Shape
createShapes n shape shapes =
  if n == 0 then shapes
  else List.append shapes [shape]


displayObj : Object a -> Shape -> Color.Color -> Form
displayObj obj shape shapeColor =
    move (obj.x, obj.y) (filled shapeColor shape)

breakoutCharcoal : Color.Color
breakoutCharcoal = rgb 54 69 79

textIvory : Color.Color
textIvory = rgb 255 255 240

txt : (Text.Text -> Text.Text) -> String -> Graphics.Element.Element
txt f = leftAligned << f << Text.monospace << Text.color textIvory << Text.fromString


display : (Int, Int) -> Game -> Graphics.Element.Element
display (w,h) {ball,state,player, bricks} =
    let scores : Graphics.Element.Element
        scores =
            toString ball.y
              |> txt (Text.height 50)
        shapes : List Shape
        shapes =
          createShapes 10 (rect 60 10) []

        brickDisplay: List Form
        brickDisplay =
          displayBricks bricks shapes

        displayObjects: List Form
        displayObjects =
          List.append [ filled breakoutCharcoal   (rect gameWidth gameHeight)
          , displayObj ball (oval 15 15) Color.white
          , displayObj player (rect 40 10) Color.white
          ] brickDisplay

    in
      container w h middle <|
      collage gameWidth gameHeight displayObjects


main : Signal Graphics.Element.Element
main =
    Signal.map2 display Window.dimensions gameState
