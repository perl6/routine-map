# Map of Perl 6 Routines and Classes

Online version for Rakudo implementation:
    [map.perl6.party](https://map.perl6.party)

# Building / Viewing

1. Run `zef --depsonly install .` to install dependencies.
2. Run `./mapper.p6` to generate `map.json` file that include mapping data.
3. Run `./bin/viewer.p6` to start the local viewing web server
4. Visit [http://localhost:3000/](http://localhost:3000/) to view the map

If you got appropriate permissions, to sync data with map.perl6.party website,
run `./update-map.perl6.party` script. Note: the viewer server needs to be
running at the time.

If you're doing development on the viewer, you may find it handy to start
it with `./morbo.p6 bin/viewer.p6` that will auto-restart the server when
detecting any changes to the source code.

# License

This code is Copyright © 2008-2017, The Perl Foundation,
distributed under the terms of the Artistic License 2.0. For more details, see
the full text of the license in the file [LICENSE](LICENSE).

**Note:** this repository also includes third-party software whose license
may be different. These include:

- `moment.js`, copyright Tim Wood, Iskren Chernev, Moment.js
    contributors, licensed under MIT; see [momentjs.com](https://momentjs.com)
- `bootstrap-sortable`, copyright Matus Brlit (drvic10k),
    bootstrap-sortable contributors, licensed under MIT; see
    [github.com/drvic10k/bootstrap-sortable
    ](https://github.com/drvic10k/bootstrap-sortable)
- `tinysort`, copyright Ron Valstar <ron@ronvalstar.nl>, licensed under MIT; see
    [tinysort.sjeiti.com](http://tinysort.sjeiti.com/)
- `morbo.p6`, copyright Zoffix Znet, licensed under Artistic License 2.0;
    see [github.com/zoffixznet/perl6-Bailador-Dev-AutoRestarter
    ](https://github.com/zoffixznet/perl6-Bailador-Dev-AutoRestarter)
