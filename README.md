# Ruby Chess

This was a 2-day project. My blog posts for this day are [here][day1] and [here][day2].
[day1]: http://justinwang11.tumblr.com/post/122918189472/w2d2
[day2]: http://justinwang11.tumblr.com/post/123025365177/w2d3

## How to run the file

These files require Ruby to run. Use this: [Ruby Installation Tutorial](http://installrails.com/steps)
Once Ruby is installed, bundle install, download the files, go into terminal,
and run the game interface:

`ruby chess.rb`

All instructions should be available right in the console.

## Features

* Uses YAML to save game states and load games
* Implements cursor in the console, user can choose pieces
using W, A, S, D and the ENTER key
* Highlights possible moves when hovering over each piece
* Uses `undo_move` method for every possible move and allows only those that
don't leave the player in check to be selected
* Has AI that looks ahead in a value hash to find and select the move that
takes the highest piece available from its opponent (and makes a random move if
none is available)
