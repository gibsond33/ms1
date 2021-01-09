*>--------------
*> system-fd.cpy
*>--------------
fd  system-file.
01  system-record.
  05  system-record-version-number.
    10  system-record-version-major pic 9(02).
    10  system-record-version-minor pic 9(02).
  05  system-user-name              pic x(32).
  05  system-address-1   					  pic x(32).
  05  system-address-2   					  pic x(32).
  05  system-address-3   						pic x(32).
  05  system-address-4   						pic x(32).
  05  system-post-code   						pic x(12).
  05  system-country-name  			  	pic x(34).
  05  system-date-format          	pic x(01).
  05  system-time-format          	pic x(01).
  05  system-serial-number.
    10  system-serial-number-xx   	pic xx.
    10  system-serial-number-nnnn 	pic 9(04).
  05  system-lines-per-page 				pic 9(3).
  05  system-pass-code   						pic x(16).
  05  system-user-code   						pic x(32).
  05  system-restrict-parameter-access pic x.
  05  system-host-type      	 			pic 9.
  05  system-operating-system 			pic 9.
  05  system-print-spool-name	    	pic x(48).
  05  system-debug-stock 						pic x.
  05  system-audit-used 						pic x.
  05  system-average-pricing 				pic x.
  05  system-highest-pricing 				pic x.
