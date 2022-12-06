#!/usr/bin/env raku

=begin pod
Your device's communication system is correctly detecting packets, but still
isn't working. It looks like it also needs to look for messages.

A start-of-message marker is just like a start-of-packet marker, except it
consists of 14 distinct characters rather than 4.

Here are the first positions of start-of-message markers for all of the above
examples:

=item mjqjpqmgbljsphdztnvjfqwrcgsmlb: first marker after character 19
=item bvwbjplbgvbhsrlpgdmjqwftvncz: first marker after character 23
=item nppdvjthqldpwncqszvftbrmjlhg: first marker after character 23
=item nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg: first marker after character 29
=item zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw: first marker after character 26

How many characters need to be processed before the first start-of-message
marker is detected?
=end pod

my $marker = 0;
my @chars = '' xx 14;
for 'input.txt'.IO.comb -> $char {
  @chars[$marker mod 14] = $char;
  $marker++;
  next if $marker < 14;
  last if @chars.Set.elems == 14;
}
say "Start of packet ends at position: $marker";
