use strict;
use IO::File;
use Text::CSV;

my $wav = IO::File->new( 'heartbeat.wav', 'r' );
my $ofh = IO::File->new( 'heartbeat.csv', 'w' );
my $csv = Text::CSV->new;

$csv->print( $ofh, [ qw/ch1 ch2 combined/ ] );
$ofh->write( "\n" );

my ( $bytes, $size, $channel_data );
while( ! eof( $wav ) ) {

  $wav->read( $bytes, 4 );

  if( $bytes eq 'data' ) {
    $wav->read( $size, 4 );

    $size = ( unpack( 'l', $size ) )[ 0 ];

    while( ( $size -= 4 ) >= 0 ) {
      $wav->read( $channel_data, 4 );

      my ( $ch1, $ch2 ) = unpack( 'ss', $channel_data );
      $csv->print( $ofh, [ $ch1, $ch2, $ch1 + $ch2 ] );
      $ofh->write( "\n" );

    }
  }

}

# be nice
$ofh->close;
$wav->close;
