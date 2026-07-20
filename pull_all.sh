#!/bin/bash

##
## Pull or update all repositories
## needed for rpm generation
## with Victor's MrPackMod
##


##
## Installer package
##
if [ ! -d MrPackMod ] ; then
    git clone https://github.com/TACC/MrPackMod.git
else
    ( cd MrPackMod && git stash && git pull )
fi

##
## Install scripts
##
if [ ! -d makefiles ] ; then
    git clone https://github.com/TACC/MrPackMod-installation.git makefiles
else
    ( cd makefiles && git stash && git pull )
fi

##
## Spec files
##
if [ ! -d tacc_specfiles ] ; then
    git clone https://github.com/VictorEijkhout/tacc_specfiles.git
else
    ( cd tacc_specfiles && git stash && git pull )
fi

##
## adapt spec files for this system
##
cd tacc_specfiles
system=$( hostname )
system=${system#*.} # sometimes it's build, sometimes staff
system=${system%.tacc.utexas.edu}
if [ ! -f "${system}.sh" ] ; then
    echo "Trouble finding specialization script for system=<<${system}>> in $(pwd)"
    exit 1
fi
./${system}.sh

# deprecated ( cd /admin/build/admin/rpms/stampede3/SPECS/rpmtng/make-support-files/ && git stash && git pull )
