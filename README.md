# swiftterm-write-example

Minimal breaking example for writing to SwiftTerm's LocalProcess.

This project contains a simple executable that prompts the user to input
a command to run, and a number `n` of times to run the command. This
command is written to a LocalProcess running `bash`, and the output of each
iteration of the command is written to a tmp file (`/tmp/0.txt`,
`/tmp/1.txt`, ...).

Running a command like `echo hello` a small number of times (~5) is okay
and the commands are all run as expected.

If you run even a simple command like this a larger number (15-20) of
times, however, the `bash` process hangs and will not execute any
subsequent commands.
