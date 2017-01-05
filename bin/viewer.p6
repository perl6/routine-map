#!/usr/bin/env perl6

use HTTP::Server::Tiny;
use Template::Mojo;

HTTP::Server::Tiny.new(:host<0.0.0.0>, :port(3000)).run: -> $env {
    200, ['Content-Type' => 'text/html'], [

    ]
};
