# Math::Combinatorics

This module provides a few combinatoric functions.

## Functions

### multi-combinations

Also known as 'combinations with replacement', 'k-multicombinations', or 'multisubsets'

    say multicombinations(<A B C D>, 2);
    # OUTPUT: ((A A) (A B) (A C) (A D) (B B) (B C) (B D) (C C) (C D) (D D))

  > Implemented in NQP

### variations

Also known as 'k-permutations of n'. I opted to give this the more archaic name of `variations` rather than creating a multi of `permutations`.

    say variations(<A B C D>, 2);
    # OUTPUT: ((A B) (A C) (A D) (B A) (B C) (B D) (C A) (C B) (C D) (D A) (D B) (D C))

  > Implemented in NQP

### partitions

Also known as 'integer partitions'.

    say partitions(5);
    # OUTPUT: ((1 1 1 1 1) (1 1 1 2) (1 1 3) (1 2 2) (1 4) (2 3) (5))

  > Implemented in NQP

### derangements

Essentially the permutations where no element is in it's original place

    say derangements(<A B C D>)
    # OUTPUT: ((B A D C) (B C D A) (B D A C) (C A D B) (C D A B) (C D B A) (D A B C) (D C A B) (D C B A)) 

  > implemented in Raku

## NOTES

The goal of this module is to be something similar to Perl's [Algorithm::Combinatorics](https://metacpan.org/pod/Algorithm::Combinatorics), implemented in NQP for fast performance. Not all functions are implemented in NQP, and if there's a function you'd like to add, I'm happy to accept pull requests for more algorithms, even in pure Raku. I - or others - can always work towards translating them to NQP later as time permits.

## CAVEATS & LIMITATIONS

I held of on publishing this module for many years because I wanted to polish it, provide more functions, and implement faster `.skip` on things like permutations, where the n-th permutation in a sequence can be determined algorithmically. Unfortunately, I have learned that my life doesn't always permit the long periods of time to dedicate to this.

I'm not a core, and my skill with NQP is that of a beginner, so I may not have written _the most_ efficient, however the implementations written in NQP should at least be noticeably faster than most pure-Raku functions implementing the same algorithms.

As always - pull requests are welcome, both for new functions, and improvements to the existing ones.

## LICENSE

    The Artistic License 2.0

See LICENSE file in the repository for the full license text.
