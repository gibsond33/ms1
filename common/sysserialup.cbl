        >> source format is free
program-id. sysserialup.
*> System file maintenance
options.
  default rounded mode is nearest-even *> use banker's
  entry-convention is cobol
  .
environment division.
configuration section.
source-computer. Linux.
object-computer. Linux.
special-names.
  numeric sign is trailing separate
  .
repository.
  function upper-case intrinsic.
input-output section.
file-control.
copy "system-sel.cpy".
data division.
file section.
copy "system-fd.cpy".
working-storage section.
01  ws-program-name   pic x(21)  value "sysserialup (0.01.01)".

01  ws-old-save-area.
  05  old-invoicing   pic 9.
  05  old-stock       pic 9.
  05  old-OE          pic 9.
  05  old-EPOS        pic 9.
  05  old-Payroll     pic 9.
  05  old-Project-Z   pic 9.
  05  wsmaps-ser.
    10  wsmaps-ser-xx pic xx.
    10  wsmaps-ser-nn pic 9(4).
  05  usera pic x(32).
01  pass-name pic x(32).

01  system-record-1.
  05  maps-serial-data.
    10  maps-ser-xx pic xx.
    10  maps-ser-nn pic 9(4).
copy "version-ws.cpy".
copy "system-ws.cpy".
01  relative-record-number pic 999.
01  file-status pic xx.

01  ws-user-credentials.
  05  encode-switch   pic x.
    88  pass                  value "P".
    88  user                  value "N".
  05  pass-code       pic x(16).
  05  user-name       pic x(32).

procedure division.
main-begin.
  perform opening-paragraph
  perform main-process
  perform closing-paragraph
  .
main-exit.
  goback
  .
opening-paragraph.
  *> Force Esc, PgUp, PgDown, PrtSC to be detected
  set environment "COB_SCREEN_EXCEPTIONS" to "Y"
  set environment "COB_SCREEN_ESC" to "Y"
  set environment "COB_EXIT_WAIT"  to "N"
  perform display-do-not-issue

  open i-o system-file
  if file-status not = zero
    display "No system file found to update" at 1001 with foreground-color 2 end-display
    display "Hit return to exit" at 1101    with foreground-color 2 end-display
    accept omitted at 1120 end-accept
    close system-file
    goback
  end-if
  move 1 to relative-record-number
  read system-file end-read
  *> display "sys rec:"  system-system-record end-display
  .
closing-paragraph.
  close system-file
  .
main-process.
  perform verify-user-by-name
  perform do-serializer
  accept omitted end-accept
  rewrite system-record end-rewrite
  .
verify-user-by-name.
  display  "Customer's name :-           [" at 1101  with foreground-color 2 end-display
  display  "]" at 1163 with foreground-color 2 end-display
  display system-user-name at 1131 with foreground-color 3 end-display
  accept system-user-name with update end-accept

  move system-user-name to  user-name
  *> display "ws-user-credentials=[" ws-user-credentials "]" end-display

  move "N"  to  encode-switch
  call "encode" using ws-user-credentials end-call
  *> display "user-name=[" user-name "]" end-display

  if user-name not = system-user-code
    display "Customer name mismatch, Hit return to close" at 1501  foreground-color 4 end-display
    display "I really should abort here" with foreground-color 5 end-display
  end-if
  accept omitted end-accept
  .
do-serializer.
  move     system-serial-number-xx to wsmaps-ser-xx.
  move     system-serial-number-nnnn to wsmaps-ser-nn.

*>  perform dump-system-record
*>
  display  "          Serial number   :- [" at 1501  with foreground-color 2 end-display
  display  "]" at 1537 with foreground-color 2 end-display
  display  wsmaps-ser at 1531 with foreground-color 3 end-display
  accept   wsmaps-ser at 1531 with update end-accept
  move     wsmaps-ser-xx to system-serial-number-xx
  move     wsmaps-ser-nn to system-serial-number-nnnn
  *> perform dump-system-record
  .
display-do-not-issue.
  display  "*****************************************" at 0420  with foreground-color 2 end-display
  display  "* This Program is for internal use only *" at 0520  with foreground-color 2 end-display
  display  "*" at 0620 with foreground-color 2 end-display
  display  "*" at 0660 with foreground-color 2 end-display
  display  "*              DO NOT ISSUE             *" at 0720  with foreground-color 4 blink end-display
  display  "*" at 0720 with foreground-color 2 end-display
  display  "*" at 0760 with foreground-color 2 end-display
  display  "*" at 0820 with foreground-color 2 end-display
  display  "*" at 0860 with foreground-color 2 end-display
  display  "*****************************************" at 0920  with foreground-color 2 end-display
  .
*> screen common routines.
show-banner.
  display ws-program-name at line 01 column 01 erase eos foreground-color 2 end-display
  display "S Y S T E M  U P D A T E" at line 01 column 28 foreground-color 2 end-display
  display "2020/12/23" at line 01 column 71 foreground-color 2 end-display
  .
dump-system-record.
  display "serial-number-xx=" system-serial-number-xx upon syserr end-display
  display "serial-number-nnn=" system-serial-number-nnnn upon syserr end-display
  .
end program sysserialup.
