#!/usr/bin/env raku

=begin pod
Now, you just need to put all of the packets in the right order. Disregard the
blank lines in your list of received packets.

The distress signal protocol also requires that you include two additional
divider packets:

[[2]]
[[6]]

Using the same rules as before, organize all packets - the ones in your list of
received packets as well as the two divider packets - into the correct order.

For the example above, the result of putting the packets in the correct order
is:

[]
[[]]
[[[]]]
[1,1,3,1,1]
[1,1,5,1,1]
[[1],[2,3,4]]
[1,[2,[3,[4,[5,6,0]]]],8,9]
[1,[2,[3,[4,[5,6,7]]]],8,9]
[[1],4]
[[2]]
[3]
[[4,4],4,4]
[[4,4],4,4,4]
[[6]]
[7,7,7]
[7,7,7,7]
[[8,7,6]]
[9]

Afterward, locate the divider packets. To find the decoder key for this
distress signal, you need to determine the indices of the two divider packets
and multiply them together. (The first packet is at index 1, the second packet
is at index 2, and so on.) In this example, the divider packets are 10th and
14th, and so the decoder key is 140.

Organize all of the packets into the correct order. What is the decoder key for
the distress signal?
=end pod

grammar Decoder {
  token TOP { '[' ~ ']' <lst> }
  token lst { [ <val> [ ',' <val> ]* ]? }
  token val { <num> || <TOP> }
  token num { \d+ }
}

class Message {
  method TOP ($/) { make $<lst>.made }
  method lst ($/) { make $<val>.map(*.made).list }
  method val ($/) { make $<TOP> ?? $<TOP>.made !! $<num>.made }
  method num ($/) { make +$/ }
}

sub cmp-msgs (@msg1, @msg2) {
  for @msg1 Z @msg2 -> [$item1, $item2] {
    my Order $result;
    if $item1 ~~ List || $item2 ~~ List {
      $result = cmp-msgs($item1.list, $item2.list);
    } else {
      $result = $item1 cmp $item2;
    }
    return $result if $result == Order::Less || $result == Order::More;
  }
  return @msg1.elems cmp @msg2.elems;
}

my @divider1 = ((2,),);
my @divider2 = ((6,),);
my @packets = 'input.txt'.IO.lines.grep(/.+/).map({ Decoder.parse($_, actions => Message).made }).Array;
@packets.push: @divider1, @divider2;
@packets = @packets.sort: &cmp-msgs;

my $idx1 = 1 + @packets.first: { cmp-msgs($_, @divider1) == Order::Same }, :k;
my $idx2 = 1 + @packets.first: { cmp-msgs($_, @divider2) == Order::Same }, :k;
say "Decoder key: $idx1 * $idx2 = {$idx1 * $idx2}";
