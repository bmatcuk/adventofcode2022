#!/usr/bin/env raku

=begin pod
You and the elephants finally reach fresh air. You've emerged near the base of
a large volcano that seems to be actively erupting! Fortunately, the lava seems
to be flowing away from you and toward the ocean.

Bits of lava are still being ejected toward you, so you're sheltering in the
cavern exit a little longer. Outside the cave, you can see the lava landing in
a pond and hear it loudly hissing as it solidifies.

Depending on the specific compounds in the lava and speed at which it cools, it
might be forming obsidian! The cooling rate should be based on the surface area
of the lava droplets, so you take a quick scan of a droplet as it flies past
you (your puzzle input).

Because of how quickly the lava is moving, the scan isn't very good; its
resolution is quite low and, as a result, it approximates the shape of the lava
droplet with 1x1x1 cubes on a 3D grid, each given as its x,y,z position.

To approximate the surface area, count the number of sides of each cube that
are not immediately connected to another cube. So, if your scan were only two
adjacent cubes like 1,1,1 and 2,1,1, each cube would have a single side covered
and five sides exposed, a total surface area of 10 sides.

Here's a larger example:

2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5

In the above example, after counting up all the sides that aren't connected to
another cube, the total surface area is 64.

What is the surface area of your scanned lava droplet?
=end pod

my @input := 'input.txt'.IO.lines.map(*.split(',').map(&prefix:<+>).list).list;
my @dimensions = @input.reduce(&infix:<Zmax>) >>+>> 1;
my @area[|@dimensions] of Bool = ((False xx @dimensions[2]) xx @dimensions[1]) xx @dimensions[0];
for @input -> ($x, $y, $z) {
  @area[$x;$y;$z] = True;
}

sub exposed-faces (($x, $y, $z)) {
  my $total = 0;
  $total++ if $x == 0 || !@area[$x-1;$y;$z];
  $total++ if $x == @dimensions[0] - 1 || !@area[$x+1;$y;$z];
  $total++ if $y == 0 || !@area[$x;$y-1;$z];
  $total++ if $y == @dimensions[1] - 1 || !@area[$x;$y+1;$z];
  $total++ if $z == 0 || !@area[$x;$y;$z-1];
  $total++ if $z == @dimensions[2] - 1 || !@area[$x;$y;$z+1];
  return $total;
}

my $exposed = @input.map(&exposed-faces).sum;
say "Exposed faces: $exposed";
