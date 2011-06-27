
# Print 3 360x216pt journal guide cards on 
# 612x792pt (8.5x11") media using postscript.
# Input is colon delemited flat text.

# Layout:
# Constant header "Journals". 
# some space
# "Starting journal title" (might be two lines)
# "to" (one line)
# "Ending journal title" (might be two lines)
# 
# Script assumes title will not be more than two lines.
#
# Starting and ending journals create lines that increment
# 216pt intervals. Remember that 0,0 is lower left corner.


# Data line:
# "start journal title":"start journal wrap":"end journal title":"end journal wrap"
# Split data on ":" .
# 
# Use Text::Wrap to interpolate "\n"'s into journal titles.
# Use split("\n",$title) to generate a new show element in postscript.
# Use modulus operation that creates new pages to increment
# postscript's coordinate space.
#
# Note that line spacing's point value should be fontscale+2 .


# Count records and use modulus ifs
# to create a new page (showpage \n newpath in postscript)

use Text::Wrap;

open(PCOUNT,"<$ARGV[0]");
while (<PCOUNT>) {
	$c++;
}
close(PCOUNT);





$tcvc = 738;  # top card's first line vertical coordinate
$hfs = 36; # heading font scale
$jfs = 24;  # journal font scale
$line_space = ($jfs + 2);
$space_below_heading = 50;


print<<EOT;

% Routine centers text horizontally
/centershow
{
dup stringwidth pop 2 div neg 0 rmoveto show
} def



newpath
EOT

while (<>) {
	$i++;

	($start_journal, $start_journal_wrap, $end_journal, $end_journal_wrap) = split(":", $_);

	# Drop down from $tcvc in 216 pt increments.
	if ($i % 3 == 1) { $vertical_label_coordinate = $tcvc; }
	if ($i % 3 == 2) { $vertical_label_coordinate = ($tcvc - 216); }
	if ($i % 3 == 0) { $vertical_label_coordinate  = ($tcvc - 432); }

	&writecard($start_journal, $start_journal_wrap, $end_journal, $end_journal_wrap, $vertical_label_coordinate);

	if ($i == $c) { print "\nshowpage\n%EOF\n"; }
	
}



sub writecard {

	# $sj - start journal title
	# $sjw - start journal wrap
	# $ej - end journal title
	# $ejw - end journal wrap
	# $vc - card's starting vertical coordinate determined by $c % 3

	my($sj, $sjw, $ej, $ejw, $vc) = @_;


	# Process start journal title.
	print "\n\n%%%%%%  NEW CARD %%%%%%%\n\n";
	print "/Arial-Bold findfont $hfs scalefont setfont\n";
	print "180 $vc moveto\n";
	print "(Journals) centershow\n\n";


	local($Text::Wrap::columns) = $sjw;
	$sjstring = wrap('','', $sj);
	@sjarray = split("\n", $sjstring);

	if ($sjarray[1] eq "") {
		print "/Arial-Narrow findfont $jfs scalefont setfont\n";
		print "180 " . ($vc - $space_below_heading) . " moveto\n";
		print "($sjarray[0]) centershow\n\n";
		print "180 ". (($vc - $space_below_heading) - $line_space) . " moveto\n";
		print "(to) centershow\n\n";
		$pc = (($vc - $space_below_heading) - $line_space);
	} else {
		print "/Arial-Narrow findfont $jfs scalefont setfont\n";
		print "180 " . ($vc - $space_below_heading) . " moveto\n";
		print "($sjarray[0]) centershow\n\n";
		print "180 " . (($vc - $space_below_heading) - $line_space) . " moveto\n";
		print "($sjarray[1]) centershow\n\n";
		print "180 " . (($vc - $space_below_heading) - (2 * $line_space )) . " moveto\n";
		print "(to) centershow\n\n";
		$pc = (($vc - $space_below_heading) - (2 * $line_space ));
	}


	# Process end journal title.

	
	local($Text::Wrap::columns) = $ejw;
	$ejstring = wrap('','', $ej);
	@ejarray = split("\n", $ejstring);


	if ($ejarray[1] eq "") {
		print "/Arial-Narrow findfont $jfs scalefont setfont\n";
		print "180 " .  ($pc - $line_space) . " moveto\n";
		print "($ejarray[0]) centershow\n\n";
	} else {
		print "/Arial-Narrow findfont $jfs scalefont setfont\n";
		print "180 " .  ($pc - $line_space) . " moveto\n";
		print "($ejarray[0]) centershow\n\n";
		print "180 " .  (($pc - $line_space) - $line_space) . " moveto\n";
		print "($ejarray[1]) centershow\n\n";

	}

	if ($i % 3 == 0) {
		unless ($i == $c) {
			print "\nshowpage\n";
			print "\n%%%%%%%%%%%%%%%% NEW PAGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n";
			print "\nnewpath\n";
		}
	}
}


