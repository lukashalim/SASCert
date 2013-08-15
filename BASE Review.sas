/*Chapter 1*/
/*create data*/
data work.person;
   	input Name $;
   	datalines;
Jonathan
;
run;

/*this gives a warning because the length needs to come earlier*/
data work.person;
	set work.person;
	Fullname = Name || ' FakeLastName';
	length fullname $ 33;
run;

/*the length statement works correctly here*/
data work.person;
	set work.person;
	length fullname $ 21;
	Fullname = Name || ' FakeLastName';
run;

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

/*Use the datalines command to create data*/
data work.person;
   input name $ age salary HireDate MMDDYY6.;
   datalines;
John 23 1245 101513
Mary 37 40000 101599
Tom 53 60180 011490
William 37 77890 011405
Scott 39 80000 012411
Jessica 37 90105 011410
Liz 23 50000 011410
;
run;

/*basic*/
PROC PRINT data=work.person;
run;

/*list the variables you want to display with VAR, in this case just state and zip*/
PROC PRINT data=work.person;
	var name age;
run;

/*hide the obs column using NOOBS*/
PROC PRINT data=work.person noobs;
	var name age;
run;

/*Make "Name" the id column using ID*/
PROC PRINT data=work.person noobs;
	id name; 
	var age;
run;

/*Only print the first 10 observations*/
PROC PRINT data=sashelp.zipcode (obs=10);
	var state zip;
run;

/*Use PROC SORT to order by age*/
/*Note that if you don't use the out= option, the sort command will overwrite your dataset.*/
/*In this case, since we did not use out=, work.person is sorted on age.*/
proc sort data=work.person;
	by age;
run;
proc print data=work.person;
run;

/*Now we use titles and footnotes*/
title1 'Proc Print';
title2 'on Work.Person';
title3 '(after sorting on age)';
footnote1 'My footnote1';
footnote2 'My footnote2';
footnote3 'My footnote3';
proc print data=work.person;
run;

/*now reset title2 and note that title3 is also removed (along with any higher numbered titles*/
title2;
/*and change footnote2.  This will remove footnote2 and any higher numbered footnotes*/
footnote2 'My Modified footnote2';
proc print data=work.person;
run;

/*display the total salary using sum*/
proc print data=work.person;
	var name;
	sum salary;
run;

/*assign a temporary label*/
/*Format the date field*/
proc print data=work.person;
	label name='Employee Name';
	format salary 5. HireDate MMDDYY.;
run;

/*Notice that the dollar symbol DOES NOT print for anyone other than John*/
/*This is because the width is 5.  All of the salaries except for John's require*/
/*the full width of 5, so there is no room for the dollar sign.*/
proc print data=work.person;
	label name='Employee Name';
	format salary dollar5. HireDate MMDDYY.;
run;

/*With a width of 6, we can show five-figure salaries with the dollar sign*/
proc print data=work.person;
	label name='Employee Name';
	format salary dollar6. HireDate MMDDYY.;
run;

/*Similar problem with using the 5.2 format - the salaries are 5 digits, */
/*so we need a width of 7 to display them with the decimals*/
proc print data=work.person;
	label name='Employee Name';
	format salary 5.2 HireDate MMDDYY.;
run;

/*We need to make the width 8:*/
/*	5 slots for digits to the left of the decimal*/
/*  1 slot for the decimal*/
/*  2 slots to the right of the decimal*/
/*Also, we use Date7. and Date9. to display dates in the form 24FEB80 or 28FEB1980*/
/*The name field is formatted to show just the first 4 characters*/
proc print data=work.person;
	label name='Employee Name';
	format name $4. salary 8.2 HireDate DATE7.;
run;

/*What we just did was a temporary label.  Now we want to set up a permenant label */
data work.person;
	set work.person;
	label name='Employee Name';
	format name $4. salary dollar9.2 HireDate DATE7.;
run;

proc print data=work.person label;
run;

/*We need to make the width 9:*/
/*  5 slots for digits to the left of the decimal, with one comma*/
/*  1 slot for the decimal*/
/*  2 slots to the right of the decimal*/
proc print data=work.person;
	label name='Employee Name';
	format salary comma9.2 HireDate MMDDYY.;
run;

/*assign a temporary label*/
/*Format the date field.  The 'w' in the format MMDDYYw. includes the separators */
proc print data=work.person;
	label name='Employee Name';
	format HireDate MMDDYY10.;
run;

/*In the above proc print, the label didn't show! */
/*This is because we forgot the label option.  We will add the label option this time*/
proc print data=work.person label;
	label name='Employee Name';
run;

/*Code related to chapter 6*/
/*This is the syntax to create a data set*/
/*Note that we use put rather than input*/
data _NULL_;
   set work.person;
   file Person;
   put name $ age salary HireDate; 
run;

/*the filename statement creates a fileref */
/*similar to how a libname statement creates a libref*/
filename PERSON 'Person.dat';
data Base.Person;
	infile PERSON;
	input name $ age salary hiredate;
run;

/*the filename statement creates a fileref */
/*similar to how a libname statement creates a libref*/
filename EMPLOYEE 'C:\Users\LukasHalim\Documents\GitHub\SASCert\employee.txt';
data Base.Employee;
	infile EMPLOYEE;
	input name $ age country salary bonus hiredate;
run;

/*Country is missing because SAS tried to read it in as a numeric field.*/
/*Check the log - see that _ERROR_ is incrimented for each row*/
/*Correct this by adding the $*/
filename SAS_CERT 'C:\Users\LukasHalim\Documents\GitHub\SASCert\employee.txt';
data Base.Employee;
	infile EMPLOYEE;
	input name $ age country $ baseSalary bonus hiredate;
run;

/*Same as above, but with a sum and a subsetting if*/
/*It could also be written without the "then output"*/
data Base.US_Employee;
	infile EMPLOYEE;
	input name $ age country $ baseSalary bonus hiredate;
	totalSalary = baseSalary + baseSalary * bonus / 100;
	if country = "USA" then output;
run;

/*Reading data from Excel*/
libname RealEstate 'C:\Users\LukasHalim\Documents\GitHub\SASCert\RealEstateSales.xlsx';

/* didn't work because libname cannot be more than eight characters! */
libname RealEst 'C:\Users\LukasHalim\Documents\GitHub\SASCert\RealEstateSales.xlsx';

proc contents data=RealEst._all_;
run;

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

/*Chapter 9*/
/*This creates a single html file*/
ods html 
	body='C:\Users\LukasHalim\Documents\GitHub\SASCert\body.html'
	contents='C:\Users\LukasHalim\Documents\GitHub\SASCert\contents.html'
	frame='C:\Users\LukasHalim\Documents\GitHub\SASCert\frame.html';
ods pdf file='C:\Users\LukasHalim\Documents\GitHub\SASCert\out.pdf';
proc print data=base.employee;
run;
proc print data=base.employee;
	format country $altcountryfmt.;
run;
ods _all_ close;
ods html;

/*Code for Chapter 10 - Creating and Managing Variables*/
/*Create small dataset for use in this chapter*/
data work.TimeCard;
   input name $ age Week1 Week2 Week3 Week4;
   datalines;
John 23 15 20 15 20
Mary 37 60 40 20 40
Tom 53 30 30 35 30
William 37 35 35 30 30
Scott 39 40 40 40 42 38
Jessica 37 40 40 0 40
Liz 23 40 40 40 38
;
run;

/*the retain statement allows us to incriment over multiple iterations of the datastep*/
data work.TimeCard;
	set work.TimeCard;
	retain TotalWeek1Hours 150;
	TotalWeek1Hours+Week1;
	if Week1 > 40 then Type ='Working Overtime';
	if Week1 < 30 then Type = 'Working Part Time';
	if Week1 ge 30 and Week1 le 40 then Type = 'Working Full Time';
run;

/*Some values in Type are truncated!  Need to use the length command*/
/*The length command must prior to any other mention of the variable in the data step*/
data work.TimeCard;
	set work.TimeCard;
	length TypeRevised $ 20;
	retain TotalWeek1Hours 150;
	TotalWeek1Hours+Week1;
	if Week1 > 40 then TypeRevised ='Working Overtime';
	if Week1 < 30 then TypeRevised = 'Working Part Time';
	if Week1 ge 30 and Week1 le 40 then TypeRevised = 'Working Full Time';
run;

/*Sum week1 and week2, then drop them*/
data work.TimeCard(drop=Week1 Week2);
	set work.TimeCard;
	FirstTwoWeekTotal = Week1 + Week2;
run;

/*This does the same as above, but using the drop statement rather than*/
/*the drop option.  */
/*I thought this wouldn't work because the drop would happen before the sum... confused why this works*/
data work.TimeCard;
	set work.TimeCard;
	drop Week3 Week4;
	SecondTwoWeekTotal = Week3 + Week4;
run;

data work.TimeCard;
	set work.TimeCard;
	select (name);
		when ("John") Gender="M";
		when ("Mary") Gender="F";
		when ("Tom") Gender="M";
		when ("William") Gender="M";
		when ("Scott") Gender="M";
		otherwise Gender="U";
	end;
run;

/*Code for Chapter 11*/

/*Create different version of the timecard datea*/
data work.TimeCard;
   input name $ age Hours;
   datalines;
John 23 15
Mary 37 60
Tom 53 30
William 37 35
Scott 39 40 
Jessica 37 40
Liz 23 40
John 23 15
Jessica 37 40
Liz 23 40
John 23 15
Mary 37 50
Tom 53 20
William 37 35
Scott 39 10 
Jessica 47 40
Liz 23 20
;
run;

proc sort data=work.timecard;
	by name;
run;

/*We use first. to detect when we are on the first occurance of a given name*/
data work.timecard;
	set work.timecard;
	if first.name then TotalHrs = 0;
	TotalHrs + Hours;
run;

/*Using first.age will not work because the data isn't sorted on age*/
/*check the log to see the error message*/
data work.timecard;
	set work.timecard;
	if first.age then TotalHrs = 0;
	TotalHrs + Hours;
run;

/*timecard for demonstrating .first and .last with subgroups*/
data work.TimeCard;
   input Name $ Gender $ Hours;
   datalines;
John M 4
Tom M 3
Scott M 2
Tom M 5
Tom M 2
Jamie M 3
Jamie M 3
Jamie M 4
Jamie F 1
Jamie F 2
Liz F 4
Liz F 5
Lisa F 5
Ann F 2
;
run;

proc sort data=work.timecard;
	by Gender Name ;
Run;

/*this saves the first and last group and subgroup variables to the output data set*/
/*look at the data step to see how the subgroup first and last variables are set*/
/*notice that there are two separate cases where first.jamie is true: */
/*once for the male group and once for the female group*/
data work.timecard;
	set work.timecard;
	by Gender Name;
	firstGender = first.Gender;
	lastGender = last.Gender;
	firstName = first.Name;
	lastName = last.Name;
run;

/*this is to select the fifth observation*/
data work.ObFiveTimecard;
	set work.timecard point=5;
	output;
	stop;
run;

/*this is to get the last observation*/
data work.OnlyLast;
	set work.timecard end=last;
	if last then output;
run;

/*this is to get all observations except the last one*/
data work.NoLast;
	set work.timecard end=last;
	if last then delete;
run;

/* "if last;" is equivalent to "if last then output;" */
data work.OnlyLast2;
	set work.timecard end=last;
	if last;
run;

/*Code for Chapter 12*/
data work.Prices;
   input Name $ 1-11 Price;
   datalines;
Pickles    20
Apples     15
Toothpaste 2
Cigarettes 5
Beer       10
Chicken    5
Diapers    5
Sprats     5
;
run;

data work.ShoppingList;
   input Name $ 1-11 Quantity;
   datalines;
Pickles    30
Apples     10
Toothpaste 10
Cigarettes 10
Beer       5
Not Chicken10
;
run;

/*This is called one-to-one merging*/
/*The number of observations will be equal to the number of observations in the*/
/*smaller of the two data sets... basically whenever SAS can't find another*/
/*row in either work.Prices or work.Shopping list, it stops iterating*/

/*Also note that the last observation has a Name of "Not Chicken"*/
/*Since both data sets include the Name variable, the second data set will*/
/*overwrite the Name values in the first data set.*/
data work.Groceries;
	set work.Prices;
	set work.ShoppingList;
run;

data work.MorePrices;
   input Name $ 1-11 Price;
   datalines;
Tuna       10
Nuts       15
Tape       2
Figs       5
Pears      10
;
run;



/*Now we will concatenate*/
data work.ConcatPrices;
	set work.Prices work.MorePrices;
run;

/*append does the same thing as concatenate, except it adds to the */
/*data set selected with the base=option */
/*also, it is more sensative than concatenate:*/
/*concatenate will fail if you have different data types on the */
/*same field, but concatenate doesn't mind */
/*will fail (see example below).  Concatenate doesn't mind*/
proc append base=work.Prices data=work.MorePrices;
run;

data work.SlightlyDifferentPrices;
   input Name $ 1-22 Price 24-25 Count;
   datalines;
Nut N Honey Cereal    10 5
Honey Bunches of Oats 5  5
;
run;

/*concatenate will combine; append will not */
/*See the log for details*/
data work.ConcatMoreFlexibleThanAppend;
	set work.Prices work.SlightlyDifferentPrices;
run;
proc append base=work.Prices data=work.SlightlyDifferentPrices;
run;

data work.DifferentPrices;
   input Name $ 1-22 Price $ 24-25 Count;
   datalines;
Nut N Honey Cereal    10 5
Honey Bunches of Oats 5  5
;
run;

/*won't work!  There are THREE different warnings in the log*/
/*LongerPrices has longer with for the Name field*/
/*Price is numeric in Prices but text in LongerPrices*/
/*Count exists in LongerPrices but is missing in Prices*/
proc append base=work.Prices data=work.DifferentPrices;
run;

/*works with FORCE*/
/*notice the following: */
/*text values for Price DifferentPrices become missing values since there is a type mismatch */
/*since count doesn't exist in Prices, it is dropped from the resulting output */ 
/*longer names are truncated*/
proc append base=work.Prices data=work.LongerPrices FORCE;
run;

/*recreating data for interleaving*/
data work.Prices;
   input Name $ 1-11 Price;
   datalines;
Pickles    20
Apples     15
Apples     6
Toothpaste 2
Cigarettes 5
Beer       10
Chicken    5
Diapers    5
Sprats     5
Sprats     5
;
run;

/*interleaving*/
/*must sort on our BY variable*/
proc sort data=work.Prices;
	by name;
run;
proc sort data=work.MorePrices;
	by name;
run;

data work.InterlevPrices;
	set work.Prices work.MorePrices;
	by name;
run;

/*match-merge*/
/*if we used set instead of merge, we would interleave*/
/*notice the missing values in the resulting data set*/
/*if the BY variable name is missing in one or the other data*/
/*set, then the values from that data set are missing*/
data work.PricesShoppingListMerge;
	merge work.Prices work.ShoppingList;
	by name;
run;

/*Renaming*/
data work.Prices;
   input Name $ 1-11 Price;
   datalines;
Pickles    20
Apples     15
Peaches     6
;
run;

data work.MorePrices;
   input Name $ 1-11 Price;
   datalines;
Pickles    2
Apples     3
Apples     4
;
run;
proc sort data=work.Prices;
	by name;
run;
proc sort data=work.MorePrices;
	by name;
run;
/*Use the rename so that we can keep both sets of prices*/
/*otherwise the price info from MorePrices would be overwritten*/
data work.CombinedPrices;
	merge 	work.Prices (rename=(Price=Price1))
			work.MorePrices (rename=(Price=Price2));
	by name;
run;

/*Notice that the above merge is basically the same as a SQL outer join*/
/*Observations are included in the merged data set even if they are missing*/
/*from one or the other data set*/
/*If you want to do an inner join, selecting only if an observation*/
/*is included in BOTH data sets, you can use the method below*/
/*the in=VARNAME creates a variable that is true if data set*/
/*contributed to the current observation.  In this example, */
/*inPrices is 1 when there are values in Prices for the current value of Name*/
/*and inMorePrices is 1 when there are values in MorePrices for the */
/*current value of Name*/
data work.CombinedPricesInBoth;
	merge 	work.Prices (in=inPrices rename=(Price=Price1))
			work.MorePrices (in=inMorePrices rename=(Price=Price2));
	by name;
	if inPrices and inMorePrices;
run;

/*Don't drop the variable like this if you need its value during*/
/*iterations of the data step*/
/*Look at the result and see the missing values*/
data work.DoublePrices;
	set work.Prices(drop=Price);
	DoubledPrice = Price * 2;
run;

/*This will work since Price is only dropped at the conclusion of the*/
/*data step*/
data work.DoublePrices(drop=Price);
	set work.Prices;
	DoubledPrice = Price * 2;
run;

/* Code for Chapter 13 */
data work.TextPrices;
   input Name $ 1-11 TextPrice $;
   datalines;
Pickles    2
Apples     3
Apples     4
;
run;

/*use the input function to convert Price from character to numeric*/
/*the INput function needs an INfomrmat*/
data work.NumericPrices;
	set work.TextPrices;
	AutoConvert = TextPrice * 2;
	NumPrice = input(TextPrice,1.);
run;

/*Now convert back to text*/
data work.ReTextPrices;
	set work.NumericPrices;
	ReTextPrice = put(NumPrice,1.);
run;

/*Text data is automatically converted to numeric when used in a calculation*/
data work.TextPrices;
	set work.TextPrices;
	AutoConverted = TextPrice * 2;
run;
proc print data=work.TextPrices;
run;

/*This works - testNum is converted to a string and appended to testChar*/
/*however, testNum is put in BEST12. format, which results in leading blanks*/
/*If we want to avoid this, we can use input to convert from numeric to character*/
/*with the desired format*/
data work.AutoNumToChar;
	testChar = 'ABC';
	testNum = 123;
	testAutoConcat = testChar || testNum;
	testInputConcat = testChar || ' ' || put(testNum,3.);
run;

data work.person;
   input name $ HireDate MMDDYY6.;
   datalines;
John 101512
Mary 101599
Tom 011490
;
run;

/*Date functions*/
/*INTCK can give the days, months, years or quarters*/
/*between dates*/
data work.person;
	set work.Person;
	Date1 = mdy(8,7,2013);
	Date2 = today();
	Experience = Date2 - HireDate;
	YearsOfWork = INTCK('Year',HireDate,Date2);
	Time = time();
run;

/*Format dates and select observations*/
/*Can't use subsetting if in proc print*/
/*instead we use a where statement*/
proc print data=work.person;
	format HireDate MMDDYY10. Date1 MMDDYY8. Date2 Date9.;
	where year(HireDate)=1990;
run;

/*String Functions*/
data work.person;
   input name $ 1-32;
   datalines;
SMiTh, John A.
Halim, Lukas
Goldberg, Lukas
;
run;

/*PropCase capitalizes first letters*/
/*Scan divides the string by specified (or default) delimiter and returns the specified nth word*/
/*Index finds the first occurrence of the specified string.  Find is a similar*/
data work.person(drop=FirstInitial Name);
	set work.person;
	LastName = PropCase(scan(name,1));
	FirstInitial = substr(scan(name,2),1,1);
	ReNamed = CatX(" ","Mr.",FirstInitial,"A.",LastName);
	Location = Index(Name,"Lukas");
	Location2 = Find(Name,"Lukas");
run;

data work.ThreeCols;
	input x1 x2 x3;
	datalines;
1.111 4.777 8.222
;
run;

/*The Round function rounds to the specified the precision.      */
/*  Default is nearest .01, but here we round to the nearest .02 */
/*Int strips off the decimals*/
data ThreeCols;
	set work.ThreeCols;
	SummedVal = sum(of x1-x3);
	RoundedX1 = round(x1,.02);
	IntX2 = Int(x2);
run;

/*Chapter 15 - ARRAYS*/
data ThreeCols;
	set ThreeCols;
	Array Predictors{*} x1 x2 x3;
	Array AnotherWay{*} _numeric_;
	Array ThirdWay{*} _All_;
	y = 0;
	do i = 1 to dim(Predictors);
		y = y + Predictors{i};
	end;
run;

data TwoWeeks;
	input x1 x2 x3 x4 x5 x6 x7 x8 x9 x10;
	datalines;
8 8 9 9 8 8 9 8 8 0
8 8 9 7 7 8 7 9 8 8
;
run;

/*In Hours{2,5}, the 2 represents 2 rows, while the 5*/
/*represents 5 rows*/
/*
Table fills up one row at a time, from left to right.
Rows are added from top to bottom
Ex: 	x1	x2	x3	x4	x5
		x6	x7	x8	x9	x10
*/
/*When the code has an "output" command, you override the usual*/
/*behavior - outputing at the end of each iteration of the data*/
/*step.  In this case, output occurs at the end of each row.   */
data TwoWeeks(drop=i j);
	set TwoWeeks;
	Array Hours{2,5} x1-x10;
	array AverageHrs{5} _temporary_ (8 8 8 8 7);
	do i = 1 to 2;
		Time = 0;
		Comparsion = 0;
		do j = 1 to 5;
			Time = Time + Hours{i,j};
			Comparision = Comparison + abs(Hours{i,j} - AverageHours{j});
		end;
		Week = i;
		output;
	end;
run;

/*Chapter 16 Reading Raw Data from Fixed-Fields*/
/*If we don't specify the length in the informat, it will just do one character*/
data work.Employee_Fixed; 
   infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\employee_formatted.txt'; 
   input Name $ @15 price comma.;
run;
proc print data=work.employee_fixed;
run;

/*Corrected*/
/*Notice that we must have a period at the end of the informat*/
data work.Employee_Fixed; 
   infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\employee_formatted.txt'; 
   input Name $13. @15 price comma7.;
run;
proc print data=work.employee_fixed;
run;


/*Chapter 17 Code*/
/*SAS sometimes uses its own specialized vocabulary when there are*/
/*perfectly suitable terms in common use that would be more easily*/
/*understandable.  In this case, SAS calls the data "Free format"*/
/*when most people would call it delimited data.*/
/*
Fixed Width
	Column (standard data)
	Formatted (standard and non-standard)
Free-Form (normally called delimited data)
	List Input
*/

/* List style of input */
data work.Employee_Free_Form; 
   infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\employee_free_form.txt' dlm=','; 
   input Name $ Age Country $ Date1 Bonus Date2; 
run; 
proc print data=work.Employee_Free_Form; 
run;

/*Same as above, but using a file that has blanks rather than commas*/
/*the default delimiter is blank, so no need to use the dsm option*/
/*Notice that the Name values are truncated!!  By default, list input is only*/
/*eight characters.*/
data work.Employee_Free_Form; 
   infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\emp_free_form_blanks.txt'; 
   input Name $ Age Country $ Date1 Bonus Date2; 
run; 
proc print data=work.Employee_Free_Form; 
run;

/*fix the truncaction*/
data work.Employee_Free_Form; 
   infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\emp_free_form_blanks.txt'; 
	length Name $ 11;
	input Name $ Age Country $ Date1 Bonus Date2; 
run; 
proc print data=work.Employee_Free_Form; 
run;

data work.Employee_Free_Form; 
   	infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\emp_free_form_blanks.txt'; 
	input Name $ 11. Age Country $ Date1 Bonus Date2; 
run; 
proc print data=work.Employee_Free_Form; 
run;

/*Example of data file with missing values at the end of a line*/
/*See the note in the log:*/
/*NOTE: SAS went to a new line when INPUT statement reached past the end of a line.*/
data work.Employee_Free_Form; 
   infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\emp_missover.txt'; 
   input Name $ Age Country $ Date1 Bonus Date2; 
run; 
proc print data=work.Employee_Free_Form; 
run;

/*Now do the same, but use the MISSOVER option*/
/*Missover only works if the missing data is at the END of the line*/
data work.Employee_Free_Form; 
   infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\emp_missover.txt' missover; 
   input Name $ Age Country $ Date1 Bonus Date2; 
run; 
proc print data=work.Employee_Free_Form; 
run;

/*Example of data file with missing values in the middle of a line*/
/*Notice that SAS doesn't understand the two commas in the data set*/
/*represent a missing value.  All Country, Date1, Bonus, and Date2 are all*/
/*shifted to the left.  SAS tries to put "USA"in the age field, but since */
/*USA is text and Age is numeric, the value shows as missing*/
data work.Employee_Free_Form; 
   infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\emp_dsd.txt' dlm=','; 
   input Name $ Age Country $ Date1 Bonus Date2; 
run; 
proc print data=work.Employee_Free_Form; 
run;

/*Fix this with the dsd option.  DSD means that SAS will impute a missing value*/
/*when it finds repeated delimiters.*/
data work.Employee_Free_Form; 
   infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\emp_dsd.txt' dsd; 
   input Name $ Age Country $ Date1 Bonus Date2; 
run; 
proc print data=work.Employee_Free_Form; 
run;

/*The file emp_embedded_blanks uses double blanks "  " as delimiters.*/
/*Single blanks are allowed within a field, so "George Blank" should*/
/*be a single value, while "George  Blank" would be treated as two different*/
/*values.  */
/*However, embedded blanks won't work - they are treated as delimiters*/
data work.Employee_Free_Form; 
   	infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\emp_embedded_blanks.txt'; 
	length Name $ 12;
	input Name $ Age Country $ Date1 Bonus Date2; 
run; 
proc print data=work.Employee_Free_Form; 
run;

/*Now we use the ampersand.*/
/*The ampersand & character is used to allow us to handle embedded blanks within a value*/
/*when we are using blanks as our delimiter.  In order to mark the end of the an */
/*amperanded-value, we use two blanks rather than just one.*/
/*
Data:
	George Blank  23 USA 40104 4 021407
	Sam Blank  35 UK 55125 1 031405
*/
data work.Employee_Free_Form; 
   	infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\emp_embedded_blanks.txt'; 
	length Name $ 12;
	input Name & Age Country $ Date1 Bonus Date2; 
run; 
proc print data=work.Employee_Free_Form; 
run;

/*This also works: variable-name ampersand informat*/
data work.Employee_Free_Form; 
   	infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\emp_embedded_blanks.txt'; 
	input Name & $12. Age Country $ Date1 Bonus Date2; 
run; 
proc print data=work.Employee_Free_Form; 
run;

/*How about nonstandard data, such as $250,000?*/
/*Trying to read $250,000 as numeric data results in missing values*/
data work.Employee_Free_Form; 
   	infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\employee_nonStandard.txt'; 
	input Name  & $12. Salary; 
run; 
proc print data=work.Employee_Free_Form; 
run;

/*The output data set was missing salary info*/
/*how about adding an informat?*/
data work.Employee_Free_Form; 
   	infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\employee_nonStandard.txt'; 
	input Name  & $12. Salary dollar.; 
run; 
proc print data=work.Employee_Free_Form; 
run;

/*The above code also failed*/
/*we need a colon to read nonstandard data (comma, currency)*/
/*and data that is longer than eight characters*/
data work.Employee_Free_Form; 
   	infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\employee_nonStandard.txt'; 
	input 	Name & $12.
			Salary : Comma.; 
run; 
proc print data=work.Employee_Free_Form; 
run;

/*Now let's create free-format (delimited) data*/
data work.person;
   input name $ age salary HireDate MMDDYY6.;
   datalines;
John 23 1245 101513
Mary 37 40000 101599
Tom 53 60180 011490
;
run;

/*Creating a delimited file*/
data _null_; 
   set work.person; 
   file 'C:\Users\LukasHalim\Documents\GitHub\SASCert\person_delimited.txt'; 
   put name $ age salary HireDate MMDDYY6.;
run;

/*CSV*/
data _null_; 
   set work.person; 
   file 'C:\Users\LukasHalim\Documents\GitHub\SASCert\person_delimited.csv' dlm=','; 
   put name $ age salary HireDate MMDDYY6.;
run;

/*CSV with commas within fields*/
/*Open the resulting file - you will see that there is an extra column*/
/*because the commas in the salary field are confused with delimiters!*/
/*we need to prevent this with the DSD option*/
data _null_; 
   set work.person; 
   file 'C:\Users\LukasHalim\Documents\GitHub\SASCert\person_comma.csv' dlm=','; 
   put name $ age salary : comma6. HireDate MMDDYY6.;
run;

/*Open the resulting file and you will see that the commas in the */
/*salary field are handled correctly*/
data _null_; 
   set work.person; 
   file 'C:\Users\LukasHalim\Documents\GitHub\SASCert\person_dsd.csv' dsd; 
   put name $ age salary : comma6. HireDate MMDDYY6.;
run;

/*Chapter 18*/
/*If we leave out the "." at the end of the "date7", SAS will create*/
/*an extra variable called date7.*/
options yearcutoff=1910; 
data work.birthdays; 
   infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\birthdays.csv' dsd; 
   input Name $ Birthday date7;
run; 
proc print data=work.birthdays; 
   format Birthday worddate12.; 
run;

/*This time we correctly use the informat "date7"*/
options yearcutoff=1910; 
data work.birthdays; 
   infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\birthdays.csv' dsd; 
   input Name $ Birthday date7.;
run; 
proc print data=work.birthdays; 
   format Birthday worddate12.; 
run;



/*Chapter 19 - single input observation/row => multiple output observations/rows */

/*The double @@ prevents SAS from moving to the next row when it*/
/*reaches the end of the data step.*/
/*It will only go to the next row when it runs out of data on the */
/*current row.*/
data work.repeat; 
   infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\repeat.txt';
   input Country $ Numeric @@; 
run;
proc print data=work.repeat;
run;

/*The single @ prevents SAS from moving to the next row after each input*/
data work.repeat; 
	infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\repeat.txt';
	do i = 1 to 3;
		input Country $ Numeric @; 
		output;
	end;
run;
proc print data=work.repeat;
run;

/*This is confusing, but the code here handles the case when*/
/*there are variable number of repeating fields within an observation*/
/*
Data:
	USA 1 2 3 
	AUS 22 
	AUS 33 33 33 33 33 
*/
data work.repeat; 
	infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\repeat_variable.txt' missover;
	input Country $ Numeric @; 
	do while(Numeric ne .);
		output;
		input Numeric @; 
	end;
run;
proc print data=work.repeat;
run;

/*Do loops do not need to incriment by 1.*/
/*Here, we incriment by 2 instead.*/
data work.DoBy;
	do  i = 1 to 10 by 2;
		output;
	end;
run;

/*Chapter 21 - outputting diffrent lines in input data set to different output data sets*/
data work.Address;
	infile 'C:\Users\LukasHalim\Documents\GitHub\SASCert\Address.txt';
	retain City State Zip;
	input type 1. @;
	if type=1 then do;
		input Number $ Street & $15.;
		output;
	end;
	if type=2 then input City $ State $ Zip;
run;
proc print data= work.address;
run;

/* Misc Code */
/* PROC REPORT */
data work.person;
   input Name $5. +1 Num 4.;
   datalines;
John  3533
Lukas 1233
Lukas 1633
;
run;
quit;

/*Order to avoid printing repeat values on each line*/
proc report data=work.person nowd;
	define Name/order;
	define Num/sum;
run;
quit;
/*Group to aggregate observations*/
proc report data=work.person nowd;
	define Name/group;
run;
quit;

