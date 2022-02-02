csv
sum/all
cut -d ',' -f 3 | perl -e '$s = 0; while(<>) { $s += $_; } print $s'