use strict ;
use Test ;
use Time::Out ;


BEGIN {
	plan(tests => 8) ;
}

print STDERR "\nThese tests use sleep() so please be patient...\n" ;

# catch timeout
timeout 2 => affects {
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
	timeout 2 => affects {
		return @_[0] ;
	} ;
}
ok(test_no_args(5), undef) ;


sub test_args {
	timeout 2,@_ => affects {
		@_[0] ;
	} ;
}
ok(test_args(5), 5) ;


# repeats 
timeout 2 => affects {
	sleep(3) ;
} ;
sleep(3) ;
ok(1) ;


# 0 
{
	my $ok = 0 ;
	local $SIG{__WARN__} = sub {$ok = 1} ;
	timeout 0 => affects {
	} ;
	ok($ok) ;
}


# blocking I/O
pipe(R, W) ;
my $nb = 2 ;
my $line = undef ;
timeout $nb => affects {
	$line = <R> ;
} ;
ok($@ eq 'timeout') ;


