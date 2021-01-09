      >> source format is free
program-id. MS.
*> This program is the main menu for the management ledger system.
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
01  program-name             pic x(15) value "MS (1.00.00)".

01  user-credentials-are-valid pic x.
01  menu-choice              pic x.
01  menu-choice-is-okay      pic x.
  88  menu-choice-is-valid   values "A" "B" "C" "D" "E" "F" "G" "X" "Z".
  
*> Date and time

*> THis controls the entry and disply of the time.
*> Zulu is CUT (GMT).  ll times are stored in locl format for now.
01  time-formt-in-use pic x value "L".
  88  time-format-is-local  value "L".
  88  time-formt-is-zulu    value "Z".

01  current-date-and-time.
  05  cdt-year         pic 9(04).
  05  cdt-month        pic 9(02).
  05  cdt-day          pic 9(02).
  05  cdt-hour         pic 9(02).
  05  cdt-minute       pic 9(02).
  05  cdt-seconds      pic 9(02).
  05  filler           pic x(11).

01  the-date           pic 9999/99/99.
01  filler redefines the-date.
  05  the-date-year    pic 9(04).
  05  filler           pic x(01).
  05  the-date-month   pic 9(02).
  05  filler           pic x(01).
  05  the-date-day     pic 9(02).

01  the-time           pic 99/99/99.
01  filler redefines the-time.
  05  the-time-hour    pic 9(02).
  05  filler           pic x(01).
  05  the-time-min     pic 9(02).
  05  filler           pic x(01).
  05  the-time-sec     pic 9(02).

copy "date-time-ws.cpy".
*> System parameters
01  serial-number.
  05  serial-number-xx    pic xx   value "GD".
  05  serial-number-nnnn  pic 9999 value 1.

*> Working parameters
01  current-user   pic x(32).

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
	move "N" to user-credentials-are-valid 
	perform get-user-credentials
	if user-credentials-are-valid = "N"
	  display "error-message-about-user-credentials" end-display
	  accept omitted at 2402 end-accept
	  goback
	end-if

	*> user is okay
	
  accept the-time-is-now from time end-accept
  move the-time-is-now to the-display-time

  accept the-date-is-now from date YYYYMMDD end-accept
  move the-date-is-now to the-display-date
  
  inspect the-display-time replacing all "/" by ":"
>>D  display "*** " the-display-date " " the-display-time " ***" end-display

 *> We need to display a menu and have the user select
  *> an option, validate the option, and call the module
  *> selected.
  perform display-heading
  perform display-menu
  perform get-menu-pick
  perform maintain-the-file
    until menu-choice = "X"
.

get-user-credentials.
  move "Y" to user-credentials-are-valid
  move "Joe Smith Industries" to current-user
  .
  
display-heading.
  display " " at line 01 col 01 erase eos end-display
  display program-name at line 03 col 01 foreground-color 2 end-display
  display serial-number-xx at line 24 col 74 foreground-color 3 end-display
  display serial-number-nnnn at line 24 col 76 foreground-color 3 end-display
  display "Copyright (c) 2020-" at line 24 col 01 foreground-color 3 end-display
  display the-date-year at line 24 col 20 foreground-color 3 end-display
  display " Daniel Gibson." at line 24 col 24 foreground-color 3 end-display
  display current-user at line 01 col 01 foreground-color 3 end-display
  display "Management System Menu" at line 03 col 29 foreground-color 2 end-display
  display "at " at line 03 col 55 foreground-color 2 end-display
  display the-time at line 03 col 58 foreground-color 2 end-display
  display "on " at line 03 col 67 foreground-color 2 end-display
  display the-date at line 03 col 70 with foreground-color 2 end-display
  .
  
display-menu.
  display "System Menu" at line 03 col 30 foreground-color 2 end-display
  display  "(A)  General Ledger"  at line 10 col 04 erase eos foreground-color 2 end-display
  display  "(B)  Sales Ledger"    at line 11 col 04 foreground-color 2 end-display
  display  "(C)  Purchase Ledger" at line 12 col 04 foreground-color 2 end-display
  display  "(D)  Stock Control"   at line 13 col 04 foreground-color 2 end-display
  display  "(E)  Order Entry"     at line 14 col 04 foreground-color 2 end-display
  display  "(F)  Payroll"         at line 15 col 04 foreground-color 2 end-display
  display  "(G)  Epos"            at line 16 col 04 foreground-color 2 end-display
  display  "(H)  Recipe Book"     at line 10 col 44 foreground-color 2 end-display
  display  "(N)  Nutrition Data"  at line 11 col 44 foreground-color 2 end-display
  display  "(N)  Scheduler"       at line 12 col 44 foreground-color 2 end-display

  display  "(X)  Exit To system" At line 14 col 44 foreground-color 2 end-display
  display  "(Z)  System Setup" At line 16 col 44 foreground-color 2 end-display
  .
  
accept-menu-choice.
  display "Select one of the following by letter :- [ ]" at line 07 col 01 with foreground-color 2 end-display
  accept menu-choice at line 07 col 43 with foreground-color 6 end-accept
  move function upper-case(menu-choice) to menu-choice
  move "N" to menu-choice-is-okay
  if menu-choice = "A" or "B" or "C" or "D" or "E" or "F" or "G" or "X" or "Z"
      move "Y" to menu-choice-is-okay
  end-if
  .
re-accept-menu-choice.
  display "You must enter A, B, C, D, E, F, G, X, or Z" at line 23 col 02 foreground-color 4 end-display
  perform accept-menu-choice
  .
  
maintain-the-file.
  perform do-the-pick
  perform get-menu-pick
  .

get-menu-pick.
  move spaces to menu-choice
  perform display-menu
  perform accept-menu-choice
  perform re-accept-menu-choice
    until menu-choice-is-okay = "Y"
  .

do-the-pick.
  evaluate menu-choice
    when "C"
      call "purchase" end-call
    when "D"
      call "stock" end-call
    when "Z"
      call "syssetup" end-call
    when other
      display  "Sorry not yet available" at line 23 col 27 with foreground-color 5 end-display
      move space to menu-choice
  end-evaluate
  .

*>--------------
*> Date routines
*>--------------
get-the-date.
  move function current-date to current-date-and-time
  .
convert-the-date.
  move cdt-year  to the-date-year
  move cdt-month to the-date-month
  move cdt-day   to the-date-day
  .

*>get-the-time.
*>  accept current-time-n from time end-accept
*>  move current-time-n(1:2) to the-time-hour
*>  move current-time-n(3:2) to the-time-minutes
*>  move current-time-n(5:2) to the-time-seconds
  .
copy "date-pd.cpy".
copy "time-pd.cpy".

end program MS.
