unit module Math::Combinatorics::Variations;

use nqp;

use Math::Combinatorics::Utils;

multi sub permutations(@l is copy, :$k) is export { variations(@l, $k); }

multi sub variations(@l is copy, $k) is export {
    return ().Seq if @l.elems == 0;
    return ().Seq if @l.elems < $k;
    Seq.new: class :: does Iterator {
        has $!n;
        has $!k;
        has $!e;
        has $!m;
        has $!v;
        has $!c;
        has $!todo;
        method SET-SELF(int \n, int \k) {
            nqp::stmts(
                ($!n := n),
                ($!k := k),
                ($!m := nqp::sub_i(n,1)),
                ($!e := nqp::sub_i(k,1)),
                ($!v := nqp::setelems(nqp::create(IterationBuffer),n)),
                ($!todo = 1),
                (my $i = -1),
                nqp::while(
                    nqp::islt_i(($i := nqp::add_i($i,1)),nqp::sub_i(n,0)),
                    nqp::bindpos($!v,$i,nqp::clone($i))
                ),
                ($!c := 0),
                self
            )
        }
        method new(\n,\k) { nqp::create(self).SET-SELF(n,k) }
        method sink-all { IterationEnd }
        method count-only {
            (
                factorial($!n)       ÷
                factorial($!n - $!k) -
                $!c
            ).Int;
        }
        method bool-only {
            self.count-only.Bool;
        }
        method pull-one {
            nqp::if($!todo,
                nqp::stmts(
                    (my $i = -1),
                    (my $r := nqp::setelems(nqp::create(IterationBuffer),$k)),
                    nqp::while(nqp::islt_i(($i = nqp::add_i($i,1)),$!k),
                        nqp::bindpos($r,$i,nqp::clone(nqp::atpos($!v,$i)))
                    )
                )
            );
            (my $j := $!k),
            nqp::while(nqp::isle_i($j,$!m),
                nqp::if(nqp::isge_i(nqp::atpos($!v,$!e),nqp::atpos($!v,$j)),
                    ($j := nqp::add_i($j,1)),
                    last
                )
            ),
            nqp::if(nqp::isle_i($j,$!m),
                swappos($!v,$!e,$j),
                nqp::stmts(
                    flippos($!v,$!k,$!m),
                    ($i := nqp::sub_i($!e,1)),
                    nqp::while(
                        nqp::bitand_i(
                            nqp::isge_i($i,0),
                            nqp::isge_i(
                                nqp::atpos($!v,$i),
                                nqp::atpos($!v,nqp::add_i($i,1))
                            )
                        ),
                        ($i := nqp::sub_i($i,1))
                    ),
                    nqp::if(nqp::islt_i($i,0),($!todo = 0)),
                    ($j := $!m),
                    nqp::while(
                        nqp::bitand_i(
                            nqp::isgt_i($j,$i),
                            nqp::isge_i(nqp::atpos($!v,$i),nqp::atpos($!v,$j))
                        ),
                        ($j := nqp::sub_i($j,1)),
                    ),
                    swappos($!v,$i,$j),
                    flippos($!v,nqp::add_i($i,1),$!m),
                )
            );
            nqp::if($r,
                nqp::stmts(
                    ($!c := nqp::add_i($!c,1)),
                    @l[
                        nqp::p6bindattrinvres(
                            nqp::create(List),
                            List,
                            '$!reified',
                            nqp::clone($r)
                        )
                    ]
                ),
                IterationEnd
            );
        }
    }.new(@l.elems, $k)
}

sub swappos(IterationBuffer $l, $a, $b) {
    my $tmp := nqp::atpos($l,$a);
    nqp::bindpos($l,$a,nqp::atpos($l,$b));
    nqp::bindpos($l,$b,$tmp);
}

sub flippos(IterationBuffer $l, $i is copy, $e is copy) {
    nqp::if(nqp::isge_i($i,$e),return);
    ($e = nqp::add_i($e,$i));
    nqp::repeat_while(nqp::isle_i(($i = nqp::add_i($i,1)),nqp::sub_i($e,$i)),
        swappos($l,$i,nqp::sub_i($e,$i))
    );
}
