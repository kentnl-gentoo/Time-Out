use strict ;
use warnings ;
use Test ;
use Time::Out ;


BEGIN {
	plan(tests => 9) ;
}

print STDERR "\nThe following tests use sleep() so please be patient...\n" ;

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
		return $_[0] ;
	} ;
}
ok(test_no_args(5), undef) ;


sub test_args {
	timeout 2,@_ => affects {
		$_[0] ;
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

# CPU
timeout 1 => affects {
	while (1) {} ;
} ;
ok(1) ;


# blocking I/O
if ($^O eq 'MSWin32'){
	skip("alarm() doesn't interrupt blocking I/O on Win32") ;
}
else {
	require IO::Handle ;
	my $r = new IO::Handle() ;
	my $w = new IO::Handle() ;
	pipe($r, $w) ;
	$w->autoflush(1) ;
	print $w "\n" ;
	my $nb = 2 ;
	my $line = <$r> ;
	timeout $nb => affects {
	    $line = <$r> ;
	} ;
	ok($@ eq 'timeout') ;
}




