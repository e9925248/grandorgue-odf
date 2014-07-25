Usage guide for jOdfCleaner
---------------------------

jOdfCleaner is a command line based tool designed to help cleaning ODFs (made 
for use with the virtual pipe organ software GrandOrgue 0.2 or similar even
earlier versions that use the same .organ file format) so that they can be
used with a modern 0.3+ version without so many log warnings. The software is
released under a MIT license.

The program expects two parameters. The first one is the original .organ file
that needs cleaning and the second is the name of the newly cleaned ODF file.
As such, make sure that you give the new output file another name than the
original .organ file so that it's not overwritten!

This program will remove such lines that are no longer used by GrandOrgue.
Examples of such entries are StopControlMidiKeyNumber, Comments and 
HighestSampleFormat. Any comment (anything after a ; character) that occur on
the same line as a configuration entry is removed. Excess whitespace is also
removed. All old style configuration lines found will be removed, but they are
assumed to always be at the end of the file after the important sections as
they would be if created by software.

Beware that this simple program will not be able to fix logical- or syntax
errors that require more than a line per line evaluation. It's design to
modernize an old but (mainly) working .organ file.

2014-07-17