*> Date and time {{{
*> This controls the date entry format.  All dates are stored in CCYYMMDD.
01  date-format-in-use          pic x       value "I".
  88  date-format-is-internatioanl          value "I".
  88  date-format-is-united-kingdom         value "K".
  88  date-format-is-united-states          value "S".
01  date-format-work            pic x(10)   value "dd/mm/ccyy".


01  the-display-time            pic xx/xx/xx.
01  filler redefines the-display-time.
  05  the-display-hour          pic 99.
  05  filler                    pic x.
  05  the-display-min           pic 99.
  05  filler                    pic x.
  05  the-display-sec           pic 99.

01  the-date-is-now             pic x(08).

01  the-display-date            pic xxxx/xx/xx.

01  the-check-date              pic xxxx/xx/xx.
01  filler redefines the-check-date.
  05  the-check-year.
    10  the-check-year-cc       pic 99.
    10  the-check-year-yy       pic 99.
  05  filler                    pic x.
  05  the-check-month           pic 99.
  05  filler                    pic x.
  05  the-check-day             pic 99.
01  the-date-quotient           pic 9(04).
01  the-date-remainder          pic 9(04).

01  the-time-is-now             pic x(08).

01  filler redefines the-time-is-now.
  05  the-time-is-hour          pic 99.
  05  the-time-is-min           pic 99.
  05  the-time-is-sec           pic 99.
  05  the-time-is-hun           pic 99.

01  the-check-time              pic xx/xx/xx.
01  filler redefines the-check-time.
  05  the-check-hour            pic xx.
  05  filler                    pic x.
  05  the-check-minutes         pic xx.
  05  filler                    pic x.
  05  the-check-seconds         pic xx.

01  the-time-is-valid           pic x.
01  the-date-is-valid           pic x.
*> }}}


