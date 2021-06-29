#!/bin/bash

# 此脚本按照固定行数分割文件

LINES=1000000 # 每个文件的行数
TOTAL=57690558 # 文件的总行数

start=1
end=1
filenum=1

echo "total lines=$TOTAL"

while (( $start < $TOTAL ));
do
  end=$(( $start+$LINES ))
  if (( $end > $TOTAL ));
  then
    end=$TOTAL
  fi
  echo "save file from line [$start,$end] to $filenum.log"
  range="$start,$end"p
  /bin/sed -n $range large_file.log > $filenum.log
  wc -l $filenum.log
  start=$end
  filenum=$(( $filenum + 1 ))
done

exit
