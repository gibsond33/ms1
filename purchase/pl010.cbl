      >> source format is free
program-id. pl010.
*> This program maintains the purchase record.
options.
  default rounded mode is nearest-even *> use banker's
  entry-convention is cobol
  .
environment division.configuration section.
source-computer. Linux.
object-computer. Linux.
input-output section.
file-control.
data division.
file section.
working-storage section.
01  program-name     pic x(15) value "pl010 (1.00.00)".

procedure division.
program-begin.
  perform opening-procedure
  perform main-process
  perform closing-procedure
  .
program-end.
  goback
  .
opening-procedure.
  *> To use the function keys, we need to set the
  *> following environment variables. This also forces
  *> the PgUp, PgDown, Esc, and PrtSc keys to be detected.
  set environment "COB_SCREEN_EXCEPTIONS" to "Y"
  set environment "COB_SCREEN_ESC" to "Y"
  *> We also set the program to not wait for user action.
*> set environment "COB_EXIT_WAIT" to "N"
  .
closing-procedure.
main-process.

end program pl010.
