#!/usr/bin/env raku

=begin pod
The monkeys are back! You're worried they're going to try to steal your stuff
again, but it seems like they're just holding their ground and making various
monkey noises at you.

Eventually, one of the elephants realizes you don't speak monkey and comes over
to interpret. As it turns out, they overheard you talking about trying to find
the grove; they can show you a shortcut if you answer their riddle.

Each monkey is given a job: either to yell a specific number or to yell the
result of a math operation. All of the number-yelling monkeys know their number
from the start; however, the math operation monkeys need to wait for two other
monkeys to yell a number, and those two other monkeys might also be waiting on
other monkeys.

Your job is to work out the number the monkey named root will yell before the
monkeys figure it out themselves.

For example:

root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32

Each line contains the name of a monkey, a colon, and then the job of that
monkey:

=item A lone number means the monkey's job is simply to yell that number.
=item A job like aaaa + bbbb means the monkey waits for monkeys aaaa and bbbb
  to yell each of their numbers; the monkey then yells the sum of those two
  numbers.
=item aaaa - bbbb means the monkey yells aaaa's number minus bbbb's number.
=item Job aaaa * bbbb will yell aaaa's number multiplied by bbbb's number.
=item Job aaaa / bbbb will yell aaaa's number divided by bbbb's number.

So, in the above example, monkey drzm has to wait for monkeys hmdt and zczc to
yell their numbers. Fortunately, both hmdt and zczc have jobs that involve
simply yelling a single number, so they do this immediately: 32 and 2. Monkey
drzm can then yell its number by finding 32 minus 2: 30.

Then, monkey sjmn has one of its numbers (30, from monkey drzm), and already
has its other number, 5, from dbpl. This allows it to yell its own number by
finding 30 multiplied by 5: 150.

This process continues until root yells a number: 152.

However, your actual situation involves considerably more monkeys. What number
will the monkey named root yell?
=end pod

grammar Input {
  token TOP { <ident> ': ' <does> }
  token does { <num> || <operation> }
  rule operation {
    $<operand1>=<ident>
    <operator>
    $<operand2>=<ident>
  }
  token operator { '+' || '-' || '*' || '/' }
  token ident { <lower> ** 4 }
  token num { '-'? \d+ }
}

role Job {
  method run (%) { ... }
}

class NumJob does Job {
  has Int $.num is required;
  method run (%) { $!num }
}

class OperationJob does Job {
  has Str $.operand1 is required;
  has Str $.operand2 is required;
  has Str $.operator is required;
  has Int $.num;
  method run (%tree) {
    return $!num if $!num ~~ Int:D;

    my $value1 = %tree{$!operand1}.job.run(%tree);
    my $value2 = %tree{$!operand2}.job.run(%tree);
    $!num = do given $!operator {
      when '+' { $value1 + $value2 }
      when '-' { $value1 - $value2 }
      when '*' { $value1 * $value2 }
      when '/' { $value1 div $value2 }
    };
  }
}

class Monkey {
  has Str $.identifier is required;
  has Job $.job is required;
  method TOP (::?CLASS:U $klass: $/) {
    make $klass.new(identifier => $<ident>.made, job => $<does>.made)
  }
  method does (::?CLASS:U: $/) {
    make $<operation> ?? $<operation>.made !! NumJob.new(num => $<num>.made)
  }
  method operation (::?CLASS:U: $/) {
    make OperationJob.new(
      operand1 => $<operand1>.made,
      operand2 => $<operand2>.made,
      operator => $<operator>.made
    )
  }
  method operator (::?CLASS:U: $/) { make ~$/ }
  method ident (::?CLASS:U: $/) { make ~$/ }
  method num (::?CLASS:U: $/) { make +$/ }
}

my %tree = 'input.txt'.IO.lines.map({ Input.parse($_, actions => Monkey).made }).map({ $_.identifier => $_ });
my $result = %tree<root>.job.run(%tree);
say "Root will yell $result";
