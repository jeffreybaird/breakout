module BreakoutTest where

import String
import Graphics.Element exposing (Element)
import Breakout exposing(..)

import ElmTest exposing (..)


tests : Test
tests =
    suite "A Test Suite"
        [ test "createBreaks" (assertEqual createBreaks [])
        ]


main : Element
main =
    elementRunner tests
