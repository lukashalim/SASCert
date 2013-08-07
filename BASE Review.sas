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
proc format lib=base
 value jobfmt
     'USA'='United States'
	 'RUS'='Russia'
	 'IL'='Israel'
run;

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

