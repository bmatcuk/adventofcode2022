#!/usr/bin/env raku

=begin pod
As you reach the force field, you think you hear some Elves in the distance.
Perhaps they've already arrived?

You approach the strange input device, but it isn't quite what the monkeys drew
in their notes. Instead, you are met with a large cube; each of its six faces
is a square of 50x50 tiles.

To be fair, the monkeys' map does have six 50x50 regions on it. If you were to
carefully fold the map, you should be able to shape it into a cube!

In the example above, the six (smaller, 4x4) faces of the cube are:

        1111
        1111
        1111
        1111
222233334444
222233334444
222233334444
222233334444
        55556666
        55556666
        55556666
        55556666

You still start in the same position and with the same facing as before, but
the wrapping rules are different. Now, if you would walk off the board, you
instead proceed around the cube. From the perspective of the map, this can look
a little strange. In the above example, if you are at A and move to the right,
you would arrive at B facing down; if you are at C and move down, you would
arrive at D facing up:

        ...#
        .#..
        #...
        ....
...#.......#
........#..A
..#....#....
.D........#.
        ...#..B.
        .....#..
        .#......
        ..C...#.

Walls still block your path, even if they are on a different face of the cube.
If you are at E facing up, your movement is blocked by the wall marked by the
arrow:

        ...#
        .#..
     -->#...
        ....
...#..E....#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

Using the same method of drawing the last facing you had with an arrow on each
tile you visit, the full path taken by the above example now looks like this:

        >>v#    
        .#v.    
        #.v.    
        ..v.    
...#..^...v#    
.>>>>>^.#.>>    
.^#....#....    
.^........#.    
        ...#..v.
        .....#v.
        .#v<<<<.
        ..v...#.

The final password is still calculated from your final position and facing from
the perspective of the map. In this example, the final row is 5, the final
column is 7, and the final facing is 3, so the final password is 1000 * 5 + 4 *
7 + 3 = 5031.

Fold the map into a cube, then follow the path given in the monkeys' notes.
What is the final password?
=end pod

enum Heading <Right Down Left Up>;
my %value-to-heading = Heading::.values.map({ $_.value => $_ });
%value-to-heading{-1} = %value-to-heading{3};
%value-to-heading{4} = %value-to-heading{0};

grammar Directions {
  token TOP { [ <num> <turn>? ]+ }
  token turn { 'L' | 'R' }
  token num { \d+ }
}

class Actions {
  method TOP ($/) { make roundrobin($<num>.map(*.made), $<turn>.map(*.made)).list }
  method turn ($/) { make ~$/ }
  method num ($/) { make +$/ }
}

# load input - last line is directions, and line before that is blank
my @input = 'input.txt'.IO.lines.map(*.comb.list);
my @directions := Directions.parse(@input.pop.join(''), actions => Actions).made;
@input.pop;

my $y = 0;
my $x = @input[$y].first({ $_ ne ' ' }, :k);
my $heading = Right;

sub wrap ($x, $y) {
  $x < 0
  || $y < 0
  || $y >= @input.elems
  || $x >= @input[$y].elems
  || @input[$y][$x] eq ' '
}

sub next-position {
  my $new-x = $x;
  my $new-y = $y;
  my $new-heading = $heading;
  given $heading {
    when Right { $new-x++; }
    when Down { $new-y++; }
    when Left { $new-x--; }
    when Up { $new-y--; }
  }
  if wrap($new-x, $new-y) {
    # The way the input wraps into a cube is hard-coded based on my input.
    # Notably, this doesn't work on the sample input which folds differently.
    # My input looked like this:
    #
    #    AB
    #    C
    #   DE
    #   F
    if $new-y < 0 {
      if $new-x < 100 {
        # off the top of A to the left of F
        $new-x = 0;
        $new-y = $x + 100;
        $new-heading = Right;
      } else {
        # off the top of B to the bottom of F
        # heading stays the same (Up)
        $new-x = $x - 100;
        $new-y = 199;
      }
    } elsif $new-y < 50 {
      if $new-x < 50 {
        # off the left of A to the left of D
        $new-x = 0;
        $new-y = 149 - $y;
        $new-heading = Right;
      } else {
        # off the right of B to the right of E
        $new-x = 99;
        $new-y = 149 - $y;
        $new-heading = Left;
      }
    } elsif $new-y < 100 {
      if $new-x < 50 {
        if $heading == Left {
          # off the left of C to the top of D
          $new-x = $y - 50;
          $new-y = 100;
          $new-heading = Down;
        } else {
          # off the top of D to the left of C
          $new-x = 50;
          $new-y = $x + 50;
          $new-heading = Right;
        }
      } else {
        if $heading == Right {
          # off the right of C to the bottom of B
          $new-x = 50 + $y;
          $new-y = 49;
          $new-heading = Up;
        } else {
          # off the bottom of B to the right of C
          $new-x = 99;
          $new-y = $x - 50;
          $new-heading = Left;
        }
      }
    } elsif $new-y < 150 {
      if $new-x < 0 {
        # off the left of D to the left of A
        $new-x = 50;
        $new-y = 149 - $y;
        $new-heading = Right;
      } else {
        # off the right of E to the right of B
        $new-x = 149;
        $new-y = 149 - $y;
        $new-heading = Left;
      }
    } elsif $new-y < 200 {
      if $new-x < 0 {
        # off the left of F to the top of A
        $new-x = $y - 100;
        $new-y = 0;
        $new-heading = Down;
      } else {
        if $heading == Right {
          # off the right of F to the bottom of E
          $new-x = $y - 100;
          $new-y = 149;
          $new-heading = Up;
        } else {
          # off the bottom of E to the right of F
          $new-x = 49;
          $new-y = $x + 100;
          $new-heading = Left;
        }
      }
    } else {
      # off the bottom of F to the top of B
      # heading stays the same (Down)
      $new-x = $x + 100;
      $new-y = 0;
    }
  }
  return ($new-x, $new-y, $new-heading);
}

sub move {
  my ($new-x, $new-y, $new-heading) = next-position;
  return False if @input[$new-y][$new-x] eq '#';
  $x = $new-x;
  $y = $new-y;
  $heading = $new-heading;
  return True;
}

for @directions -> ($move, $turn = '') {
  for ^$move {
    last unless move;
  }

  if $turn eq 'L' {
    $heading = %value-to-heading{$heading - 1};
  } elsif $turn eq 'R' {
    $heading = %value-to-heading{$heading + 1};
  }
}

say "Final password: {1000 * ($y + 1) + 4 * ($x + 1) + $heading}";
