#!/usr/bin/env perl6

constant MAP_FILE = 'map.json'.IO;
use JSON::Tiny;

my @data = |subs, |methods;
say "Writing {+@data} entries to {MAP_FILE}";
MAP_FILE.spurt: to-json %(
    made-on  => ~DateTime.now,
    routines => @data,
);

sub subs {
    find-symbols({
        $_ ~~ Sub and .DEFINITE and .name !~~ /^<[A..Z_-]>+ (':<'.+)? $/
    }, :sort(*.name))».&keyit;
}

sub methods {
    find-symbols({
        !.DEFINITE and try .can('say')
    }, :sort(*.^name)).unique.grep({
        try .^methods
    }).map(*.^methods.Slip).grep({
        try {.gist} and .^name ne 'ForeignCode'
    })».&keyit;
}

sub keyit ($_) {
    %(
            <type         name   file  candidates>
        Z=> .WHAT.^name, .name, .file, cand-info .candidates».signature
    )
}

sub cand-info (@candidates) {
    @candidates.map: {
        my %info = :0named, :0pos, :0slurpy, :signature(.gist),
            :count($_ == Inf ?? "Inf" !! $_ with .count), # Inf in JSON => null
            :arity($_ == Inf ?? "Inf" !! $_ with .arity); # Inf in JSON => null

        for .params {
            .named      and %info<named>++;
            .positional and %info<pos>++;
            .slurpy     and %info<slurpy>++;
        }
        %info
    }
}

sub find-symbols ($matcher, :$sort) {
    my @answer = CORE::.keys.grep(
        * ne 'IterationEnd'
    ).map({CORE::{$_}}).grep($matcher);

    @answer .= sort: $sort if $sort;

    @answer;
}
