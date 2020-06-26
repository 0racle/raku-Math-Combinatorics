use v6.c;
use Test;
use lib $?FILE.IO.parent ~ '/../lib';
use Math::Combinatorics :ALL;

is-deeply
  multicombinations(<A B C D>, 2),
  (<A A>, <A B>, <A C>, <A D>, <B B>, <B C>, <B D>, <C C>, <C D>, <D D>),
  'multicombinations pick 2'
;

is-deeply
  multicombinations(<A B C D>, 3),
  (<A A A>, <A A B>, <A A C>, <A A D>, <A B B>, <A B C>, <A B D>,
   <A C C>, <A C D>, <A D D>, <B B B>, <B B C>, <B B D>, <B C C>,
   <B C D>, <B D D>, <C C C>, <C C D>, <C D D>, <D D D>),
  'multicombinations pick 3'
;

is-deeply
  variations(<A B C D>, 2),
  (<A B>, <A C>, <A D>, <B A>, <B C>, <B D>, <C A>, <C B>, <C D>, <D A>, <D B>, <D C>),
  'variations pick 2'
;

is-deeply
  variations(<A B C>, 3), (<A B C>).permutations,
  'variations(n,k) where n == k is eqv to permutations(n)'
;

{
    my @l = <A B>;
    my $k = 2;
    my $c = multicombinations(@l, $k).iterator;
    my @c = multicombinations(@l, $k);

    TEST-ITER-OPT($c, @c, @c.elems, 'multi-combinations Iterator methods');
}

{
    my @l = <A B C>;
    my $k = 2;
    my $v = variations(@l, $k).iterator;
    my @v = variations(@l, $k);

    TEST-ITER-OPT($v, @v, @v.elems, 'multi-combinations Iterator methods');
}

sub TEST-ITER-OPT (\iter, \data, \n, $desc,) {
    subtest $desc => {
        plan 5 + 2*n + ($_ with data);
        sub count (\v, $desc) {
            iter.can('count-only')
              ?? is-deeply iter.count-only, v, "count  ($desc)"
              !! skip "iterator does not support .count-only ($desc)";
        }
        sub bool (\v, $desc) {
            iter.can('bool-only')
              ?? is-deeply iter.bool-only, v, "bool   ($desc)"
              !! skip "iterator does not support .bool-only ($desc)";
        }
        for ^n -> $i {
            count  n-$i,  "before pull $i";
            bool ?(n-$i), "before pull $i";
            data andthen is-deeply iter.pull-one, data[$i], "pulled (pull $i)"
                 orelse  iter.pull-one;
        }
        count  0, 'after last pull';
        bool  ?0, 'after last pull';
        ok iter.pull-one =:= IterationEnd, 'one more pull gives IterationEnd';
        count  0, 'after IterationEnd';
        bool  ?0, 'after IterationEnd';
    }
}

done-testing;

# vim: ft=raku
