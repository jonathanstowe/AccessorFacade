#!perl6

use v6;
use lib 'lib';
use Test;

use AccessorFacade;

my $test_class;

$test_class = 'class Bar { method boom() is rw is accessor_facade {}; }';
throws-like { EVAL $test_class }, X::AccessorFacade::Usage, "accessor_facade - no args",  message => q[trait 'accessor_facade' requires &getter and &setter arguments];
 
$test_class = 'class Bar { method boom() is rw is accessor_facade("foo", "bar") {}; }';
throws-like { EVAL $test_class }, X::AccessorFacade::Usage, "accessor_facade - non-code args",  message => q[trait 'accessor_facade' only takes Callable arguments];
 

done;
# vim: expandtab shiftwidth=4 ft=perl6
