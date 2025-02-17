%% parse_problem(+File, -Output).
% parses PDDL problem File and turns it into re-written Prolog syntax
parse_problem(F, O) :- parseProblem(F, O, []).

%% parseProblem(+File, -Output, -RestOfFile).
% same as parseProblem/2 but also returns the rest of the file. It can be useful if the domain and problem are in one file
parseProblem(F, Problem, R) :-
	read_file(F, L),
	problem(O, L, R),
    O =.. [problem|Data],
    (
        foreach(Term, Data),
        foreach(GroundTerm, GroundData)
    do
        (var(Term) -> GroundTerm = [] ; GroundTerm = Term)
    ),
    Problem =.. [problem|GroundData].

:- [parseDomain]. % loads dependancies

% List of DCG rules describing structure of problem file in language PDDL.
% BNF description was obtain from http://www.cs.yale.edu/homes/dvm/papers/pddl-bnf.pdf
% This parser does not fully NOT support PDDL 3.0
% However you will find comment out lines ready for futher development.
% Some of the rules are already implemented in parseDomain.pl

problem(problem(Name, Domain, Requirements, ObjectsDeclaration, I, G, [], [], []))
    --> ['(', define, '(', problem, Name, ')',
        '(', ':', domain, Domain, ')'],
        (require_def(Requirements) ; []),
        (object_declaration(ObjectsDeclaration)	; []),
        init(I),
        goal(G),
        % (constraints(C) ; []), % :constraints
        % (metric_spec(MS) ; []),
        % (length_spec(LS) ; []),
        [')'].

%% object_declaration(+List).
% DCG for objects declaration of the problem
object_declaration(L) --> ['(', ':', objects], typed_list(name, L), [')'].

%% typed_list_as_list(+Word, -TypedList).
typed_list_as_list(W, [G|Ns])
    --> oneOrMore(W, N), ['-'], type(T),
        !,
        typed_list_as_list(W, Ns),
        {G =.. [T, N]}. % /!\ N is a list ! Example : functor([t1, t2])
typed_list_as_list(W, N) --> zeroOrMore(W, N).

init(I) --> ['(', ':', init], zeroOrMore(init_el, I), [')'].

init_el(I) --> literal(name, I).
init_el(set(H, N)) --> ['(', '='], f_head(H), number(N), [')']. % fluents
init_el(at(N, L)) --> ['(', at], number(N), literal(name, L), [')']. % timed-initial literal

goal(G)	--> ['(', ':', goal], pre_GD(G), [')'].

/** for constraints. Not seen yet.
% constraints(C) --> ['(', ':', constraints], pref_con_GD(C), [')']. % constraints

pref_con_GD(and(P))		--> ['(',and], zeroOrMore(pref_con_GD, P), [')'].
%pref_con_GD(foral(L, P))	--> ['(',forall,'('], typed_list(variable, L), [')'], pref_con_GD(P), [')'].	%universal-preconditions
%pref_con_GD(prefernce(N, P))	--> ['(',preference], (pref_name(N) ; []), con_GD(P), [')'].			%prefernces
pref_con_GD(P)			--> con_GD(P).

con_GD(and(L))			--> ['(',and], zeroOrMore(con_GD, L), [')'].
con_GD(forall(L, P))		--> ['(',forall,'('], typed_list(variable, L),[')'], con_GD(P), [')'].
con_GD(at_end(P))		--> ['(',at,end],	gd(P), [')'].
con_GD(always(P))		--> ['(',always],	gd(P), [')'].
con_GD(sometime(P))		--> ['(',sometime],	gd(P), [')'].
con_GD(within(N, P))		--> ['(',within], number(N), gd(P), [')'].

con_GD(at_most_once(P))		--> ['(','at-most-once'], gd(P),[')'].
con_GD(some_time_after(P1, P2))	--> ['(','sometime-after'], gd(P1), gd(P2), [')'].
con_GD(some_time_before(P1, P2))--> ['(','sometime-before'], gd(P1), gd(P2), [')'].
con_GD(always_within(N, P1, P2))--> ['(','always-within'], number(N), gd(P1), gd(P2), [')'].
con_GD(hold_during(N1, N2, P))	--> ['(','hold-during'], number(N1), number(N2), gd(P), [')'].
con_GD(hold_after(N, P))	--> ['(','hold-after'], number(N), gd(P),[')'].
*/

metric_spec(metric(O, E)) --> ['(', ':', metric], optimization(O), metric_f_exp(E), [')'].

optimization(minimize) --> [minimize].
optimization(maximize) --> [maximize].

metric_f_exp(E) --> ['('], binary_op(O), metric_f_exp(E1), metric_f_exp(E2), [')'], {E =..[O, E1, E2]}.
metric_f_exp(multi_op(O,[E1|E])) --> ['('], multi_op(O), metric_f_exp(E1), oneOrMore(metric_f_exp, E), [')']. % I dont see meanful of this rule, in additional is missing in f-exp
metric_f_exp(E) --> ['(','-'], metric_f_exp(E1), [')'], {E=.. [-, E1]}.
metric_f_exp(N)	--> number(N).
metric_f_exp(F)	--> ['('], function_symbol(S), zeroOrMore(name, Ns), [')'], { F=..[S|Ns]}. % concat_atom([S|Ns], '-', F).
metric_f_exp(function(S)) --> function_symbol(S).
metric_f_exp(total_time) --> ['total-time'].
metric_f_exp(is_violated(N)) --> ['(', 'is-violated'], pref_name(N), [')'].

% Work arround
length_spec([])	--> [not_defined]. % there is no definition???