@ECHO OFF
:: http://www.dostips.com/
:: DATE: 2015-05-22
::
:: Terms of Use
::
:: Description:	The information provided under the domain dostips.com is hopefully useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. All information is provided "as is". The information may be incorrect and you use it at your own risk. We take no responsibly for any damage that may unintentionally be caused through its use. 
:: You may not distribute any information provided under the domain dostips.com in any form without express written permission of the domain owner. To contact the dostips.com web master click here. 
:: The Terms and Conditions may change at any time without notice. 
::
:: We use third-party advertising companies to serve ads when you visit our website. These companies may use information (not including your name, address, email address, or telephone number) about your visits to this and other websites in order to provide advertisements about goods and services of interest to you. If you would like more information about this practice and to know your choices about not having this information used by these companies, click here. 
::
:: The Forum: 
:: By submitting information to the forum you transfer the rights of its content to the domain owner. The domain owner reserve the right to add, modify, or remove information to/from the forum as the domain owner feels is appropriate. 
:: The domain owner further reserves the right to use and distribute the information submitted in the forum in a different form, reformat it rearrange it and/or sell it.
::


:parseDate yyVar mmVar ddVar
::
:: Parses %DATE% into numeric year, month, and date components
::
::   yyVar = name of variable to hold numeric year value
::   mmVar = name ov variable to hold numeric month value
::   ddVar = name of variable to hold numeric day value

  setlocal enableDelayedExpansion
  
  :: Parse the native date format tokens output by the DATE command
  for /f "skip=1 tokens=2-4 delims=(-)" %%a in ('"echo:|date"') do (
  
    rem Parse the numeric date components of %DATE%
    for /f "tokens=1-3 delims=/.- " %%A in ("%date:* =%") do (
  
      rem Set variables named after native date tokens to appropriate numeric date component values
      set %%a=%%A
      set %%b=%%B
      set %%c=%%C
  
      rem Create string of sorted native date format tokens
      if %%a lss %%b if %%b lss %%c set "tokens=%%a %%b %%c"
      if %%a lss %%c if %%c lss %%b set "tokens=%%a %%c %%b"
      if %%b lss %%a if %%a lss %%c set "tokens=%%b %%a %%c"
      if %%b lss %%c if %%c lss %%a set "tokens=%%b %%c %%a"
      if %%c lss %%a if %%a lss %%b set "tokens=%%c %%a %%b"
      if %%c lss %%b if %%b lss %%a set "tokens=%%c %%b %%a"
    )
  )
  :: We now have variables with the correct values, but the code doesn't know
  :: the name of the variables! We must translate the unknown native variable
  :: names into known English names
  
  :: Initialize the translation of native tokens to English tokens
  set translate=
  set T_yy=
  set T_mm=
  set T_dd=
  
  :: Determine the correct token translation map
  :: Each map in the for list should contain the space delimited English tokens
  :: on the left followed by a semicolon followed by the space delimited native
  :: tokens on the right. The native tokens should be sorted alphabetically
  :: and the English tokens should be in the matching logical order.
  :: Currently supports English and German. Additional translation maps
  :: should be added for additional language support.
  for %%t in (
    "dd mm yy;dd mm yy"
    "yy mm dd;JJ MM TT"
  ) do (
    set test=%%~t
    if "!test:*;=!"=="%tokens%" set translate=%%~t
  )
  
  :: Parse the token translation map into variables used for translation
  for /f "tokens=1-6 delims=; " %%a in ("%translate%") do (
    set T_%%a=%%d
    set T_%%b=%%e
    set T_%%c=%%f
  )
  
  :: Transfer the values from native date variables to English date variables
  set E_yy=!%T_yy%!
  set E_mm=!%T_mm%!
  set E_dd=!%T_dd%!
  
  :: Eliminate leading zeros so that numbers aren't interpreted as octal
rem  set /a "E_yy=10000%E_yy% %%10000, E_mm=100%E_mm% %%100, E_dd=100%E_dd% %%100"
  
  :: Return the date values
  (endlocal
	SET FDATE=%E_yy%-%E_mm%-%E_dd%
  )
rem ECHO %FDATE%
EXIT /B 
