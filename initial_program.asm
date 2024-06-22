// Test program

:start
GET val
ADD one
PUT val

SUB five
JS start
JMP end

:end
GETL
JMP end

:val
DW 0
:one
DW 1
:five
DW 5