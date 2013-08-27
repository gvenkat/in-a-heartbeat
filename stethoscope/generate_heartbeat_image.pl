use strict;
use GD::Graph::lines;
use Text::CSV;
use IO::File;

my $csv   = Text::CSV->new;
my $io    = IO::File->new( 'heartbeat.csv' ) or die( "cant open hearbeat.csv" );
my $gd    = GD::Graph::lines->new( 800, 600 );  
my $img   = IO::File->new( 'heartbeat.png', 'w' );

$img->binmode( 1 );

my @data  = (
  # x axis
  [ ],

  # y axis
  [ ]
); 

$gd->set( 
  x_label => 'Time',
  y_label => 'Freequency',
  title   => 'Heartbeats Yo!'
);

# ignore headers
$csv->getline( $io );

my $i = 0;
while( my $row = $csv->getline( $io ) ) {
  push @{ $data[ 0 ] }, $i++;

  # channel-1 data
  push @{ $data[ 1 ] }, $row->[0];
}

$img->print( 
  $gd
    ->plot( \@data )
    ->png
);

$img->close;

print "Done! Think you're in love \n";
