import subprocess
import os


VC_PATH = ''


def get_configuration_filename(configuration: tuple[str, str, str]) -> str:
    """Returns the filename prefix associated to @configuration. It is used to build the executable filenames."""
    # forward a-star h_0 gives fastar_h0
    # uninformed searches has 'blind' as heuristic keyword
    return f'{configuration[0][0]}{configuration[1].replace("-", "")}_{configuration[2].replace("_", "") if configuration[2] is not None else "blind"}'


def build_configuration(prolog_filename: str, result_filename: str) -> str:
    """Compiles @prolog_filename as an executable file (named @result_filename) and removes all the artifacts that are created during the process."""
    output_filename = f'{result_filename}.exe'
    if os.path.exists(output_filename):
        return output_filename

    if os.path.exists(f'{prolog_filename}.pl'):
        compile_command = f'sicstus --goal "compile(\'{prolog_filename}\'), compile(compile_helper), save_program(\'{result_filename}.sav\'), halt."'
        build_command = f'cd "{VC_PATH}" && vcvars64.bat && cd "{os.getcwd()}" && spld --output={output_filename} --static {result_filename}.sav'
        try:
            subprocess.run(compile_command, shell=True, stdout=subprocess.DEVNULL)
            subprocess.run(build_command, shell=True, stdout=subprocess.DEVNULL)
            for artifact in [f'{result_filename}.sav', f'{result_filename}.pdb', f'{result_filename}.ilk', f'{result_filename}.exp', f'{result_filename}.lib']:
                os.remove(artifact)
            return output_filename
        except:
            print('Something went wrong.')
    else:
        raise FileNotFoundError(f'{prolog_filename}.pl not found. Compilation aborted.')


def build_configurations(configurations: list[tuple[str, str, str]]) -> list[str]:
    """Builds the given @configurations and returns the filenames of the executables generated."""
    results = []
    for (ss, s, h) in configurations:
        if h is not None:
            filename = f'{ss}-{s}-{h}'
        else:
            filename = f'{ss}-{s}'
        try:
            results.append(build_configuration(filename, get_configuration_filename((ss, s, h))))
        except FileNotFoundError as e:
            print(e)
    return results


###########################################################################################################################
###################################################### MAIN ###############################################################


if __name__ == '__main__':

    if VC_PATH == '':
        print('In order to use this Python script, please indicate the path to the .bat file vcvars64.bat!')
        exit(1)

    state_spaces = ['forward']
    blind_searches = ['bfs', 'iddfs']
    informed_searches = ['a-star', 'dfs']
    heuristics = ['h_0', 'h_max']
    configurations_to_build = []
    for ss in state_spaces:
        for s in blind_searches:
            configurations_to_build.append((ss, s, None))
        for s in informed_searches:
            for h in heuristics:
                configurations_to_build.append((ss, s, h))

    print('Number of configurations to build:', len(configurations_to_build))
    executable_filenames = build_configurations(configurations_to_build)
    if all([os.path.exists(f) for f in executable_filenames]):
        print('All executable files have been found.')
    else:
        print('Some of the executable files are missing.')