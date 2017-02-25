#!/usr/bin/env perl6

constant MAP_FILE = 'map.json'.IO;
use JSON::Tiny;

my @data = unique :with(&[eqv]), |subs, |methods;
say "Writing {+@data} entries to {MAP_FILE}";
MAP_FILE.spurt: to-json %(
    made-on  => ~DateTime.now,
    routines => @data.sort: *.<name>,
);

sub subs {
    find-symbols({
        $_ ~~ Sub and .DEFINITE and .name !~~ /^<['A..Z_-]>+ (':<'.+)? $/
    })».&keyit;
}

sub methods {
    find-symbols({ !.DEFINITE and try .can('say') }).unique.grep({
        try .^methods
    }).map(*.^methods.Slip).grep({
        try {.gist} and .^name ne 'ForeignCode'
    })».&keyit;
}

sub keyit ($_) {
    my $file = .file;
    $file.starts-with: $_ and $file .= substr: .chars with 'SETTING::';
    $file .= split('/').=tail if $file.starts-with: '/'; # toss full paths
    %(
            <type         name   file  candidates>
        Z=> .WHAT.^name, .name, $file, cand-info .candidates».signature
    )
}

sub cand-info (@candidates) {
    eager @candidates.map: {
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

sub find-symbols ($matcher) {
    eager CORE::.keys.grep(
        * ne 'IterationEnd'
    ).map({CORE::{$_}}).grep($matcher);
}
