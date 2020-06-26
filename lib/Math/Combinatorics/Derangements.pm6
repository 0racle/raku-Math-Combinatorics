unit module Math::Combinatorics::Derangements;

use Math::Combinatorics::Utils;

proto sub derangements(Positional) is export {*}

multi sub derangements(@l) {
    my @sum-alt-facs = (1, 1, -> $a, $ { factorial($++ + 2) + $a } ... *);

    my $iter = permutations(@l).skip(@sum-alt-facs[@l.end]).grep(-> @p {
        not @l.keys.first(-> $k { @p[$k] eqv @l[$k] }).defined
    }).iterator;

    Seq.new: class :: does Iterator {
        has $!todo = subfactorial(@l.elems);
        method pull-one {
            $!todo--;
            $iter.pull-one;
        }
        method count-only {
            $!todo > 0 ?? $!todo !! 0;
        }
    }.new()
}
