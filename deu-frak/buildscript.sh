#!/bin/sh
LANG=deu-frak
for i in *.tif
  do echo $i:
  tesseract $i ${i%.tif} nobatch box.train
done
unicharset_extractor *.box
shapeclustering -F font_properties -U unicharset *.tr
mftraining -F font_properties -U unicharset -O $LANG.unicharset *.tr
cntraining *.tr
for i in inttemp normproto pffmtable shapetable
  do mv -f $i $LANG.$i
done
wordlist2dawg number $LANG.number-dawg $LANG.unicharset
wordlist2dawg punc $LANG.punc-dawg $LANG.unicharset
wordlist2dawg word_list $LANG.word-dawg $LANG.unicharset
wordlist2dawg frequency_list $LANG.freq-dawg $LANG.unicharset
combine_tessdata $LANG.
