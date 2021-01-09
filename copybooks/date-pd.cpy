*> Date {{{
*> This procedure checks for a valid date.
validate-the-date.
*>>>D  display the-receipt-date at line 23 col 02 foreground-color 5 end-display
*>>>D  accept omitted end-accept
*>  if date-format-is-united-states 
*>    unstring the-receipt-date delimited by "/" into the-check-month,the-check-day,the-check-year  end-unstring
*>  end-if
*>  if date-format-is-united-kingdom 
*>    unstring the-receipt-date delimited by "/" into the-check-day,the-check-month,the-check-year  end-unstring
*>  end-if
*>  if date-format-is-internatioanl 
*>    unstring the-receipt-date delimited by "/" into the-check-year,the-check-month,the-check-day  end-unstring
*>  end-if
>>D  display the-check-date at line 23 col 02 foreground-color 5 end-display
>>D  accept omitted at line 23 col 34 end-accept
  move "Y" to the-date-is-valid
  perform check-year
  if the-date-is-valid = "Y"
    perform check-month
  end-if
  if the-date-is-valid = "Y"
    perform check-day
  end-if
  if the-date-is-valid = "Y"
    perform check-month-day
  end-if
  if the-date-is-valid = "Y"
    perform check-leap-year
  end-if
>>D  display " " at 2402 erase eol end-display
>>D  display "date valid=" at 2402 end-display
>>D  display the-date-is-valid at 2413 end-display
>>D  accept omitted end-accept
>>D  display " " at 2402 erase eol end-display
  .
  
check-year.
  if (the-check-year-cc > 20) or (the-check-year-cc < 19)
    move "N" to the-date-is-valid
  end-if
  .
  
check-month.
  if (the-check-month < 1) or (the-check-month > 12)
    move "N" to the-date-is-valid
  end-if
  .
  
check-day.
  if (the-check-day < 1) or (the-check-day > 31)
    move "N" to the-date-is-valid
  end-if
  .
  
check-month-day.
  if the-check-day = 31 and (the-check-month = 4 or 6 or 9 or 11) 
    move "N" to the-date-is-valid
  end-if
  if the-check-day > 29 and the-check-month = 2
    move "N" to the-date-is-valid
  end-if
  .
  
check-leap-year.
  if the-check-month = 2 and the-check-day = 29
    divide the-check-year by 400 giving the-date-quotient remainder the-date-remainder end-divide
>>D    display " " at 2402 erase eol end-display
>>D    display "date 400 remainder=" at 2402 end-display
>>D    display the-date-remainder at 2413 end-display
>>D  accept omitted at 2478 end-accept
    if the-date-remainder = zero
      move "N" to the-date-is-valid
    else
      divide the-check-year by 100 giving the-date-quotient remainder the-date-remainder end-divide
>>D      display " " at 2402 erase eol end-display
>>D      display "date 100 remainder=" at 2402 end-display
>>D      display the-date-remainder at 2413 end-display
>>D  accept omitted at 2478 end-accept
      if the-date-remainder = zero 
        move "N" to the-date-is-valid
      else
        divide the-check-year by 4 giving the-date-quotient remainder the-date-remainder end-divide
>>D        display " " at 2402 erase eol end-display
>>D        display "date 4 remainder=" at 2402 end-display
>>D        display the-date-remainder at 2413 end-display
>>D  accept omitted at 2478 end-accept
        if the-date-remainder equals zero
          move "Y" to the-date-is-valid
        else
          move "N" to the-date-is-valid
        end-if
      end-if
    end-if
  end-if
  .

