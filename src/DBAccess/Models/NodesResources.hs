module DBAccess.Models.NodesResources where

data NodeResources = NodeResources{
    nodeName :: String,
    usedVCpu :: Integer,
    usedRAM :: Integer
}

instance Show NodeResources where
  show b = show (nodeName b) ++ ":" ++ show (usedVCpu b) ++ ":" ++ show (usedRAM b)

getNodesInfo :: [NodeResources]
getNodesInfo = [NodeResources{}] -- must be obtained from DB

getNodesNames :: [NodeResources] -> [String]
getNodesNames [] = []
getNodesNames (nd:nds) = [nodeName nd] ++ getNodesNames nds
