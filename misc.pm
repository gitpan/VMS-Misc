package VMS::Misc;

use strict;
use Carp;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK $AUTOLOAD);

require Exporter;
require DynaLoader;
require AutoLoader;

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw();
@EXPORT_OK = qw(byte_to_iv word_to_iv long_to_iv quad_to_date date_to_quad
               vms_date_to_unix_epoch);
$VERSION = '1.00';

bootstrap VMS::Misc $VERSION;

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

VMS::Misc - Misc data conversions

=head1 SYNOPSIS

  use VMS::Misc;

  $foo = byte_to_iv($byte);
  $foo = word_to_iv($word);
  $foo = long_to_iv($long);
  $quadword = date_to_quad($VMS_Format_Date);
  $VMS_Format_Date = quad_to_date($quadword);
  $SecsSinceEpoch = vms_date_to_unix_epoch($VMS_Format_Date);

=head1 DESCRIPTION

Miscellaneous data conversion routines

=head1 AUTHOR

Dan Sugalski <sugalskd@ous.edu>

=head1 SEE ALSO

perl(1).

=cut
