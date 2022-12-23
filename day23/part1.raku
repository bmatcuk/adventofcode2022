#!/usr/bin/env raku

=begin pod
You enter a large crater of gray dirt where the grove is supposed to be. All
around you, plants you imagine were expected to be full of fruit are instead
withered and broken. A large group of Elves has formed in the middle of the
grove.

"...but this volcano has been dormant for months. Without ash, the fruit can't
grow!"

You look up to see a massive, snow-capped mountain towering above you.

"It's not like there are other active volcanoes here; we've looked everywhere."

"But our scanners show active magma flows; clearly it's going somewhere."

They finally notice you at the edge of the grove, your pack almost overflowing
from the random star fruit you've been collecting. Behind you, elephants and
monkeys explore the grove, looking concerned. Then, the Elves recognize the ash
cloud slowly spreading above your recent detour.

"Why do you--" "How is--" "Did you just--"

Before any of them can form a complete question, another Elf speaks up: "Okay,
new plan. We have almost enough fruit already, and ash from the plume should
spread here eventually. If we quickly plant new seedlings now, we can still
make it to the extraction point. Spread out!"

The Elves each reach into their pack and pull out a tiny plant. The plants rely
on important nutrients from the ash, so they can't be planted too close
together.

There isn't enough time to let the Elves figure out where to plant the
seedlings themselves; you quickly scan the grove (your puzzle input) and note
their positions.

For example:

....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#..

The scan shows Elves # and empty ground .; outside your scan, more empty ground
extends a long way in every direction. The scan is oriented so that north is
up; orthogonal directions are written N (north), S (south), W (west), and E
(east), while diagonal directions are written NE, NW, SE, SW.

The Elves follow a time-consuming process to figure out where they should each
go; you can speed up this process considerably. The process consists of some
number of rounds during which Elves alternate between considering where to move
and actually moving.

During the first half of each round, each Elf considers the eight positions
adjacent to themself. If no other Elves are in one of those eight positions,
the Elf does not do anything during this round. Otherwise, the Elf looks in
each of four directions in the following order and proposes moving one step in
the first valid direction:

=item If there is no Elf in the N, NE, or NW adjacent positions, the Elf
  proposes moving north one step.
=item If there is no Elf in the S, SE, or SW adjacent positions, the Elf
  proposes moving south one step.
=item If there is no Elf in the W, NW, or SW adjacent positions, the Elf
  proposes moving west one step.
=item If there is no Elf in the E, NE, or SE adjacent positions, the Elf
  proposes moving east one step.

After each Elf has had a chance to propose a move, the second half of the round
can begin. Simultaneously, each Elf moves to their proposed destination tile if
they were the only Elf to propose moving to that position. If two or more Elves
propose moving to the same position, none of those Elves move.

Finally, at the end of the round, the first direction the Elves considered is
moved to the end of the list of directions. For example, during the second
round, the Elves would try proposing a move to the south first, then west, then
east, then north. On the third round, the Elves would first consider west, then
east, then north, then south.

As a smaller example, consider just these five Elves:

.....
..##.
..#..
.....
..##.
.....

The northernmost two Elves and southernmost two Elves all propose moving north,
while the middle Elf cannot move north and proposes moving south. The middle
Elf proposes the same destination as the southwest Elf, so neither of them
move, but the other three do:

..##.
.....
..#..
...#.
..#..
.....

Next, the northernmost two Elves and the southernmost Elf all propose moving
south. Of the remaining middle two Elves, the west one cannot move south and
proposes moving west, while the east one cannot move south or west and proposes
moving east. All five Elves succeed in moving to their proposed positions:

.....
..##.
.#...
....#
.....
..#..

Finally, the southernmost two Elves choose not to move at all. Of the remaining
three Elves, the west one proposes moving west, the east one proposes moving
east, and the middle one proposes moving north; all three succeed in moving:

..#..
....#
#....
....#
.....
..#..

At this point, no Elves need to move, and so the process ends.

The larger example above proceeds as follows:

== Initial State ==
..............
..............
.......#......
.....###.#....
...#...#.#....
....#...##....
...#.###......
...##.#.##....
....#..#......
..............
..............
..............

== End of Round 1 ==
..............
.......#......
.....#...#....
...#..#.#.....
.......#..#...
....#.#.##....
..#..#.#......
..#.#.#.##....
..............
....#..#......
..............
..............

== End of Round 2 ==
..............
.......#......
....#.....#...
...#..#.#.....
.......#...#..
...#..#.#.....
.#...#.#.#....
..............
..#.#.#.##....
....#..#......
..............
..............

== End of Round 3 ==
..............
.......#......
.....#....#...
..#..#...#....
.......#...#..
...#..#.#.....
.#..#.....#...
.......##.....
..##.#....#...
...#..........
.......#......
..............

== End of Round 4 ==
..............
.......#......
......#....#..
..#...##......
...#.....#.#..
.........#....
.#...###..#...
..#......#....
....##....#...
....#.........
.......#......
..............

== End of Round 5 ==
.......#......
..............
..#..#.....#..
.........#....
......##...#..
.#.#.####.....
...........#..
....##..#.....
..#...........
..........#...
....#..#......
..............
After a few more rounds...

== End of Round 10 ==
.......#......
...........#..
..#.#..#......
......#.......
...#.....#..#.
.#......##....
.....##.......
..#........#..
....#.#..#....
..............
....#..#..#...
..............

To make sure they're on the right track, the Elves like to check after round 10
that they're making good progress toward covering enough ground. To do this,
count the number of empty ground tiles contained by the smallest rectangle that
contains every Elf. (The edges of the rectangle should be aligned to the
N/S/E/W directions; the Elves do not have the patience to calculate arbitrary
rectangles.) In the above example, that rectangle is:

......#.....
..........#.
.#.#..#.....
.....#......
..#.....#..#
#......##...
....##......
.#........#.
...#.#..#...
............
...#..#..#..

In this region, the number of empty ground tiles is 110.

Simulate the Elves' process and find the smallest rectangle that contains the
Elves after 10 rounds. How many empty ground tiles does that rectangle contain?
=end pod

constant $rounds = 10;

enum Direction <North South West East>;
constant @directions = [North, South, West, East, North, South, West];

class Point {
  has Int $.x is required;
  has Int $.y is required;
  method new(Int $x, Int $y) { self.bless(:$x, :$y) }
  method WHICH { ValueObjAt.new("Point($!x,$!y)") }
  method nw { Point.new($!x - 1, $!y - 1) }
  method n { Point.new($!x, $!y - 1) }
  method ne { Point.new($!x + 1, $!y - 1) }
  method w { Point.new($!x - 1, $!y) }
  method e { Point.new($!x + 1, $!y) }
  method sw { Point.new($!x - 1, $!y + 1) }
  method s { Point.new($!x, $!y + 1) }
  method se { Point.new($!x + 1, $!y + 1) }
}

my $elves = SetHash[Point].new;
for 'input.txt'.IO.lines.kv -> $y, $line {
  for $line.comb.kv -> $x, $char {
    if $char eq '#' {
      $elves.set(Point.new($x, $y));
    }
  }
}

my Direction $first-direction = North;
for ^$rounds -> $round {
  my Array %considered-moves{Point};
  say "Round $round";
  for $elves.keys -> $elf {
    my @neighbors = [
      $elves{$elf.nw},
      $elves{$elf.n},
      $elves{$elf.ne},
      $elves{$elf.w},
      $elves{$elf.e},
      $elves{$elf.sw},
      $elves{$elf.s},
      $elves{$elf.se},
    ];
    if any @neighbors {
      my Point $move = Nil;
      for @directions[$first-direction..($first-direction+3)] -> $direction {
        given $direction {
          when North {
            if none @neighbors[^3] {
              $move = $elf.n;
              last;
            }
          }
          when South {
            if none @neighbors[5..7] {
              $move = $elf.s;
              last;
            }
          }
          when West {
            if none @neighbors[(0, 3, 5)] {
              $move = $elf.w;
              last;
            }
          }
          when East {
            if none @neighbors[(2, 4, 7)] {
              $move = $elf.e;
              last;
            }
          }
        }
      }
      if $move ~~ Point:D {
        if %considered-moves{$move}:exists {
          %considered-moves{$move}.push: $elf;
        } else {
          %considered-moves{$move} = [$elf];
        }
      }
    }
  }

  for %considered-moves.kv -> $move-to, @move-from {
    next if @move-from.elems != 1;
    $elves.unset(@move-from[0]);
    $elves.set($move-to);
  }

  $first-direction = @directions[$first-direction + 1];
}

my $xrange = $elves.keys.map(*.x).minmax;
my $yrange = $elves.keys.map(*.y).minmax;
my $empty = $xrange.elems * $yrange.elems - $elves.elems;
say "Empty spaces: $empty";
