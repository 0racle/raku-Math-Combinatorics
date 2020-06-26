unit module Math::Combinatorics::Utils;

sub factorial(int \n) is export { [×] 1 .. n }

sub subfactorial(int \n) is export {
    (1, 0, 1, -> $a, $b { ($++ + 2) * ($b + $a) } ... *)[n]
}
