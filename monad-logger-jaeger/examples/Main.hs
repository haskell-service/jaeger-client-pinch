{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Main (
      main
    ) where

import Control.Concurrent.Lifted (threadDelay)

import Control.Monad.Logger (
    LogLevel(LevelInfo), logDebug, logInfo, logWarn, runStderrLoggingT)

import Network.Jaeger (withJaeger)

import Jaeger.Process (process)

import Control.Monad.Trans.Jaeger (runJaegerT)
import Control.Monad.Trans.JaegerTrace (runJaegerTraceT)

import Control.Monad.Logger.Jaeger (runJaegerLoggingT)

main :: IO ()
main = withJaeger $ \sock -> runJaegerT (runStderrLoggingT act) sock =<< process
  where
    act = flip runJaegerTraceT "root" $ flip runJaegerLoggingT LevelInfo $ do
        threadDelay 1000
        $(logDebug) "Debug message"
        $(logInfo) "Info message"
        $(logWarn) "Warn message"
        threadDelay 1000