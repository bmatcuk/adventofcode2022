#!/usr/bin/env raku

=begin pod
Something seems off about your calculation. The cooling rate depends on
exterior surface area, but your calculation also included the surface area of
air pockets trapped in the lava droplet.

Instead, consider only cube sides that could be reached by the water and steam
as the lava droplet tumbles into the pond. The steam will expand to reach as
much as possible, completely displacing any air on the outside of the lava
droplet but never expanding diagonally.

In the larger example above, exactly one cube of air is trapped within the lava
droplet (at 2,2,5), so the exterior surface area of the lava droplet is 58.

What is the exterior surface area of your scanned lava droplet?
=end pod

my @input := 'input.txt'.IO.lines.map(*.split(',').map(&prefix:<+>).list).list;
my @dimensions = @input.reduce(&infix:<Zmax>) >>+>> 1;
my @area[|@dimensions] of Bool = ((False xx @dimensions[2]) xx @dimensions[1]) xx @dimensions[0];
for @input -> ($x, $y, $z) {
  @area[$x;$y;$z] = True;
}

# track points that are inside the shape
my @inside[|@dimensions] of Bool = ((True xx @dimensions[2]) xx @dimensions[1]) xx @dimensions[0];
sub cast-ray (@xrange, @yrange, @zrange) {
  my @possibly-false;
  my $prev-area = False;
  my $in = False;
  for @xrange -> $x {
    for @yrange -> $y {
      for @zrange -> $z {
        my $this-area = @area[$x;$y;$z];
        if $prev-area && !$this-area {
          $in = True;
        } elsif !$prev-area && $this-area {
          $in = False;
          @possibly-false = [];
        }
        $prev-area = $this-area;
        @possibly-false.push(($x, $y, $z)) if $in;
        @inside[$x;$y;$z] = False unless $in;
      }
    }
  }

  # from the last edge of the shape to the edge of the area, $in will be True
  # even though those spaces are not inside, so we take care of that here
  for @possibly-false -> ($x, $y, $z) {
    @inside[$x;$y;$z] = False;
  }
}

# ray-casting from every possible direction to determine what spaces are inside
for ^@dimensions[0] -> $x {
  cast-ray([$x], [$_], ^@dimensions[2]) for ^@dimensions[1];
  cast-ray([$x], ^@dimensions[1], [$_]) for ^@dimensions[2];
}
for ^@dimensions[1] -> $y {
  cast-ray([$_], [$y], ^@dimensions[2]) for ^@dimensions[0];
  cast-ray(^@dimensions[0], [$y], [$_]) for ^@dimensions[2];
}
for ^@dimensions[2] -> $z {
  cast-ray([$_], ^@dimensions[1], [$z]) for ^@dimensions[0];
  cast-ray(^@dimensions[0], [$_], [$z]) for ^@dimensions[1];
}

sub exposed-face ($x, $y, $z) {
  !@area[$x;$y;$z] && !@inside[$x;$y;$z]
}

sub exposed-faces (($x, $y, $z)) {
  my $total = 0;
  $total++ if $x == 0 || exposed-face($x - 1, $y, $z);
  $total++ if $x == @dimensions[0] - 1 || exposed-face($x + 1, $y, $z);
  $total++ if $y == 0 || exposed-face($x, $y - 1, $z);
  $total++ if $y == @dimensions[1] - 1 || exposed-face($x, $y + 1, $z);
  $total++ if $z == 0 || exposed-face($x, $y, $z - 1);
  $total++ if $z == @dimensions[2] - 1 || exposed-face($x, $y, $z + 1);
  return $total;
}

my $exposed = @input.map(&exposed-faces).sum;
say "Exposed faces: $exposed";
