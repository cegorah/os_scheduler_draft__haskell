# OpenstackScheduler
Just a nasty draft of a service that could works
as openstack scheduler module. Choosing a node with 
enough resources.
## Computation
The module is responsible for all main logic.  
`AllocRequest` instances is able to:
* init request from JSON
* send request to API
* find the name of a node that has enough resources for placement

## DBAccess
The module is responsible for getting data from a database 
and present models for `NodeResources` and `User`.

## API
The module will get information (GRPC?/REST?) and send the request 
to the Nova API to allocate resources.
