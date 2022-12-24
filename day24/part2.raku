#!/usr/bin/env raku

=begin pod
As the expedition reaches the far side of the valley, one of the Elves looks
especially dismayed:

He forgot his snacks at the entrance to the valley!

Since you're so good at dodging blizzards, the Elves humbly request that you go
back for his snacks. From the same initial conditions, how quickly can you make
it from the start to the goal, then back to the start, then back to the goal?

In the above example, the first trip to the goal takes 18 minutes, the trip
back to the start takes 23 minutes, and the trip back to the goal again takes
13 minutes, for a total time of 54 minutes.

What is the fewest number of minutes required to reach the goal, go back to the
start, then reach the goal again?
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
  has $!startx is required;
  has $!starty is required;
  has $!endx is required;
  has $!endy is required;
  has $!width is required;
  has $!height is required;
  method new {
    my @map = 'input.txt'.IO.lines.map(*.comb.list);
    my $startx = @map[0].first('.', :k);
    my $starty = 0;
    my $endy = @map.elems - 1;
    my $endx = @map[$endy].first('.', :k);
    my $width = @map[0].elems - 2;
    my $height = @map.elems - 2;
    self.bless(:@map, :$startx, :$starty, :$endx, :$endy, :$width, :$height);
  }
  submethod BUILD (:@!map, :$!startx, :$!starty, :$!endx, :$!endy, :$!width, :$!height) {}
  method start { ($!startx, $!starty) }
  method swap-start-end {
    ($!startx, $!endx) = ($!endx, $!startx);
    ($!starty, $!endy) = ($!endy, $!starty);
  }
  method full-cycle { $!width lcm $!height }
  method possible-moves ($x, $y) {
    gather {
      take ($x, $y - 1) unless $y == 0 || @!map[$y-1][$x] eq '#';
      take ($x, $y + 1) unless $y == (@!map.elems - 1) || @!map[$y+1][$x] eq '#';
      take ($x - 1, $y) unless @!map[$y][$x-1] eq '#';
      take ($x + 1, $y) unless @!map[$y][$x+1] eq '#';
    }
  }
  method is-end ($x, $y) { $x == $!endx && $y == $!endy }
  method is-safe-at ($x, $y, $t) {
    return True if $y == 0 || $y == (@!map.elems - 1);

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
my $endt = 0;
for ^3 {
  my @queue of State = [State.new(|$map.start, $endt)];
  my SetHash[Str] $seen .= new;
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
  $map.swap-start-end;
}

say "End reached after $endt minutes";
