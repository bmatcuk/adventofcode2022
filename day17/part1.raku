#!/usr/bin/env raku

=begin pod
Your handheld device has located an alternative exit from the cave for you and
the elephants. The ground is rumbling almost continuously now, but the strange
valves bought you some time. It's definitely getting warmer in here, though.

The tunnels eventually open into a very tall, narrow chamber. Large,
oddly-shaped rocks are falling into the chamber from above, presumably due to
all the rumbling. If you can't work out where the rocks will fall next, you
might be crushed!

The five types of rocks have the following peculiar shapes, where # is rock and
. is empty space:

####

.#.
###
.#.

..#
..#
###

#
#
#
#

##
##

The rocks fall in the order shown above: first the - shape, then the + shape,
and so on. Once the end of the list is reached, the same order repeats: the -
shape falls first, sixth, 11th, 16th, etc.

The rocks don't spin, but they do get pushed around by jets of hot gas coming
out of the walls themselves. A quick scan reveals the effect the jets of hot
gas will have on the rocks as they fall (your puzzle input).

For example, suppose this was the jet pattern in your cave:

>>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>

In jet patterns, < means a push to the left, while > means a push to the right.
The pattern above means that the jets will push a falling rock right, then
right, then right, then left, then left, then right, and so on. If the end of
the list is reached, it repeats.

The tall, vertical chamber is exactly seven units wide. Each rock appears so
that its left edge is two units away from the left wall and its bottom edge is
three units above the highest rock in the room (or the floor, if there isn't
one).

After a rock appears, it alternates between being pushed by a jet of hot gas
one unit (in the direction indicated by the next symbol in the jet pattern) and
then falling one unit down. If any movement would cause any part of the rock to
move into the walls, floor, or a stopped rock, the movement instead does not
occur. If a downward movement would have caused a falling rock to move into the
floor or an already-fallen rock, the falling rock stops where it is (having
landed on something) and a new rock immediately begins falling.

Drawing falling rocks with @ and stopped rocks with #, the jet pattern in the
example above manifests as follows:

The first rock begins falling:
|..@@@@.|
|.......|
|.......|
|.......|
+-------+

Jet of gas pushes rock right:
|...@@@@|
|.......|
|.......|
|.......|
+-------+

Rock falls 1 unit:
|...@@@@|
|.......|
|.......|
+-------+

Jet of gas pushes rock right, but nothing happens:
|...@@@@|
|.......|
|.......|
+-------+

Rock falls 1 unit:
|...@@@@|
|.......|
+-------+

Jet of gas pushes rock right, but nothing happens:
|...@@@@|
|.......|
+-------+

Rock falls 1 unit:
|...@@@@|
+-------+

Jet of gas pushes rock left:
|..@@@@.|
+-------+

Rock falls 1 unit, causing it to come to rest:
|..####.|
+-------+

A new rock begins falling:
|...@...|
|..@@@..|
|...@...|
|.......|
|.......|
|.......|
|..####.|
+-------+

Jet of gas pushes rock left:
|..@....|
|.@@@...|
|..@....|
|.......|
|.......|
|.......|
|..####.|
+-------+

Rock falls 1 unit:
|..@....|
|.@@@...|
|..@....|
|.......|
|.......|
|..####.|
+-------+

Jet of gas pushes rock right:
|...@...|
|..@@@..|
|...@...|
|.......|
|.......|
|..####.|
+-------+

Rock falls 1 unit:
|...@...|
|..@@@..|
|...@...|
|.......|
|..####.|
+-------+

Jet of gas pushes rock left:
|..@....|
|.@@@...|
|..@....|
|.......|
|..####.|
+-------+

Rock falls 1 unit:
|..@....|
|.@@@...|
|..@....|
|..####.|
+-------+

Jet of gas pushes rock right:
|...@...|
|..@@@..|
|...@...|
|..####.|
+-------+

Rock falls 1 unit, causing it to come to rest:
|...#...|
|..###..|
|...#...|
|..####.|
+-------+

A new rock begins falling:
|....@..|
|....@..|
|..@@@..|
|.......|
|.......|
|.......|
|...#...|
|..###..|
|...#...|
|..####.|
+-------+

The moment each of the next few rocks begins falling, you would see this:

|..@....|
|..@....|
|..@....|
|..@....|
|.......|
|.......|
|.......|
|..#....|
|..#....|
|####...|
|..###..|
|...#...|
|..####.|
+-------+

|..@@...|
|..@@...|
|.......|
|.......|
|.......|
|....#..|
|..#.#..|
|..#.#..|
|#####..|
|..###..|
|...#...|
|..####.|
+-------+

|..@@@@.|
|.......|
|.......|
|.......|
|....##.|
|....##.|
|....#..|
|..#.#..|
|..#.#..|
|#####..|
|..###..|
|...#...|
|..####.|
+-------+

|...@...|
|..@@@..|
|...@...|
|.......|
|.......|
|.......|
|.####..|
|....##.|
|....##.|
|....#..|
|..#.#..|
|..#.#..|
|#####..|
|..###..|
|...#...|
|..####.|
+-------+

|....@..|
|....@..|
|..@@@..|
|.......|
|.......|
|.......|
|..#....|
|.###...|
|..#....|
|.####..|
|....##.|
|....##.|
|....#..|
|..#.#..|
|..#.#..|
|#####..|
|..###..|
|...#...|
|..####.|
+-------+

|..@....|
|..@....|
|..@....|
|..@....|
|.......|
|.......|
|.......|
|.....#.|
|.....#.|
|..####.|
|.###...|
|..#....|
|.####..|
|....##.|
|....##.|
|....#..|
|..#.#..|
|..#.#..|
|#####..|
|..###..|
|...#...|
|..####.|
+-------+

|..@@...|
|..@@...|
|.......|
|.......|
|.......|
|....#..|
|....#..|
|....##.|
|....##.|
|..####.|
|.###...|
|..#....|
|.####..|
|....##.|
|....##.|
|....#..|
|..#.#..|
|..#.#..|
|#####..|
|..###..|
|...#...|
|..####.|
+-------+

|..@@@@.|
|.......|
|.......|
|.......|
|....#..|
|....#..|
|....##.|
|##..##.|
|######.|
|.###...|
|..#....|
|.####..|
|....##.|
|....##.|
|....#..|
|..#.#..|
|..#.#..|
|#####..|
|..###..|
|...#...|
|..####.|
+-------+

To prove to the elephants your simulation is accurate, they want to know how
tall the tower will get after 2022 rocks have stopped (but before the 2023rd
rock begins falling). In this example, the tower of rocks will be 3068 units
tall.

How many units tall will the tower of rocks be after 2022 rocks have stopped
falling?
=end pod

constant $max-rocks = 2022;
constant $max-width = 7;
constant $init-x = 2;
constant $init-y = 3;

role Stone {
  has Int $.x is required;
  has Int $.y is required;
  method can-move-left { $!x > 0 }
  method can-move-right { $!x + self.width < $max-width }
  method move-left { $!x-- }
  method move-right { $!x++ }
  method move-up { $!y++ }
  method move-down { $!y-- }
  method overlaps (Stone $s, --> Bool) {
    return False if ($s.y - $s.height) >= $!y || $s.y <= ($!y - self.height);
    for $!x..^($!x + self.width) -> $x {
      for ($!y - self.height)^..$!y -> $y {
        return True if self.covers($x, $y) && $s.covers($x, $y);
      }
    }
    return False;
  }
  method covers (Int $x, Int $y, --> Bool) { ... }
  method width (--> Int) { ... }
  method height (--> Int) { ... }
}

class BarStone does Stone {
  method covers (Int $x, Int $y) {
    $y == $!y && $x >= $!x && $x < ($!x + self.width)
  }
  method width { 4 }
  method height { 1 }
}

class PlusStone does Stone {
  method covers (Int $x, Int $y) {
    ($x == ($!x + 1) && $y <= $!y && $y > ($!y - self.height))
    || ($y == ($!y - 1) && $x >= $!x && $x < ($!x + self.width));
  }
  method width { 3 }
  method height { 3 }
}

class EllStone does Stone {
  method covers (Int $x, Int $y) {
    ($x == ($!x + self.width - 1) && $y <= $!y && $y > ($!y - self.height))
    || ($y == ($!y - self.height + 1) && $x >= $!x && $x < ($!x + self.width));
  }
  method width { 3 }
  method height { 3 }
}

class PipeStone does Stone {
  method covers (Int $x, Int $y) { $x == $!x && $y <= $!y && $y > ($!y - self.height) }
  method width { 1 }
  method height { 4 }
}

class BlockStone does Stone {
  method covers (Int $x, Int $y) {
    $x >= $!x && $x < ($!x + self.width)
    && $y <= $!y && $y > ($!y - self.height);
  }
  method width { 2 }
  method height { 2 }
}

class Floor does Stone {
  method covers (Int $x, Int $y) { $y == $!y }
  method width { $max-width }
  method height { 1 }
}

# @stone-classes is rotated right once because $current-idx starts at position
# 1 instead of 0 to accommodate the floor
my @stone-classes = [BlockStone, BarStone, PlusStone, EllStone, PipeStone];
my @stones[$max-rocks + 1] of Stone;
my $current-idx = 1;
@stones[0] = Floor.new(x => 0, y => 0);

# create a new stone above all others
sub init-stone (Int $idx) {
  my $max-y = @stones[^$idx].map(*.y).max;
  my $klass = @stone-classes[$idx % @stone-classes.elems];
  $klass.new(x => $init-x, y => $max-y + $init-y + $klass.height);
}

# initialize the first stone
@stones[$current-idx] = init-stone($current-idx);

# keep track of what stones are at each y position
my %stones-at-y = 0 => [@stones[0]];
sub store-stone-at-y (Stone $stone) {
  for ($stone.y - $stone.height)^..$stone.y -> $y {
    %stones-at-y{$y} = [] unless %stones-at-y{$y}:exists;
    %stones-at-y{$y}.push: $stone;
  }
}

# check if the current stone overlaps any others
sub does-overlap (Stone $current-stone) {
  for ($current-stone.y - $current-stone.height)^..$current-stone.y -> $y {
    if %stones-at-y{$y}:exists {
      my @stones := %stones-at-y{$y};
      for @stones -> $stone {
        return True if $stone.overlaps($current-stone);
      }
    }
  }
  return False;
}

# try to move down
sub try-move-down (Stone $current-stone) {
  $current-stone.move-down;
  if does-overlap($current-stone) {
    $current-stone.move-up;
    return False;
  }
  return True;
}

# try to move left
sub try-move-left (Stone $current-stone) {
  if $current-stone.can-move-left {
    $current-stone.move-left;
    $current-stone.move-right if does-overlap($current-stone);
  }
}

# try to move right
sub try-move-right (Stone $current-stone) {
  if $current-stone.can-move-right {
    $current-stone.move-right;
    $current-stone.move-left if does-overlap($current-stone);
  }
}

# read input
my @inputs = 'input.txt'.IO.comb.list;
@inputs.pop if @inputs.tail eq "\n";

# This algo is unnecessarily complex because I took a guess that part 2 was
# going to change some dimension to be ridiculously large, thus making it
# impractical to build a giant 2d array, which is the more obvious approach.
# The downside is that I spent _entirely_ too long debugging this damn thing...
# hopefully it'll pay off in part 2!
my $idx = 0;
FLOW: loop {
  my $char = @inputs[$idx % @inputs.elems];
  $idx++;

  # push left or right
  my $current-stone = @stones[$current-idx];
  if $char eq '<' {
    try-move-left($current-stone);
  } elsif $char eq '>' {
    try-move-right($current-stone);
  }

  # try dropping
  unless try-move-down($current-stone) {
    # couldn't move down so this stone rests
    store-stone-at-y($current-stone);
    $current-idx++;
    last FLOW if $current-idx > $max-rocks;
    @stones[$current-idx] = init-stone($current-idx);
  }
}

say "Height: {@stones.map(*.y).max}";
