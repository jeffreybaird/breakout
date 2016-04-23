module Bricks where

import Color
import Object exposing (..)
import Graphics.Collage exposing (..)
import Constants exposing(..)


type alias Brick =
  Object {color : Color.Color}

type alias Bricks = List Brick


makeBrick : Float -> Brick
makeBrick x =
  {x=x, y=halfHeight-7, vy=0, vx = 0, color=Color.green}

firstBrick : Bricks
firstBrick =
  [{x=21-halfWidth, y=halfHeight-7, vy=0, vx = 0, color = Color.green}]


initBrick: Brick
initBrick = makeBrick(31-halfWidth)

newBricks: Bricks
newBricks = initBrick :: []


createBricks : Bricks
createBricks  =
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

displayBricks : Bricks -> List Shape -> List Form
displayBricks bricks shapes =
  let
    brickColors : List Color.Color
    brickColors = List.map .color bricks
  in
    List.map3 displayObj bricks shapes brickColors
