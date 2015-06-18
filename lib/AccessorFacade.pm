#!perl6

use v6;

module AccessorFacade {

    my role Provider[&get, &set, &before?, &after?] {
        method CALL-ME(*@args) is rw {
            my $self = @args[0];
            Proxy.new(
                        FETCH   => sub ($) {
                            &get($self);
                        },
                        STORE   =>  sub ($, $val is copy ) {
                            if &before.defined {
                                $val = &before($self, $val);
                            }
                            my $rc = &set($self, $val);
                            if &after.defined {
                                &after($self, $rc);
                            }
                        }
            );
	    }
    }

    class X::AccessorFacade::Usage is Exception {
        has Str $.message is rw;
    }

    multi trait_mod:<is>(Method $r, :$accessor_facade!) is export {
        if $accessor_facade.elems < 2 {
            die X::AccessorFacade::Usage.new(message => "trait 'accessor_facade' requires &getter and &setter arguments");

        }
        if not all($accessor_facade.list) ~~ Callable {
            die X::AccessorFacade::Usage.new(message => "trait 'accessor_facade' only takes Callable arguments");
        }

        my $before = $accessor_facade[2]:exists ?? $accessor_facade[2] !! Code;
        my $after  = $accessor_facade[3]:exists ?? $accessor_facade[3] !! Code;

	    $r does Provider[$accessor_facade[0], $accessor_facade[1], $before, $after];
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
