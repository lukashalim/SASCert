/*Chapter 20 - single input observation/row => multiple output observations/rows */

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
