#!/usr/bin/env raku

=begin pod
You try contacting the Elves using your handheld device, but the river you're
following must be too low to get a decent signal.

You ask the device for a heightmap of the surrounding area (your puzzle input).
The heightmap shows the local area from above broken into a grid; the elevation
of each square of the grid is given by a single lowercase letter, where a is
the lowest elevation, b is the next-lowest, and so on up to the highest
elevation, z.

Also included on the heightmap are marks for your current position (S) and the
location that should get the best signal (E). Your current position (S) has
elevation a, and the location that should get the best signal (E) has elevation
z.

You'd like to reach E, but to save energy, you should do it in as few steps as
possible. During each step, you can move exactly one square up, down, left, or
right. To avoid needing to get out your climbing gear, the elevation of the
destination square can be at most one higher than the elevation of your current
square; that is, if your current elevation is m, you could step to elevation n,
but not to elevation o. (This also means that the elevation of the destination
square can be much lower than the elevation of your current square.)

For example:

Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi

Here, you start in the top-left corner; your goal is near the middle. You could
start by moving down or right, but eventually you'll need to head toward the e
at the bottom. From there, you can spiral around to the goal:

v..v<<<<
>v.vv<<^
.>vv>E^^
..v>>>^^
..>>>>>^

In the above diagram, the symbols indicate whether the path exits each square
moving up (^), down (v), left (<), or right (>). The location that should get
the best signal is still E, and . marks unvisited squares.

This path reaches the goal in 31 steps, the fewest possible.

What is the fewest steps required to move from your current position to the
location that should get the best signal?
=end pod

class Point {
  has $.x is required;
  has $.y is required;
  method kv { ($!x, $!y) }
  method WHICH { ValueObjAt.new("Point|($!x,$!y)") }
}

my @map = 'input.txt'.IO.lines.map(*.comb.list);

my Point $start;
my Point $end;
for ^@map.elems -> $y {
  if !$start && @map[$y].grep('S', :k) -> $x {
    $start = Point.new(x => $x[0], y => $y);
  }
  if !$end && @map[$y].grep('E', :k) -> $x {
    $end = Point.new(x => $x[0], y => $y);
  }
  last if $start && $end;
}

my @distances = @map.map({ (-1 xx $_.elems).Array });
@distances[$start.y][$start.x] = 0;

sub get-height ($x, $y) {
  my $height = @map[$y][$x];
  if $height eq 'S' {
    $height = 'a';
  } elsif $height eq 'E' {
    $height = 'z';
  }
  return $height;
}

sub valid-move ($x, $y, $from-height) {
  $y >= 0 && $y < @map.elems
    && $x >= 0 && $x < @map[$y].elems
    && get-height($x, $y).ord <= ($from-height.ord + 1)
    && @distances[$y][$x] == -1;
}

sub adjacent ($x, $y) {
  my $height = get-height($x, $y);
  gather {
    take Point.new(x => $x + 1, y => $y) if valid-move($x + 1, $y, $height);
    take Point.new(x => $x, y => $y + 1) if valid-move($x, $y + 1, $height);
    take Point.new(x => $x - 1, y => $y) if valid-move($x - 1, $y, $height);
    take Point.new(x => $x, y => $y - 1) if valid-move($x, $y - 1, $height);
  }
}

# Think of the map as a graph where each node connects to (most) of its
# neighbors in the cardinal directions. The edge weights of this graph are all
# the same, so, Dijkstra's essentially becomes a breadth-first search.
my @queue = [$start];
QUEUE: while @queue.shift -> $point {
  my ($x, $y) = $point.kv;
  my $next-distance = @distances[$y][$x] + 1;
  for adjacent($x, $y) -> $loc {
    @distances[$loc.y][$loc.x] = $next-distance;
    last QUEUE if $loc === $end;
    @queue.push($loc);
  }
}

say "Minimum distance: {@distances[$end.y][$end.x]}";
