# Package installation at TACC with MrPackMod

Here are the basic repositories you need:

- https://github.com/TACC/MrPackMod : the python install scripts
- https://github.com/TACC/MrPackMod-installation : the install configurations
- https://github.com/TACC/MrPackMod-testing : regression tests

## Local installation

You install packages locally, including generating modules, if you set a couple of environment variables.
See the readme in the basic repository.

## TACC rpm generation in `jail'

This section is only for TACC. It is not particularly portable, and requires some specific naming.
In addition to the above repositories, it requires https://github.com/VictorEijkhout/tacc_specfiles
which has the spec files.

Here is the first time setup:

- In the `SPECS` directory clone this repository.
  Leave the name unchanged because it appears hard-wired in several scripts.
- Go into `RPMtheNextGeneration` and call `./pull_all.sh`. 
  This will clone the python, configurations, and specfiles repositories. (Not the testing repo.)
  It also does the following:
- Let `system` be the name of the system where you are installing. At TACC that was most recently `horizon`.
  The `pull_all.sh` scripts will invoke the `${system}.sh` script to specialize the general `install.sh` script,
  for instance specifying the available compilers.

With all this in place, you can now generate rpms. This relies on McLay's `build_rpm_sh` being properly set up.

- Make sure that the most recent version of your package has been downloaded:
  ```./make_download yourpackage```
  This will use the version number from the `makefiles/yourpackage/Configuration` file. 
  Make sure this is in sync with the version number in the spec file.
  (Sorry, I have no idea how to keep this synced automatically.)
- Call `./tacc_specfiles/${system}_specfiles/install.sh -m yourpackage`
- This will loop through all available compilers and generate the rpm for that package, that compiler.
  The list of available rpms (for the exact version and release) is given at the end of the install process. 
  You can cut and paste this into a collab ticket.
- If the installation failed, you can find the full log in `tacc_specfiles/${system}_specfiles/yourpackage*log`.
  The failure can be an rpm problem, MrPackMod problems, compilation problems, you name it. Debugging time!
- If you want to install only for a certain compiler, do ```[stuff]/install.sh -c g -v 15 yourpackage```
  where `g` is for GNU, `i` for Intel, `n` for NVidia, 
  and the version number you supply matches the start of the actual 
  compiler version: `15` matches `15.1.0` et cetera.

## Writing and editing spec files

Writing a new spec file is a dark art. 
Best to find a package that looks like yours, copy the spec file and edit.
Add the package to `versions.txt` in the specfiles repo, with version number and rpm release number.

Updating a spec file is easy. 
Example: a new version of your package has come out.
- Make sure to update the version number in the `Configuration` file for that package.
- Also update the version in the spec file and in the `versions.txt` file.
- Also update the release in the spec file and the `versions.txt` file. 
  Please also leave a note in the `%changelog` section of the spec file.
- Push the configurations and specfiles repos.
- Before you can generate the rpm, do `./pull_all.sh` to update your clones 
  (oh, you can not edit and push from jail! some network idiosyncracy)
  and `./make_download.sh yourpackage` to download the new version.
- Run the installation as before. The rpm listing will only show the new version and release.

## Repo ownership

Right now all this is owned by Victor Eijkhout.
If you want to contribute, ask to be added.


