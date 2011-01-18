#!/bin/sh
LANG=swe-frak
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
wordlist2dawg number $LANG.number-dawg $LANG.unicharset
wordlist2dawg punc $LANG.punc-dawg $LANG.unicharset
wordlist2dawg word_list $LANG.word-dawg $LANG.unicharset
wordlist2dawg frequency_list $LANG.freq-dawg $LANG.unicharset
combine_tessdata $LANG.
