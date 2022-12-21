#!/usr/bin/env raku

=begin pod
Your scans show that the lava did indeed form obsidian!

The wind has changed direction enough to stop sending lava droplets toward you,
so you and the elephants exit the cave. As you do, you notice a collection of
geodes around the pond. Perhaps you could use the obsidian to create some
geode-cracking robots and break them open?

To collect the obsidian from the bottom of the pond, you'll need waterproof
obsidian-collecting robots. Fortunately, there is an abundant amount of clay
nearby that you can use to make them waterproof.

In order to harvest the clay, you'll need special-purpose clay-collecting
robots. To make any type of robot, you'll need ore, which is also plentiful but
in the opposite direction from the clay.

Collecting ore requires ore-collecting robots with big drills. Fortunately, you
have exactly one ore-collecting robot in your pack that you can use to
kickstart the whole operation.

Each robot can collect 1 of its resource type per minute. It also takes one
minute for the robot factory (also conveniently from your pack) to construct
any type of robot, although it consumes the necessary resources available when
construction begins.

The robot factory has many blueprints (your puzzle input) you can choose from,
but once you've configured it with a blueprint, you can't change it. You'll
need to work out which blueprint is best.

For example:

Blueprint 1:
  Each ore robot costs 4 ore.
  Each clay robot costs 2 ore.
  Each obsidian robot costs 3 ore and 14 clay.
  Each geode robot costs 2 ore and 7 obsidian.

Blueprint 2:
  Each ore robot costs 2 ore.
  Each clay robot costs 3 ore.
  Each obsidian robot costs 3 ore and 8 clay.
  Each geode robot costs 3 ore and 12 obsidian.

(Blueprints have been line-wrapped here for legibility. The robot factory's
actual assortment of blueprints are provided one blueprint per line.)

The elephants are starting to look hungry, so you shouldn't take too long; you
need to figure out which blueprint would maximize the number of opened geodes
after 24 minutes by figuring out which robots to build and when to build them.

Using blueprint 1 in the example above, the largest number of geodes you could
open in 24 minutes is 9. One way to achieve that is:

== Minute 1 ==
1 ore-collecting robot collects 1 ore; you now have 1 ore.

== Minute 2 ==
1 ore-collecting robot collects 1 ore; you now have 2 ore.

== Minute 3 ==
Spend 2 ore to start building a clay-collecting robot.
1 ore-collecting robot collects 1 ore; you now have 1 ore.
The new clay-collecting robot is ready; you now have 1 of them.

== Minute 4 ==
1 ore-collecting robot collects 1 ore; you now have 2 ore.
1 clay-collecting robot collects 1 clay; you now have 1 clay.

== Minute 5 ==
Spend 2 ore to start building a clay-collecting robot.
1 ore-collecting robot collects 1 ore; you now have 1 ore.
1 clay-collecting robot collects 1 clay; you now have 2 clay.
The new clay-collecting robot is ready; you now have 2 of them.

== Minute 6 ==
1 ore-collecting robot collects 1 ore; you now have 2 ore.
2 clay-collecting robots collect 2 clay; you now have 4 clay.

== Minute 7 ==
Spend 2 ore to start building a clay-collecting robot.
1 ore-collecting robot collects 1 ore; you now have 1 ore.
2 clay-collecting robots collect 2 clay; you now have 6 clay.
The new clay-collecting robot is ready; you now have 3 of them.

== Minute 8 ==
1 ore-collecting robot collects 1 ore; you now have 2 ore.
3 clay-collecting robots collect 3 clay; you now have 9 clay.

== Minute 9 ==
1 ore-collecting robot collects 1 ore; you now have 3 ore.
3 clay-collecting robots collect 3 clay; you now have 12 clay.

== Minute 10 ==
1 ore-collecting robot collects 1 ore; you now have 4 ore.
3 clay-collecting robots collect 3 clay; you now have 15 clay.

== Minute 11 ==
Spend 3 ore and 14 clay to start building an obsidian-collecting robot.
1 ore-collecting robot collects 1 ore; you now have 2 ore.
3 clay-collecting robots collect 3 clay; you now have 4 clay.
The new obsidian-collecting robot is ready; you now have 1 of them.

== Minute 12 ==
Spend 2 ore to start building a clay-collecting robot.
1 ore-collecting robot collects 1 ore; you now have 1 ore.
3 clay-collecting robots collect 3 clay; you now have 7 clay.
1 obsidian-collecting robot collects 1 obsidian; you now have 1 obsidian.
The new clay-collecting robot is ready; you now have 4 of them.

== Minute 13 ==
1 ore-collecting robot collects 1 ore; you now have 2 ore.
4 clay-collecting robots collect 4 clay; you now have 11 clay.
1 obsidian-collecting robot collects 1 obsidian; you now have 2 obsidian.

== Minute 14 ==
1 ore-collecting robot collects 1 ore; you now have 3 ore.
4 clay-collecting robots collect 4 clay; you now have 15 clay.
1 obsidian-collecting robot collects 1 obsidian; you now have 3 obsidian.

== Minute 15 ==
Spend 3 ore and 14 clay to start building an obsidian-collecting robot.
1 ore-collecting robot collects 1 ore; you now have 1 ore.
4 clay-collecting robots collect 4 clay; you now have 5 clay.
1 obsidian-collecting robot collects 1 obsidian; you now have 4 obsidian.
The new obsidian-collecting robot is ready; you now have 2 of them.

== Minute 16 ==
1 ore-collecting robot collects 1 ore; you now have 2 ore.
4 clay-collecting robots collect 4 clay; you now have 9 clay.
2 obsidian-collecting robots collect 2 obsidian; you now have 6 obsidian.

== Minute 17 ==
1 ore-collecting robot collects 1 ore; you now have 3 ore.
4 clay-collecting robots collect 4 clay; you now have 13 clay.
2 obsidian-collecting robots collect 2 obsidian; you now have 8 obsidian.

== Minute 18 ==
Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
1 ore-collecting robot collects 1 ore; you now have 2 ore.
4 clay-collecting robots collect 4 clay; you now have 17 clay.
2 obsidian-collecting robots collect 2 obsidian; you now have 3 obsidian.
The new geode-cracking robot is ready; you now have 1 of them.

== Minute 19 ==
1 ore-collecting robot collects 1 ore; you now have 3 ore.
4 clay-collecting robots collect 4 clay; you now have 21 clay.
2 obsidian-collecting robots collect 2 obsidian; you now have 5 obsidian.
1 geode-cracking robot cracks 1 geode; you now have 1 open geode.

== Minute 20 ==
1 ore-collecting robot collects 1 ore; you now have 4 ore.
4 clay-collecting robots collect 4 clay; you now have 25 clay.
2 obsidian-collecting robots collect 2 obsidian; you now have 7 obsidian.
1 geode-cracking robot cracks 1 geode; you now have 2 open geodes.

== Minute 21 ==
Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
1 ore-collecting robot collects 1 ore; you now have 3 ore.
4 clay-collecting robots collect 4 clay; you now have 29 clay.
2 obsidian-collecting robots collect 2 obsidian; you now have 2 obsidian.
1 geode-cracking robot cracks 1 geode; you now have 3 open geodes.
The new geode-cracking robot is ready; you now have 2 of them.

== Minute 22 ==
1 ore-collecting robot collects 1 ore; you now have 4 ore.
4 clay-collecting robots collect 4 clay; you now have 33 clay.
2 obsidian-collecting robots collect 2 obsidian; you now have 4 obsidian.
2 geode-cracking robots crack 2 geodes; you now have 5 open geodes.

== Minute 23 ==
1 ore-collecting robot collects 1 ore; you now have 5 ore.
4 clay-collecting robots collect 4 clay; you now have 37 clay.
2 obsidian-collecting robots collect 2 obsidian; you now have 6 obsidian.
2 geode-cracking robots crack 2 geodes; you now have 7 open geodes.

== Minute 24 ==
1 ore-collecting robot collects 1 ore; you now have 6 ore.
4 clay-collecting robots collect 4 clay; you now have 41 clay.
2 obsidian-collecting robots collect 2 obsidian; you now have 8 obsidian.
2 geode-cracking robots crack 2 geodes; you now have 9 open geodes.

However, by using blueprint 2 in the example above, you could do even better:
the largest number of geodes you could open in 24 minutes is 12.

Determine the quality level of each blueprint by multiplying that blueprint's
ID number with the largest number of geodes that can be opened in 24 minutes
using that blueprint. In this example, the first blueprint has ID 1 and can
open 9 geodes, so its quality level is 9. The second blueprint has ID 2 and can
open 12 geodes, so its quality level is 24. Finally, if you add up the quality
levels of all of the blueprints in the list, you get 33.

Determine the quality level of each blueprint using the largest number of
geodes it could produce in 24 minutes. What do you get if you add up the
quality level of all of the blueprints in your list?
=end pod

constant $max-time = 24;

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
  method can-build-with (|, --> Bool) { ... }
  method time-until-can-build (|, --> Int) { ... }
}

class OreRobot does Robot {
  has $.ore-cost is required;
  method can-build-with (:$ore) { $ore >= $!ore-cost }
  method time-until-can-build (:$ore, :$ore-robots) {
    return 1 if self.can-build-with(:$ore);
    return Nil if $ore-robots == 0;
    ceiling(($!ore-cost - $ore) / $ore-robots) + 1
  }
}

class ClayRobot does Robot {
  has $.ore-cost is required;
  method can-build-with (:$ore) { $ore >= $!ore-cost }
  method time-until-can-build (:$ore, :$ore-robots) {
    return 1 if self.can-build-with(:$ore);
    return Nil if $ore-robots == 0;
    ceiling(($!ore-cost - $ore) / $ore-robots) + 1
  }
}

class ObsidianRobot does Robot {
  has $.ore-cost is required;
  has $.clay-cost is required;
  method can-build-with (:$ore, :$clay) {
    $ore >= $!ore-cost && $clay >= $!clay-cost
  }
  method time-until-can-build (:$ore, :$clay, :$ore-robots, :$clay-robots) {
    return 1 if self.can-build-with(:$ore, :$clay);
    return Nil if $ore-robots == 0 || $clay-robots == 0;
    (
      ceiling(($!ore-cost - $ore) / $ore-robots),
      ceiling(($!clay-cost - $clay) / $clay-robots),
    ).max + 1
  }
}

class GeodeRobot does Robot {
  has $.ore-cost is required;
  has $.obsidian-cost is required;
  method can-build-with (:$ore, :$obsidian) {
    $ore >= $!ore-cost && $obsidian >= $!obsidian-cost
  }
  method time-until-can-build (:$ore, :$obsidian, :$ore-robots, :$obsidian-robots) {
    return 1 if self.can-build-with(:$ore, :$obsidian);
    return Nil if $ore-robots == 0 || $obsidian-robots == 0;
    (
      ceiling(($!ore-cost - $ore) / $ore-robots),
      ceiling(($!obsidian-cost - $obsidian) / $obsidian-robots),
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

sub simulate (
  Blueprint $blueprint,
  Int:D :$time,
  Int:D :$ore-robots,
  Int:D :$clay-robots,
  Int:D :$obsidian-robots,
  Int:D :$geode-robots,
  Int:D :$ore,
  Int:D :$clay,
  Int:D :$obsidian,
  Int:D :$geodes,
  Int:D :$max-ore-robots,
  Int:D :$max-clay-robots,
  Int:D :$max-obsidian-robots,
) {
  my $time-remaining = $max-time - $time;
  my $max-geodes = $geodes + $geode-robots * $time-remaining;
  if $blueprint.geode-robot.time-until-can-build(:$ore, :$obsidian, :$ore-robots, :$obsidian-robots) -> $time-needed {
    if $time-needed < $time-remaining {
      my $this-geodes = simulate(
        $blueprint,
        time => $time + $time-needed,
        :$ore-robots,
        :$clay-robots,
        :$obsidian-robots,
        geode-robots => $geode-robots + 1,
        ore => $ore + $ore-robots * $time-needed - $blueprint.geode-robot.ore-cost,
        clay => $clay + $clay-robots * $time-needed,
        obsidian => $obsidian + $obsidian-robots * $time-needed - $blueprint.geode-robot.obsidian-cost,
        geodes => $geodes + $geode-robots * $time-needed,
        :$max-ore-robots,
        :$max-clay-robots,
        :$max-obsidian-robots,
      );
      $max-geodes = $this-geodes if $this-geodes > $max-geodes;
    }
  }
  if $obsidian-robots < $max-obsidian-robots {
    if $blueprint.obsidian-robot.time-until-can-build(:$ore, :$clay, :$ore-robots, :$clay-robots) -> $time-needed {
      if $time-needed < $time-remaining {
        my $this-geodes = simulate(
          $blueprint,
          time => $time + $time-needed,
          :$ore-robots,
          :$clay-robots,
          obsidian-robots => $obsidian-robots + 1,
          :$geode-robots,
          ore => $ore + $ore-robots * $time-needed - $blueprint.obsidian-robot.ore-cost,
          clay => $clay + $clay-robots * $time-needed - $blueprint.obsidian-robot.clay-cost,
          obsidian => $obsidian + $obsidian-robots * $time-needed,
          geodes => $geodes + $geode-robots * $time-needed,
          :$max-ore-robots,
          :$max-clay-robots,
          :$max-obsidian-robots,
        );
        $max-geodes = $this-geodes if $this-geodes > $max-geodes;
      }
    }
  }
  if $clay-robots < $max-clay-robots {
    if $blueprint.clay-robot.time-until-can-build(:$ore, :$ore-robots) -> $time-needed {
      if $time-needed < $time-remaining {
        my $this-geodes = simulate(
          $blueprint,
          time => $time + $time-needed,
          :$ore-robots,
          clay-robots => $clay-robots + 1,
          :$obsidian-robots,
          :$geode-robots,
          ore => $ore + $ore-robots * $time-needed - $blueprint.clay-robot.ore-cost,
          clay => $clay + $clay-robots * $time-needed,
          obsidian => $obsidian + $obsidian-robots * $time-needed,
          geodes => $geodes + $geode-robots * $time-needed,
          :$max-ore-robots,
          :$max-clay-robots,
          :$max-obsidian-robots,
        );
        $max-geodes = $this-geodes if $this-geodes > $max-geodes;
      }
    }
  }
  if $ore-robots < $max-ore-robots {
    if $blueprint.ore-robot.time-until-can-build(:$ore, :$ore-robots) -> $time-needed {
      if $time-needed < $time-remaining {
        my $this-geodes = simulate(
          $blueprint,
          time => $time + $time-needed,
          ore-robots => $ore-robots + 1,
          :$clay-robots,
          :$obsidian-robots,
          :$geode-robots,
          ore => $ore + $ore-robots * $time-needed - $blueprint.ore-robot.ore-cost,
          clay => $clay + $clay-robots * $time-needed,
          obsidian => $obsidian + $obsidian-robots * $time-needed,
          geodes => $geodes + $geode-robots * $time-needed,
          :$max-ore-robots,
          :$max-clay-robots,
          :$max-obsidian-robots,
        );
        $max-geodes = $this-geodes if $this-geodes > $max-geodes;
      }
    }
  }
  return $max-geodes;
}

sub quality-level (Blueprint $blueprint) {
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
  return $blueprint.id * simulate(
    $blueprint,
    time => 0,
    ore-robots => 1,
    clay-robots => 0,
    obsidian-robots => 0,
    geode-robots => 0,
    ore => 0,
    clay => 0,
    obsidian => 0,
    geodes => 0,
    :$max-ore-robots,
    :$max-clay-robots,
    :$max-obsidian-robots,
  );
}

my @blueprints = 'input.txt'.IO.lines.map({ Input.parse($_, actions => Blueprint).made });
say "Sum of quality levels: {@blueprints.map(&quality-level).sum}";
