#!/usr/bin/env raku

=begin pod
Your handheld device indicates that the distress signal is coming from a beacon
nearby. The distress beacon is not detected by any sensor, but the distress
beacon must have x and y coordinates each no lower than 0 and no larger than
4000000.

To isolate the distress beacon's signal, you need to determine its tuning
frequency, which can be found by multiplying its x coordinate by 4000000 and
then adding its y coordinate.

In the example above, the search space is smaller: instead, the x and y
coordinates can each be at most 20. With this reduced search area, there is
only a single position that could have a beacon: x=14, y=11. The tuning
frequency for this distress beacon is 56000011.

Find the only possible position for the distress beacon. What is its tuning
frequency?
=end pod

constant $possible-coords = 4000000;

class Point {
  has $.x is required;
  has $.y is required;
  method kv { ($!x, $!y) }
  method WHICH { ValueObjAt.new("Point|($!x,$!y)") }
  method distance (::?CLASS:D: $p2) { ($!x - $p2.x).abs + ($!y - $p2.y).abs }
}

grammar SensorParser {
  token TOP { [ <reading> <.ws> ]+ }
  rule reading {
    'Sensor at'
    $<point>=<coord>
    ': closest beacon is at'
    $<beacon>=<coord>
 }
  token coord { 'x=' $<x>=<num> ', y=' $<y>=<num> }
  token num { '-'? \d+ }
}

class SensorReading {
  has Point $.point is required;
  has Point $.beacon is required;
  method TOP (::?CLASS:U: $/) { make $<reading>.map(*.made) }
  method reading (::?CLASS:U $klass: $/) { make $klass.new(point => $<point>.made, beacon => $<beacon>.made) }
  method coord (::?CLASS:U: $/) { make Point.new(x => $<x>.made, y => $<y>.made) }
  method num (::?CLASS:U: $/) { make +$/ }
}

# Raku keeps wanting to expand Ranges, so I made my own class
class MinMax {
  has $.min is required;
  has $.max is required;
}

class Uncovered {
  has @!empty = [MinMax.new(min => 0, max => $possible-coords)];
  method cover ($range) {
    @!empty = @!empty.map({
      if $_.min > $range.max || $_.max < $range.min {
        $_;
      } elsif $_.min >= $range.min {
        if $_.max <= $range.max {
          [];
        } else {
          MinMax.new(min => $range.max + 1, max => $_.max);
        }
      } elsif $_.max <= $range.max {
        MinMax.new(min => $_.min, max => $range.min - 1);
      } else {
        [
          MinMax.new(min => $_.min, max => $range.min - 1),
          MinMax.new(min => $range.max + 1, max => $_.max)
        ];
      }
    }).flat;
  }
  method first { @!empty[0].min }
  method has-one { @!empty.elems == 1 && @!empty[0].elems == 1 }
}

my @readings = SensorParser.parsefile('input.txt', actions => SensorReading).made;
my $tuning-frequency = 0;
ROWS: for ^$possible-coords -> $row {
  say $row if $row %% 100000;

  my Uncovered $uncovered .= new;
  for @readings -> $reading {
    my $distance-to-beacon = $reading.point.distance($reading.beacon);
    my $distance-to-row = ($reading.point.y - $row).abs;
    next if $distance-to-row > $distance-to-beacon;

    my $diff = ($distance-to-beacon - $distance-to-row).abs;
    my $range = ($reading.point.x - $diff)..($reading.point.x + $diff);
    $uncovered.cover($range);
  }

  if $uncovered.has-one {
    $tuning-frequency = $possible-coords * $uncovered.first + $row;
    last ROWS;
  }
}

say "Tuning Frequency: $tuning-frequency";
