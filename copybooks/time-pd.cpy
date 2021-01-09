*> Time {{{
*> This routine checks for a valid time.
check-time.
*>unstring purchase-time-hhmmss delimited by ":" into the-check-hour,the-check-minutes,the-check-seconds end-unstring
*>  display purchase-time-hhmmss at line 23 col 02 foreground-color 5 end-display
*>  accept omitted end-accept
*>  move purchase-time-hhmmss(1:2) to the-check-hour
*>  move purchase-time-hhmmss(4:2) to the-check-minutes
*>  move purchase-time-hhmmss(7:2) to the-check-seconds
  display the-check-time at line 23 col 02 foreground-color 1 end-display
  accept omitted end-accept
  if the-check-seconds = spaces
    move zeroes to the-check-seconds
  end-if
  move "Y" to the-time-is-valid
  if the-check-time = zeroes
    move "Y" to the-time-is-valid
  else
    if the-check-hour > 23
      move "N" to the-time-is-valid
    else
      if the-check-minutes > 59
        move "N" to the-time-is-valid
      else
        if the-check-seconds > 59
          move "N" to the-time-is-valid
        end-if
      end-if
    end-if
  end-if
  if the-check-hour= 24 and the-check-minutes = zero and the-check-seconds = zero
    move "Y" to the-time-is-valid
  end-if
>>D  display " " at 2402 erase eol end-display
>>D  display "time valid=" at 2402 end-display
>>D  display the-time-is-valid at 2413 end-display
>>D  accept omitted at 2478 end-accept
>>D  display " " at 2402 erase eol end-display
  .
*>}}}
