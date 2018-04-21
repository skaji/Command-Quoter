use strict;
use warnings;
use Test::More;
use Command::Quoter;

my $q = Command::Quoter->new;

my $str = $q->quote("%{foo}q b b | 2", { foo => qq{a '"b c} });

if (Command::Quoter::WIN32) {
    is $str, q{"a '\"b c" b b | 2};
} else {
    is $str, q{'a '\''"b c' b b | 2};
}

my $out = $q->qx("%{perl}q -e %{script}q", { perl => $^X, script => q{ print 1; print 2 }});
is $out, '12';

done_testing;
