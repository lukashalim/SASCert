/*Code Related to Chapter 7 - Creating Unique Formats*/
libname base 'C:\Users\LukasHalim\Documents\My SAS Files\Base';
/*if you do not use lib= or library=, the format data will be placed in work.formats*/
/*Format name can be up to 32 characters and may NOT end in a number*/
/*for example, $countryfmt9 is not a valid format name*/
/*In the value statement, must not end with a period (.)*/
proc format;
 value $countryfmt
     'USA'='United States'
	 'RUS'='Russia'
	 'IL'='Israel';
run;

proc format;
 value $altcountryfmt
     'USA'='United States'
	 'RUS'='Russia'
	 'IL'='Israel'
	 'UK'='United Kingdom';
run;

/*examples of errors*/
proc format;
 value $countryfmt.
     'USA'='United States';
 value $countryfmt9
 	'USA'='United States';	
run;

/*using the data set we loaded in the chapter 6 code*/
data base.Employee;
	set base.Employee;
	format country $countryfmt.;
run;

proc print data=base.employee;
	format country $altcountryfmt.;
run;
