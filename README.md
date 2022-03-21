# About this fork
This fork is the result of one of the works I've done during my six month graduation project. Actually, I've changed many things (as I needed to really understand the initial implementation); nonetheless the initial work was done by Robert Sasak and so it would have been unfair to not fork it.

Despite the big changes in the files organisation, my main contribution consists in adding hand-coded variants of known search algorithms. Those *faulty variants* are meant to be non-optimal. They can be found in the file *search_algorithms.pl*:
- **a_star_mutant1** Mutated implementation of a forward A* search. It does not reopen closed nodes (states that have already been visited) and the *f* function (used to prioritise the open set) is given by *f(state)=-g(state)-h(state)*.
- **a_star_mutant2** Similar to the first A* based mutant, but uses a mutated prioritisation function *f(state)=-g(state)+h(state)*.
- **a_star_mutant3** Weighted A* version of **a_star_mutant2**. Precisely, the weight parameter is set to 10, leading to *f(state)=-g(state)+10\*h(state)*.

## Changes

In addition to those *faulty variants*, I added:
- PDDL parsing and modeling capabilities (single-level heritage support, action instantiation is now based on both objects of the problem and constants of the domain).
- Comments in source code.
- Verification capabilities (plunit tests as well as dedicated plan validation predicates).

Moreover, the way this project can be used as an AI planner is different (and better, IMHO). Before having different .pl files implementating a same API (which thus involves reloading another file to erase from the database the current predicates), now it uses configured predicates (which avoids the afermentioned reloading and erasing process). As a consequence, the project can be now built once and used as a configurable AI planning system.

Finally, I've downgraded the backward-based solving capabilities. Indeed, even if backward searching is still available, it has not been thoroughly tested (e.g., the *faulty variants* have been developed as forward-based algorithms) and mutexes (used to prevent considering inconsistent states when regressing) have been removed. I did so because of my total lack of understanding  when I initially tackled the source code. They can be re-added though. 

## Running the AI planning system
Recall that SICStus should be installed (I used version 4.7.0) in order to run the program. A planner (a configuration of the planning system) can be run with the command `sicstus -l main.pl --goal "start, halt." -a $1 $2 $3 $4 $5 $6` where:
- `$1` is the search space (either `forward` or `backward`).
- `$2` is the search algorithm (e.g., `bfs`; see *main.pl* for more information).
- `$3` is the heuristic (e.g., `h_add`; see *heuristics.pl* for more information).
- `$4` is the domain filename.
- `$5` is the problem filename.
- `$6` is the output filename.

As a side note, the backward-based searches deliver poor performance and are thus not recommended. For that matter, the behavior of the unsupported configurations (like the mutated searches coupled with the backward space) is unknown.

## Building the planning system
As mentioned before, since the Library has been turned into an AI planning system, one can be interested in building the tool. For that matter, SICStus provides a simple and easy way to do so. Open a terminal in the folder containing this repository and do the following:
- Run the `sicstus` command and successively execute `compile(main).`,  `save_program('main.sav').` and `halt.`. The traces should look like:
```
sicstus
SICStus [...]
| ?- compile(main).
% [...]
yes
| ?- save_program('main.sav').
% [...]
yes
| ?- halt.
```
- Build the executable with `spld --output=main.exe --static main.sav`:
```
spld --output=main.exe --static main.sav
[...]
spldgen_s_14540_1647527992_restore_main.c
spldgen_s_14540_1647527992_main_wrapper.c
spldgen_s_14540_1647527992_prolog_rtable.c
   Creating library main.lib and object main.exp
Created "main.exe"
```
At this point, an executable file *main.exe* should have been created. When built, it uses the same inputs described above.

## Conclusion and future works

To me, this fork project can be used as an affordable AI planning system for beginners. Indeed, I tried to give insights for each search algorithm implemented (and the code is pretty well commented overall), unit tests are set up and a modest number of configurations can be experimented. I hope it'll help students in AI planning. 

For people interested in forking this repository, future works can be the following: keep improving PDDL support, add configurations (or improve the current one, especially when leveraging the backward search space) and finally improve the solver from a software engineering perspective (error handling, better logging, monitoring functionalities, better performance, better test suite etc.).