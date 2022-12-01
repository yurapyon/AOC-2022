256 constant max-line
create line-buffer max-line 1 + chars allot

0 value max_
0 value curr

s" files/01-input" r/o open-file throw value input

: read-line ( -- t/f-was-number t/f-was-eof )
  line-buffer max-line input read-line throw
  over line-buffer + 0 swap !
  ;

: buf>number ( -- number )
  0 0 line-buffer max-line >number 2drop drop
  ;

: process-line ( t/f-was-number -- )
  if
    buf>number
    curr + to curr
  else
    curr max_ max to max_
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
  max_ . cr
  ;

main
