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

    $ cat $DOING_FILE
    Something Productive:1388345856:1388349524

New sessions get added onto the end of this file.

After you have done some things, you can look at how much time you've
spent on a specific task:

    $ doing -l reddit
    04:48:12 spent on 'reddit'

Or on all tasks:

    $ doing -l
    reading: 02:14:46
    youtube: 05:55:47
    reddit: 04:48:12
    coding: 03:00:05

Now stop focusing so much on *how* you're doing, and just do!

