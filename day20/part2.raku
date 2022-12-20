#!/usr/bin/env raku

=begin pod
The grove coordinate values seem nonsensical. While you ponder the mysteries of
Elf encryption, you suddenly remember the rest of the decryption routine you
overheard back at camp.

First, you need to apply the decryption key, 811589153. Multiply each number by
the decryption key before you begin; this will produce the actual list of
numbers to mix.

Second, you need to mix the list of numbers ten times. The order in which the
numbers are mixed does not change during mixing; the numbers are still moved in
the order they appeared in the original, pre-mixed list. (So, if -3 appears
fourth in the original list of numbers to mix, -3 will be the fourth number to
move during each round of mixing.)

Using the same example as above:

Initial arrangement:
811589153, 1623178306, -2434767459, 2434767459, -1623178306, 0, 3246356612

After 1 round of mixing:
0, -2434767459, 3246356612, -1623178306, 2434767459, 1623178306, 811589153

After 2 rounds of mixing:
0, 2434767459, 1623178306, 3246356612, -2434767459, -1623178306, 811589153

After 3 rounds of mixing:
0, 811589153, 2434767459, 3246356612, 1623178306, -1623178306, -2434767459

After 4 rounds of mixing:
0, 1623178306, -2434767459, 811589153, 2434767459, 3246356612, -1623178306

After 5 rounds of mixing:
0, 811589153, -1623178306, 1623178306, -2434767459, 3246356612, 2434767459

After 6 rounds of mixing:
0, 811589153, -1623178306, 3246356612, -2434767459, 1623178306, 2434767459

After 7 rounds of mixing:
0, -2434767459, 2434767459, 1623178306, -1623178306, 811589153, 3246356612

After 8 rounds of mixing:
0, 1623178306, 3246356612, 811589153, -2434767459, 2434767459, -1623178306

After 9 rounds of mixing:
0, 811589153, 1623178306, -2434767459, 3246356612, 2434767459, -1623178306

After 10 rounds of mixing:
0, -2434767459, 1623178306, 3246356612, -1623178306, 2434767459, 811589153

The grove coordinates can still be found in the same way. Here, the 1000th
number after 0 is 811589153, the 2000th is 2434767459, and the 3000th is
-1623178306; adding these together produces 1623178306.

Apply the decryption key and mix your encrypted file ten times. What is the sum
of the three numbers that form the grove coordinates?
=end pod

constant $decryption-key = 811589153;
constant $mix = 10;

my @input = 'input.txt'.IO.lines.map(* * $decryption-key);
my $len = @input.elems;
my @orig-idx-to-new = ^$len;
my @new-idx-to-orig = ^$len;
my $zero-idx = -1;
for ^$mix {
  for @input.kv -> $k, $v is copy {
    say $k if $k %% 100;

    # this works with positive and negative numbers since $multiples will have
    # the same sign as $v
    while $v <= -$len || $v >= $len {
      my $multiples = ($v / $len).truncate;
      $v = $v - $len * $multiples + $multiples;
    }

    my $current-idx = @orig-idx-to-new[$k];
    my $next-idx = $current-idx + $v;
    my $prev-idx = $current-idx;
    for $current-idx^...$next-idx -> $new-idx is copy {
      $new-idx %= $len;
      my $orig-idx = @new-idx-to-orig[$new-idx];
      @orig-idx-to-new[$orig-idx] = $prev-idx;
      @new-idx-to-orig[$prev-idx] = $orig-idx;
      $prev-idx = $new-idx;
    }

    @orig-idx-to-new[$k] = $next-idx % $len;
    @new-idx-to-orig[@orig-idx-to-new[$k]] = $k;
    $zero-idx = $k if $v == 0;
  }
}

$zero-idx = @orig-idx-to-new[$zero-idx];
my @coord-idxs = @new-idx-to-orig[((1000, 2000, 3000) >>+>> $zero-idx) >>%>> $len];
say "Coords: {@input[@coord-idxs].sum}";
