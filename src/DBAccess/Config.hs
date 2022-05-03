module DBAccess.Config
  (initConfig)
where

import Control.Exception
import System.Environment

data DBConfig = DBConfig
  { host :: String,
    username :: String,
    password :: String,
    port :: String
  }

instance Show DBConfig where
  show a = show $ getDSN a

getDSN :: DBConfig -> String
getDSN a = host a ++ username a ++ password a ++ port a

initConfig :: Maybe DBConfig
initConfig = do
  let h = getEnvString "host"
      un = getEnvString "user_name"
      pwd = getEnvString "pwd"
      pt = getEnvString "port"
      in do
        if h == "none" || un == "none" || pwd == "none" || pt == "none"
          then Nothing
        else 
          Just DBConfig{host=h, port=pt, username=un, password=pwd}

getEnvString :: String -> String
getEnvString envName = "none"
  -- foo <- catch (getEnv "FOO") (const $ pure "none" :: IOException -> IO String)