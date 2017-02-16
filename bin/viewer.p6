#!/usr/bin/env perl6

use HTTP::Server::Tiny;
use JSON::Tiny;

HTTP::Server::Tiny.new(:host<0.0.0.0>, :port(3000)).run: -> $env {
    200, ['Content-Type' => 'text/html'], [

    ]
};

sub page ($routines) {
    my $table = join "\n", map {"<tr>$_\</tr>"}, $routines.map: {Q:c:to/END/};
        <td>{.<type>}</td>
        <td>{.<name>}</td>
        <td>{.<file>}</td>
        <td>{.<candidates>.join: '<br>'}</td>
    END

    Q:c:to/END/
<!DOCTYPE html>
<html lang="en">
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Perl 6 Routine Map</title>

<div class="container">
    <table id="routines">
    <thead>
        <tr>
            <th>Type</th>
            <th>Name</th>
            <th>File</th>
            <th>Candidates</th>
        </tr>
    </thead>
    <tbody>
        {$table}
    </tbody>
    </table>
</div>

<script src="/packed/app-ee94204ae3189f6634650ad1ab13c95b.min.js"></script>
END
}
