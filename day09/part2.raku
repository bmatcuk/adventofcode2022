#!/usr/bin/env raku

=begin pod
A rope snaps! Suddenly, the river is getting a lot closer than you remember.
The bridge is still there, but some of the ropes that broke are now whipping
toward you as you fall through the air!

The ropes are moving too quickly to grab; you only have a few seconds to choose
how to arch your body to avoid being hit. Fortunately, your simulation can be
extended to support longer ropes.

Rather than two knots, you now must simulate a rope consisting of ten knots.
One knot is still the head of the rope and moves according to the series of
motions. Each knot further down the rope follows the knot in front of it using
the same rules as before.

Using the same series of motions as the above example, but with the knots
marked H, 1, 2, ..., 9, the motions now occur as follows:

== Initial State ==

......
......
......
......
H.....  (H covers 1, 2, 3, 4, 5, 6, 7, 8, 9, s)

== R 4 ==

......
......
......
......
1H....  (1 covers 2, 3, 4, 5, 6, 7, 8, 9, s)

......
......
......
......
21H...  (2 covers 3, 4, 5, 6, 7, 8, 9, s)

......
......
......
......
321H..  (3 covers 4, 5, 6, 7, 8, 9, s)

......
......
......
......
4321H.  (4 covers 5, 6, 7, 8, 9, s)

== U 4 ==

......
......
......
....H.
4321..  (4 covers 5, 6, 7, 8, 9, s)

......
......
....H.
.4321.
5.....  (5 covers 6, 7, 8, 9, s)

......
....H.
....1.
.432..
5.....  (5 covers 6, 7, 8, 9, s)

....H.
....1.
..432.
.5....
6.....  (6 covers 7, 8, 9, s)

== L 3 ==

...H..
....1.
..432.
.5....
6.....  (6 covers 7, 8, 9, s)

..H1..
...2..
..43..
.5....
6.....  (6 covers 7, 8, 9, s)

.H1...
...2..
..43..
.5....
6.....  (6 covers 7, 8, 9, s)

== D 1 ==

..1...
.H.2..
..43..
.5....
6.....  (6 covers 7, 8, 9, s)

== R 4 ==

..1...
..H2..
..43..
.5....
6.....  (6 covers 7, 8, 9, s)

..1...
...H..  (H covers 2)
..43..
.5....
6.....  (6 covers 7, 8, 9, s)

......
...1H.  (1 covers 2)
..43..
.5....
6.....  (6 covers 7, 8, 9, s)

......
...21H
..43..
.5....
6.....  (6 covers 7, 8, 9, s)

== D 1 ==

......
...21.
..43.H
.5....
6.....  (6 covers 7, 8, 9, s)

== L 5 ==

......
...21.
..43H.
.5....
6.....  (6 covers 7, 8, 9, s)

......
...21.
..4H..  (H covers 3)
.5....
6.....  (6 covers 7, 8, 9, s)

......
...2..
..H1..  (H covers 4; 1 covers 3)
.5....
6.....  (6 covers 7, 8, 9, s)

......
...2..
.H13..  (1 covers 4)
.5....
6.....  (6 covers 7, 8, 9, s)

......
......
H123..  (2 covers 4)
.5....
6.....  (6 covers 7, 8, 9, s)

== R 2 ==

......
......
.H23..  (H covers 1; 2 covers 4)
.5....
6.....  (6 covers 7, 8, 9, s)

......
......
.1H3..  (H covers 2, 4)
.5....
6.....  (6 covers 7, 8, 9, s)

Now, you need to keep track of the positions the new tail, 9, visits. In this
example, the tail never moves, and so it only visits 1 position. However, be
careful: more types of motion are possible than before, so you might want to
visually compare your simulated rope to the one above.

Here's a larger example:

R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20

These motions occur as follows (individual steps are not shown):

== Initial State ==

..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
...........H..............  (H covers 1, 2, 3, 4, 5, 6, 7, 8, 9, s)
..........................
..........................
..........................
..........................
..........................

== R 5 ==

..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
...........54321H.........  (5 covers 6, 7, 8, 9, s)
..........................
..........................
..........................
..........................
..........................

== U 8 ==

..........................
..........................
..........................
..........................
..........................
..........................
..........................
................H.........
................1.........
................2.........
................3.........
...............54.........
..............6...........
.............7............
............8.............
...........9..............  (9 covers s)
..........................
..........................
..........................
..........................
..........................

== L 8 ==

..........................
..........................
..........................
..........................
..........................
..........................
..........................
........H1234.............
............5.............
............6.............
............7.............
............8.............
............9.............
..........................
..........................
...........s..............
..........................
..........................
..........................
..........................
..........................

== D 3 ==

..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
.........2345.............
........1...6.............
........H...7.............
............8.............
............9.............
..........................
..........................
...........s..............
..........................
..........................
..........................
..........................
..........................

== R 17 ==

..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
................987654321H
..........................
..........................
..........................
..........................
...........s..............
..........................
..........................
..........................
..........................
..........................

== D 10 ==

..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
...........s.........98765
.........................4
.........................3
.........................2
.........................1
.........................H

== L 25 ==

..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
...........s..............
..........................
..........................
..........................
..........................
H123456789................

== U 20 ==

H.........................
1.........................
2.........................
3.........................
4.........................
5.........................
6.........................
7.........................
8.........................
9.........................
..........................
..........................
..........................
..........................
..........................
...........s..............
..........................
..........................
..........................
..........................
..........................

Now, the tail (9) visits 36 positions (including s) at least once:

..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
#.........................
#.............###.........
#............#...#........
.#..........#.....#.......
..#..........#.....#......
...#........#.......#.....
....#......s.........#....
.....#..............#.....
......#............#......
.......#..........#.......
........#........#........
.........########.........

Simulate your complete series of motions on a larger rope with ten knots. How
many positions does the tail of the rope visit at least once?
=end pod

class Point {
  has $.x is required;
  has $.y is required;
  method kv { ($!x, $!y) }
  method WHICH { ValueObjAt.new("Point|($!x,$!y)") }
}

grammar Movements {
  token TOP { [ <up> | <down> | <left> | <right> ] }
  rule up { 'U' <num> }
  rule down { 'D' <num> }
  rule left { 'L' <num> }
  rule right { 'R' <num> }
  token num { \d+ }
}

class Moves {
  has @!knots = Point.new(x => 0, y => 0) xx 10;
  has SetHash $.visited .= new(@!knots[0]);
  method up ($/) { self!move-head: 0, -$<num> }
  method down ($/) { self!move-head: 0, +$<num> }
  method left ($/) { self!move-head: -$<num>, 0 }
  method right ($/) { self!move-head: +$<num>, 0 }
  method !move-head ($x, $y) {
    # say "== move $x,$y ==";
    my ($headx, $heady) = @!knots.head.kv;
    for ^$x.abs {
      $headx += $x.sign;
      self!move-tail: 1, $headx, $heady;
    }
    for ^$y.abs {
      $heady += $y.sign;
      self!move-tail: 1, $headx, $heady;
    }
    @!knots[0] = Point.new(x => $headx, y => $heady);
    # self!visualize;
  }
  method !move-tail ($idx, $headx, $heady) {
    my ($tailx, $taily) = @!knots[$idx].kv;
    my $diffx = $headx - $tailx;
    my $diffy = $heady - $taily;
    if $diffx.abs > 1 || $diffy.abs > 1 {
      if $diffx.abs > 1 {
        $tailx += $diffx.sign;
        $taily += $diffy.sign if $diffy.abs >= 1;
      } elsif $diffy.abs > 1 {
        $taily += $diffy.sign;
        $tailx += $diffx.sign if $diffx.abs >= 1;
      }
      @!knots[$idx] = Point.new(x => $tailx, y => $taily);
      if $idx == 9 {
        $.visited.set: @!knots[$idx];
      } else {
        self!move-tail: $idx + 1, $tailx, $taily;
      }
    }
  }
  method !visualize {
    my @xs = flat $!visited.keys.map(*.x), @!knots.map(*.x);
    my @ys = flat $!visited.keys.map(*.y), @!knots.map(*.y);
    my @xrange = @xs.minmax;
    my @yrange = @ys.minmax;
    for @yrange -> $y {
      for @xrange -> $x {
        my $point = Point.new(x => $x, y => $y);
        if @!knots[0] === $point {
          print 'H';
        } elsif @!knots.first($point, :k) -> $idx {
          print $idx == 0 ?? 'H' !! $idx;
        } elsif $.visited{$point} {
          print '#';
        } else {
          print '.';
        }
      }
      say '';
    }
    say '';
  }
}

my $actions = Moves.new;
for 'input.txt'.IO.lines -> $line {
  Movements.parse($line, actions => $actions);
}
say "The tail visited {$actions.visited.elems} positions.";
