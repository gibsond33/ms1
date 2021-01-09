       >> source format is free
program-id. syssetup.
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
01  ws-program-name pic x(19) value "syssetup (01.01.01)".

copy "version-ws.cpy".
copy "system-ws.cpy".
01  system-record-2.
  05  user-data.
    10  name   pic x(32).
    10  address-1   pic x(48).
    10  address-2   pic x(48).
    10  address-3   pic x(48).
    10  address-4   pic x(48).
    10  post-code   pic x(12).
    10  country-name pic x(34).
    10  serial-data.
      15  serial-xx   pic xx.
      15  serial-nnnn binary-short.
    10  date-format pic 9.
      88  date-uk               value 1.  		*> dd/mm/yyyy
      88  date-usa              value 2.  		*> mm/dd/yyyy
      88  date-Intl             value 3.  		*> yyyy/mm/dd
      88  date-valid-Formats    values 1 2 3.
    10  lines-per-page pic 999.
    10  pass-code   pic x(16).
  05  system-data.
    10  restrict-parameter-access pic 9.
    10  host-type pic 9.
    10  operating-system pic 9.
    10  print-spool-name   pic x(48).
  05  stock-data.
    10  debug-stock    pic x.
    10  audit-used     pic x.
    10  average-pricing  pic x.
    10  highest-pricing  pic x.

01  ws-save-data-area.
  05  ws-save-name   pic x(32).
  05  ws-save-address-1   pic x(32).
  05  ws-save-address-2   pic x(32).
  05  ws-save-address-3   pic x(32).
  05  ws-save-address-4   pic x(32).
  05  ws-save-post-code   pic x(12).
  05  ws-save-country-name   pic x(34).
  05  ws-save-serial-xx   pic x(2).
  05  ws-save-serial-nnnn binary-short.
  05  ws-save-date-format pic 9.
  05  ws-save-lines-per-page pic 9(3).
  05  ws-save-pass-code   pic x(16).
  05  ws-save-restrict-parameter-access pic x.
  05  ws-save-host-type pic 9.
  05  ws-save-operating-system pic 9.
  05  ws-save-print-spool-name   pic x(48).
  05  ws-save-debug-stock pic x.
  05  ws-save-audit-used pic x.
  05  ws-save-average-pricing pic x.
  05  ws-save-highest-pricing pic x.

01  relative-record-number pic 999.
01  file-status pic xx.

01  ws-input-x  pic x.
01  ws-input-xxx  pic xxx.

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
*>  perform create-system-file
  open i-o system-file
*> display "open file status=" file-status end-display
  if file-status not = zero
    display "SY101 Open I-O Err = " at 0310 end-display
    display file-status at  0330 end-display
    display " " at 0410 end-display
    display "SY104 Fix and Press Enter" end-display
    accept omitted at 2420 end-accept
  end-if
  move 1 to relative-record-number
  read system-file end-read
*>display "read file status=" file-status end-display
  if file-status not = zero
    move zero to file-status
    initialize system-record
    move ws-sys-record-ver-major to ws-system-record-version-major
    move ws-sys-record-ver-minor to ws-system-record-version-minor
    move "S" to system-date-format
    move 1 to relative-record-number
    rewrite system-record end-rewrite
*>display "write file status=" file-status end-display
    read system-file end-read
*>display "read2 file status=" file-status end-display
  end-if
*>     03  SY101    pic x(24) value "SY101 Open I-O Err = ".
*>     03  SY102    pic x(46) value "SY102 Read Err 1 = ".
*>     03  SY103    pic x(38) value "SY103 Rewrite Err 1 = ".
*>     03  SY105    pic x(16) value "SY105 Lines > 28".
  .
closing-paragraph.
  close system-file
  .
main-process.
  perform get-user-data
  perform get-system-data
  perform get-stock-data

  move 1 to relative-record-number
  rewrite system-record end-rewrite
  *> display "rewrite file status=" file-status upon syserr end-display
  .
get-user-data.
  perform display-user-data
  perform show-user-data
  accept omitted at 2421 end-accept
  perform accept-user-data
  if system-date-format = "K"
    display "    Using UK format dd/mm/ccyy  " at line 14 col 25 with erase eol foreground-color 3 end-display
  else
    if system-date-format = "S"
      display "    Using USA format mm/dd/ccyy " at line 14 col 25 with erase eol foreground-color 3 end-display
    else
      if system-date-format = "I"
        display "    Using Intl format ccyy/mm/dd" at line 14 col 25 with erase eol foreground-color 3 end-display
      else
        display "    Incorectly Set. You MUST set this"
                                        at line 14 col 25 with erase eol foreground-color 4 highlight
        end-display
        move "I" to system-date-format
      end-if
    end-if
  end-if

  move system-user-name to user-name
  move "N"  to  encode-switch
  call "encode" using ws-user-credentials end-call
  *> display "user-name=[" user-name "]" upon syserr end-display
  move user-name to system-user-code
  .

display-user-data.
  perform show-banner
  display "User Data" at line 04 col 45 foreground-color 2 end-display
  display "Name:     [" at line 07 col 08 foreground-color 2 end-display
  display "]" at line 7 col 51 foreground-color 2 end-display
  display "Address:  [" at line 08 col 08 foreground-color 2 end-display
  display "]" at line 8 col 67 foreground-color 2 end-display
  display "          [" at line 09 col 08 foreground-color 2 end-display
  display "]" at line 9 col 67 foreground-color 2 end-display
  display "          [" at line 10 col 08 foreground-color 2 end-display
  display "]" at line 10 col 67 foreground-color 2 end-display
  display "          [" at line 11 col 08 foreground-color 2 end-display
  display "]" at line 11 col 67 foreground-color 2 end-display
  display "Post Code:[" at line 12 col 08 foreground-color 2 end-display
  display "]" at line 12 col 31 foreground-color 2 end-display
  display "Country:  [" at line 13 col 08 foreground-color 2 end-display
  display "]" at line 13 col 53 foreground-color 2 end-display
  display "Date Format:[" at line 14 col 08 foreground-color 2 end-display
  display "]" at line 14 col 22 foreground-color 2 end-display
  display "  (1 = UK, 2 = USA, 3 = Intl)" at line 14 col 23 foreground-color 2 end-display
  display "Lines Per Page:[" at line 15 col 08 foreground-color 2 end-display
  display "]" at line 15 col 27 foreground-color 2 end-display
  display "Pass Code:[" at line 16 col 08 foreground-color 2 end-display
  display "]" at line 16 col 35 foreground-color 2 end-display
  display "Press ESC to quit" at line 24 col 02 foreground-color 2 end-display
 .
show-user-data.
  display system-user-name at line 07 col 19 foreground-color 3 end-display
  display system-address-1 at line 08 col 19 foreground-color 3 end-display
  display system-address-2 at line 09 col 19 foreground-color 3 end-display
  display system-address-3 at line 10 col 19 foreground-color 3 end-display
  display system-address-4 at line 11 col 19 foreground-color 3 end-display
  display system-post-code at line 12 col 19 foreground-color 3 end-display
  display system-country-name at line 13 col 19 foreground-color 3 end-display
  display system-date-format at line 14 col 21 foreground-color 3 end-display
  display system-lines-per-page at line 15 col 24 foreground-color 3 end-display
  display system-pass-code at line 16 col 19 foreground-color 3 end-display
  .
accept-user-data.
  move system-user-name to ws-save-name
  accept system-user-name at line 07 col 19 foreground-color 6 end-accept
  if system-user-name = spaces
    move ws-save-name to system-user-name
  end-if

  move system-address-1 to ws-save-address-1
  accept system-address-1 at line 08 col 19 foreground-color 6 end-accept
  if system-address-1 = spaces
    move ws-save-address-1 to system-address-1
  end-if

  move system-address-2 to ws-save-address-2
  accept system-address-2 at line 09 col 19 foreground-color 6 end-accept
  if system-address-2 = spaces
    move ws-save-address-2 to system-address-2
  end-if

  move system-address-3 to ws-save-address-3
  accept system-address-3 at line 10 col 19 foreground-color 6 end-accept
  if system-address-3 = spaces
    move ws-save-address-3 to system-address-3
  end-if

  move system-address-4 to ws-save-address-4
  accept system-address-4 at line 11 col 19 foreground-color 6 end-accept
  if system-address-4 = spaces
    move ws-save-address-4 to system-address-4
  end-if

  move system-post-code to ws-save-post-code
  accept system-post-code at line 12 col 19 foreground-color 6 end-accept
  if system-post-code = spaces
    move ws-save-post-code to system-post-code
  end-if

  move system-country-name to ws-save-country-name
  accept system-country-name at line 13 col 19 foreground-color 6 end-accept
  move function upper-case(system-country-name) to system-country-name
  if system-country-name = spaces
    move ws-save-address-1 to system-country-name
  end-if

  move system-date-format to ws-save-date-format
  accept ws-input-x at line 14 col 21 foreground-color 6 end-accept
  if ws-input-x = spaces
    move ws-save-date-format to system-date-format
  else
    move function numval(ws-input-x) to system-date-format
  end-if

  move system-lines-per-page to ws-save-lines-per-page
  accept ws-input-xxx at line 15 col 24 foreground-color 6 end-accept
  if ws-input-xxx = spaces
    move ws-save-lines-per-page to system-lines-per-page
  else
    move function numval(ws-input-xxx) to system-lines-per-page
  end-if

  move system-pass-code to ws-save-pass-code
  accept system-pass-code at line 16 col 19 foreground-color 6 end-accept
  if system-pass-code = spaces
    move ws-save-pass-code to system-pass-code
  end-if
  .
get-system-data.
  perform display-system-data
  perform show-system-data
  accept omitted end-accept
  perform accept-system-data
  *>perform dump-system-record
  accept omitted end-accept
  .
display-system-data.
  perform show-banner
  display "System Data" at line 04 col 44 foreground-color 2 end-display
  display "Restrict Parameter Access:[" at line 07 col 08 foreground-color 2 end-display
  display "]  (Y/N)" at line 07 col 36 foreground-color 2 end-display
  display "Single/Multiuser:[" at line 08 col 08 foreground-color 2 end-display
  display "]  (0=Single, 1=Multi)" at line 08 col 27 foreground-color 2 end-display
  display "Operating System:[" at line 09 col 08 foreground-color 2 end-display
  display "]" at line 09 col 27 foreground-color 2 end-display
  display  "(1=Dos, 2=Windows," &
          " 3=Mac, 4=OS/2, 5=Unix, 6=Linux)" at line 09 col 30 foreground-color 2 end-display
  display "Cups Print Spool Name:[" at line 10 col 08 foreground-color 2 end-display
  display "]" at line 10 col 79 foreground-color 2 end-display
  .
show-system-data.
  display system-restrict-parameter-access at line 07 col 35 foreground-color 3 end-display
  display system-host-type at line  08 col 26 foreground-color 3 end-display
  display system-operating-system at line 09 col 26 foreground-color 3 end-display
  display system-print-spool-name at line 10 col 31 foreground-color 3 end-display
  .
accept-system-data.
  move system-restrict-parameter-access to ws-save-restrict-parameter-access
  accept system-restrict-parameter-access at line 07 col 35 foreground-color 6 end-accept
  move function upper-case(system-restrict-parameter-access) to system-restrict-parameter-access
  if system-restrict-parameter-access = spaces
    move ws-save-restrict-parameter-access to system-restrict-parameter-access
  end-if

  move system-host-type to ws-save-host-type
  accept ws-input-x at line 08 col 26 foreground-color 6 end-accept
  if ws-input-x = spaces
    move ws-save-host-type to system-host-type
  else
    move function numval(ws-input-x) to system-host-type
  end-if

  move system-operating-system to ws-save-operating-system
  accept ws-input-x at line 09 col 26 foreground-color 6 end-accept
  if ws-input-x = spaces
    move ws-save-operating-system to system-operating-system
  else
    move function numval(ws-input-x) to system-operating-system
  end-if

  move system-print-spool-name to ws-save-print-spool-name
  accept system-print-spool-name at line 10 col 31 foreground-color 6 end-accept
  if system-print-spool-name = spaces
    move ws-save-print-spool-name to system-print-spool-name
  end-if
  .

get-stock-data.
  perform display-stock-data
  perform show-stock-data
  accept omitted end-accept
  perform accept-stock-data
  perform show-stock-data
  accept omitted end-accept
  .
display-stock-data.
  perform show-banner
  display "Stock Data" at line 4 col 35 foreground-color 2 end-display
  display "Debugging:  [" at line 07 col 08 foreground-color 2 end-display
  display "] (Y/N)" at line 07 col 22 foreground-color 2 end-display
  display "Audit Used: [" at line 08 col 08 foreground-color 2 end-display
  display "] (Y/N)" at line 08 col 22 foreground-color 2 end-display
  display "Average Pricing:  [" at line 09 col 08 foreground-color 2 end-display
  display "] (Y/N)" at line 09 col 28 foreground-color 2 end-display
  display "Highest Pricing:  [" at line 10 col 08 foreground-color 2 end-display
  display "] (Y/N)" at line 10 col 28 foreground-color 2 end-display
  .
show-stock-data.
  display system-debug-stock at line 07 col 21 foreground-color 3 end-display
  display system-audit-used at line 08 col 21 foreground-color 3 end-display
  display system-average-pricing at line 09 col 27 foreground-color 3 end-display
  display system-highest-pricing at line 10 col 27 foreground-color 3 end-display
  .
accept-stock-data.
  move system-debug-stock to ws-save-debug-stock
  accept system-debug-stock at line 07 col 21 foreground-color 6 end-accept
  move function upper-case(system-debug-stock) to system-debug-stock
  if system-debug-stock = spaces
    move ws-save-debug-stock to system-debug-stock
  end-if

  move system-audit-used to ws-save-audit-used
  accept system-audit-used at line 08 col 21 foreground-color 6 end-accept
  move function upper-case(system-audit-used) to system-audit-used
  if system-audit-used = spaces
    move ws-save-audit-used to system-audit-used
  end-if

  move system-average-pricing to ws-save-average-pricing
  accept system-average-pricing at line 09 col 27 foreground-color 6 end-accept
  move function upper-case(system-average-pricing) to system-average-pricing
  if system-average-pricing = spaces
    move ws-save-average-pricing to system-average-pricing
  end-if

  move system-highest-pricing to ws-save-highest-pricing
  accept system-highest-pricing at line 10 col 27 foreground-color 6 end-accept
  move function upper-case(system-highest-pricing) to system-highest-pricing
  if system-highest-pricing = spaces
    move ws-save-highest-pricing to system-highest-pricing
  end-if
  .
*> screen common routines.
show-banner.
  display ws-program-name at line 01 column 01 erase eos foreground-color 2 end-display
  display "S Y S T E M  S E T - U P" at line 01 column 28 foreground-color 2 end-display
  display "2020/12/23" at line 01 column 71 foreground-color 2 end-display
  .
create-system-file.
  open output system-file
  display "create file status=" file-status end-display
  move 1 to relative-record-number
  initialize system-record
  perform generate-test-record
  write system-record end-write
  display "write file status=" file-status end-display
  close system-file
  display "close file status=" file-status end-display
  .
generate-test-record.
  move 1 to system-record-version-major
  move 1 to system-record-version-minor
  move "GD Consulting Services, LLC" to system-user-name
  move "12354 Somewhere Blvd" to system-address-1
  move "Penthouse Suite" to system-address-2
  move "Sometown" to system-address-3
  move "Anywhere" to system-address-4
  move "85635-4323" to system-post-code
  move "United States of America" to system-country-name
  move "00" to system-serial-number-xx
  move zeroes to system-serial-number-nnnn
  move "L" to system-date-format
  move 55 to system-lines-per-page
  move "Uxa123%$#@qwtu" to system-pass-code
  move 6 to system-operating-system
  move 1 to system-host-type
  move "Y" to system-restrict-parameter-access
  move "HP-HP-Officejet-Pro-8610" to system-print-spool-name
  move "Y" to system-debug-stock system-audit-used system-average-pricing
  move "N" to system-highest-pricing
  .
dump-system-record.
  display "version major=[" system-record-version-major "]" end-display
  display "version minor=[" system-record-version-minor "]" end-display
  display "name=[" system-user-name "]" end-display
  display "address 1=[" system-address-1 "]" end-display
  display "address 2=[" system-address-2 "]" end-display
  display "address 3=[" system-address-3 "]" end-display
  display "address 4=[" system-address-4 "]" end-display
  display "version-major=[" system-post-code "]" end-display
  display "country=[" system-country-name "]" end-display
  display "serial-xx=[" system-serial-number-xx "]" end-display
  display "serial-nnnn=[" system-serial-number-nnnn "]" end-display
  display "date format=[" system-date-format "]" end-display
  display "lines per page=[" system-lines-per-page "]" end-display
  display "pass-code=[" system-pass-code "]" end-display
  display "op sys=[" system-operating-system "]" end-display
  display "host type=[" system-host-type "]" end-display
  display "version-major=[" system-restrict-parameter-access "]" end-display
  display "print spool=[" system-print-spool-name "]" end-display
  display "debug stock=["  system-debug-stock "]" end-display
  display "audit used=[" system-audit-used "]" end-display
  display "avg price=[" system-average-pricing "]" end-display
  display "high price=[" system-highest-pricing "]" end-display
  display "user code=[" system-user-code "]" end-display
  .
end program syssetup.
