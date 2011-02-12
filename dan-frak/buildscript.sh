#!/bin/bash
LANG=dan-frak
for i in *.tif
  do echo $i:
  tesseract $i ${i%.tif} nobatch box.train
done
unicharset_extractor *.box
mftraining *.tr
cntraining *.tr
for i in inttemp normproto pffmtable unicharset
  do mv -f $i $LANG.$i
done
rm -f number
function integerrange {
  temp=$1
  while test $temp -le $2
  do 
     echo $temp$3
     temp=$[ $temp + 1 ]
  done
}
integerrange -9999 9999 >> number
for i in $(integerrange 0 9)
do
   integerrange -99 99 ,$i >> number
done
for i in $(integerrange 0 99)
do
   integerrange 0 99 $(printf ,%02d $i) >> number
done
wordlist2dawg number $LANG.number-dawg $LANG.unicharset
wordlist2dawg punc $LANG.punc-dawg $LANG.unicharset
wordlist2dawg word_list $LANG.word-dawg $LANG.unicharset
wordlist2dawg frequency_list $LANG.freq-dawg $LANG.unicharset
combine_tessdata $LANG.
