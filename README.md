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
subsequent commands. Writes will still be dispatched, but eventually the writes
will not complete, and so the commands will not be executed (this is also evidenced by the `/tmp/` files not being created)

**To Break**

The example will consistently break with the following steps: 
1. Run `echo hello` 1 time (successfully runs)
2. Run `echo hello` 100 times
3. Run `echo hello` 1 time (this will queue data, but writes will not complete)

Example successful write output as in step 1 is something along the lines of 
```
Enter command to run (default 'echo hello'):

Enter number of times to run (default 1):

Running echo hello > /tmp/2.txt
[SEND-2] Queuing data to client: [101, 99, 104, 111, 32, 104, 101, 108, 108, 111, 32, 62, 32, 47, 116, 109, 112, 47, 50, 46, 116, 120, 116, 13, 10] 
[READ] count=3 received from host total=298
[SEND-2] completed bytes=75
[READ] count=22 received from host total=320
[READ] count=12 received from host total=332
[READ] count=10 received from host total=342
```

While after running many successive writes, every subsequent write, as in step 3, will look something like this:
```
Enter command to run (default 'echo hello'):

Enter number of times to run (default 1):

Running echo hello > /tmp/103.txt
[SEND-103] Queuing data to client: [101, 99, 104, 111, 32, 104, 101, 108, 108, 111, 32, 62, 32, 47, 116, 109, 112, 47, 49, 48, 51, 46, 116, 120, 116, 13, 10] 
```
