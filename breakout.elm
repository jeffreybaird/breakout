module Breakout where

import Time
import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Window
import Color exposing (rgb)
import Text

-- representation of the Game

type alias Bricks = List

type State = Play | Pause

type alias Input =
  {
  -- start the Game
    delta  : Time.Time
  , paddle : Int
  , space  : Bool
}

type alias Game =
  {
    ball    : Ball
  , player  : Player
  , state   : State
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
  Object {}


-- Track the passage of Time
delta : Signal Time.Time
delta = Signal.map Time.inSeconds (Time.fps 35)

defaultGame : Game
defaultGame =
    {
      state   = Pause
    , ball    = {x=0, y=0, vy=200, vx=200}
    , player = {vx = 0.0, vy= 0.0, x= 0.0, y = 0.0}
  }

-- Change the direction of the ball after a collision



-- View

(gameWidth,gameHeight) = (600,400)
(halfWidth,halfHeight) = (300,200)

breakoutCharcoal : Color.Color
breakoutCharcoal = rgb 54 69 79

textIvory : Color.Color
textIvory = rgb 255 255 240

txt : (Text.Text -> Text.Text) -> String -> Graphics.Element.Element
txt f = leftAligned << f << Text.monospace << Text.color textIvory << Text.fromString


display : (Int, Int) -> Graphics.Element.Element
display (w,h) =
    let scores : Graphics.Element.Element
        scores =
            toString 10
              |> txt (Text.height 50)
    in
      container w h middle <|
      collage gameWidth gameHeight
       [ filled breakoutCharcoal   (rect gameWidth gameHeight)
       , toForm scores
           |> move (0, gameHeight/2 - 40)
       , toForm (spacer 1 1)
           |> move (0, 40 - gameHeight/2)
       ]


main : Signal Graphics.Element.Element
main =
    Signal.map display Window.dimensions
