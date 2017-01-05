#!/usr/bin/env perl6

# Subs
.say for find-symbols({
    $_ ~~ Sub and .DEFINITE and .name !~~ /^<[A..Z_-]>+ (':<'.+)? $/
}, :sort(*.name)).elems; #.map({ .candidates.Slip }).elems;

.say for find-symbols({
    !.DEFINITE and try .^can('say')
}, :sort(*.^name)).unique.grep({
    try .^methods
}).map(*.^methods).grep({try .gist}).flat.elems;
# .flat.map({
#     try {.candidates} ?? .candidates !! $_
# }).flat.elems;

sub find-symbols ($matcher, :$sort) {
    my @answer = CORE::.keys.grep(
        * ne 'IterationEnd'
    ).map({CORE::{$_}}).grep($matcher);

    @answer .= sort: $sort if $sort;

    @answer;
}
