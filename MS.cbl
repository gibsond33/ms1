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

*> System parameters
01  serial-number.
  05  serial-number-xx    pic xx   value "GD".
  05  serial-number-nnnn  pic 9999 value 1.

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
	perform display-headings
	move "N" to menu-choice-is-okay
	perform accept-menu-choice
	perform re-accept-menu-choice
		until menu-choice-is-okay = "Y"
	perform do-the-menu-choice
.

get-user-credentials.
  move "Y" to user-credentials-are-valid
  move "Joe Smith Industries" to current-user
  .
  
display-headings.
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
  display  "(A)  General Ledger"  at 1004 erase eos foreground-color 2 end-display
  display  "(B)  Sales Ledger"    at 1104 foreground-color 2 end-display
  display  "(C)  Purchase Ledger" at 1204 foreground-color 2 end-display
  display  "(D)  Stock Control"   at 1304 foreground-color 2 end-display
  display  "(E)  Order Entry"     at 1404 foreground-color 2 end-display
  display  "(F)  Payroll"         at 1504 foreground-color 2 end-display
  display  "(G)  Epos"            at 1604 foreground-color 2 end-display
  display  "(H)  Recipe Book"     at 1044 foreground-color 2 end-display
  display  "(N)  Nutrition Data"  at 1144 foreground-color 2 end-display
  display  "(N)  Scheduler"       at 1244 foreground-color 2 end-display

  display  "(X)  Exit To system" At 1444 foreground-color 2 end-display
  display  "(Z)  System Setup" At 1644 foreground-color 2 end-display
  .
  
accept-menu-choice.
  display "Select one of the following by letter :- [ ]" at 0701 with foreground-color 2 end-display
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
  
do-the-menu-choice.

end program MS.
