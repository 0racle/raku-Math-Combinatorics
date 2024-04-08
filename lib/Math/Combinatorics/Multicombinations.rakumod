unit module Math::Combinatorics::Multicombinations;

use nqp;

use Math::Combinatorics::Utils;

proto sub multicombinations(Positional, Int) is export {*}

multi sub multicombinations(@l is copy, $k) {
    return @l.Seq if @l.elems ≤ 1;
    Seq.new: class :: does Iterator {
        has $!e;
        has $!k;
        has $!i;
        has $!v;
        has $!c;
        has $!todo;
        method SET-SELF(int \n, int \k) {
            nqp::stmts(
                ($!e := nqp::sub_i(n,1)),
                ($!k := k),
                ($!v := nqp::setelems(nqp::create(IterationBuffer),k)),
                ($!i := -1),
                nqp::while(
                    nqp::islt_i(($!i := nqp::add_i($!i,1)),nqp::sub_i(k,1)),
                    nqp::bindpos($!v,$!i,nqp::clone(0))
                ),
                nqp::bindpos($!v,nqp::sub_i(k,1),nqp::clone(-1)),
                ($!i := 0),
                ($!c := 0),
                ($!todo = 1),
                self
            )
        }
        method new(\n,\k) { nqp::create(self).SET-SELF(n,k) }
        method sink-all { IterationEnd }
        method count-only {
            (
               (factorial($!e + $!k) ÷
                factorial($!k)       ÷
                factorial($!e))      -
                $!c
            ).Int;
        }
        method bool-only {
            self.count-only.Bool;
        }
        method pull-one {
            nqp::if(
                nqp::islt_i(nqp::atpos($!v,nqp::sub_i($!k,1)),$!e),
                nqp::stmts(
                    nqp::bindpos(
                        $!v,
                        nqp::sub_i($!k,1),
                        nqp::add_i(nqp::atpos($!v,nqp::sub_i($!k,1)),1)
                    )
                ),
                nqp::stmts(
                    ($!i := nqp::sub_i($!k,1)),
                    nqp::while(
                        nqp::isge_i(($!i := nqp::sub_i($!i,1)),0),
                        nqp::if(nqp::isne_i(nqp::atpos($!v,$!i),$!e),last)
                    ),
                    nqp::if(nqp::islt_i($!i,0),($!todo = 0)),
                    nqp::bindpos($!v,$!i,nqp::add_i(nqp::atpos($!v,$!i),1)),
                    nqp::while(
                        nqp::islt_i(($!i := nqp::add_i($!i,1)),$!k),
                        nqp::bindpos($!v,$!i,nqp::atpos($!v,nqp::sub_i($!i,1)))
                    )
                )
            );
            nqp::if($!todo,
                nqp::stmts(
                    ($!c := nqp::add_i($!c,1)),
                    @l[
                        nqp::p6bindattrinvres(
                            nqp::create(List),
                            List,
                            '$!reified',
                            nqp::clone($!v)
                        )
                    ]
                ),
                IterationEnd
            );
        }
    }.new(@l.elems, $k)
}
