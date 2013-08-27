use strict;
use Text::CSV;
use IO::File;
use Data::Dumper;

my @periods   = grep { $_ % 25 == 0 } ( 25 .. 200 );
my @channel1  = read_channel1_data();


for my $period ( @periods ) {
  my @filtered      = grep { $_ > $period } @channel1;
  my %beats         = map { $_ => 1 } map {  $_ / 1000  } @filtered;
  my @beats_unique  = keys %beats;
  my $count         = 1;

  my @cycles_between_beats;
  while( $count < @beats_unique ) {
    $count += 2;
    push @cycles_between_beats, $beats_unique[ $count + 1 ] - $beats_unique[ $count ];
  }


  print Dumper \@cycles_between_beats;
  exit;

}


sub read_channel1_data {
  my $io        = IO::File->new( 'heartbeat.csv', 'r' );
  my $csv       = Text::CSV->new;

  # ignore first line
  $csv->getline( $io );

  my @data;
  while( my $row = $csv->getline( $io ) ) {
    push @data, $row->[0];
  }

  @data;
}



