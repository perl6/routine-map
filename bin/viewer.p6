#!/usr/bin/env perl6
use HTTP::Server::Tiny;
use JSON::Tiny;
use HTML::Entity;

constant $host     = '0.0.0.0';
constant $port     = 3000;
constant DATA_FILE = $?FILE.IO.parent.parent.child: 'map.json';
constant ASSETS    = $?FILE.IO.parent.parent.child: 'assets';

.run: -> % (:PATH_INFO($_), *%) {
    sub asset { slurp ASSETS.child: $^asset }
    sub res ($type, $content)
        { 200, [ 'Content-Type' => "$type; charset=utf-8" ], [ $content ] }

    when '/sort.js' | '/moment.js' { res 'application/javascript', .&asset   }
    when '/sort.css'               { res 'text/css',               .&asset   }
    when '/map.json'               { res 'application/json', slurp DATA_FILE }
    when '/' { res 'text/html', page DATA_FILE.slurp.&from-json<routines>    }
    404, ['Content-Type' => 'text/plain'], ['404']
} with HTTP::Server::Tiny.new: :$host, :$port;

sub page ($routines) {
    my $table = join "\n", map {"<tr>$_\</tr>"}, $routines.map: {
        my $meta = Q:c:to/META_END/;
        <td>{encode-entities .<file>}</td>
        <td><small>{
                encode-entities .<type>.subst: :g, /« 'anon|' \w+/, 'anon'
            }</small></td>
        <td>{encode-entities .<name>}</td>
        META_END

        |.<candidates>.map: {
            $meta ~ Q:c:to/CANDIDATE_END/
            <td>{encode-entities .<named>}</td>
            <td>{encode-entities .<pos>}</td>
            <td>{encode-entities .<slurpy>}</td>
            <td>{encode-entities .<arity>}</td>
            <td>{encode-entities .<count>}</td>
            <td>{encode-entities .<signature>}</td>
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
<link rel="stylesheet" href="/sort.css">
<style>{
    Q:to/CSS_END/
        th { white-space: nowrap }
    CSS_END
}</style>
<div class="container-fluid">
    <p class="h4">
        Click on table headers to sort by that column (takes a bit of time)
        <a href="/map.json" class="btn btn-primary"
            >Data in JSON format</a>
        <a href="https://github.com/perl6/routine-map"
            class="btn btn-small btn-success"
            >GitHub repository</a>

    <table id="routines" class="sortable table table-condensed">
    <thead>
        <tr>
            <th>File</th>
            <th>Type</th>
            <th data-defaultsort="asc">Name</th>
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
  src="https://code.jquery.com/jquery-3.1.1.min.js"
  integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8="
  crossorigin="anonymous"></script>
<script
  src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
  integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
  crossorigin="anonymous"></script>
<script src="/moment.js"></script>
<script src="/sort.js"></script>
END
}
