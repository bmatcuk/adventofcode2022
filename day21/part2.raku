#!/usr/bin/env raku

=begin pod
Due to some kind of monkey-elephant-human mistranslation, you seem to have
misunderstood a few key details about the riddle.

First, you got the wrong job for the monkey named root; specifically, you got
the wrong math operation. The correct operation for monkey root should be =,
which means that it still listens for two numbers (from the same two monkeys as
before), but now checks that the two numbers match.

Second, you got the wrong monkey for the job starting with humn:. It isn't a
monkey - it's you. Actually, you got the job wrong, too: you need to figure out
what number you need to yell so that root's equality check passes. (The number
that appears after humn: in your input is now irrelevant.)

In the above example, the number you need to yell to pass root's equality test
is 301. (This causes root to get the same number, 150, from both of its
monkeys.)

What number do you yell to pass root's equality test?
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

my %parents;
my %tree = 'input.txt'.IO.lines.map({
  my $monkey = Input.parse($_, actions => Monkey).made;
  if $monkey.job ~~ OperationJob {
    %parents{$monkey.job.operand1} = $monkey.identifier;
    %parents{$monkey.job.operand2} = $monkey.identifier;
  }
  $monkey.identifier => $monkey
});

# starting with the humn node, walk up the tree and rearrange nodes to place
# the humn on top
my $current = 'humn';
while %parents{$current}:exists {
  my $parent = %tree{%parents{$current}};
  my $is-left-operand = $parent.job.operand1 eq $current;
  if $parent.identifier eq 'root' {
    # if the parent is root, calculate the other half of the tree and make this
    # node a regular number node, then we can quit walking
    my $other-side = %tree{$is-left-operand ?? $parent.job.operand2 !! $parent.job.operand1};
    my $num = $other-side.job.run(%tree);
    %tree{$current} = Monkey.new(identifier => $current, job => NumJob.new(:$num));
    last;
  }

  my $operand-name = $parent.identifier eq 'root'
    ?? ($is-left-operand ?? $parent.job.operand2 !! $parent.job.operand1)
    !! $parent.identifier;
  my $new-monkey = do given $parent.job.operator {
    when '+' {
      Monkey.new(
        identifier => $current,
        job => OperationJob.new(
          operand1 => $operand-name,
          operand2 => $is-left-operand ?? $parent.job.operand2 !! $parent.job.operand1,
          operator => '-'
        ),
      )
    }
    when '-' {
      Monkey.new(
        identifier => $current,
        job => OperationJob.new(
          operand1 => $is-left-operand ?? $operand-name !! $parent.job.operand1,
          operand2 => $is-left-operand ?? $parent.job.operand2 !! $operand-name,
          operator => $is-left-operand ?? '+' !! '-',
        ),
      )
    }
    when '*' {
      Monkey.new(
        identifier => $current,
        job => OperationJob.new(
          operand1 => $operand-name,
          operand2 => $is-left-operand ?? $parent.job.operand2 !! $parent.job.operand1,
          operator => '/',
        ),
      )
    }
    when '/' {
      Monkey.new(
        identifier => $current,
        job => OperationJob.new(
          operand1 => $is-left-operand ?? $operand-name !! $parent.job.operand1,
          operand2 => $is-left-operand ?? $parent.job.operand2 !! $operand-name,
          operator => $is-left-operand ?? '*' !! '/',
        ),
      )
    }
  };
  %tree{$new-monkey.identifier} = $new-monkey;
  $current = $parent.identifier;
}

my $result = %tree<humn>.job.run(%tree);
say "Human should yell $result";
