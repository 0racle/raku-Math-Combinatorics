unit module Math::Combinatorics::Partitions;

use nqp;

proto sub partitions(Int) is export {*}

multi sub partitions($n) {
    Seq.new: class :: does Iterator {
        has $!i;
        has $!k;
        has $!x;
        has $!y;
        has $!v;
        has $!todo;
        method SET-SELF(int \n) {
            nqp::stmts(
                ($!v := nqp::setelems(nqp::create(IterationBuffer),n)),
                ($!i = -1),
                nqp::while(
                    nqp::islt_i(($!i := nqp::add_i($!i,1)),n),
                    nqp::bindpos($!v,$!i,0)
                ),
                nqp::bindpos($!v,1,n),
                ($!k := 1),
                self
            )
        }
        method new(\n) { nqp::create(self).SET-SELF(n) }
        method sink-all { IterationEnd }
        method bool-only {
            self.count-only.Bool;
        }
        method pull-one {
            nqp::if(nqp::isne_i($!k,0),
                nqp::stmts(
                    ($!x := nqp::add_i(nqp::atpos($!v,nqp::sub_i($!k,1)),1)),
                    ($!y := nqp::sub_i(nqp::atpos($!v,$!k),1)),
                    ($!k := nqp::sub_i($!k,1)),
                    nqp::while(nqp::isle_i($!x,$!y),
                        nqp::stmts(
                            nqp::bindpos($!v,$!k,$!x),
                            ($!y := nqp::sub_i($!y,$!x)),
                            ($!k := nqp::add_i($!k,1)),
                        )
                    ),
                    nqp::bindpos($!v,$!k,nqp::add_i($!x,$!y)),
                    ($!i := -1),
                    (my $c := nqp::create(IterationBuffer)),
                    nqp::while(nqp::isle_i(($!i := nqp::add_i($!i,1)),$!k),
                        nqp::bindpos($c,$!i,nqp::atpos($!v,$!i))
                    ),
                    nqp::p6bindattrinvres(
                        nqp::create(List),
                        List,
                        '$!reified',
                        nqp::clone($c)
                    )
                ),
                IterationEnd
            );
        }
    }.new($n)
}
