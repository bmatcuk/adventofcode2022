#!/usr/bin/env raku

=begin pod
As you walk up the hill, you suspect that the Elves will want to turn this into
a hiking trail. The beginning isn't very scenic, though; perhaps you can find a
better starting point.

To maximize exercise while hiking, the trail should start as low as possible:
elevation a. The goal is still the square marked E. However, the trail should
still be direct, taking the fewest steps to reach its goal. So, you'll need to
find the shortest path from any square at elevation a to the square marked E.

Again consider the example from above:

Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi

Now, there are six choices for starting position (five marked a, plus the
square marked S that counts as being at elevation a). If you start at the
bottom-left square, you can reach the goal most quickly:

...v<<<<
...vv<<^
...v>E^^
.>v>>>^^
>^>>>>>^

This path reaches the goal in only 29 steps, the fewest possible.

What is the fewest steps required to move starting from any square with
elevation a to the location that should get the best signal?
=end pod

class Point {
  has $.x is required;
  has $.y is required;
  method kv { ($!x, $!y) }
  method WHICH { ValueObjAt.new("Point|($!x,$!y)") }
}

my @map = 'input.txt'.IO.lines.map(*.comb.list);
my @distances;

my @starts;
my Point $end;
for ^@map.elems -> $y {
  @starts.append: @map[$y].grep(/[a|S]/, :k).map({ Point.new(x => $_, y => $y) });
  if !$end && @map[$y].grep('E', :k) -> $x {
    $end = Point.new(x => $x[0], y => $y);
  }
}

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

my $minimum = 100000;
for @starts -> $start {
  @distances = @map.map({ (-1 xx $_.elems).Array });
  @distances[$start.y][$start.x] = 0;

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

  my $distance = @distances[$end.y][$end.x];
  $minimum = $distance if $distance != -1 && $distance < $minimum;
}

say "Minimum distance: $minimum";
