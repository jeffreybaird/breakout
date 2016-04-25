module Bricks where

import Color
import Object exposing (..)
import Graphics.Collage exposing (..)
import Constants exposing(..)



type alias Brick =
  Object {color : Color.Color, hit: Bool}

type alias Bricks = List Brick


makeBrick : Float -> Brick
makeBrick x =
  {x=x, y=halfHeight-7, vy=0, vx = 0, color=Color.green, hit=False}

initBrick: Brick
initBrick = makeBrick(35-halfWidth)

newBricks: Bricks
newBricks = initBrick :: []

numberOfBricks : Int
numberOfBricks =
  floor (((toFloat gameWidth) / 60.0) - 2)

createBricks : Bricks
createBricks  =
  createSubsequentBricks numberOfBricks initBrick newBricks

createSubsequentBricks : Int -> Brick -> Bricks -> Bricks
createSubsequentBricks numberOfBricksLeft brick bricks =
  let
    nextBrick: Brick
    nextBrick = makeBrick(brick.x + 66)

    newBricks: Bricks
    newBricks = nextBrick :: bricks

    num : Int
    num = numberOfBricksLeft-1
  in
    if numberOfBricksLeft == 0 then bricks
    else
      createSubsequentBricks num nextBrick newBricks


displayBrick : Brick -> Form
displayBrick brick =
  if brick.hit then displayObj brick (rect 0 0) brick.color
  else displayObj brick (rect 65 10) brick.color

displayBricks : Bricks -> List Shape -> List Form
displayBricks bricks shapes =
  let
    brickColors : List Color.Color
    brickColors = List.map .color bricks
  in
    List.map displayBrick bricks
