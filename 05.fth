: >snumber ( addr len -- addr len number )
  >r >r 0 0 r> r> >number
  >r >r drop r> r> rot ;

\ ===

0 value in-file

: open-input  r/o open-file throw to in-file ;
: reset-input 0 0 in-file reposition-file throw ;
: close-input in-file close-file throw ;

50 constant max-line
create line-buffer max-line 1 + chars allot

: read-to-buffer ( -- buf-len t/f-eof )
  line-buffer max-line in-file read-line throw ;
: skip-line read-to-buffer 2drop ;

\ ===

: stack cell 128 chars + ;
: stacks stack * ;
: length @ ;
: top dup length chars cell + + 1- ;
: top@ top c@ ;
: top! top c! ;
: +length ( addr val -- ) over length + swap ! ;
: pop ( addr -- val ) dup top@ swap -1 +length ;
: push ( val addr -- ) dup 1 +length top! ;
: show ( addr -- ) dup length swap cell + swap type ;

create supplies 9 stacks allot
: reset-supplies supplies 9 stacks 0 fill ;
: get-stack ( idx -- addr ) 1- stacks supplies + ;

: skip-placements 10 0 ?do skip-line loop ;
: next-number ( addr -- next-addr number ) 2 >snumber nip ;
: instruction ( -- move from to )
  line-buffer
  5 + next-number swap
  6 + next-number swap
  4 + next-number nip ;

: do-it
  get-stack swap get-stack rot
  0 ?do
    2dup pop swap push
  loop
  2drop ;

reset-supplies

s" files/05-input" open-input

1 get-stack value stk1
2 get-stack value stk2
3 get-stack value stk3
4 get-stack value stk4
5 get-stack value stk5
6 get-stack value stk6
7 get-stack value stk7
8 get-stack value stk8
9 get-stack value stk9

char l stk1 push
char n stk1 push
char w stk1 push
char t stk1 push
char d stk1 push

char c stk2 push
char p stk2 push
char h stk2 push

stk1 show cr
stk2 show cr
2 1 2 do-it
stk1 show cr
stk2 show cr

( -
skip-placements

read-to-buffer 2drop
instruction

read-to-buffer 2drop
instruction
)

bye
