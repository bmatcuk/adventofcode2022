#!/usr/bin/env raku

=begin pod
You're worried that even with an optimal approach, the pressure released won't
be enough. What if you got one of the elephants to help you?

It would take you 4 minutes to teach an elephant how to open the right valves
in the right order, leaving you with only 26 minutes to actually execute your
plan. Would having two of you working together be better, even if it means
having less time? (Assume that you teach the elephant before opening any valves
yourself, giving you both the same full 26 minutes.)

In the example above, you could teach the elephant to help you as follows:

== Minute 1 ==
No valves are open.
You move to valve II.
The elephant moves to valve DD.

== Minute 2 ==
No valves are open.
You move to valve JJ.
The elephant opens valve DD.

== Minute 3 ==
Valve DD is open, releasing 20 pressure.
You open valve JJ.
The elephant moves to valve EE.

== Minute 4 ==
Valves DD and JJ are open, releasing 41 pressure.
You move to valve II.
The elephant moves to valve FF.

== Minute 5 ==
Valves DD and JJ are open, releasing 41 pressure.
You move to valve AA.
The elephant moves to valve GG.

== Minute 6 ==
Valves DD and JJ are open, releasing 41 pressure.
You move to valve BB.
The elephant moves to valve HH.

== Minute 7 ==
Valves DD and JJ are open, releasing 41 pressure.
You open valve BB.
The elephant opens valve HH.

== Minute 8 ==
Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
You move to valve CC.
The elephant moves to valve GG.

== Minute 9 ==
Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
You open valve CC.
The elephant moves to valve FF.

== Minute 10 ==
Valves BB, CC, DD, HH, and JJ are open, releasing 78 pressure.
The elephant moves to valve EE.

== Minute 11 ==
Valves BB, CC, DD, HH, and JJ are open, releasing 78 pressure.
The elephant opens valve EE.

(At this point, all valves are open.)

== Minute 12 ==
Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

...

== Minute 20 ==
Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

...

== Minute 26 ==
Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

With the elephant helping, after 26 minutes, the best you could do would
release a total of 1707 pressure.

With you and an elephant working together for 26 minutes, what is the most
pressure you could release?
=end pod

constant $max-minutes = 26;

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
my $labels-with-flow-set = @labels-with-flow.Set;

class FinalState {
  has $.opened is required;
  has $.pressure is required;
}

# DFS to find the best path to maximum flow rate - this time, we'll store the
# final state of each path
my @final-states of FinalState;
sub walk ($current, $time, $pressure, $closed) {
  my $current-idx = %valve-to-idx{$current};
  my $has-out-of-time = $closed.elems == 0;
  my $has-possible-paths = False;
  for $closed.keys -> $neighbor {
    my $neighbor-idx = %valve-to-idx{$neighbor};
    my $new-time = $time + @distances[$current-idx;$neighbor-idx] + 1;
    if $new-time < $max-minutes {
      my $path-pressure = $pressure + %valves{$neighbor}.flow-rate * ($max-minutes - $new-time);
      walk($neighbor, $new-time, $path-pressure, $closed (-) $neighbor);
      $has-possible-paths = True;
    } else {
      $has-out-of-time = True;
    }
  }
  if $has-out-of-time && !$has-possible-paths {
    @final-states.push: FinalState.new(
      opened => $labels-with-flow-set (-) $closed,
      pressure => $pressure
    );
  }
}

# Now that we have help, we'll calculate all of the paths through the nodes
# that we care about in the given time and then find the best two paths that
# don't overlap.
#
# This algo took, like, an hour to run =( But it got the answer so I don't care
my $max-pressure = 0;
walk('AA', 0, 0, $labels-with-flow-set);
for ^(@final-states.elems - 1) -> $i {
  for $i^..^@final-states.elems -> $j {
    unless @final-states[$i].opened (&) @final-states[$j].opened {
      my $pressure = @final-states[$i].pressure + @final-states[$j].pressure;
      $max-pressure = $pressure if $pressure > $max-pressure;
    }
  }
}

say "Maximum pressure released: $max-pressure";
