use strict ;
use Test ;
use Time::Out ;


BEGIN {
	plan(tests => 5) ;
}


# catch timeout
timeout 1 => affects {
	sleep(3) ;
} ;
ok($@ eq 'timeout') ;


# no timeout
my $rc = timeout 3 => affects {
	sleep(1) ;
	56 ;
} ;
ok($@, '') ;
ok($rc, 56) ;


sub test_no_args {
	timeout 1 => affects {
		return @_[0] ;
	} ;
}
ok(test_no_args(5), undef) ;


sub test_args {
	timeout 1,@_ => affects {
		@_[0] ;
	} ;
}
ok(test_args(5), 5) ;


