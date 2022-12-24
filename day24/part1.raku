#!/usr/bin/env raku

=begin pod
With everything replanted for next year (and with elephants and monkeys to tend
the grove), you and the Elves leave for the extraction point.

Partway up the mountain that shields the grove is a flat, open area that serves
as the extraction point. It's a bit of a climb, but nothing the expedition
can't handle.

At least, that would normally be true; now that the mountain is covered in
snow, things have become more difficult than the Elves are used to.

As the expedition reaches a valley that must be traversed to reach the
extraction site, you find that strong, turbulent winds are pushing small
blizzards of snow and sharp ice around the valley. It's a good thing everyone
packed warm clothes! To make it across safely, you'll need to find a way to
avoid them.

Fortunately, it's easy to see all of this from the entrance to the valley, so
you make a map of the valley and the blizzards (your puzzle input). For
example:

#.#####
#.....#
#>....#
#.....#
#...v.#
#.....#
#####.#

The walls of the valley are drawn as #; everything else is ground. Clear ground
- where there is currently no blizzard - is drawn as .. Otherwise, blizzards
are drawn with an arrow indicating their direction of motion: up (^), down (v),
left (<), or right (>).

The above map includes two blizzards, one moving right (>) and one moving down
(v). In one minute, each blizzard moves one position in the direction it is
pointing:

#.#####
#.....#
#.>...#
#.....#
#.....#
#...v.#
#####.#

Due to conservation of blizzard energy, as a blizzard reaches the wall of the
valley, a new blizzard forms on the opposite side of the valley moving in the
same direction. After another minute, the bottom downward-moving blizzard has
been replaced with a new downward-moving blizzard at the top of the valley
instead:

#.#####
#...v.#
#..>..#
#.....#
#.....#
#.....#
#####.#

Because blizzards are made of tiny snowflakes, they pass right through each
other. After another minute, both blizzards temporarily occupy the same
position, marked 2:

#.#####
#.....#
#...2.#
#.....#
#.....#
#.....#
#####.#

After another minute, the situation resolves itself, giving each blizzard back
its personal space:

#.#####
#.....#
#....>#
#...v.#
#.....#
#.....#
#####.#

Finally, after yet another minute, the rightward-facing blizzard on the right
is replaced with a new one on the left facing the same direction:

#.#####
#.....#
#>....#
#.....#
#...v.#
#.....#
#####.#

This process repeats at least as long as you are observing it, but probably
forever.

Here is a more complex example:

#.######
#>>.<^<#
#.<..<<#
#>v.><>#
#<^v^^>#
######.#

Your expedition begins in the only non-wall position in the top row and needs
to reach the only non-wall position in the bottom row. On each minute, you can
move up, down, left, or right, or you can wait in place. You and the blizzards
act simultaneously, and you cannot share a position with a blizzard.

In the above example, the fastest way to reach your goal requires 18 steps.
Drawing the position of the expedition as E, one way to achieve this is:

(Redacted because Pod didn't like it)

What is the fewest number of minutes required to avoid the blizzards and reach
the goal?
=end pod

class State {
  has Int $.x is required;
  has Int $.y is required;
  has Int $.t is required;
  method new (Int $x, Int $y, Int $t) {
    self.bless(:$x, :$y, :$t)
  }
  method cache-key ($full-cycle) {
    "$!x,$!y,{$!t % $full-cycle}"
  }
}

class Map {
  has @!map is required;
  has $!endx is required;
  has $!endy is required;
  has $!width is required;
  has $!height is required;
  method new {
    my @map = 'input.txt'.IO.lines.map(*.comb.list);
    my $endy = @map.elems - 1;
    my $endx = @map[$endy].first('.', :k);
    my $width = @map[0].elems - 2;
    my $height = @map.elems - 2;
    self.bless(:@map, :$endx, :$endy, :$width, :$height);
  }
  submethod BUILD (:@!map, :$!endx, :$!endy, :$!width, :$!height) {}
  method start { (@!map[0].first('.', :k), 0) }
  method full-cycle { $!width lcm $!height }
  method possible-moves ($x, $y) {
    gather {
      take ($x, $y - 1) unless $y == 0 || @!map[$y-1][$x] eq '#';
      take ($x, $y + 1) unless @!map[$y+1][$x] eq '#';
      take ($x - 1, $y) unless @!map[$y][$x-1] eq '#';
      take ($x + 1, $y) unless @!map[$y][$x+1] eq '#';
    }
  }
  method is-end ($x, $y) { $x == $!endx && $y == $!endy }
  method is-safe-at ($x, $y, $t) {
    return True if $y == 0;

    my $horzt = $t % $!width;
    return False if @!map[$y][($x - 1 - $horzt) % $!width + 1] eq '>';
    return False if @!map[$y][($x - 1 + $horzt) % $!width + 1] eq '<';

    my $vertt = $t % $!height;
    return False if @!map[($y - 1 - $vertt) % $!height + 1][$x] eq 'v';
    return False if @!map[($y - 1 + $vertt) % $!height + 1][$x] eq '^';

    return True;
  }
}

my Map $map .= new;
my $full-cycle = $map.full-cycle;
my @queue of State = [State.new(|$map.start, 0)];
my SetHash[Str] $seen .= new;
my $endt = 0;
MAINLOOP: while @queue.shift -> $state {
  my $cache-key = $state.cache-key($full-cycle);
  next if $seen{$cache-key};
  $seen.set($cache-key);

  my $nextt = $state.t + 1;
  for $map.possible-moves($state.x, $state.y) -> ($x, $y) {
    if $map.is-end($x, $y) {
      $endt = $nextt;
      last MAINLOOP;
    }
    @queue.push(State.new($x, $y, $nextt)) if $map.is-safe-at($x, $y, $nextt);
  }
  @queue.push($state.clone(t => $nextt)) if $map.is-safe-at($state.x, $state.y, $nextt);
}

say "End reached after $endt minutes";
