# SSA Library's callnumber guide's use a 3x5 card format.
# This script prints 3 cards per 8.5x11 page.
# Usage: callnumberguide -L "location" -C "collection" list-of-call-number-ranges.txt > foo.ps
#
# File list-of-call-number-ranges.txt is a plain text file:
#
# HB1-HD2003
# HD2004-HF1453
# HF1454-HG2
# HG3-JA3
# XXKF1500%b-XXKF1600
# LA3-LB2300
# ...
#
# Use %b to break a line.  You can only have two lines for call numbers.
# You shouldn't need more than that.  
#
# notes: 8.5x11 letter size page is 612x792 points (point = 1/72 inch)
#        3x5 card is 216x360 points




#use Getopt::Std;
#getopt(CL);
#$location = $opt_L;
#$collection = $opt_C;

$location = "SSA Library";
$collection = "General Collection";

open(PCCOUNT,"<$ARGV[0]");
while (<PCCOUNT>) { $pc++; } 
close PCCOUNT;



# Start postscript
#####################3

print "%!\n\n%%%%%%%%%%%%%%%%%%%%%%%%%% NEW PAGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\nnewpath\n\n";
print<<EOT3;
/cardlines
{
newpath

% vertical line
360 792 moveto
360 0 lineto
stroke

% horizontal lines
0 576 moveto
360 576 lineto
stroke
0 360 moveto
360 360 lineto
stroke
0 144 moveto
360 144 lineto
stroke
} def
EOT3


while (<>) {
	chomp;
	$c++;

	if ($c %  3 == 0) { $hv = 315; $hv2 = 301; $cv = 238; $pv = 208 }
	if ($c % 3 == 2) { $hv = 531; $hv2 = 517; $cv = 454 ; $pv = 424 }
	if ($c % 3 == 1) { $hv = 747; $hv2 = 733; $cv = 670 ; $pv = 640 }

	$xcl = $cv - 50;	

	@sline = split("%b",$_);


if ($c == $pc) { $collection = "Reference Collection"; }

	print<<EOT;	
%%%%% card %%%%%

cardlines

/Arial findfont
12 scalefont
setfont
180 $pv moveto
(Please return books for re-shelving to the circulation desk.) dup stringwidth pop 2 div neg 0 rmoveto show

/Arial findfont
12 scalefont
setfont
18 $hv moveto
($location) show


/Arial findfont
12 scalefont
setfont
18 $hv2 moveto
($collection) show

%x y moveto
%	(string) dup stringwidth pop 2 div neg 0 rmoveto show



/Arial-Narrow findfont
48 scalefont
setfont
180 $cv moveto
($sline[0]) dup stringwidth pop 2 div neg 0 rmoveto show
180 $xcl moveto
($sline[1]) dup stringwidth pop 2 div neg 0 rmoveto show
EOT


	if ($c == $pc) { print "\n\nshowpage\n\n%%EOF\n"; exit }

	if ($c % 3 == 0) {
		print "showpage\n\n%%%%%%%%%%%%%%%%%%%%%%% NEW PAGE %%%%%%%%%%%%%%%%%%%%%%%%%%%\nnewpath\n\n";
	}
}

