module Computation.Service where

import qualified DBAccess.Models.UserResources as UserModel
import qualified DBAccess.Models.NodesResources as NodeModel

data UserAllocRequest = UserAllocRequest{
  userName :: String,
  vCPU :: Integer,
  ram :: Integer
}

class AllocRequest ar where
  findNode :: ar -> String -> String -- find a node that is satisfied the request
  sendRequest :: ar -> String --send HTTP request to the Nova API
  initRequest :: ar -> String-> (Integer,Integer) -> ar

instance AllocRequest UserAllocRequest where
  initRequest a uName reqFields = a{userName=uName, vCPU=fst reqFields, ram=snd reqFields}
  findNode a uName = do
    let umNodes = UserModel.getUserNodes uName
        nmInfo = NodeModel.getNodesInfo
        ndsMatch = userResourceMatch a nmInfo
      in do
        case ndsMatch of
          [] -> "None"
          nds -> getNodeByLocation umNodes nds
  sendRequest a = do
    "Ok"

sendAllocRequest :: (AllocRequest a) => a -> Maybe String
sendAllocRequest a
  | sendRequest a == "Ok" = Just ("Ok")
  | otherwise = Nothing

userResourceMatch :: UserAllocRequest -> [NodeModel.NodeResources] -> [NodeModel.NodeResources]
-- Looking for a node with enough resources
userResourceMatch _ [] = []
userResourceMatch uAllocReq (nr:nodesResources) = do
  let p = NodeModel.usedVCpu nr - vCPU uAllocReq > 0 && 
              NodeModel.usedRAM nr - ram uAllocReq > 0
      res = []
      in do
        if p == False
          then userResourceMatch uAllocReq nodesResources
        else
          res ++ [nr]  ++ userResourceMatch uAllocReq nodesResources
          
getNodeByLocation :: [String] -> [NodeModel.NodeResources] -> String
-- Trying to find a Node without any user's instances to increase fault-tolerance
-- Returns it's name
getNodeByLocation _ [] = ""
getNodeByLocation [] nds = NodeModel.nodeName (nds!!0)
getNodeByLocation (node:uNodes) availableNodes = do
  let nodeNames = NodeModel.getNodesNames availableNodes
      in do
        if node `elem` nodeNames
          then getNodeByLocation uNodes availableNodes
        else
          NodeModel.nodeName (availableNodes!!0)
