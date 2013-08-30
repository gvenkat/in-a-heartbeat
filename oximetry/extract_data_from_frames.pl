use strict;
use Text::CSV;
use IO::File;
use Data::Dumper;
use Image::Magick;


my $ffmpeg = '/usr/bin/ffmpeg'; 
my $file = 'video.MOV';
my %info;
my $ofh = IO::File->new( 'data.csv', 'w');
my $csv = Text::CSV->new;

$csv->print( $ofh, [ qw/frame intensity/ ]);
$ofh->print( "\n" );

sub get_video_info {
  my $info = `$ffmpeg -i $file 2>&1`;

  my ( $width, $height ) = $info =~ /Stream.*?(\d+)x(\d+),/s;
  my ( $fps ) = $info =~ /Stream.*?(\d+) fps,/s;
  my ( $duration ) = $info =~ /Duration:\s+00:00:(\d+)\./s;

  %info = (
    fps       => $fps,
    width     => $width,
    height    => $height,
    duration  => $duration
  );

}

sub video_to_frames {
  mkdir 'frames';
  system "$ffmpeg -i $file -f image2 'frames/frame%05d.png' 2>&1 1>/dev/null";
}

get_video_info;
# video_to_frames;

for my $frame ( 1 .. ( $info{duration} * $info{fps} ) ) {

  my $img = Image::Magick->new;

  $img->read( 
    sprintf( 'frames/frame%05d.png', $frame ) 
  );

  print Dumper( $img );

  my ( $width, $height ) = $img->Get( 'width', 'height' );

  $img->Quantize( colorspace => 'red' );

  my $i = 0;
  map { $i += $_ } $img->GetPixels( map => 'I', height => $height, width => $width, normalize => 1 );

  $csv->print( $ofh, [ $frame, $i ] );
  $ofh->print( "\n" );

}



# get_video_info;
# video_to_frames;

