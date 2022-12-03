: flip ( a b c - c b a ) -rot swap ;
: c!or ( val addr -- ) dup c@ rot or swap c! ;
: span ( addr len -- addr end-addr) over + swap ;

\ === input ===

0 value in-file

: open-input  r/o open-file throw to in-file ;
: reset-input 0 0 in-file reposition-file throw ;
: close-input in-file close-file throw ;

64 constant max-line

: create-buffer create max-line chars cell + allot ;
: buffer-len-addr ( addr ) max-line chars + ;
: read-to-buffer ( addr -- t/f-eof )
  dup max-line in-file read-line throw ( addr len t/f-eof )
  flip buffer-len-addr ! ;
: buf-len buffer-len-addr @ ;
: half-len buf-len 2 / ;

create-buffer lb1
create-buffer lb2
create-buffer lb3

: read-3-to-buffer ( -- t/f-eof )
  lb1 read-to-buffer drop
  lb2 read-to-buffer drop
  lb3 read-to-buffer ;

\ ===

: char>priority ( char -- idx )
  dup [char] a > if
  [char] a - 1 + else
  [char] A - 27 + then ;

create tbl 256 chars allot
: clear-table tbl 256 chars 0 fill ;
: table-idx tbl + ;

: read-collection ( or-with start len -- )
  span ?do
    dup i c@ table-idx c!or loop
  drop ;

: check-collection ( for start len -- char )
  span ?do
    i c@ 2dup ( for char for char )
    table-idx c@ ( for char for found )
    = if nip unloop exit else drop then
  loop ( unreachable ) ;

0 value total
: +total total + to total ;
: reset-total 0 to total ;

\ ===

: part1 ( -- )
  begin lb1 read-to-buffer
  while
    clear-table
    %01 lb1 dup half-len read-collection
    %01 lb1 dup half-len + lb1 half-len check-collection
    char>priority +total
  repeat
  total . cr ;

: part2 ( -- )
  begin read-3-to-buffer
  while
    clear-table
    %01 lb1 dup buf-len read-collection
    %10 lb2 dup buf-len read-collection
    %11 lb3 dup buf-len check-collection
    char>priority +total
  repeat
  total . cr ;

: reset reset-input reset-total ;

: main
  s" files/03-input" open-input
  part1 reset part2
  close-input bye ;

main
