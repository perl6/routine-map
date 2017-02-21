#!/usr/bin/env perl6

use HTTP::Server::Tiny;
use JSON::Tiny;

constant DATA_FILE = 'map.json'.IO;

HTTP::Server::Tiny.new(:host<0.0.0.0>, :port(3000)).run: -> $env {
    my $data = from-json DATA_FILE.slurp;

    200, ['Content-Type' => 'text/html'], [
        page $data<routines>
    ]
};

sub page ($routines) {
    my $table = join "\n", map {"<tr>$_\</tr>"}, $routines.map: {
        my $meta = Q:c:to/META_END/;
        <td>{.<file>}</td>
        <td>{.<type>}</td>
        <td>{.<name>}</td>
        META_END

        |.<candidates>.map: {
            $meta ~ Q:c:to/CANDIDATE_END/
            <td>{.<named>}</td>
            <td>{.<pos>}</td>
            <td>{.<slurpy>}</td>
            <td>{.<arity>}</td>
            <td>{.<count>}</td>
            <td>{.<signature>}</td>
            CANDIDATE_END
        }
    }


    Q:c:to/END/
<!DOCTYPE html>
<html lang="en">
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Perl 6 Routine Map</title>
<link
  href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
  rel="stylesheet"
  integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u"
  crossorigin="anonymous">
<div class="container-fluid">
    <table id="routines" class="table">
    <thead>
        <tr>
            <th>File</th>
            <th>Type</th>
            <th>Name</th>
            <th># Named</th>
            <th># Pos.</th>
            <th># Slurpy</th>
            <th>Arity</th>
            <th>Count</th>
            <th>Signature</th>
        </tr>
    </thead>
    <tbody>
        {$table}
    </tbody>
    </table>
</div>

<script
  src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
  integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
  crossorigin="anonymous"></script>
END
}
