use strict ;
use Test ;
use Time::Out ;


BEGIN {
	plan(tests => 3) ;
}


# exception
eval {
	timeout 3 => affects {
		die("allo\n") ;
	} ;
} ;
ok($@, "allo\n") ;


# exception
eval {
	timeout 3 => affects {
		die("allo") ;
	} ;
} ;
ok($@, qr/^allo/) ;


# exception
eval {
	timeout 3 => affects {
		die([56]) ;
	} ;
} ;
ok($@->[0], 56) ;



