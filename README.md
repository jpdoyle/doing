doing
=====

doing lets you be accountable to yourself for how you spend your time,
without getting in your way.

How to do
---------

doing records your actions, as well as their start and end times (in
UNIX epoch format) in $DOING_FILE if you've set it, or ~/doing.txt if
you have not. Recording tasks is simple; just start a task:

    $ doing Something Productive

check how long you've spent on it:

    $ doing
    Something Productive ((00:31:25))

and end a session:

    $ doing -f
    01:01:08 spent on 'Something Productive'

That's it! Your doing.txt file will look somethign like this:

    Something Productive:1388345856:1388349524

New sessions get added onto the end of this file. Soon, you will be
able to do cool things to display information from this file like
totalling time spent on different tasks, but right now this is it.

