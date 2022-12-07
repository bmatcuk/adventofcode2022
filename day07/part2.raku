#!/usr/bin/env raku

=begin pod
Now, you're ready to choose a directory to delete.

The total disk space available to the filesystem is 70000000. To run the
update, you need unused space of at least 30000000. You need to find a
directory you can delete that will free up enough space to run the update.

In the example above, the total size of the outermost directory (and thus the
total amount of used space) is 48381165; this means that the size of the unused
space must currently be 21618835, which isn't quite the 30000000 required by
the update. Therefore, the update still requires a directory with total size of
at least 8381165 to be deleted before it can run.

To achieve this, you have the following options:

=item Delete directory e, which would increase unused space by 584.
=item Delete directory a, which would increase unused space by 94853.
=item Delete directory d, which would increase unused space by 24933642.
=item Delete directory /, which would increase unused space by 48381165.

Directories e and a are both too small; deleting them would not free up enough
space. However, directories d and / are both big enough! Between these, choose
the smallest: d, increasing unused space by 24933642.

Find the smallest directory that, if deleted, would free up enough space on the
filesystem to run the update. What is the total size of that directory?
=end pod

grammar Filesystem {
  rule TOP { [ <cd> | <ls> | <dir> | <file> ] }
  proto rule cd           { * }
        rule cd:sym<up>   { <cmd> 'cd' '..' }
        rule cd:sym<root> { <cmd> 'cd' '/' }
        rule cd:sym<down> { <cmd> 'cd' <path> }
  rule ls { <cmd> 'ls' }
  rule dir { 'dir' <path> }
  rule file { <size> <path> }
  token cmd { '$' }
  token path { <[\w.]>+ }
  token size { \d+ }
}

class FilesystemActions {
  has Int %.sizes{Str};
  has @!path = [''];
  method cd:sym<up> ($/) { @!path.pop }
  method cd:sym<root> ($/) { @!path = [''] }
  method cd:sym<down> ($/) { @!path.push: $<path> }
  method file ($/) { %!sizes{@!path[0..$_].join('/')} += $<size> for ^@!path.elems }
}

my $actions = FilesystemActions.new;
for 'input.txt'.IO.lines -> $line {
  Filesystem.parse($line, actions => $actions);
}

constant $total-space = 70000000;
constant $update = 30000000;
my $free-space = $total-space - $actions.sizes{''};
my $needed-space = $update - $free-space;
my $smallest-delete = $actions.sizes.values.grep(* >= $needed-space).sort[0];
say "Smallest directory to delete: $smallest-delete";
