/*Chapter 5 Creating SAS data sets from external files*/

/*Column input: 	data is fixed with and standard format*/
/*				standard numeric format:*/
/*					decimals*/
/*					scientific notation*/
/*					+ or - sign*/
/*					NO commas, currency signs*/

filename column 'C:\Users\LukasHalim\Documents\GitHub\SASCert\column.txt'; 

/*This doesn't work - why not?*/
/*Check the log to see the errors*/
data column; 
   infile column; 
   input CHAR $ 1-4 NUM 6-10; 
run;

/*This works except for the nonstandard numeric value: $290 is converted to missing*/
data column; 
   infile column; 
   input CHAR $ 1-4 NUM 6-9; 
run;

/*Use obs=2 to read in just the first two rows*/
data column; 
   infile column obs=2; 
   input CHAR $ 1-4 NUM 6-9; 
run;

/* with calculations and date variable */
data column; 
   	infile column obs=2; 
   	input CHAR $ 1-4 NUM 6-9; 
	Doubled = Num * 2;
	TestDate='01jan2000'd; 
run;

/* with subsetting if */
data subsetted; 
   	infile column; 
   	input CHAR $ 1-4 NUM 6-9; 
	if CHAR='ABC';
run;

/* if .... then delete */
data ifthenDelete; 
   	infile column; 
   	input CHAR $ 1-4 NUM 6-9; 
	if CHAR='ABC' then delete;
run;


/* What happens if we use a WHERE statement instead of a subsetting if? */
/* Check the log after running this data step*/
/* error b/c WHERE doesn't work with raw input data file */
data ColumnWithWhere; 
   	infile column; 
   	input CHAR $ 1-4 NUM 6-9; 
	WHERE CHAR='ABC';
run;

/*This works - you can use WHERE in data step with variables from the input data step*/
/*WHERE subsets before data enters the input buffer, while IF works on the PDV*/
/*For more detail see http://www2.sas.com/proceedings/sugi31/238-31.pdf*/
data ColumnWithWhere;
	set column;
	where CHAR='ABC';
run;

