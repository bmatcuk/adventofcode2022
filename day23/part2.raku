#!/usr/bin/env raku

=begin pod
It seems you're on the right track. Finish simulating the process and figure
out where the Elves need to go. How many rounds did you save them?

In the example above, the first round where no Elf moved was round 20:

.......#......
....#......#..
..#.....#.....
......#.......
...#....#.#..#
#.............
....#.....#...
..#.....#.....
....#.#....#..
.........#....
....#......#..
.......#......

Figure out where the Elves need to go. What is the number of the first round
where no Elf moves?
=end pod

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

# I really thought the performance of this algo was going to be terrible, but
# it surprised me. Each round takes maybe a quarter of a second, which isn't
# great, but it arrived at an answer in a few minutes. I'll take it!
my Direction $first-direction = North;
my $round = 1;
loop {
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

  last if %considered-moves.elems == 0;
  for %considered-moves.kv -> $move-to, @move-from {
    next if @move-from.elems != 1;
    $elves.unset(@move-from[0]);
    $elves.set($move-to);
  }

  $first-direction = @directions[$first-direction + 1];
  $round++;
}

say "Steady state found in round $round";
