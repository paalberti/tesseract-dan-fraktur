#!/bin/sh
LANGCODE=deu_frak
for i in *.tif
  do echo $i:
  tesseract $i ${i%.tif} nobatch box.train
done
unicharset_extractor *.box
cat unicharset | sed -e "s/^\([æøåäöüâêàèéçß][a-z]*\) 0/\1 3/" \
  -e "s/^\([ÆØÅÄÖÜÂÊÀÈÉÇ][a-z]*\) 0/\1 5/" \
  -e "s/^\([«»„”·§—ɔ]\) 0/\1 10/" \
  -e "s/^ɔ 3 /ɔ 10 /" \
  -e "s/^½ 0/½ 8/" | sed -e "s/^\([æøåäöüâêàèéçßa-zÆØÅÄÖÜÂÊÀÈÉÇA-Z].*\) NULL /\1 Latin /" \
  -e "s/^\([«»„”·§—ɔ[:punct:][:digit:]].*\) NULL /\1 Common /" \
  -e "s/^\(&c .*\) Common /\1 Latin /" > unicharset.edited
shapeclustering -F font_properties -U unicharset.edited *.tr
mftraining -F font_properties -U unicharset.edited -O $LANGCODE.unicharset *.tr
cntraining *.tr
for i in inttemp normproto pffmtable shapetable
  do mv -f $i $LANGCODE.$i
done
wordlist2dawg number $LANGCODE.number-dawg $LANGCODE.unicharset
wordlist2dawg punc $LANGCODE.punc-dawg $LANGCODE.unicharset
wordlist2dawg word_list $LANGCODE.word-dawg $LANGCODE.unicharset
wordlist2dawg frequency_list $LANGCODE.freq-dawg $LANGCODE.unicharset
combine_tessdata $LANGCODE.
