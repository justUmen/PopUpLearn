#!/bin/bash
grep -v "#!#"  "/home/umen/SyNc/Projects/PopUpLearn/DB/LANGUAGE/CN/hsk/hsk1/ALL/HSK1_en_cn.pul" > /tmp/sound_text.sh
grep "#!#" "/home/umen/SyNc/Projects/PopUpLearn/DB/LANGUAGE/CN/hsk/hsk1/ALL/HSK1_en_cn.pul" | sed 's/#!#//' > /tmp/sound_source.sh
source /tmp/sound_source.sh
while read line; do
  LEFT=`echo $line | sed 's/ |=| .*//'`
  RIGHT=`echo $line | sed 's/.* |=| //'`
  #REPLACE SPACE WITH UNDERSCORES FOR NAMES
  LEFT_N=`echo $LEFT | sed 's/ /_/g'`
  RIGHT_N=`echo $RIGHT | sed 's/ /_/g'`
  echo "/home/umen/SyNc/Projects/wikiface_new/soundDB/$LANGUAGE_1/$LEFT_N.mp3"
  echo "/home/umen/SyNc/Projects/wikiface_new/soundDB/$LANGUAGE_2/$RIGHT_N.mp3"
  MAX=10
  LANGUAGE_1_GTTS=$LANGUAGE_1
  LANGUAGE_2_GTTS=$LANGUAGE_2
  if [ "$LANGUAGE_1" == "cn" ]; then
    LANGUAGE_1_GTTS="zh-cn"
  fi
  if [ "$LANGUAGE_2" == "cn" ]; then
    LANGUAGE_2_GTTS="zh-cn"
  fi
  if [ ! -f "/home/umen/SyNc/Projects/wikiface_new/soundDB/$LANGUAGE_1/$LEFT_N.mp3" ]; then
    gtts-cli -l "$LANGUAGE_1_GTTS" "$LEFT" --output "/home/umen/SyNc/Projects/wikiface_new/soundDB/$LANGUAGE_1/$LEFT_N.mp3"
    sleep $((RANDOM % MAX))
    echo -n "."
  fi
  if [ ! -f "/home/umen/SyNc/Projects/wikiface_new/soundDB/$LANGUAGE_2/$RIGHT_N.mp3" ]; then
    gtts-cli -l "$LANGUAGE_2_GTTS" "$RIGHT" --output "/home/umen/SyNc/Projects/wikiface_new/soundDB/$LANGUAGE_2/$RIGHT_N.mp3"
    sleep $((RANDOM % MAX))
    echo -n "."
  fi
done < /tmp/sound_text.sh
