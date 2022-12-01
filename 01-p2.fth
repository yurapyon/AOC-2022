256 constant max-line
create line-buffer max-line 1 + chars allot

0 value curr

0 value max0
0 value max1
0 value max2

s" files/01-input" r/o open-file throw value input

: read-line ( -- t/f-was-number t/f-was-eof )
  line-buffer max-line input read-line throw
  over line-buffer + 0 swap !
  ;

: buf>number ( -- number )
  0 0 line-buffer max-line >number 2drop drop
  ;

: update-maxes
  curr max0 > if
    max1 to max2
    max0 to max1
    curr to max0
  else
    curr max1 > if
      max1 to max2
      curr to max1
    else
      curr max2 > if
        curr to max2
      then
    then
  then
  ;

: process-line ( t/f-was-number -- )
  if
    buf>number
    curr + to curr
  else
    update-maxes
    0 to curr
  then
  ;

: main
  cr
  begin
    read-line
  while
    process-line
  repeat
  max0 max1 max2 + + . cr
  ;

main
