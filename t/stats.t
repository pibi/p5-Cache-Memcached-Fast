use warnings;
use strict;

use Test::More;

use FindBin;

use lib "$FindBin::Bin";
use Memd;

if ($Memd::memd) {
    plan tests => 6 + 5 * scalar(@Memd::addr);
} else {
    plan skip_all => 'Not connected';
}


# count should be >= 4.
use constant count => 100;

my $key = 'commands';

is($Memd::memd->max_size_exceeded_count, 0);
$Memd::memd->delete($key);
$Memd::memd->add($key, 'v1', undef);
$Memd::memd->get($key);
$Memd::memd->delete($key."2");
$Memd::memd->add($key."2", 'v1', undef);
$Memd::memd->add("${key}_$_", 'v1', undef) for 1..100;
is($Memd::memd->max_size_exceeded_count, 0);

my $stats = $Memd::memd->server_stats;
is(ref($stats), 'ARRAY', "server_stats returns array");
is(scalar(@$stats), scalar(@Memd::addr), "server_stats returns one element per server");

foreach my $i (0..$#Memd::addr) {
    my $srv = $stats->[$i];
    is(ref($srv), 'HASH', "single server stats are a hash");
    foreach my $key (qw(num_failures num_interactions server num_not_available)) {
        ok(defined($srv->{$key}), "single server stats hash hash key '$key'");
    }
}

my $ntotal_req = 0;
$ntotal_req += $_->{num_interactions} for @{ $Memd::memd->server_stats };
cmp_ok($ntotal_req, '>', 0, "Stats actually contain some data");

$Memd::memd->server_stats(1);
$ntotal_req = 0;
$ntotal_req += $_->{num_interactions} for @{ $Memd::memd->server_stats };
is($ntotal_req, 0, "Stats contain no data after reset");

