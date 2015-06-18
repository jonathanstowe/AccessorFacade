#!perl6

use v6;
use lib 'lib';
use Test;

use AccessorFacade;

class Bar {
    has $.boot is rw = "foo";
    has $.star is rw = '*';
    sub get_bar(Bar:D $self) {
        $self.boot;
    }
    sub set_bar(Bar:D $self, $val) {
        $self.boot = $val;
    }

    sub my_fudge(Bar $self, Str $t) {
        $self.star ~ $t ~ $self.star;
    }

    sub my_check(Bar $self, $rc ) {
        die "with $rc";
    }

    method boom() is rw is accessor_facade(&get_bar, &set_bar) {};
    method zapp() is rw is accessor_facade(&get_bar, &set_bar, &my_fudge) {};
    method poww() is rw is accessor_facade(&get_bar, &set_bar, &my_fudge, &my_check ) { }
    method bosh() is rw is accessor_facade(&get_bar, &set_bar, Code, &my_check ) { }
}
 
my $a;

lives-ok { $a = Bar.new }, "construct object with trait";
 
is($a.boom, $a.boot, "get works fine");
lives-ok { $a.boom = "yada" }, "exercise setter";
is($a.boom, "yada", "get returns what we set");
is($a.boot, "yada", "and the internal thing got set");
is($a.zapp, "yada", "method with fudge");
lives-ok { $a.zapp = 'banana' }, "setter with fudge";
is($a.zapp, '*banana*', "and got fudged value");
is($a.boot, '*banana*', "and the storage get changed");
throws-like { $a.poww = 'food' }, ( message => '*food*' ) , '&after got called';
throws-like { $a.bosh = 'duck' }, ( message => 'duck' ) , '&after got called (no &before)';

done;
# vim: expandtab shiftwidth=4 ft=perl6
