#!/usr/bin/perl
# (c) German Gomez-Herrero, german.gomezherrero@kasku.org

# Description: Splits directory names from the directory portion of a path
# Documentation: pkg_filespec.txt

use warnings;

# Make our Spec.pm visible
my $libLocation;
BEGIN {
    use Cwd 'abs_path';
    use File::Spec;
    my $name = abs_path($0);
    $name=~m/^.+\//; 
    $libLocation = abs_path(File::Spec->catdir($&, '../../lib'));
}

use lib $libLocation;

use File::Spec;
use File::Temp;

my @dirs = File::Spec->splitdir(shift);
print join("\n", @dirs);

