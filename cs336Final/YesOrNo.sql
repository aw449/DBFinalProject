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

We want to decide whether the user should go to college or not, given just what state they live in, 
and what major they want. 

Create an algorithm to weight several factors, given
State and major.
State only serves to determine that 'instate tuition' for the particular state is used, rather than out-state tuition.

Determine 'tuition' which will be 'instate' for the state the user is in, and 'outstate' otherwise.
*/
SELECT UNITID, INSTNM, STABBR, InStateUgradTut as UgradTutIn FROM innodb.College 
where STABBR = 'NJ' and InStateUgradTut <> 0 ;
SELECT UNITID, INSTNM, STABBR, InStateGradTut as GradTutIn FROM innodb.College 
where STABBR = 'NJ' and InStateGradTut <> 0 ;
SELECT UNITID, INSTNM, STABBR, OutStateUgradTut as UgradTutOut FROM innodb.College 
where STABBR <> 'NJ' and OutStateUgradTut <> 0 ;
SELECT UNITID, INSTNM, STABBR, OutStateGradTut as GradTutOut FROM innodb.College 
where STABBR <> 'NJ' and OutStateGradTut <> 0 ;

/*
Assume the user is going to pay for college. Estimate that they will pay an average tuition of colleges
Assume the user will be more likely to stay in state rather than go out of state. 
	Weight the in-state average as 50% to the out-state average as 50%, despite there being many more out-state universities.
*/

SELECT avg(a.UgradTutIn) as InStateU, avg(b.GradTutIn) as InStateG, avg(c.UgradTutOut) as OutStateU, avg(d.GradTutOut) as OutStateG
from 
(SELECT UNITID, INSTNM, STABBR, InStateUgradTut as UgradTutIn FROM innodb.College 
where STABBR = 'NJ' and InStateUgradTut <> 0)a,
(SELECT UNITID, INSTNM, STABBR, InStateGradTut as GradTutIn FROM innodb.College 
where STABBR = 'NJ' and InStateGradTut <> 0)b,
(SELECT UNITID, INSTNM, STABBR, OutStateUgradTut as UgradTutOut FROM innodb.College 
where STABBR <> 'NJ' and OutStateUgradTut <> 0)c,
(SELECT UNITID, INSTNM, STABBR, OutStateGradTut as GradTutOut FROM innodb.College 
where STABBR <> 'NJ' and OutStateGradTut <> 0)d;

/*
Determine the tuition that the user will pay
*/
SELECT (InStateU + OutStateU) /2 as U, (InStateG + OutStateG) /2 as G 
from (
	SELECT avg(a.UgradTutIn) as InStateU, avg(b.GradTutIn) as InStateG, avg(c.UgradTutOut) as OutStateU, avg(d.GradTutOut) as OutStateG
	from 
	(SELECT UNITID, INSTNM, STABBR, InStateUgradTut as UgradTutIn FROM innodb.College 
	where STABBR = 'NJ' and InStateUgradTut <> 0)a,
	(SELECT UNITID, INSTNM, STABBR, InStateGradTut as GradTutIn FROM innodb.College 
	where STABBR = 'NJ' and InStateGradTut <> 0)b,
	(SELECT UNITID, INSTNM, STABBR, OutStateUgradTut as UgradTutOut FROM innodb.College 
	where STABBR <> 'NJ' and OutStateUgradTut <> 0)c,
	(SELECT UNITID, INSTNM, STABBR, OutStateGradTut as GradTutOut FROM innodb.College 
	where STABBR <> 'NJ' and OutStateGradTut <> 0)d
)e;

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

SELECT ROUND((sub3.G*4 / sub4.GradWages)*100)/100 as YearsToPayOffDebt, ROUND((sub4.UgradWages*2 + sub3.G*4)*100)/100 as OC,
ROUND((sub4.UgradWages*2 + sub3.G*4)/sub4.GradWages*100)/100 as YearsToMakeUpOC
from(
	(SELECT (sub1.InStateU + sub2.OutStateU)/2 as U, (sub1.InStateG + sub2.OutStateG)/2 as G
	from 
	(
		(
		SELECT avg(a.UgradTutIn) as InStateU, avg(b.GradTutIn) as InStateG
		from (
			(SELECT UNITID, STABBR, InStateUgradTut as UgradTutIn FROM innodb.College 
			where STABBR = 'NJ' and InStateUgradTut <> 0)a,
			(SELECT UNITID, STABBR, InStateGradTut as GradTutIn FROM innodb.College 
			where STABBR = 'NJ' and InStateGradTut <> 0)b
		)
		where a.UNITID = b.UNITID
		)sub1,
		(
		SELECT avg(c.UgradTutOut) as OutStateU, avg(d.GradTutOut) as OutStateG
		from (
			(SELECT UNITID, STABBR, OutStateUgradTut as UgradTutOut FROM innodb.College 
			where STABBR <> 'NJ' and OutStateUgradTut <> 0)c,
			(SELECT UNITID, STABBR, OutStateGradTut as GradTutOut FROM innodb.College 
			where STABBR <> 'NJ' and OutStateGradTut <> 0)d
		)
		where c.UNITID = d.UNITID
		)sub2
	)
    )sub3,
	(
	SELECT MEDIAN_ANNUAL_WAGES as UgradWages, (MEDIAN_ANNUAL_WAGES * (1+(GRADUATE_DEGREE_WAGE_PREMIUM/100))) as GradWages 
	from innodb.Majors
	where MAJOR_SUBGROUP = 'Chemistry'
	)sub4
);
    
    
/*
REDO Above with generic state and major subgroup, in order to create a lookup table

*/

CREATE TABLE innodb.OpportunityCosts as(
SELECT sub3.ST as State, sub4.MAJOR_SUBGROUP as Major, 
ROUND((sub3.G*4 / sub4.GradWages)*100)/100 as YearsToPayOffDebt, 
ROUND((sub4.UgradWages*2 + sub3.G*4)*100)/100 as OC,
ROUND((sub4.UgradWages*2 + sub3.G*4)/sub4.GradWages*100)/100 as YearsToMakeUpOC
from(
	(SELECT sub1.ST as ST, (sub1.InStateU + sub2.OutStateU)/2 as U, (sub1.InStateG + sub2.OutStateG)/2 as G
	from 
	(
		(
        #if(inState){
		SELECT a.STABBR as ST, avg(a.UgradTutIn) as InStateU, avg(b.GradTutIn) as InStateG
		from (
			(SELECT UNITID, STABBR, InStateUgradTut as UgradTutIn FROM innodb.College 
			where InStateUgradTut <> 0)a,
			(SELECT UNITID, STABBR, InStateGradTut as GradTutIn FROM innodb.College 
			where InStateGradTut <> 0)b
		)
		where a.UNITID = b.UNITID and a.STABBR = b.STABBR
        #and a.UNITID = 'College ID here' //If you want to select a specific college
        group by ST
        )sub1,
		(
		SELECT c.STABBR as ST, avg(c.UgradTutOut) as OutStateU, avg(d.GradTutOut) as OutStateG
		from (
			(SELECT UNITID, STABBR, OutStateUgradTut as UgradTutOut FROM innodb.College 
			where OutStateUgradTut <> 0)c,
			(SELECT UNITID, STABBR, OutStateGradTut as GradTutOut FROM innodb.College 
			where OutStateGradTut <> 0)d
		)
		where c.UNITID = d.UNITID and c.STABBR = d.STABBR
        #and c.UNITID = 'College ID here' //If you want to select a specific college
		group by ST
        )sub2
	)
    where sub1.ST = sub2.ST
    )sub3,
	(
	SELECT MAJOR_SUBGROUP, MEDIAN_ANNUAL_WAGES as UgradWages, (MEDIAN_ANNUAL_WAGES * (1+(GRADUATE_DEGREE_WAGE_PREMIUM/100))) as GradWages 
	from innodb.Majors
    #where MAJOR_SUBGROUP = 'Major Subgroup here' // If you wish to add a major subgroup
    #and 
	)sub4
)
)



    
/*
Each of the 'assume' phases can be 'skipped' if the user selects an option in the advanced options

Each of the 'Determine' phases will be executed with either the results from the 'assume' phase, or the user input.
*/





 