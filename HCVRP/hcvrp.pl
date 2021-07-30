% File: hcvrp.pl
% Pavlos Spanoudakis (sdi1800184)

:- lib(ic).
:- lib(branch_and_bound).
:- lib(ic_global).

:- [hcvrp_data].

hcvrp(NCl, NVe, Timeout, TrimmedRoutes, Cost, Time) :-
	% Start time
	statistics(runtime, [Start|_]),

	% Get requested input data
	getData(NCl, NVe, RealClients, RealDemands, Vehicles),
	% Add one more 0 demand (used for client 0)
	Demands = [0|RealDemands],
	% Create variables (NCl variables per Vehicle)
	makeVariables(NCl, NVe, VehicleRoutes),
	% Calculate distances between all clients and the base (0, 0)
	makeDistancesMatrix([c(0, 0, 0)|RealClients], [c(0, 0, 0)|RealClients], DistancesMatrix),
	% Flatten the variable list
	flatten(VehicleRoutes, FlattenedRoutes),

	% Set required constraints
	setConstraints(VehicleRoutes, FlattenedRoutes, Vehicles, Demands, NCl),

	% Increase NCl by 1, since the Matrix is (NCl + 1) x (NCl + 1)
	TotalNCl is NCl + 1,
	evaluateCost(DistancesMatrix, VehicleRoutes, Cost, TotalNCl),

	% Find solution
	bbMinCall(FlattenedRoutes, Cost, Timeout),

	% Remove 0's from the solution
	trimSolution(VehicleRoutes, TrimmedRoutes),
	% Stop time
	statistics(runtime, [End|_]),
	Time is (End - Start) / 1000.

bbMinCall(Solution, Cost, Timeout) :-
	Timeout > 0,
	bb_min(search(Solution, 0, occurrence, indomain_middle , complete, []),
		   Cost, bb_options{strategy: continue, timeout: Timeout}).
bbMinCall(Solution, Cost, Timeout) :-
	Timeout = 0,
	bb_min(search(Solution, 0, occurrence, indomain_middle , complete, []),
		   Cost, bb_options{strategy: continue}).

% Removes 0's from the solution
trimSolution([], []).
trimSolution([FirstRoute|RestRoutes], [TrimmedFirst|RestTrimmed]) :-
	trimRoute(FirstRoute, TrimmedFirst),
	trimSolution(RestRoutes, RestTrimmed).

% Ignore 0's from the given list.
% We know 0's are stored at the end, so stop when the first 0 is found.
trimRoute([], []).
trimRoute([0|_], []).
trimRoute([FirstClient|RestClients], [FirstClient|RestTrimmed]) :-
	FirstClient > 0,
	trimRoute(RestClients, RestTrimmed).

% Constraints -------------------------------------------------------------------------------------

setConstraints(VehicleRoutes, FlattenedRoutes, Vehicles, Demands, NCl) :-
	noCapacityOverflow(VehicleRoutes, Vehicles, Demands),
	emptySlotsRight(VehicleRoutes),
	serveOnce(NCl, FlattenedRoutes).

noCapacityOverflow([], [], _).
noCapacityOverflow([CurrentRoute|RestRoutes], [CurrentVehicle|RestVehicles], Demands) :-
	% Get the Quantities of the route
	getRouteQuantities(CurrentRoute, CurrentRouteQuantity, Demands),
	% Ensure their sum does not exceed the vehicle capacity
	CurrentVehicle #>= sum(CurrentRouteQuantity),
	noCapacityOverflow(RestRoutes, RestVehicles, Demands).

% Collect this route quantities
getRouteQuantities([], [], _).
getRouteQuantities([CurrentClient|RestClients], [CurrentQuantity|RestQuantities], Demands) :-
	Index #= CurrentClient + 1,
	element(Index, Demands, CurrentQuantity),
	getRouteQuantities(RestClients, RestQuantities, Demands).

% Ensure all routes have any empty client slots at the end.
emptySlotsRight([]).
emptySlotsRight([CurrentRoute|RestRoutes]) :-
	routeEmptySlotsRight(CurrentRoute),
	emptySlotsRight(RestRoutes).

% Ensure a 0 client is followed by 0 clients only.
routeEmptySlotsRight([_]).
routeEmptySlotsRight([Current, Next|Rest]) :-
	Current #= 0 => Next #= 0,
	routeEmptySlotsRight([Next|Rest]).

% Ensure all Clients are served exactly one time.
serveOnce(0, _).
serveOnce(CurrentClient, FlattenedRoutes) :-
	CurrentClient > 0,
	occurrences(CurrentClient, FlattenedRoutes, 1),
	NextClient is CurrentClient - 1,
	serveOnce(NextClient, FlattenedRoutes).

% Cost --------------------------------------------------------------------------------------------

% Store the total cost of the given VehicleRoutes in Cost.
evaluateCost(DistancesMatrix, VehicleRoutes, Cost, NCl) :-
	flatten(DistancesMatrix, FlattenMatrix),
	routesCost(VehicleRoutes, FlattenMatrix, CostList, NCl),
	Cost #= sum(CostList).

% Find the Cost for each Route in the list and store all costs in the Costs List.
routesCost([], _, [], _).
routesCost([CurrentRoute|RestRoutes], FlattenMatrix, [Cost|RestCosts], NCl) :-
	routeCost(0, CurrentRoute, FlattenMatrix, RouteDistances, NCl),
	Cost #= sum(RouteDistances),
	routesCost(RestRoutes, FlattenMatrix, RestCosts, NCl).

% Calculate the Distances between clients of this Route and store them in the Distances List.
routeCost(PrevClient, [], FlattenMatrix, [Distance], NCl) :-
	% No more clients left, so find distance between PrevClient and Base.
	% Essentially this is (PrevClient * NCl) + 0 + 1, to find distance of PrevClient from (0, 0)
	Index #= (PrevClient * NCl) + 1,
	element(Index, FlattenMatrix, Distance).
routeCost(PrevClient, [CurrentClient|RestClients], FlattenMatrix, [PrevToCurrentDistance|RestDistances], NCl) :-
	% Find and store distance between PrevClient and CurrentClient.
	% If CurrentClient is 0, 0 will be stored.
	Index #= (PrevClient * NCl) + CurrentClient + 1,
	element(Index, FlattenMatrix, Distance),
	% If CurrentClient is 0, keep the same PrevClient
	CurrentClient #= 0 => ((PrevToCurrentDistance #= 0) and (NextPrevClient #= PrevClient)),
	% CurrentClient is not 0, so pass CurrentClient to the recursive call
	CurrentClient #> 0 => ((PrevToCurrentDistance #= Distance) and (NextPrevClient #= CurrentClient)),
	routeCost(NextPrevClient, RestClients, FlattenMatrix, RestDistances, NCl).

% Initializing ------------------------------------------------------------------------------------

% Create the Matrix that contains all the distances between Clients.
makeDistancesMatrix([], _, []).
% Iterate over each Client in the first list
makeDistancesMatrix([FirstClient|RestClients], Clients, [FirstClientDistances|RestDistances]) :-
	% Find Distances between this Client and all the Clients (second list),
	% and add the Distances List in the Matrix (as a line).
	getClientDistances(FirstClient, Clients, FirstClientDistances),
	% Repeat for all Clients
	makeDistancesMatrix(RestClients, Clients, RestDistances).	

getClientDistances(_, [], []).
% Find the Distances between TargetClient and all the Clients in the Clients List,
% and store them in the Distances List.
getClientDistances(TargetClient, [OtherClient|Rest], [Distance|RestDistances]) :-
	clientDistance(TargetClient, OtherClient, Distance),
	getClientDistances(TargetClient, Rest, RestDistances).

% Create NCl variables for each of the NVe vehicles.
makeVariables(NCl, NVe, VarMatrix) :-
	length(VarMatrix, NVe),
	makeVariables(NCl, VarMatrix).
makeVariables(_, []).
makeVariables(NCl, [Vehicle|Rest]) :-
	length(Vehicle, NCl),
	Vehicle #:: 0..NCl,
	makeVariables(NCl, Rest).

% Store NCl Clients in the Client List, their respective Demands in the Demands List,
% and NVe Vehicles in the Vehicles List.
getData(NCl, NVe, Clients, Demands, Vehicles) :-
	% Get all available Clients
	clients(DataClients),
	% Get all available Vehicles
	vehicles(DataVehicles),
	% Store the requested number of Clients and Vehicles
	getClientData(NCl, Clients, Demands, DataClients),
	getVehicleData(NVe, Vehicles, DataVehicles).

% Store NCl Clients from the Client Data List to the Client List,
% and their respective Demands in the Demands List.
getClientData(0, [], [], _).
getClientData(NCl, [c(D, X, Y)|RestClients], [D|RestDemands], [c(D, X, Y)|RestData]) :-
	NCl > 0,
	NewNCl is NCl - 1,
	getClientData(NewNCl, RestClients, RestDemands, RestData).

% Store NVe vehicles from the Data Vehicle List to the Vehicles List.
getVehicleData(0, [], _).
getVehicleData(NVe, [Current|RestVehicles], [Current|RestData]) :-
	NVe > 0,
	NewNVe is NVe - 1,
	getVehicleData(NewNVe, RestVehicles, RestData).

% Store the distance between the 2 clients in Distance.
clientDistance(c(_, X1, Y1), c(_, X2, Y2), Distance) :-
	eucledianDistance(X1, Y1, X2, Y2, Distance).

eucledianDistance(X1, Y1, X2, Y2, Distance) :-
	Temp is (X1 - X2)^2 + (Y1 - Y2)^2,
	RealDistance is sqrt(Temp),
	RoundDistance is round(RealDistance * 1000),
	Distance is fix(RoundDistance).
