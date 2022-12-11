#!/usr/bin/env raku

=begin pod
You're worried you might not ever get your items back. So worried, in fact,
that your relief that a monkey's inspection didn't damage an item no longer
causes your worry level to be divided by three.

Unfortunately, that relief was all that was keeping your worry levels from
reaching ridiculous levels. You'll need to find another way to keep your worry
levels manageable.

At this rate, you might be putting up with these monkeys for a very long time -
possibly 10000 rounds!

With these new rules, you can still figure out the monkey business after 10000
rounds. Using the same example above:

== After round 1 ==
Monkey 0 inspected items 2 times.
Monkey 1 inspected items 4 times.
Monkey 2 inspected items 3 times.
Monkey 3 inspected items 6 times.

== After round 20 ==
Monkey 0 inspected items 99 times.
Monkey 1 inspected items 97 times.
Monkey 2 inspected items 8 times.
Monkey 3 inspected items 103 times.

== After round 1000 ==
Monkey 0 inspected items 5204 times.
Monkey 1 inspected items 4792 times.
Monkey 2 inspected items 199 times.
Monkey 3 inspected items 5192 times.

== After round 2000 ==
Monkey 0 inspected items 10419 times.
Monkey 1 inspected items 9577 times.
Monkey 2 inspected items 392 times.
Monkey 3 inspected items 10391 times.

== After round 3000 ==
Monkey 0 inspected items 15638 times.
Monkey 1 inspected items 14358 times.
Monkey 2 inspected items 587 times.
Monkey 3 inspected items 15593 times.

== After round 4000 ==
Monkey 0 inspected items 20858 times.
Monkey 1 inspected items 19138 times.
Monkey 2 inspected items 780 times.
Monkey 3 inspected items 20797 times.

== After round 5000 ==
Monkey 0 inspected items 26075 times.
Monkey 1 inspected items 23921 times.
Monkey 2 inspected items 974 times.
Monkey 3 inspected items 26000 times.

== After round 6000 ==
Monkey 0 inspected items 31294 times.
Monkey 1 inspected items 28702 times.
Monkey 2 inspected items 1165 times.
Monkey 3 inspected items 31204 times.

== After round 7000 ==
Monkey 0 inspected items 36508 times.
Monkey 1 inspected items 33488 times.
Monkey 2 inspected items 1360 times.
Monkey 3 inspected items 36400 times.

== After round 8000 ==
Monkey 0 inspected items 41728 times.
Monkey 1 inspected items 38268 times.
Monkey 2 inspected items 1553 times.
Monkey 3 inspected items 41606 times.

== After round 9000 ==
Monkey 0 inspected items 46945 times.
Monkey 1 inspected items 43051 times.
Monkey 2 inspected items 1746 times.
Monkey 3 inspected items 46807 times.

== After round 10000 ==
Monkey 0 inspected items 52166 times.
Monkey 1 inspected items 47830 times.
Monkey 2 inspected items 1938 times.
Monkey 3 inspected items 52013 times.

After 10000 rounds, the two most active monkeys inspected items 52166 and 52013
times. Multiplying these together, the level of monkey business in this
situation is now 2713310158.

Worry levels are no longer divided by three after each item is inspected;
you'll need to find another way to keep your worry levels manageable. Starting
again from the initial state in your puzzle input, what is the level of monkey
business after 10000 rounds?
=end pod

grammar MonkeyRules {
  rule TOP {
    <header>
    <items>
    <operation>
    <test>
    <iftrue>
    <iffalse>
  }
  rule header { 'Monkey' <num> ':' }
  rule items { 'Starting' 'items:' <list> }
  rule list { <num> [ ',' <num> ]* }
  rule operation { 'Operation:' 'new' '=' 'old' <operator> <operand> }
  token operator { [ '+' | '*' ] }
  token operand { [ <num> | 'old' ] }
  rule test { 'Test:' 'divisible' 'by' <num> }
  rule iftrue { 'If' 'true:' <throw> }
  rule iffalse { 'If' 'false:' <throw> }
  rule throw { 'throw' 'to' 'monkey' <num> }
  token num { \d+ }
}

class Monkey {
  has $.considerations = 0;
  has @.items is required;
  has &.operation is required;
  has $.test is required;
  has $.iftrue is required;
  has $.iffalse is required;
  method throw-items (@monkeys, $lcm) {
    for @!items -> $item {
      my $worry = &!operation($item) % $lcm;
      my $throw-to = $worry %% $!test ?? $!iftrue !! $!iffalse;
      @monkeys[$throw-to].items.push: $worry;
      $!considerations++;
    }
    @!items = [];
  }
}

sub add ($num) { sub { $^a + $num } }
sub prod ($num) { sub { $^a * $num } }
sub square ($num) { $num * $num }

class Monkeys {
  has @.monkeys;
  method TOP ($/) {
    my $num = $<header>.made;
    my &operation = $<operation>.made;
    my $monkey = Monkey.new(
      items => $<items>.made,
      operation => &operation,
      test => $<test>.made,
      iftrue => $<iftrue>.made,
      iffalse => $<iffalse>.made
    );
    @!monkeys[$num] = $monkey;
  }
  method header ($/) { make $<num>.made }
  method items ($/) { make $<list>.made }
  method list ($/) { make $/.split(', ', :skip-empty).map(+*) }
  method operation ($/) {
    if $<operand> eq 'old' {
      make &square;
    } elsif $<operator> eq '+' {
      make add($<operand>.made);
    } else {
      make prod($<operand>.made);
    }
  }
  method operand ($/) { make($/ eq 'old' ?? $/ !! $<num>) }
  method test ($/) { make $<num>.made }
  method iftrue ($/) { make $<throw>.made }
  method iffalse ($/) { make $<throw>.made }
  method throw ($/) { make $<num>.made }
  method num ($/) { make +$/ }

  method run ($rounds) {
    # Say I want to know if X is evenly divisible by Y. I can ask the same
    # question of X mod Y and that won't change the answer. Now say I want to
    # know if X is evenly divisible by either Y *or* Z: in this case, X mod
    # lcm(Y,Z) won't change the answer.
    #
    # So, the idea is to modulo each worry by the lcm of all of the monkeys'
    # test values at each step so that the worry value doesn't grow out of
    # control.
    my $lcm = @!monkeys.map(*.test).reduce(&infix:<lcm>);
    for ^$rounds {
      .throw-items(@!monkeys, $lcm) for @!monkeys;
    }
  }
}

my $actions = Monkeys.new;
my @lines;
for 'input.txt'.IO.lines -> $line {
  if $line {
    @lines.push: $line;
  } else {
    MonkeyRules.parse(@lines.join("\n"), actions => $actions);
    @lines = [];
  }
}
MonkeyRules.parse(@lines.join("\n"), actions => $actions);
$actions.run: 10000;

my @monkeys = $actions.monkeys.map(*.considerations).sort;
say "Monkey business: {@monkeys.tail(2).reduce(&infix:<*>)}";
