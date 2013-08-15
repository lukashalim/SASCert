/*Code related to chapter 6*/

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
