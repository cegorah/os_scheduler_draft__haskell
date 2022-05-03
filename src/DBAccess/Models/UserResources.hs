module DBAccess.Models.UserResources where
  
getUserNodes :: String -> [String]
getUserNodes uName = [""] -- SELECT node_name FROM user2nodes
