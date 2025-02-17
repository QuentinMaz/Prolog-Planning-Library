:- use_module(library(plunit)).
:- use_module(library(timeout), [time_out/3]).

:- [readFile, parseDomain, parseProblem].
:- [state_space_searches, search_algorithms, utils, blackboard_data].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TESTS FILES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

complex_problem('test/blocks/domain.pddl', 'test/blocks/blocks5.pddl').
complex_problem('test/monkey/domain.pddl', 'test/monkey/monkey2.pddl').
complex_problem('test/complex_rover/domain.pddl', 'test/complex_rover/complex_rover1.pddl').
complex_problem('test/hanoi/domain.pddl', 'test/hanoi/hanoi3.pddl').
complex_problem('test/logistics/domain.pddl', 'test/logistics/logistics1.pddl').

light_problem('test/blocks/domain.pddl', 'test/blocks/blocks2.pddl').
light_problem('test/blocks/domain.pddl', 'test/blocks/blocks3.pddl').

light_problem('test/hanoi/domain.pddl', 'test/hanoi/hanoi1.pddl').
light_problem('test/hanoi/domain.pddl', 'test/hanoi/hanoi2.pddl').

light_problem('test/gripper/domain.pddl', 'test/gripper/gripper1.pddl').
light_problem('test/gripper/domain.pddl', 'test/gripper/gripper2.pddl').

light_problem('test/typed_gripper/domain.pddl', 'test/typed_gripper/typed_gripper1.pddl').
light_problem('test/typed_gripper/domain.pddl', 'test/typed_gripper/typed_gripper2.pddl').

light_problem('test/monkey/domain.pddl', 'test/monkey/monkey1.pddl').
light_problem('test/monkey/domain.pddl', 'test/monkey/monkey2.pddl').

light_problem('test/simple_rover/domain.pddl', 'test/simple_rover/simple_rover1.pddl').

light_problem('test/airport/domain1.pddl', 'test/airport/airport1.pddl').
light_problem('test/airport/domain2.pddl', 'test/airport/airport2.pddl').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TESTING HELPERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a_star_heuristic(h_0).
a_star_heuristic(h_add).
a_star_heuristic(h_diff).
a_star_heuristic(h_plus).
a_star_heuristic(h_length).

a_star_mutant_heuristic(h_add).
a_star_mutant_heuristic(h_diff).
a_star_mutant_heuristic(h_plus).
a_star_mutant_heuristic(h_length).

%% forward validation
validate_fwd_bfs(DomainFile, ProblemFile) :-
    validate_problem(DomainFile, ProblemFile, forward, bfs).

validate_fwd_dfs(DomainFile, ProblemFile) :-
    validate_problem(DomainFile, ProblemFile, forward, dfs).

validate_fwd_iddfs(DomainFile, ProblemFile) :-
    validate_problem(DomainFile, ProblemFile, forward, iddfs).

validate_fwd_dfs_first_solution(DomainFile, ProblemFile) :-
    validate_problem(DomainFile, ProblemFile, forward, dfs_first_solution).

validate_fwd_dfs_longer_solution(DomainFile, ProblemFile) :-
    validate_problem(DomainFile, ProblemFile, forward, dfs_longer_solution).

validate_fwd_a_star(DomainFile, ProblemFile) :-
    validate_problem(DomainFile, ProblemFile, forward, a_star).

validate_fwd_a_star_mutant1(DomainFile, ProblemFile) :-
    validate_problem(DomainFile, ProblemFile, forward, a_star_mutant1).

validate_fwd_a_star_mutant2(DomainFile, ProblemFile) :-
    validate_problem(DomainFile, ProblemFile, forward, a_star_mutant2).

validate_fwd_a_star_mutant3(DomainFile, ProblemFile) :-
    validate_problem(DomainFile, ProblemFile, forward, a_star_mutant3).

validate_problem(DomainFile, ProblemFile, StateSpaceSearch, SearchAlgorithm) :-
    make_input(DomainFile, ProblemFile, Domain-Problem),
    !,
    time_out(solve(Domain, Problem, StateSpaceSearch, SearchAlgorithm, Plan), 30000, _),
    check_plan_validity(Problem, Plan).

%% backward validation
validate_bwd_bfs(DomainFile, ProblemFile) :-
    validate_problem(DomainFile, ProblemFile, backward, bfs).

validate_bwd_dfs(DomainFile, ProblemFile) :-
    validate_problem(DomainFile, ProblemFile, backward, dfs).

%% solve(+Domain, +Problem, +StateSpaceSearch, +SearchAlgorithm, -Solution).
solve(D, P, StateSpaceSearch, SearchAlgorithm, Solution) :-
    set_blackboard(D, P, StateSpaceSearch, SearchAlgorithm),
    initialise_start_state(StateSpaceSearch, StartState),
    search(SearchAlgorithm, StartState, Solution).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLUNIT TESTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BFS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% FORWARD BFS
:- begin_tests(forward_bfs).

test(forward_bfs_light_problems, [nondet, forall(light_problem(Domain, Problem))]) :-
    validate_fwd_bfs(Domain, Problem).

:- end_tests(forward_bfs).

:- begin_tests(backward_bfs, [blocked(backward_testing_is_too_long)]).

test(backward_bfs_light_problems, [nondet, forall(light_problem(Domain, Problem))]) :-
    validate_bwd_bfs(Domain, Problem).

:- end_tests(backward_bfs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DFS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% FORWARD DFS
:- begin_tests(forward_dfs).

test(forward_dfs_light_problems, [nondet, forall(light_problem(Domain, Problem))]) :-
    validate_fwd_dfs(Domain, Problem).

:- end_tests(forward_dfs).

:- begin_tests(backward_dfs, [blocked(backward_testing_is_too_long)]).

test(backward_dfs_light_problems, [nondet, forall(light_problem(Domain, Problem))]) :-
    validate_bwd_dfs(Domain, Problem).

:- end_tests(backward_dfs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IDDFS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% FORWARD IDDFS
:- begin_tests(forward_iddfs).

test(forward_iddfs_light_problems, [nondet, forall(light_problem(Domain, Problem))]) :-
    validate_fwd_iddfs(Domain, Problem).

:- end_tests(forward_iddfs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DFS_FIRST_SOLUTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% FORWARD DFS_FIRST_SOLUTION
:- begin_tests(forward_dfs_first_solution).

test(forward_dfs_first_solution_light_problems, [nondet, forall(light_problem(Domain, Problem))]) :-
    validate_fwd_dfs_first_solution(Domain, Problem).

:- end_tests(forward_dfs_first_solution).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DFS_LONGER_SOLUTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% FORWARD DFS_LONGER_SOLUTION
:- begin_tests(forward_dfs_longer_solution).

test(forward_dfs_longer_solution_light_problems, [nondet, forall(light_problem(Domain, Problem))]) :-
    validate_fwd_dfs_longer_solution(Domain, Problem).

:- end_tests(forward_dfs_longer_solution).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% A_STAR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% FORWARD A_STAR
:- begin_tests(forward_a_star).

test(forward_a_star_light_problems, [nondet, forall((light_problem(Domain, Problem), a_star_heuristic(Heuristic)))]) :-
    set_heuristic(Heuristic),
    validate_fwd_a_star(Domain, Problem).
:- end_tests(forward_a_star).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% A_STAR_MUTANT1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% FORWARD A_STAR_MUTANT1
:- begin_tests(forward_a_star_mutant1).

test(forward_mutant1_light_problems, [nondet, forall((light_problem(Domain, Problem), a_star_mutant_heuristic(Heuristic)))]) :-
    set_heuristic(Heuristic),
    validate_fwd_a_star_mutant1(Domain, Problem).

:- end_tests(forward_a_star_mutant1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% A_STAR_MUTANT2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% FORWARD A_STAR_MUTANT2
:- begin_tests(forward_a_star_mutant2).

test(forward_mutant2_light_problems, [nondet, forall((light_problem(Domain, Problem), a_star_mutant_heuristic(Heuristic)))]) :-
    set_heuristic(Heuristic),
    validate_fwd_a_star_mutant2(Domain, Problem).

:- end_tests(forward_a_star_mutant2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% A_STAR_MUTANT3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% FORWARD A_STAR_MUTANT3
:- begin_tests(forward_a_star_mutant3).

test(forward_mutant3_light_problems, [nondet, forall((light_problem(Domain, Problem), a_star_mutant_heuristic(Heuristic)))]) :-
    set_heuristic(Heuristic),
    validate_fwd_a_star_mutant3(Domain, Problem).

:- end_tests(forward_a_star_mutant3).