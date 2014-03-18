NoisePipes
Copyright (C) 2013 Lars Palo
Released under GNU/GPL v3

This program creates the necessary lines for an .organ file of GrandOrgue
to use noise effects with separate attacks and releases and no markers.

To compile libsndfile must be present on the computer. On Ubuntu Linux
you must install both the libsndfile package and its -dev package. WxWidgets
must also be installed.

compilation is done in the src folder with the command

g++ -o NoisePipes NoisePipes.cpp NPFrame.cpp NPPipe.cpp -lsndfile `wx-config --cxxflags --libs`