# Advent of Code, 2022 :christmas_tree:
My solutions to the [Advent of Code 2022] in [Raku].

I like to use the Advent of Code as a learning opportunity. This year, I
decided on learning [Raku]. I have zero experience with the language.

## Retrospective :santa:
[Raku] is a fun language. Built-in support for big numbers was nice for several
AoC challenges, as were several concise and powerful language constructs. I
found the language to be fairly easy to pick up. The grammar parsing and regex
engine are hella powerful, and I really enjoyed using them to great effect for
input parsing in many of the puzzles.

That said, the regex language in Raku is unlike any other, so it had a small
learning curve. I found the associative sigils to be a little confusing: the
documentation often uses `$` and `%` interchangeably for Maps/Hashes/Sets/etc.
What's the difference? I also found that sometimes I'd end up with results
wrapped in an extra Array or List - like, I was expecting an Array, but what I
got was an Array with a single element (which was the Array I was expecting)
and it took me a while to realize I could "fix" that by using `:=` binding
instead of regular `=` assignment and I'm still not sure why? Lastly, the
performance of Hashes was fairly abysmal. I remember one of the days, I tried
to speed up my algo by memoizing the main function with a Hash. Despite getting
many cache-hits, the overall algo was actually _slower_ because of the Hash
performance. I've read that, under the hood, Hash keys are always converted to
strings - perhaps that's the issue? In some later days, I started explicitly
defining the key type (such as `Hash[Type]`) and that seemed to maybe help? But
it's hard to say for certain since it was a different problem.

Anyway, I enjoyed [Raku]. Another tool for the toolbox!

:snowman_with_snow:

[Advent of Code 2022]: https://adventofcode.com/2022
[Raku]: https://raku.org/
