#!/usr/bin/env raku

=begin pod
The elephants are not impressed by your simulation. They demand to know how
tall the tower will be after 1000000000000 rocks have stopped! Only then will
they feel confident enough to proceed through the cave.

In the example above, the tower would be 1514285714288 units tall!

How tall will the tower be after 1000000000000 rocks have stopped?
=end pod

constant $max-rocks = 1000000000000;
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

class FloorState {
  has $.settled-rocks is required;
  has $.max-height is required;
  has $.stone-idx is required;
  has $.flow-idx is required;
  has $.floor is required;
}

# array of stone classes in order and a rotating index into that array
constant @stone-classes = [BarStone, PlusStone, EllStone, PipeStone, BlockStone];
my $stone-idx = 0;

# keep track of maximum height
my $max-height = 0;

# keep track of what stones are at each y position
my %stones-at-y = 0 => [Floor.new(x => 0, y => 0)];
sub store-stone-at-y (Stone $stone) {
  for ($stone.y - $stone.height)^..$stone.y -> $y {
    %stones-at-y{$y} = [] unless %stones-at-y{$y}:exists;
    %stones-at-y{$y}.push: $stone;
  }
}

# create a new stone above all others
sub init-stone (Int $idx) {
  my $klass = @stone-classes[$idx];
  $klass.new(x => $init-x, y => $max-height + $init-y + $klass.height);
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

# check if there's a completely filled row
sub check-for-floor (@yrange) {
  for @yrange -> $y {
    my @stones := %stones-at-y{$y};
    return $y if all (^$max-width).map(-> $x {
      so any @stones.map(*.covers($x, $y))
    });
  }
  return -1;
}

# read input
my @inputs = 'input.txt'.IO.comb.list;
@inputs.pop if @inputs.tail eq "\n";

# I dunno if my algo from part 1 was worth all the trouble, but by the time I
# started hacking on part 2, I realized there was a ton I could rip out. This
# version is improved in every way, but still maintains a lot of the
# complexity. Oh well.
my $current-stone = init-stone($stone-idx);
my @floor-states of FloorState;
my $cycle-found = False;
my $settled-rocks = 0;
my $flow-idx = 0;
FLOW: loop {
  my $char = @inputs[$flow-idx];

  # push left or right
  if $char eq '<' {
    try-move-left($current-stone);
  } elsif $char eq '>' {
    try-move-right($current-stone);
  }

  # try dropping
  unless try-move-down($current-stone) {
    # couldn't move down so this stone rests
    $max-height = $current-stone.y if $current-stone.y > $max-height;
    store-stone-at-y($current-stone);
    $settled-rocks++;
    last FLOW if $settled-rocks >= $max-rocks;

    # check for a new floor
    my $floor = check-for-floor(($current-stone.y - $current-stone.height)^..$current-stone.y);
    if $floor > 0 {
      # if we've found a floor, we can forget everything below it by removing
      # lower y values from %stones-at-y
      for $floor^...0 -> $y {
        if %stones-at-y{$y}:exists {
          %stones-at-y{$y}:delete;
        } else {
          last;
        }
      }

      unless $cycle-found {
        my $cycle = @floor-states.first({ $_.stone-idx == $stone-idx && $_.flow-idx == $flow-idx });
        if $cycle {
          say "CYCLE FOUND";
          my $rocks-in-cycle = $settled-rocks - $cycle.settled-rocks;
          my $repeat = ($max-rocks - $settled-rocks) div $rocks-in-cycle;
          my $height-adjust = ($max-height - $cycle.max-height) * $repeat;
          $settled-rocks += $rocks-in-cycle * $repeat;
          $max-height += $height-adjust;
          $cycle-found = True;
          for %stones-at-y.keys -> $y {
            my @stones := %stones-at-y{$y};
            %stones-at-y{$y}:delete;
            for @stones.keys -> $i {
              @stones[$i] = @stones[$i].clone(y => @stones[$i].y + $height-adjust);
            }
            %stones-at-y{$y + $height-adjust} = @stones;
          }
        } else {
          @floor-states.push: FloorState.new(:$settled-rocks, :$max-height, :$stone-idx, :$flow-idx, :$floor);
        }
      }
    }

    $stone-idx = ($stone-idx + 1) % @stone-classes.elems;
    $current-stone = init-stone($stone-idx);
  }

  $flow-idx = ($flow-idx + 1) % @inputs.elems;
}

say "Height: $max-height";
