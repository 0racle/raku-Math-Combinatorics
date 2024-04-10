
my @EXPORT_OK = <
    multicombinations partitions derangements variations permutations
    factorial subfactorial
>;

my %exportable;
module Math::Combinatorics:ver<0.0.8> {
    use Math::Combinatorics::Multicombinations;
    use Math::Combinatorics::Variations;
    use Math::Combinatorics::Partitions;
    use Math::Combinatorics::Derangements;
    use Math::Combinatorics::Utils;

    %exportable = @EXPORT_OK.map({ $_ => ::("&$_") });

    my package EXPORT::ALL {
        for %exportable.keys -> $f {
            OUR::{"&$f"} := ::{"&$f"};
        }
    }
}

multi sub EXPORT(*@names --> Map()) {
    do for @names -> $name {
        unless %exportable{ $name }:exists {
            die("Unknown name for export: '$name'");
        }
        "&$name" => %exportable{ $name }
    }
}
