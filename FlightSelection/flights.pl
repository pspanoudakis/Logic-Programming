% File: flights.pl
% Pavlos Spanoudakis (sdi1800184)

:- lib(ic).
:- lib(branch_and_bound).

:- [flight_data].

flights(I, Pairings, Cost) :-
	% Obtain input Pairings & Costs
	get_flight_data(I,N,DataPairings,DataCosts),
	length(DataPairings, M),
	% One variable for each pair
	length(PairingChoices, M),
	% Just creating a list of Flights [1,N]
	makeFlights(Flights, 1, N),
	% Variables are binary: 1 -> Pairing selected, 0 -> Pairing not selected
	PairingChoices #:: [0, 1],
	% Setting up constraints
	constraints(Flights, PairingChoices, DataPairings, DataCosts, CostList),
	Cost #= sum(CostList),
	% Finding a solution
	bb_min(search(PairingChoices, 0, first_fail, indomain_max , complete, []),
		   Cost, bb_options{strategy: continue, report_success: true/0, report_failure:true/0}),
	% Collect the chosen Pairings (along with their costs)
	collectChoices(Pairings, PairingChoices, DataPairings, CostList).

% Creates a list [1, 2, ... , N] (flight numbers)
makeFlights([N], N, N).
makeFlights([CurrentFlight|RestFlights], CurrentFlight, N) :-
	CurrentFlight < N,
	NextFlight is CurrentFlight + 1,
	makeFlights(RestFlights, NextFlight, N).

constraints(Flights, Choices, DataPairs, DataCosts, CostList) :-
	% Setting up constraints about flights (each flight must appear exectly 1 time)
	flightConstraints(Flights, Choices, DataPairs),
	% Setting corresponding costs of non-selected Pairings to 0
	choiceCosts(Choices, DataCosts, CostList).

flightConstraints([], _, _).
flightConstraints([CurrentFlight|RestFlights], Choices, DataPairs) :-
	% Require that the current Flight must be present exactly 1 time in the chosen Pairings
	flightPresence(CurrentFlight, Choices, DataPairs, 0),
	% Require the same for all Flights
	flightConstraints(RestFlights, Choices, DataPairs).

% Count how many times the given Flight appears in a chosen Pairing
flightPresence(_, [], [], TotalTimes) :-
	TotalTimes #= 1.
flightPresence(Flight, [Choice|RestChoices], [DataPair|RestData], TotalTimes) :-
	% If the given Flight appears in this Pairing, increment counter by 1 if the Pairing has been chosen (else no change)
	( member(Flight, DataPair) -> NewTotalTimes #= TotalTimes + ( 1 * Choice) ; NewTotalTimes #= TotalTimes ),
	% Check this flight presence in the rest of the Pairings
	flightPresence(Flight, RestChoices, RestData, NewTotalTimes).

% Require costs of non selected Pairings to be 0
choiceCosts([], [], []).
choiceCosts([Choice|RestChoices], [PairCost|RestPairCosts], [EvalCost|RestEval]) :-
	EvalCost #= Choice * PairCost,						% Choice is 1 if Pairing chosen, 0 if Pairing non-chosen,
														% so non-selected Pairing costs will be set to 0
	choiceCosts(RestChoices, RestPairCosts, RestEval).

% Collect the chosen Pairings (along with their costs) in the first argument.
collectChoices([], [], [], []).
% Choices contains 0 or 1 elements, 0 -> corresponding Pairing non-chosen,
% 1 -> corresponding Pairing chosen
collectChoices(Rest, [0|RestChoices], [_|RestData], [_|RestCosts]) :-
	% Current Pairing non chosen, so don't include it
	collectChoices(Rest, RestChoices, RestData, RestCosts).
% Current Pairing (DataPair) chosen, so include it along with its cost.
collectChoices([DataPair / Cost |Rest], [1|RestChoices], [DataPair|RestData], [Cost|RestCosts]) :-
	collectChoices(Rest, RestChoices, RestData, RestCosts).
