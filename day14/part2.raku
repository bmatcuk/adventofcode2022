#!/usr/bin/env raku

=begin pod
You realize you misread the scan. There isn't an endless void at the bottom of
the scan - there's floor, and you're standing on it!

You don't have time to scan the floor, so assume the floor is an infinite
horizontal line with a y coordinate equal to two plus the highest y coordinate
of any point in your scan.

In the example above, the highest y coordinate of any point is 9, and so the
floor is at y=11. (This is as if your scan contained one extra rock path like
-infinity,11 -> infinity,11.) With the added floor, the example above now looks
like this:

        ...........+........
        ....................
        ....................
        ....................
        .........#...##.....
        .........#...#......
        .......###...#......
        .............#......
        .............#......
        .....#########......
        ....................
<-- etc #################### etc -->

To find somewhere safe to stand, you'll need to simulate falling sand until a
unit of sand comes to rest at 500,0, blocking the source entirely and stopping
the flow of sand into the cave. In the example above, the situation finally
looks like this after 93 units of sand come to rest:

............o............
...........ooo...........
..........ooooo..........
.........ooooooo.........
........oo#ooo##o........
.......ooo#ooo#ooo.......
......oo###ooo#oooo......
.....oooo.oooo#ooooo.....
....oooooooooo#oooooo....
...ooo#########ooooooo...
..ooooo.......ooooooooo..
#########################

Using your scan, simulate the falling sand until the source of the sand becomes
blocked. How many units of sand come to rest?
=end pod

class Point {
  has $.x is required;
  has $.y is required;
  method kv { ($!x, $!y) }
  method WHICH { ValueObjAt.new("Point|($!x,$!y)") }
}

grammar Line {
  rule TOP { <point> [ '->' <point> ]+ }
  token point { $<x>=<num> ',' $<y>=<num> }
  token num { \d+ }
}

class LineBuilder {
  method TOP ($/) { make $<point>.map(*.made).list }
  method point ($/) { make Point.new(x => $<x>.made, y => $<y>.made) }
  method num ($/) { make +$/ }
}

# load input - pad out x
my @lines = 'input.txt'.IO.lines.map({ Line.parse($_, actions => LineBuilder).made }).list;
my $ymax = @lines.map({ $_.map(*.y) }).flat.max + 2;
my $yrange = 0..$ymax;
my $xrange = 0..1000;

my $xadj = $xrange.min;
$xrange -= $xadj;

# build map
my @map[$yrange.max + 1; $xrange.max + 1] = ('.' xx ($xrange.max + 1)) xx ($yrange.max + 1);
for @lines -> @line {
  my $prev-point = @line.first;
  for @line.skip -> $point {
    for ($point.y, $prev-point.y).minmax -> $y {
      @map[$y; $_] = '#' for ($point.x, $prev-point.x).minmax - $xadj;
    }
    $prev-point = $point;
  }
}
@map[$yrange.max; $_] = '#' for ^$xrange.max;

# simulate
my $emitter = 500 - $xadj;
my $sand = 0;
SAND: loop {
  my $x = $emitter;
  my $y = 0;
  last if @map[$y; $x] ne '.';
  loop {
    if @map[$y; $x] ne '.' {
      # can't fall straight down
      if @map[$y; $x - 1] eq '.' {
        # fall to the left
        $x--;
      } else {
        if @map[$y; $x + 1] eq '.' {
          # fall to the right
          $x++;
        } else {
          # we've come to rest
          @map[$y - 1; $x] = 'o';
          $sand++;
          last;
        }
      }
    }
    $y++;
  }
}

say "$sand units of sand have come to rest.";
