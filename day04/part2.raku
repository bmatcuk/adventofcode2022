#!/usr/bin/env raku

=begin pod
It seems like there is still quite a bit of duplicate work planned. Instead,
the Elves would like to know the number of pairs that overlap at all.

In the above example, the first two pairs (2-4,6-8 and 2-3,4-5) don't overlap,
while the remaining four pairs (5-7,7-9, 2-8,3-7, 6-6,4-6, and 2-6,4-8) do
overlap:

5-7,7-9 overlaps in a single section, 7.
2-8,3-7 overlaps all of the sections 3 through 7.
6-6,4-6 overlaps in a single section, 6.
2-6,4-8 overlaps in sections 4, 5, and 6.

So, in this example, the number of overlapping assignment pairs is 4.

In how many assignment pairs do the ranges overlap?
=end pod

my regex Input {
  $<start1> = (\d+)
  \-
  $<end1> = (\d+)
  \,
  $<start2> = (\d+)
  \-
  $<end2> = (\d+)
}

my $count = 0;
for 'input.txt'.IO.lines -> $line {
  $line ~~ &Input;
  my ($elf1, $elf2) = ($<start1>..$<end1>, $<start2>..$<end2>);
  if ($elf1 (&) $elf2).elems > 0 {
    $count++;
  }
}

say "Duplicated work: $count";
