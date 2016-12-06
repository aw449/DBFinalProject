/*Given State and Major, compute whether or not it is worth it to go to grad school
Make several assumptions: 
The priority for the user is to make the most money. 
Quality of life should be taken into consideration
The user will go into a field related to their major.
The user will earn an average amount of money.
The user will pay an average tuition.
The user will graduate in a standard amount of years.
The user will find a job immediately after graduation.
The user wishes to enter a good college.


Create an algorithm to weight several factors, given
State and major.
State only serves to determine that 'instate tuition' for the particular state is used, rather than out-state tuition.

Determine 'tuition' which will be 'instate' for the state the user is in, and 'outstate' otherwise.
*/
SELECT UNITID, INSTNM, STABBR, InStateUgradTut as UgradTut, InStateGradTut as GradTut FROM innodb.College 
where STABBR = 'NJ';

SELECT UNITID, INSTNM, STABBR, OutStateUgradTut as UgradTut, OutStateGradTut as GradTut FROM innodb.College 
where STABBR <> 'NJ';

/*
Assume the user is going to pay for college. Estimate that they will pay an average tuition of colleges
Assume the user will be more likely to stay in state rather than go out of state. 
	Weight the in-state average as 50% to the out-state average as 50%, despite there being many more out-state universities.
*/

SELECT avg(a.UgradTut) as InStateU, avg(a.GradTut) as InStateG, avg(b.UgradTut) as OutStateU, avg(b.GradTut) as OutStateG
from 
(SELECT UNITID, INSTNM, STABBR, InStateUgradTut as UgradTut, InStateGradTut as GradTut FROM innodb.College 
where STABBR = 'NJ') a, 
(SELECT UNITID, INSTNM, STABBR, OutStateUgradTut as UgradTut, OutStateGradTut as GradTut FROM innodb.College 
where STABBR <> 'NJ')b;

/*
Determine the tuition that the user will pay
*/
SELECT (InStateU + OutStateU) /2 as U, (InStateG + OutStateG) /2 as G 
from (
	
	SELECT avg(a.UgradTut) as InStateU, avg(a.GradTut) as InStateG, avg(b.UgradTut) as OutStateU, avg(b.GradTut) as OutStateG
	from 
	(SELECT UNITID, INSTNM, STABBR, InStateUgradTut as UgradTut, InStateGradTut as GradTut FROM innodb.College 
	where STABBR = 'NJ') a, 
	(SELECT UNITID, INSTNM, STABBR, OutStateUgradTut as UgradTut, OutStateGradTut as GradTut FROM innodb.College 
	where STABBR <> 'NJ')b
    )c;

/*
Assume the user will take a job related to their field, and earn a median wage
	Compute the opportunity cost for going to college versus taking the job for each. 
	Take the average of these costs.
*/

SELECT MEDIAN_ANNUAL_WAGES as UgradWages, (MEDIAN_ANNUAL_WAGES * (1+(GRADUATE_DEGREE_WAGE_PREMIUM/100))) as GradWages 
from innodb.Majors
where MAJOR_SUBGROUP = 'Chemistry';

/*
DETERMINE
Number of years it will take in order to be college debt free
In Major, there is 'graduate wage premium' and 'median annual wage'
combine this with college costs to determine opportunity cost
*/

SELECT (sub1.G*8 / sub2.GradWages) as YearsToPayOffDebt, (sub2.UgradWages*4 + sub1.G*8)OC,
 (sub2.UgradWages*4 + sub1.G*8)/sub2.GradWages as YearsToMakeUpOC
from (
SELECT (InStateU + OutStateU) /2 as U, (InStateG + OutStateG) /2 as G 
from (
	SELECT avg(a.UgradTut) as InStateU, avg(a.GradTut) as InStateG, avg(b.UgradTut) as OutStateU, avg(b.GradTut) as OutStateG
		from 
		(SELECT UNITID, INSTNM, STABBR, InStateUgradTut as UgradTut, InStateGradTut as GradTut FROM innodb.College 
		where STABBR = 'NJ') a, 
		(SELECT UNITID, INSTNM, STABBR, OutStateUgradTut as UgradTut, OutStateGradTut as GradTut FROM innodb.College 
		where STABBR <> 'NJ')b
		)c
	)sub1,
    (
		SELECT MEDIAN_ANNUAL_WAGES as UgradWages, (MEDIAN_ANNUAL_WAGES * (1+(GRADUATE_DEGREE_WAGE_PREMIUM/100))) as GradWages 
		from innodb.Majors
		where MAJOR_SUBGROUP = 'Chemistry'
	)sub2;
    
    
    
/*Determine Lifetime Earnings */


    
/*
Each of the 'assume' phases can be 'skipped' if the user selects an option in the advanced options

Each of the 'Determine' phases will be executed with either the results from the 'assume' phase, or the user input.
*/





 