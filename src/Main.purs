module Main where

import Prelude

import Data.Generic
import Data.Int
import Data.List as L
import Data.Map as M

import React as R
import React.DOM as R
import React.DOM.Props as RP
import ReactDOM as RDOM

import Thermite as T


data Understanding = TooEasy | Normal | TooHard
derive instance uGeneric :: Generic Understanding

instance uEq :: Eq Understanding where
  eq = gEq

type WatcherId = Int

data Action = SetUnderstanding WatcherId Understanding

type State = { understanding :: M.Map WatcherId Understanding }


initialState :: State
initialState = { understanding : M.empty }

render :: T.Render State _ Action
render dispatch _ state _ = [ R.div [ RP.style { width: "400px", height: "100px" } ]
                              (map (renderUnderstanding state) [TooEasy, Normal, TooHard])
                            , renderButtons dispatch 1
                            , renderButtons dispatch 2
                            , renderButtons dispatch 3
                            , renderButtons dispatch 4
                            ]

cssPercentage :: Number -> String
cssPercentage value = show (value * 100.0) <> "%"

understandingPercentage :: State -> Understanding -> Number
understandingPercentage state u = (toNumber matching) / toNumber (M.size state.understanding)
  where matching = L.length (L.filter (eq u) (M.values state.understanding))

understandingColor :: Understanding -> String
understandingColor TooEasy = "#00ff00"
understandingColor Normal = "#ffff00"
understandingColor TooHard = "#ff0000"

renderUnderstanding :: State -> Understanding -> R.ReactElement
renderUnderstanding state u = R.div [ RP.style { width: cssPercentage (understandingPercentage state u)
                                               , height: "100px"
                                               , backgroundColor: understandingColor u
                                               , display: "inline-block"
                                               }
                                    ] []

renderButtons :: (Action -> T.EventHandler) -> WatcherId -> R.ReactElement
renderButtons dispatch watcher = R.p' [ R.button [ RP.onClick \_ -> dispatch (SetUnderstanding watcher TooEasy)]
                                        [ R.text "Easy"]
                                      , R.button [ RP.onClick \_ -> dispatch (SetUnderstanding watcher Normal)]
                                        [ R.text "Normal"]
                                      , R.button [ RP.onClick \_ -> dispatch (SetUnderstanding watcher TooHard)]
                                        [ R.text "Hard"]

                                      ]

performAction :: T.PerformAction _ State _ Action
performAction (SetUnderstanding watcher value) _ _ = void (T.cotransform (\state -> state { understanding = M.insert watcher value state.understanding }))

spec :: T.Spec _ State _ Action
spec = T.simpleSpec performAction render

main = T.defaultMain spec initialState unit
