:- use_module(library(timeout), [time_out/3]).


user:runtime_entry(start) :-
    start,
    halt.


start :-
    prolog_flag(argv, [TimeoutAtom, DomainFilepath, ProblemFilepath, OutputFilename]),
    atom_codes(TimeoutAtom, Codes),
    number_codes(TimeoutInteger, Codes),
    parseDomain(DomainFilepath, D, _),
    parseProblem(ProblemFilepath, P, _),
    term_to_ord_term(D, Domain),
    term_to_ord_term(P, Problem),
    reset_statistic,
    !,
    time_out(solve(Domain, Problem, Solution), TimeoutInteger, _Result),
    serialise_plan(Solution, OutputFilename),
    show_statistic(Problem, Solution).


start :-
    write('Something went wrong before solving the problem (parsing issues?)\n').


%% serialise_plan(+Plan, +Filename).
serialise_plan(Plan, Filename) :-
    open(Filename, write, FileStream),
    set_output(FileStream),
    write_plan(Plan),
    flush_output(FileStream),
    told.

%% write_plan(+Plan).
write_plan([]).
write_plan([ActionDef|T]) :-
    ActionDef =.. [Action|Parameters],
    format('(~a~@)\n', [Action, write_list_with_space(Parameters)]),
    write_plan(T).

%% write_list_with_space(+List).
write_list_with_space([]).
write_list_with_space([H|T]) :-
    write(' '),
    write(H),
    write_list_with_space(T).