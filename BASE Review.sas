/*Code Related to Chapter 2*/

/*Display metadata on all tables in library, supressing details using NODS*/
PROC CONTENTS DATA=sashelp._all_ NODS;
RUN;

/*Display metadata on all tables in library, with details*/
PROC CONTENTS DATA=sashelp._all_;
RUN;

/*Display metadata for individual table*/
/*By default, fields are listed in alphabetical order*/
PROC CONTENTS DATA=sashelp.zipcode;
RUN;

/*Display metadata for individual table*/
/*the varnum option lists the fields in the 'logical' order*/
PROC CONTENTS DATA=sashelp.zipcode varnum;
RUN;

/*CHAPTER 4 - PROC PRINT*/

/*basic*/
PROC PRINT data=sashelp.zipcode;
run;

/*list the variables you want to display with VAR, in this case just state and zip*/
PROC PRINT data=sashelp.zipcode;
	var state zip;
run;

/*Don't want the Obs column?  Use Noobs*/
PROC PRINT data=sashelp.zipcode noobs;
	var state zip;
run;

PROC PRINT data=sashelp.zipcode;
	id state;
run;


/*Code Related to Chapter 7 - Creating Unique Formats*/
libname base 'C:\Users\LukasHalim\Documents\My SAS Files\Base';
/*if you do not use lib= or library=, the format data will be placed in work.formats*/
proc format lib=base
 value jobfmt
     103='manager' 
     105='text processor' 
     111='assoc. technical writer' 
     112='technical writer' 
     113='senior technical writer'; 
run;

title 'Proc Format';
proc format lib=base fmtlib;
run;
