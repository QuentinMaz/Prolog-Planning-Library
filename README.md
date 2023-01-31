# About this branch

This branch aims at enabling convenient executable building of different search configurations of the AI planning system **before Tobhias Opsahl's changes** (in 2021). Precisely, the source code of this repository (other than the few adaptations listed below) comes from **[last Robert Sasak's commit of 2010](https://github.com/RobertSasak/Prolog-Planning-Library/tree/d590f74df38177784699171b5d1069280e0e04fa)**.

## Modifications done

- *compilation_helper.py* is a Prolog file that helps building executable of a search configuration.
- *compilation_script.py* is a Python script which lets the user define a list of search settings he/she would like to build executables for. 

Those modest adaptations should not interfere whatsoever with the original implementation's semantic.

## Executable usage

Once built, an executable file expects 4 inputs:
- A timeout value (in seconds).
- Filepath of the domain definition.
- Filepath of the problem definition.
- Filepath of output the solution.

For example, the script should build the forward *A** search guided by the *hmax* as *fastar_hmax.exe*, which can be then used as follows: `fastar_hmax.exe 60000 test/blocks/domain-blocks.pddl test/blocks/blocks-03-0.pddl output.txt`