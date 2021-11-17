NoisePipes
Copyright (C) 2021 Lars Palo
Released under GNU/GPL v3

This program writes the necessary Pipe999 lines for a GrandOrgue .organ file to
create noise effect stops/ranks with separate attack(s) and release(s) from 
sample files that have no embedded markers. What it does is write the lines
necessary to add a loop to the attack file(s) last samples (no modification of
the original sample file happens) and add the release sample(s) as release(s).
In effect, you can in this way create a non percussive stop/rank from samples
that are percussive == lacks loop/cue markers.

The user supplies the .organ file location and the location of attacks and
releases (they must be in different folders but having same names). In the pipe
tab of the notebook the lines will be written and can easily be selected 
(Ctrl+A), copied (Ctrl+C) and pasted (Ctrl+V) into your .organ file.

To compile, libsndfile must be present on the computer either installed from
package or available as local install. On Ubuntu Linux you must install both
the libsndfile package and its -dev package if you use the Ubuntu repository.
WxWidgets must also be installed. Cmake must of course also be present.

Compilation is best done in a separate build folder, for instance in the
noisepipes/ directory you issue the commands:

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make

and you'll have the binary in the build/bin folder if all goes well.

To cross compile to windows from Linux you must have both libsndfile and
wxwidgets cross compiled first.

Modify the toolchain.def in the noisepipes/ root so that CMAKE_FIND_ROOT_PATH
points to your wx cross compile install location. Then in the noisepipes/ root
directory you issue the commands:

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/path/to/libsndfile/include -DCMAKE_LIBRARY_PATH=/path/to/libsndfile/lib/libsndfile.a -DCMAKE_TOOLCHAIN_FILE=../toolchain.def
make

