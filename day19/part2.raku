#!/usr/bin/env raku

=begin pod
While you were choosing the best blueprint, the elephants found some food on
their own, so you're not in as much of a hurry; you figure you probably have 32
minutes before the wind changes direction again and you'll need to get out of
range of the erupting volcano.

Unfortunately, one of the elephants ate most of your blueprint list! Now, only
the first three blueprints in your list are intact.

In 32 minutes, the largest number of geodes blueprint 1 (from the example
above) can open is 56. One way to achieve that is:

== Minute 1 ==
1 ore-collecting robot collects 1 ore; you now have 1 ore.

== Minute 2 ==
1 ore-collecting robot collects 1 ore; you now have 2 ore.

== Minute 3 ==
1 ore-collecting robot collects 1 ore; you now have 3 ore.

== Minute 4 ==
1 ore-collecting robot collects 1 ore; you now have 4 ore.

== Minute 5 ==
Spend 4 ore to start building an ore-collecting robot.
1 ore-collecting robot collects 1 ore; you now have 1 ore.
The new ore-collecting robot is ready; you now have 2 of them.

== Minute 6 ==
2 ore-collecting robots collect 2 ore; you now have 3 ore.

== Minute 7 ==
Spend 2 ore to start building a clay-collecting robot.
2 ore-collecting robots collect 2 ore; you now have 3 ore.
The new clay-collecting robot is ready; you now have 1 of them.

== Minute 8 ==
Spend 2 ore to start building a clay-collecting robot.
2 ore-collecting robots collect 2 ore; you now have 3 ore.
1 clay-collecting robot collects 1 clay; you now have 1 clay.
The new clay-collecting robot is ready; you now have 2 of them.

== Minute 9 ==
Spend 2 ore to start building a clay-collecting robot.
2 ore-collecting robots collect 2 ore; you now have 3 ore.
2 clay-collecting robots collect 2 clay; you now have 3 clay.
The new clay-collecting robot is ready; you now have 3 of them.

== Minute 10 ==
Spend 2 ore to start building a clay-collecting robot.
2 ore-collecting robots collect 2 ore; you now have 3 ore.
3 clay-collecting robots collect 3 clay; you now have 6 clay.
The new clay-collecting robot is ready; you now have 4 of them.

== Minute 11 ==
Spend 2 ore to start building a clay-collecting robot.
2 ore-collecting robots collect 2 ore; you now have 3 ore.
4 clay-collecting robots collect 4 clay; you now have 10 clay.
The new clay-collecting robot is ready; you now have 5 of them.

== Minute 12 ==
Spend 2 ore to start building a clay-collecting robot.
2 ore-collecting robots collect 2 ore; you now have 3 ore.
5 clay-collecting robots collect 5 clay; you now have 15 clay.
The new clay-collecting robot is ready; you now have 6 of them.

== Minute 13 ==
Spend 2 ore to start building a clay-collecting robot.
2 ore-collecting robots collect 2 ore; you now have 3 ore.
6 clay-collecting robots collect 6 clay; you now have 21 clay.
The new clay-collecting robot is ready; you now have 7 of them.

== Minute 14 ==
Spend 3 ore and 14 clay to start building an obsidian-collecting robot.
2 ore-collecting robots collect 2 ore; you now have 2 ore.
7 clay-collecting robots collect 7 clay; you now have 14 clay.
The new obsidian-collecting robot is ready; you now have 1 of them.

== Minute 15 ==
2 ore-collecting robots collect 2 ore; you now have 4 ore.
7 clay-collecting robots collect 7 clay; you now have 21 clay.
1 obsidian-collecting robot collects 1 obsidian; you now have 1 obsidian.

== Minute 16 ==
Spend 3 ore and 14 clay to start building an obsidian-collecting robot.
2 ore-collecting robots collect 2 ore; you now have 3 ore.
7 clay-collecting robots collect 7 clay; you now have 14 clay.
1 obsidian-collecting robot collects 1 obsidian; you now have 2 obsidian.
The new obsidian-collecting robot is ready; you now have 2 of them.

== Minute 17 ==
Spend 3 ore and 14 clay to start building an obsidian-collecting robot.
2 ore-collecting robots collect 2 ore; you now have 2 ore.
7 clay-collecting robots collect 7 clay; you now have 7 clay.
2 obsidian-collecting robots collect 2 obsidian; you now have 4 obsidian.
The new obsidian-collecting robot is ready; you now have 3 of them.

== Minute 18 ==
2 ore-collecting robots collect 2 ore; you now have 4 ore.
7 clay-collecting robots collect 7 clay; you now have 14 clay.
3 obsidian-collecting robots collect 3 obsidian; you now have 7 obsidian.

== Minute 19 ==
Spend 3 ore and 14 clay to start building an obsidian-collecting robot.
2 ore-collecting robots collect 2 ore; you now have 3 ore.
7 clay-collecting robots collect 7 clay; you now have 7 clay.
3 obsidian-collecting robots collect 3 obsidian; you now have 10 obsidian.
The new obsidian-collecting robot is ready; you now have 4 of them.

== Minute 20 ==
Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
2 ore-collecting robots collect 2 ore; you now have 3 ore.
7 clay-collecting robots collect 7 clay; you now have 14 clay.
4 obsidian-collecting robots collect 4 obsidian; you now have 7 obsidian.
The new geode-cracking robot is ready; you now have 1 of them.

== Minute 21 ==
Spend 3 ore and 14 clay to start building an obsidian-collecting robot.
2 ore-collecting robots collect 2 ore; you now have 2 ore.
7 clay-collecting robots collect 7 clay; you now have 7 clay.
4 obsidian-collecting robots collect 4 obsidian; you now have 11 obsidian.
1 geode-cracking robot cracks 1 geode; you now have 1 open geode.
The new obsidian-collecting robot is ready; you now have 5 of them.

== Minute 22 ==
Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
2 ore-collecting robots collect 2 ore; you now have 2 ore.
7 clay-collecting robots collect 7 clay; you now have 14 clay.
5 obsidian-collecting robots collect 5 obsidian; you now have 9 obsidian.
1 geode-cracking robot cracks 1 geode; you now have 2 open geodes.
The new geode-cracking robot is ready; you now have 2 of them.

== Minute 23 ==
Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
2 ore-collecting robots collect 2 ore; you now have 2 ore.
7 clay-collecting robots collect 7 clay; you now have 21 clay.
5 obsidian-collecting robots collect 5 obsidian; you now have 7 obsidian.
2 geode-cracking robots crack 2 geodes; you now have 4 open geodes.
The new geode-cracking robot is ready; you now have 3 of them.

== Minute 24 ==
Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
2 ore-collecting robots collect 2 ore; you now have 2 ore.
7 clay-collecting robots collect 7 clay; you now have 28 clay.
5 obsidian-collecting robots collect 5 obsidian; you now have 5 obsidian.
3 geode-cracking robots crack 3 geodes; you now have 7 open geodes.
The new geode-cracking robot is ready; you now have 4 of them.

== Minute 25 ==
2 ore-collecting robots collect 2 ore; you now have 4 ore.
7 clay-collecting robots collect 7 clay; you now have 35 clay.
5 obsidian-collecting robots collect 5 obsidian; you now have 10 obsidian.
4 geode-cracking robots crack 4 geodes; you now have 11 open geodes.

== Minute 26 ==
Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
2 ore-collecting robots collect 2 ore; you now have 4 ore.
7 clay-collecting robots collect 7 clay; you now have 42 clay.
5 obsidian-collecting robots collect 5 obsidian; you now have 8 obsidian.
4 geode-cracking robots crack 4 geodes; you now have 15 open geodes.
The new geode-cracking robot is ready; you now have 5 of them.

== Minute 27 ==
Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
2 ore-collecting robots collect 2 ore; you now have 4 ore.
7 clay-collecting robots collect 7 clay; you now have 49 clay.
5 obsidian-collecting robots collect 5 obsidian; you now have 6 obsidian.
5 geode-cracking robots crack 5 geodes; you now have 20 open geodes.
The new geode-cracking robot is ready; you now have 6 of them.

== Minute 28 ==
2 ore-collecting robots collect 2 ore; you now have 6 ore.
7 clay-collecting robots collect 7 clay; you now have 56 clay.
5 obsidian-collecting robots collect 5 obsidian; you now have 11 obsidian.
6 geode-cracking robots crack 6 geodes; you now have 26 open geodes.

== Minute 29 ==
Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
2 ore-collecting robots collect 2 ore; you now have 6 ore.
7 clay-collecting robots collect 7 clay; you now have 63 clay.
5 obsidian-collecting robots collect 5 obsidian; you now have 9 obsidian.
6 geode-cracking robots crack 6 geodes; you now have 32 open geodes.
The new geode-cracking robot is ready; you now have 7 of them.

== Minute 30 ==
Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
2 ore-collecting robots collect 2 ore; you now have 6 ore.
7 clay-collecting robots collect 7 clay; you now have 70 clay.
5 obsidian-collecting robots collect 5 obsidian; you now have 7 obsidian.
7 geode-cracking robots crack 7 geodes; you now have 39 open geodes.
The new geode-cracking robot is ready; you now have 8 of them.

== Minute 31 ==
Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
2 ore-collecting robots collect 2 ore; you now have 6 ore.
7 clay-collecting robots collect 7 clay; you now have 77 clay.
5 obsidian-collecting robots collect 5 obsidian; you now have 5 obsidian.
8 geode-cracking robots crack 8 geodes; you now have 47 open geodes.
The new geode-cracking robot is ready; you now have 9 of them.

== Minute 32 ==
2 ore-collecting robots collect 2 ore; you now have 8 ore.
7 clay-collecting robots collect 7 clay; you now have 84 clay.
5 obsidian-collecting robots collect 5 obsidian; you now have 10 obsidian.
9 geode-cracking robots crack 9 geodes; you now have 56 open geodes.

However, blueprint 2 from the example above is still better; using it, the
largest number of geodes you could open in 32 minutes is 62.

You no longer have enough blueprints to worry about quality levels. Instead,
for each of the first three blueprints, determine the largest number of geodes
you could open; then, multiply these three values together.

Don't worry about quality levels; instead, just determine the largest number of
geodes you could open using each of the first three blueprints. What do you get
if you multiply these numbers together?
=end pod

constant $max-time = 32;

class SimulationState {
  has $.time;
  has $.ore-robots;
  has $.clay-robots;
  has $.obsidian-robots;
  has $.geode-robots;
  has $.ore;
  has $.clay;
  has $.obsidian;
  has $.geodes;
}

grammar Input {
  rule TOP {
    <blueprint>
    <ore>
    <clay>
    <obsidian>
    <geode>
  }
  token blueprint { 'Blueprint ' <num> ':' }
  token ore { 'Each ore robot costs ' <num> ' ore.' }
  token clay { 'Each clay robot costs ' <num> ' ore.' }
  token obsidian { 'Each obsidian robot costs ' $<ore>=<num> ' ore and ' $<clay>=<num> ' clay.' }
  token geode { 'Each geode robot costs ' $<ore>=<num> ' ore and ' $<obsidian>=<num> ' obsidian.' }
  token num { \d+ }
}

role Robot {
  method can-build-with (SimulationState $, --> Bool) { ... }
  method time-until-can-build (SimulationState $, --> Int) { ... }
}

class OreRobot does Robot {
  has $.ore-cost is required;
  method can-build-with (SimulationState $state) { $state.ore >= $!ore-cost }
  method time-until-can-build (SimulationState $state) {
    return 1 if self.can-build-with($state);
    return Nil if $state.ore-robots == 0;
    ceiling(($!ore-cost - $state.ore) / $state.ore-robots) + 1
  }
}

class ClayRobot does Robot {
  has $.ore-cost is required;
  method can-build-with (SimulationState $state) { $state.ore >= $!ore-cost }
  method time-until-can-build (SimulationState $state) {
    return 1 if self.can-build-with($state);
    return Nil if $state.ore-robots == 0;
    ceiling(($!ore-cost - $state.ore) / $state.ore-robots) + 1
  }
}

class ObsidianRobot does Robot {
  has $.ore-cost is required;
  has $.clay-cost is required;
  method can-build-with (SimulationState $state) {
    $state.ore >= $!ore-cost && $state.clay >= $!clay-cost
  }
  method time-until-can-build (SimulationState $state) {
    return 1 if self.can-build-with($state);
    return Nil if $state.ore-robots == 0 || $state.clay-robots == 0;
    (
      ceiling(($!ore-cost - $state.ore) / $state.ore-robots),
      ceiling(($!clay-cost - $state.clay) / $state.clay-robots),
    ).max + 1
  }
}

class GeodeRobot does Robot {
  has $.ore-cost is required;
  has $.obsidian-cost is required;
  method can-build-with (SimulationState $state) {
    $state.ore >= $!ore-cost && $state.obsidian >= $!obsidian-cost
  }
  method time-until-can-build (SimulationState $state) {
    return 1 if self.can-build-with($state);
    return Nil if $state.ore-robots == 0 || $state.obsidian-robots == 0;
    (
      ceiling(($!ore-cost - $state.ore) / $state.ore-robots),
      ceiling(($!obsidian-cost - $state.obsidian) / $state.obsidian-robots),
    ).max + 1
  }
}

class Blueprint {
  has Int $.id is required;
  has OreRobot $.ore-robot is required;
  has ClayRobot $.clay-robot is required;
  has ObsidianRobot $.obsidian-robot is required;
  has GeodeRobot $.geode-robot is required;
  method TOP (::?CLASS:U $klass: $/) {
    make $klass.new(
      id => $<blueprint>.made,
      ore-robot => $<ore>.made,
      clay-robot => $<clay>.made,
      obsidian-robot => $<obsidian>.made,
      geode-robot => $<geode>.made,
    )
  }
  method blueprint (::?CLASS:U: $/) { make $<num>.made }
  method ore (::?CLASS:U: $/) { make OreRobot.new(ore-cost => $<num>.made) }
  method clay (::?CLASS:U: $/) { make ClayRobot.new(ore-cost => $<num>.made) }
  method obsidian (::?CLASS:U: $/) { make ObsidianRobot.new(ore-cost => $<ore>.made, clay-cost => $<clay>.made) }
  method geode (::?CLASS:U: $/) { make GeodeRobot.new(ore-cost => $<ore>.made, obsidian-cost => $<obsidian>.made) }
  method num (::?CLASS:U: $/) { make +$/ }
}

# Determine if this path has a chance of producing a better result than we
# already have.
sub worth-exploring (@most-geode-robots, $t, $num) {
  $num >= @most-geode-robots[$t] - 1
}

sub simulate (Blueprint $blueprint) {
  say "running blueprint {$blueprint.id}";

  # we probably don't need more robots than any single robot costs because we
  # can only make one robot a round. If we had more robots, we'd just be
  # wasting resources.
  my $max-ore-robots = (
    $blueprint.ore-robot.ore-cost,
    $blueprint.clay-robot.ore-cost,
    $blueprint.obsidian-robot.ore-cost,
    $blueprint.geode-robot.ore-cost
  ).max;
  my $max-clay-robots = $blueprint.obsidian-robot.clay-cost;
  my $max-obsidian-robots = $blueprint.geode-robot.obsidian-cost;

  my @queue = [SimulationState.new(
    time => 0,
    ore-robots => 1,
    clay-robots => 0,
    obsidian-robots => 0,
    geode-robots => 0,
    ore => 0,
    clay => 0,
    obsidian => 0,
    geodes => 0,
  )];
  my @most-geode-robots = 0 xx $max-time;
  my $max-geodes = 0;
  while @queue.shift -> $state {
    next unless worth-exploring(@most-geode-robots, $state.time, $state.geode-robots);

    my $produced-geodes = $state.geodes + $state.geode-robots * ($max-time - $state.time);
    $max-geodes = $produced-geodes if $produced-geodes > $max-geodes;

    my $time-remaining = $max-time - $state.time;
    if $blueprint.geode-robot.time-until-can-build($state) -> $time-needed {
      if $time-needed < $time-remaining && worth-exploring(@most-geode-robots, $state.time + $time-needed, $state.geode-robots) {
        my $new-state = $state.clone(
          time => $state.time + $time-needed,
          geode-robots => $state.geode-robots + 1,
          ore => $state.ore + $state.ore-robots * $time-needed - $blueprint.geode-robot.ore-cost,
          clay => $state.clay + $state.clay-robots * $time-needed,
          obsidian => $state.obsidian + $state.obsidian-robots * $time-needed - $blueprint.geode-robot.obsidian-cost,
          geodes => $state.geodes + $state.geode-robots * $time-needed,
        );
        for $new-state.time..^$max-time -> $t {
          @most-geode-robots[$t] = $new-state.geode-robots if $new-state.geode-robots > @most-geode-robots[$t];
        }
        @queue.push: $new-state;
      }
    }
    if $state.obsidian-robots < $max-obsidian-robots {
      if $blueprint.obsidian-robot.time-until-can-build($state) -> $time-needed {
        if $time-needed < $time-remaining && worth-exploring(@most-geode-robots, $state.time + $time-needed, $state.geode-robots) {
          @queue.push: $state.clone(
            time => $state.time + $time-needed,
            obsidian-robots => $state.obsidian-robots + 1,
            ore => $state.ore + $state.ore-robots * $time-needed - $blueprint.obsidian-robot.ore-cost,
            clay => $state.clay + $state.clay-robots * $time-needed - $blueprint.obsidian-robot.clay-cost,
            obsidian => $state.obsidian + $state.obsidian-robots * $time-needed,
            geodes => $state.geodes + $state.geode-robots * $time-needed,
          );
        }
      }
    }
    if $state.clay-robots < $max-clay-robots {
      if $blueprint.clay-robot.time-until-can-build($state) -> $time-needed {
        if $time-needed < $time-remaining && worth-exploring(@most-geode-robots, $state.time + $time-needed, $state.geode-robots) {
          @queue.push: $state.clone(
            time => $state.time + $time-needed,
            clay-robots => $state.clay-robots + 1,
            ore => $state.ore + $state.ore-robots * $time-needed - $blueprint.clay-robot.ore-cost,
            clay => $state.clay + $state.clay-robots * $time-needed,
            obsidian => $state.obsidian + $state.obsidian-robots * $time-needed,
            geodes => $state.geodes + $state.geode-robots * $time-needed,
          );
        }
      }
    }
    if $state.ore-robots < $max-ore-robots {
      if $blueprint.ore-robot.time-until-can-build($state) -> $time-needed {
        if $time-needed < $time-remaining && worth-exploring(@most-geode-robots, $state.time + $time-needed, $state.geode-robots) {
          @queue.push: $state.clone(
            time => $state.time + $time-needed,
            ore-robots => $state.ore-robots + 1,
            ore => $state.ore + $state.ore-robots * $time-needed - $blueprint.ore-robot.ore-cost,
            clay => $state.clay + $state.clay-robots * $time-needed,
            obsidian => $state.obsidian + $state.obsidian-robots * $time-needed,
            geodes => $state.geodes + $state.geode-robots * $time-needed,
          );
        }
      }
    }
  }

  return $max-geodes;
}

my @blueprints = 'input.txt'.IO.lines.map({ Input.parse($_, actions => Blueprint).made });
# say @blueprints.map(&simulate);
say "Product of geode mining: {@blueprints[^3].map(&simulate).reduce(&infix:<*>)}";
