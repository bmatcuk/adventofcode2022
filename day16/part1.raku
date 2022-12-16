#!/usr/bin/env raku

=begin pod
The sensors have led you to the origin of the distress signal: yet another
handheld device, just like the one the Elves gave you. However, you don't see
any Elves around; instead, the device is surrounded by elephants! They must
have gotten lost in these tunnels, and one of the elephants apparently figured
out how to turn on the distress signal.

The ground rumbles again, much stronger this time. What kind of cave is this,
exactly? You scan the cave with your handheld device; it reports mostly igneous
rock, some ash, pockets of pressurized gas, magma... this isn't just a cave,
it's a volcano!

You need to get the elephants out of here, quickly. Your device estimates that
you have 30 minutes before the volcano erupts, so you don't have time to go
back out the way you came in.

You scan the cave for other options and discover a network of pipes and
pressure-release valves. You aren't sure how such a system got into a volcano,
but you don't have time to complain; your device produces a report (your puzzle
input) of each valve's flow rate if it were opened (in pressure per minute) and
the tunnels you could use to move between the valves.

There's even a valve in the room you and the elephants are currently standing
in labeled AA. You estimate it will take you one minute to open a single valve
and one minute to follow any tunnel from one valve to another. What is the most
pressure you could release?

For example, suppose you had the following scan output:

Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II

All of the valves begin closed. You start at valve AA, but it must be damaged
or jammed or something: its flow rate is 0, so there's no point in opening it.
However, you could spend one minute moving to valve BB and another minute
opening it; doing so would release pressure during the remaining 28 minutes at
a flow rate of 13, a total eventual pressure release of 28 * 13 = 364. Then,
you could spend your third minute moving to valve CC and your fourth minute
opening it, providing an additional 26 minutes of eventual pressure release at
a flow rate of 2, or 52 total pressure released by valve CC.

Making your way through the tunnels like this, you could probably open many or
all of the valves by the time 30 minutes have elapsed. However, you need to
release as much pressure as possible, so you'll need to be methodical. Instead,
consider this approach:

== Minute 1 ==
No valves are open.
You move to valve DD.

== Minute 2 ==
No valves are open.
You open valve DD.

== Minute 3 ==
Valve DD is open, releasing 20 pressure.
You move to valve CC.

== Minute 4 ==
Valve DD is open, releasing 20 pressure.
You move to valve BB.

== Minute 5 ==
Valve DD is open, releasing 20 pressure.
You open valve BB.

== Minute 6 ==
Valves BB and DD are open, releasing 33 pressure.
You move to valve AA.

== Minute 7 ==
Valves BB and DD are open, releasing 33 pressure.
You move to valve II.

== Minute 8 ==
Valves BB and DD are open, releasing 33 pressure.
You move to valve JJ.

== Minute 9 ==
Valves BB and DD are open, releasing 33 pressure.
You open valve JJ.

== Minute 10 ==
Valves BB, DD, and JJ are open, releasing 54 pressure.
You move to valve II.

== Minute 11 ==
Valves BB, DD, and JJ are open, releasing 54 pressure.
You move to valve AA.

== Minute 12 ==
Valves BB, DD, and JJ are open, releasing 54 pressure.
You move to valve DD.

== Minute 13 ==
Valves BB, DD, and JJ are open, releasing 54 pressure.
You move to valve EE.

== Minute 14 ==
Valves BB, DD, and JJ are open, releasing 54 pressure.
You move to valve FF.

== Minute 15 ==
Valves BB, DD, and JJ are open, releasing 54 pressure.
You move to valve GG.

== Minute 16 ==
Valves BB, DD, and JJ are open, releasing 54 pressure.
You move to valve HH.

== Minute 17 ==
Valves BB, DD, and JJ are open, releasing 54 pressure.
You open valve HH.

== Minute 18 ==
Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
You move to valve GG.

== Minute 19 ==
Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
You move to valve FF.

== Minute 20 ==
Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
You move to valve EE.

== Minute 21 ==
Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
You open valve EE.

== Minute 22 ==
Valves BB, DD, EE, HH, and JJ are open, releasing 79 pressure.
You move to valve DD.

== Minute 23 ==
Valves BB, DD, EE, HH, and JJ are open, releasing 79 pressure.
You move to valve CC.

== Minute 24 ==
Valves BB, DD, EE, HH, and JJ are open, releasing 79 pressure.
You open valve CC.

== Minute 25 ==
Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

== Minute 26 ==
Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

== Minute 27 ==
Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

== Minute 28 ==
Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

== Minute 29 ==
Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

== Minute 30 ==
Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

This approach lets you release the most pressure possible in 30 minutes with
this valve layout, 1651.

Work out the steps to release the most pressure in 30 minutes. What is the most
pressure you can release?
=end pod

constant $max-minutes = 30;

grammar Input {
  rule TOP {
    'Valve'
    <identifier>
    'has flow rate='
    <num>
    ';'
    <tunnels>
  }
  token identifier { <upper> ** 2 }
  token num { \d+ }
  token tunnels {
    'tunnel leads to valve ' <identifier>
    || 'tunnels lead to valves ' <identifier> [ ', ' <identifier> ]*
  }
}

class Valve {
  has $.label is required;
  has $.flow-rate is required;
  has @.neighbors is required;
  method TOP (::?CLASS:U $klass: $/) {
    make $klass.new(
      label => $<identifier>.made,
      flow-rate => $<num>.made,
      neighbors => $<tunnels>.made
    )
  }
  method identifier (::?CLASS:U: $/) { make ~$/; }
  method num (::?CLASS:U: $/) { make +$/; }
  method tunnels (::?CLASS:U: $/) { make $<identifier>.map(*.made) }
}

# load data
my %valves = 'input.txt'.IO.lines
  .map({ Input.parse($_, actions => Valve).made })
  .map({ $_.label => $_ })
  .Map;

# Floyd-Warshall to find all of the shortest paths between nodes
# 42000000 is an arbitrarily large number
my @distances[%valves.elems; %valves.elems] = (42000000 xx %valves.elems) xx %valves.elems;
my %valve-to-idx = %valves.keys.kv.map({ $^b => $^a }).Map;
for %valves.values -> $valve {
  my $idx = %valve-to-idx{$valve.label};
  @distances[$idx;$idx] = 0;
  for $valve.neighbors -> $neighbor {
    my $neighbor-idx = %valve-to-idx{$neighbor};
    @distances[$idx;$neighbor-idx] = 1;
  }
}

for ^%valves.elems -> $k {
  for ^%valves.elems -> $i {
    for ^%valves.elems -> $j {
      if @distances[$i;$j] > @distances[$i;$k] + @distances[$k;$j] {
        @distances[$i;$j] = @distances[$i;$k] + @distances[$k;$j];
      }
    }
  }
}

# "Create" a new graph of only the nodes that have a flow rate greater than
# 0... they're the only nodes we care about. The edge weights will be the
# shortest distances we calculated with Floyd-Warshall above. I don't actually
# need to create a graph, though... I just need the labels of the nodes I care
# about and I can get all of the information I need from the previous data
# structures since the new graph will be fully connected.
my @labels-with-flow = %valves.values.grep(*.flow-rate > 0).map(*.label);

# Now we'll do a DFS to find the best path to maximum flow rate
sub walk ($current, $time, %closed) {
  my $current-idx = %valve-to-idx{$current};
  my $max-pressure = 0;
  if $time < $max-minutes {
    for %closed.keys -> $neighbor {
      my $neighbor-idx = %valve-to-idx{$neighbor};
      my $new-time = $time + @distances[$current-idx;$neighbor-idx] + 1;
      if $new-time < $max-minutes {
        my $pressure = %valves{$neighbor}.flow-rate * ($max-minutes - $new-time);
        $pressure += walk($neighbor, $new-time, %closed (-) $neighbor);
        $max-pressure = $pressure if $pressure > $max-pressure;
      }
    }
  }
  return $max-pressure;
}

my $max-pressure = walk('AA', 0, @labels-with-flow.Set);
say "Maximum pressure released: $max-pressure";
