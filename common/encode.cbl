      >> source format is free
program-id. encode.
*> Encoder for user name and pass code
data division.
working-storage section.
01  ws-data.
  05  alpha           pic x(26)     value "CKQUAELSMWYIZJRPBXFVGNODTH".
  05  filler  redefines  alpha.
    10  ar1           pic x         occurs  26 indexed by xx.
  05  alower          pic x(26)     value "ckquaelsmwyizjrpbxfvgnodth".
  05  filler  redefines  alower.
    10  ar1-l         pic x         occurs  26  indexed by a.

  05  pass-word-input.
    10  ar2           pic x         occurs  16.
  05  pass-word-output.
    10  ar3           pic x         occurs  16.

  05  pass-word-length  pic 99  value 16.

  05  pass-name-input.
    10  ar4           pic x         occurs  32.
  05  pass-name-output.
    10  ar5           pic x         occurs  32.
  05  pass-name-length  pic 99  value 32.


77  q                 pic s9(9)      computational.
77  y                 pic s9(9)      computational.
77  z                 pic s9(9)      computational.
77  base              pic s9(9)      computational.

*> Debugging loops
01  uu pic 9(5) computational.
01  upper-was-founding pic x.
  88  upper-was-found value "Y".
  88  upper-not-found value "N".
01  lower-was-founding pic x.
  88  lower-was-found value "Y".
  88  lower-not-found value "N".

linkage section.
01  l-user-credentials.
  05  encode-switch   pic x.
    88  pass                  value "P".
    88  user                  value "N".
  05  pass-code       pic x(16).
  05  user-name       pic x(32).

procedure division  using  l-user-credentials.
  if not  pass
    perform encode-name
  else
    perform encode-pass
  end-if

  goback
  .

encode-name.
  move user-name to pass-name-input
  move 1 to y
  perform varying y from 1 by 1 until y > pass-name-length
    set xx to 1
    set upper-was-found to true
    search ar1
      at end
        set upper-not-found to true
      when  ar1(xx) = ar4(y)
        set a to xx
        perform set-base-case
    end-search
    if upper-not-found
       perform test-lower-case
    end-if
  end-perform
  move pass-name-output to user-name
  .
test-lower-case.
  set lower-was-found to true
  set a to 1
  search ar1-l
    at end
      set lower-not-found to true
    when  ar1-l(a) = ar4(y)
      perform set-base-case
  end-search
  .
set-base-case.
  add y 51  giving  base end-add
  divide base by y giving base rounded end-divide
  if base > 25 then
    subtract 26 from base end-subtract
  end-if
  set z to a

  add base to z end-add

  subtract 27 from z end-subtract

  if z < 1
    multiply z by -1 giving z end-multiply
  end-if

  if z > 26
     subtract  26  from  z end-subtract
  end-if

  if z not = zero
    move ar1(z) to ar5(y)
  else
    move space to ar5(y)
  end-if
  .

encode-pass.
  move pass-code  to pass-word-input
  move 1  to  y
  perform varying y from 1 by 1 until y > pass-word-length
    set xx to 1
    set upper-was-found to true
    search ar1
      at end
        set upper-not-found to true
      when  ar1(xx) = ar2(y)
        set a to xx
        perform set-base-pass
    end-search
    if upper-not-found
       perform test-lower-pass
    end-if
  end-perform
  move pass-word-output to pass-code
  .
test-lower-pass.
  set lower-was-found to true
  set a to 1
  search ar1-l
    at end
      set lower-not-found to true
    when  ar1-l(a) = ar2(y)
      perform set-base-pass
  end-search
  .
set-base-pass.
  multiply y by y giving base end-multiply
  add 3 to base end-add
  set z to a
  add base to z end-add

  subtract 26 from z end-subtract

  if z < 1
    multiply z by -1 giving z end-multiply
  end-if

  subtract y from 5 giving q end-subtract

  if z not = zero
    move ar1(z) to ar3(q)
  else
    move space to ar3(q)
  end-if
  .

main-exit.
  goback
    .
end program encode.
