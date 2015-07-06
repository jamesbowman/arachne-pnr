: emit
     begin
        d# 0 io@
     until
     d# 1 io!
;

: main
    begin
        d# 32 emit
        [char] J emit
        [char] 1 emit
    again
;
