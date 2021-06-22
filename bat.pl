#!/usr/bin/perl

for ($i=1;$i<51;$i++) {
    $n = sprintf("%04d", $i);
    print "robot -d testv-$n verify-$n.robot\n";
}
