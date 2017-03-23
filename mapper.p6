#!/usr/bin/env perl6

constant MAP_FILE = 'map.json'.IO;
use JSON::Tiny;
use nqp;

my @data = unique :as(*.perl), |subs, |methods;
my $total = +@data;
my $unique = @data.map(*.<name>).unique.elems;
say "Writing $total entries to {MAP_FILE}";
say "There are $unique unique routine names";

MAP_FILE.spurt: to-json %(
    made-on  => ~DateTime.now,
    routines => @data.sort(*.<name>),
    total    => $total,
    unique   => $unique,
);

sub subs {
    find-symbols({
        .DEFINITE and nqp::istype($_, Sub)
            and .name !~~ /^<['A..Z_-]>+ (':<'.+)? $/
    })».&keyit;
}

sub methods {
    find-symbols({
        !.DEFINITE and try .^can('say')
    }).unique.map(*.^methods(:local).Slip).grep({
        try {.^can: 'gist'} and .^name ne 'ForeignCode'
    }).unique(:as(*.perl))».&keyit
}

sub keyit ($_) {
    %(
            <type         name   candidates>
        Z=> .WHAT.^name, .name,  cand-info .candidates
    )
}

sub cand-info (@candidates) {
    eager @candidates.map: -> $_ is copy {
        my $file = .file;
        $file.starts-with: $_ and $file .= substr: .chars with 'SETTING::';
        $file .= split('/').=tail if $file.starts-with: '/'; # toss full paths

        $_ .= signature;
        my %info = :0named, :0pos, :0slurpy, :signature(.gist), :$file,
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
    eager grep $matcher, map {*.^name.say; $_}, lazy gather {
        my Mu %seen{Mu};
        for CORE::.keys.grep(* ne 'IterationEnd') {
            try {.^methods} and take $_ given CORE::{$_};

            sub dig ($stash) {
                for $stash.keys {
                    try {.^methods} and take $_ given $stash{$_};
                    next if %seen{ $_ }++;
                    try { .keys } and .&dig given $stash{$_}.WHO;
                }
            }(CORE::{$_}.WHO) if try CORE::{$_}.WHO.keys;
        }
    }
}
