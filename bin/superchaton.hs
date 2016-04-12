{-# LANGUAGE OverloadedStrings #-}
module EchoBot where

import Control.Applicative
import Control.Lens ((^.))
import Control.Monad.IO.Class (liftIO)
import Data.Maybe (fromMaybe)
import qualified Data.Text as T
import System.Environment (lookupEnv)
import System.Random (randomRIO)
import Web.Slack
import Web.Slack.Message

main :: IO ()
main = do
  apiToken <- fromMaybe (error "SLACK_API_TOKEN not set")
    <$> lookupEnv "SLACK_API_TOKEN"
  runBot (myConfig apiToken) bot ()

-- Those values are discovered in the MessagePayload, I don't know yet how to
-- discover them robustly.
directChannel = "D0ZAXRJG5"
generalChannel = "C0429EZKC"
superChatonPrefix = "<@U0MH92B3N>"

meows = ["Meow", "Grrrr", "Hisssss", "Purrr", "Purr", "Purrrr"]

bot :: SlackBot ()
bot (Message cid _ msg _ _ _)
  | cid^.getId == directChannel || superChatonPrefix `T.isPrefixOf` msg = do
    if "faisan" `elem` T.words msg
      then do
        sendMessage cid "http://www.oiseaux.net/photos/jean-louis.corsin/images/faisan.de.colchide.jlco.6g.jpg"
      else do
        meow <- liftIO (pick meows)
        sendMessage cid (meow `T.append` ".")
bot _ = return ()

pick :: [a] -> IO a
pick xs = randomRIO (0, length xs - 1) >>= return . (xs !!)

myConfig :: String -> SlackConfig
myConfig apiToken = SlackConfig
  { _slackApiToken = apiToken
  }
