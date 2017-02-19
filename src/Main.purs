module Main where

import Prelude

import Data.Map as M

import React as R
import React.DOM as R
import React.DOM.Props as RP
import ReactDOM as RDOM

import Thermite as T


data Understanding = TooEasy | Normal | TooHard

type WatcherId = Int

data Action = SetUnderstanding WatcherId Understanding

type State = { understanding :: M.Map WatcherId Understanding }


initialState :: State
initialState = { understanding : M.empty }

render :: T.Render State _ Action
render dispatch _ state _ =
  [ R.div' [] ]

performAction :: T.PerformAction _ State _ Action
performAction (SetUnderstanding watcher value) _ _ = void (T.cotransform (\state -> state { understanding = M.insert watcher value state.understanding }))

spec :: T.Spec _ State _ Action
spec = T.simpleSpec performAction render

main = T.defaultMain spec initialState unit
