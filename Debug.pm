############################################################################
# NAME: Debug.pm
# FUNC: Code for debugging.
# AUTH: Fitz
# VERS: $Id: Debug.pm,v 1.2 2017/10/04 02:12:07 fitzer Exp $
#  SRC: $Source: /media/fitzer/42478fce-2984-4f76-9d2a-70381ca94d31/src/perl/libs/Debug/RCS/Debug.pm,v $
#===========================================================================
# HISTORY
#===========================================================================
#   DATE      # NAME      # COMMENT
#===========================================================================
# 20060805    # Fitz      # Original.
# 20060805    # Fitz      # Added these comments.
# 20060805    # Fitz      # Cleanup.
# 20060805    # Fitz      # Added Debug and Error logs.
# 20060901    # Fitz      # Added LabeledInt.
# 20060909    # Fitz      # Small fixes to H2 and H4.
# 20100222    # Fitz      # Renamed H4 to h4 and added LabeledInt and H4
# 20130502    # Fitz      # General cleanup.
# 20150302    # Fitz      # Deprecated LString and LabeledString and
#													# created lString and lqString.
# 20150705    # Fitz      # Exit was decrementing IL before the printing.
# 20150705    # Fitz      # Fixed Entry to increment IL before printing.
# 20160422    # Fitz      # Added Start and LevelCheck.
# 20160826    # Fitz      # Added StartBlock and EndBlock.
# 20171003    # Fitz      # Deprecated LabeledInt and replaced w/ lInt.
############################################################################
############################################################################
# sub Indent {
# sub Nl {
# sub Char {
# sub QChar {
# sub Debug {
# sub Label {
# sub String
# sub QString
# sub LabeledString {
# sub Int {
# sub LabeledInt {
# sub Hex {
# sub H2 {
# sub H4 {
# sub Entry {
# sub Exit {
# sub LString {
# sub lString {
# sub lqString {
# sub Ntry {
# sub Spaces {
# sub StartBlock {
# sub EnbdBlock {
############################################################################
use Data::Dumper;

############################################################################
# Set up logs.
#
$LOG_DIR = "$ENV{CWD}/logs";
stat $LOG_DIR;
if( !-d _ )
{
	#print "oops\n";
	mkdir( $LOG_DIR, 0755 );
}
$ErrLog = "$LOG_DIR/error.log";
open( ERR, ">$ErrLog" );

$DbgLog = "$LOG_DIR/debug.log";
open( DBG, ">$DbgLog" );

############################################################################
# Generic variables
#
#$Dlvl = 0;

sub Indent {
	my( $n ) = @_;

	if( $n > 0 ) {
		while( $n > 0 ) {
			print "  ";
			$n--;
		}
	}
	undef $n;
}

sub Nl {
	print "\n";
}

sub Char {
	my( $ch ) = @_;

	print $ch;
}

sub QChar {
	my( $ch ) = @_;

	print "'$ch'";
}

sub Debug {
	my( $n ) = @_;
	my $DBG = 0;
	if( $DBG )
		{ print "Entering Debug\n"; }
	if( $DBG )
		{ print "IL at Entry: $n\n"; }

	Indent( $n );
	print "DEBUG - ";
	if( $DBG )
		{ print "\nExiting Debug\n"; }
	if( $DBG )
		{ print "IL at Exit $n\n"; }
		#undef $n;
}

sub Label {
	my( $str ) = @_;

	print "$str: ";
}

sub String
	{ print @_; }

sub QString
	{ print( "\"@_\"" ); }

sub LabeledString {
	my $mySub = (caller(0))[3];
	print "Deprecated - $mySub. Use 'lqString'.\n";
	exit;
}

sub Int {
	my( $int ) = shift( @_ );
	my( $cnt ) = shift( @_ );

	printf( "$int", $cnt );
}

sub LabeledInt {
	my $mySub = (caller(0))[3];
	print "Deprecated - $mySub. Use 'lqString'.\n";
	exit;
	my( $lbl ) = shift( @_ );
	my( $int ) = shift( @_ );
	my( $cnt ) = shift( @_ );

	Label( $lbl );
	Int( $int, $cnt );
}

sub lInt {
	my( $lbl ) = shift( @_ );
	my( $int ) = shift( @_ );
	my( $cnt ) = shift( @_ );

	Label( $lbl );
	Int( $int, $cnt );
}

sub Hex {
	my( $int ) = shift( @_ );
	my( $cnt ) = shift( @_ );

	printf( "%$cntx", $int );
}

sub H2 {
	my( $int ) = shift( @_ );

	printf( "%0.2x", $int );
}

sub H4 {
	my( $int ) = shift( @_ );

	printf( "%0.4x", $int );
}

sub Entry {
	my( $il ) = shift( @_ );
	my( $file ) = shift( @_ );
	my( $proc ) = shift( @_ );

	printf( "\n" );
	Debug( $il );
	printf( "Entering: \"$proc\" in File: $file\n" );
	$il++;

	return $il;
}

sub Exit {
	my( $il ) = shift( @_ );
	my( $file ) = shift( @_ );
	my( $proc ) = shift( @_ );

	$il--;
	Debug( $il );
	printf( "Exiting: \"$proc\" in File: $file\n" );

	return $il;
}

sub LString {
	my $mySub = (caller(0))[3];
	print "Deprecated - $mySub. Use 'lqString'.\n";
	exit;
}

sub lString {
	my( $lbl ) = shift( @_ );
	my( $str ) = shift( @_ );

	Label( $lbl );
	String( $str );
}

sub lqString {
	my( $lbl ) = shift( @_ );
	my( $str ) = shift( @_ );

	Label( $lbl );
	QString( $str );
}

sub Ntry {
	my( $il ) = shift( @_ );
	my( $file ) = shift( @_ );
	my( $str ) = shift( @_ );

	Debug( $il );
	print( "Entering: \"$str\" in File: $file\n" );
}

sub Spaces {
	my( $n ) = shift( @_ );

	while( $n > 0 ) {
		print " ";
		$n--;
	}
}

sub Start {
	my $DBG = 0;
	if( $DBG )
		{ print "Entering Start\n"; }
	my( $n ) = shift( @_ );
	my( $proc ) = shift( @_ );

	if( $DBG )
		{ print "n: $n\n"; }

	while( $n ) {
		( $n1, $rest ) = split( /,/, $n, 2 );
		my $str = $proc . $n1;
		$Levels{ $str } = $n1;
		$n = $rest;

		if( $DBG ) {
			print "n1: $n1\n";
			print "Levels: str: $str\n";
			print Dumper( \%Levels );
		}
	}

	if( $DBG ) {
		print "Levels: str: $str\n";
	}
}

sub LevelCheck {
	my $DBG = 0;
	if( $DBG )
		{ print "Entering LevelCheck\n"; }
	my $Dlvl = shift( @_ );
	my( $proc ) = shift( @_ );
	my $str = $proc . $Dlvl;
	if( $DBG ) {
		Indent( 8 ); print "Dlvl: $Dlvl\n";
		Indent( 8 ); print "str: $str\n";
	}

	my $yes = 0;

	if( $Levels{ $str } == $Dlvl ) {
		$yes = 1;
	}
	if( $DBG ) {
		if( $yes )
			{ print "yes: TRUE\n"; }
		else
			{ print "yes: FALSE\n"; }
	}
	return $yes;
}

sub StartBlock {
	my( $il ) = shift( @_ );
	my( $block ) = shift( @_ );

	printf( "\n" );
	Debug( $il );
	printf( "Entering block: \"$block\"\n" );
	$il++;

	return $il;
}

sub EndBlock {
	my( $il ) = shift( @_ );
	my( $block ) = shift( @_ );

	$il--;
	Debug( $il );
	printf( "Exiting block: \"$block\"\n" );

	return $il;
}

#print "Fitz\n";

1;



