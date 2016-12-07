SELECT maj.Major_Group, avg(maj.Median_Annual_Wages) as Wages FROM Major maj GROUP BY maj.Major_Group ORDER BY avg(maj.Median_Annual_Wages) DESC
SELECT DISTINCT maj.Major_Subgroup, maj.Median_Annual_Wages FROM Major maj WHERE maj.Major_Group in (SELECT m.Major_Group FROM Major m WHERE m.Major_Subgroup = "Computer science")
SELECT occ.ST, ROUND(AVG(occ.A_MEAN),2) as StateWage FROM StateOccupations occ WHERE occ.OCC_CODE in (SELECT wor.SOC2010Code FROM WorksIn wor WHERE wor.CIP2010Code  LIKE CONCAT('%',(SELECT maj.CIPCode FROM Major maj WHERE maj.Major_Subgroup = "Computer science" ORDER BY maj.CIPCODE ASC LIMIT 1),'%')) GROUP BY occ.ST ORDER BY AVG(occ.A_MEAN) DESC;
SELECT maj.Graduate_Degree_Attainment, maj.Median_Annual_Wages, maj.Graduate_Degree_Wage_Premium FROM Major maj where Major_Subgroup = "Computer science"
SELECT count(distinct m1.Major_Group) as Rank FROM (SELECT maj.Major_Group, avg(maj.Median_Annual_Wages) as Average_Annual_Wages FROM Major maj GROUP BY maj.Major_Group ORDER BY avg(maj.Median_Annual_Wages) DESC) m1, Major m2 WHERE m1.Average_Annual_Wages >= (SELECT avg(m2.Median_Annual_Wages) from Major m2 where m2.Major_Group = ( SELECT distinct m3.Major_Group from Major m3 where m3.Major_Subgroup = "Computer science"));
SELECT Major_Group FROM Major where Major_Subgroup = "Computer science"
SELECT Round(avg(NULLIF(a.UgradTut,0)),2) as InStateU, Round(avg(NULLIF(b.UgradTut,0)),2) as OutStateU from (SELECT UNITID, INSTNM, STABBR, InStateUgradTut as UgradTut FROM innodb.College where STABBR = 'NJ') a, (SELECT UNITID, INSTNM, STABBR, OutStateUgradTut as UgradTut FROM innodb.College where STABBR <> 'NJ')b;
SELECT Round(MEDIAN_ANNUAL_WAGES,2) as UgradWages, Round((MEDIAN_ANNUAL_WAGES * (1+(GRADUATE_DEGREE_WAGE_PREMIUM/100))),2) as GradWages from innodb.Majors where MAJOR_SUBGROUP = 'Computer science';
SELECT Round(avg(NULLIF(a.GradTut,0)),2) as InStateG, Round(avg(NULLIF(b.GradTut,0)),2) as OutStateG from  (SELECT UNITID, INSTNM, STABBR, InStateGradTut as GradTut FROM innodb.College where STABBR = 'NJ') a, (SELECT UNITID, INSTNM, STABBR, OutStateGradTut as GradTut FROM innodb.College where STABBR <> 'NJ')b;
SELECT Field_of_Study FROM Earns WHERE Major_Group = 'Computers statistics and mathematics'
SELECT B_SWE, M_SWE FROM Computers_Mathematics_and_Statistics WHERE Occupation = "All occupations"
SELECT Occupation, B_SWE FROM Computers_Mathematics_and_Statistics WHERE Occupation <> "All occupations" and B_SWE <> "(B)" ORDER BY B_SWE DESC LIMIT 3
SELECT Occupation, M_SWE FROM Computers_Mathematics_and_Statistics WHERE Occupation <> "All occupations" and M_SWE <> "(B)" ORDER BY M_SWE DESC LIMIT 3
SELECT * FROM OpportunityCosts WHERE State = 'NJ' and Major = 'Computer science'
SELECT Earns.Field_of_Study, MajorGroup.Major_Subgroup FROM Earns, (SELECT m1.Major_Group, m1.Major_Subgroup FROM Major m1 WHERE m1.Major_Subgroup = 'Animal sciences' OR m1.Major_Subgroup = 'Mechanical engineering') as MajorGroup WHERE Earns.Major_Group = MajorGroup.Major_Group
SELECT o1.Occupation, o1.Bachelors_Earnings1, o2.Bachelors_Earnings2, o1.Masters_Earnings1, o2.Masters_Earnings2 FROM (SELECT Occupation, B_SWE AS Bachelors_Earnings1, M_SWE AS Masters_Earnings1 FROM Biological_Agricultural_and_Environmental_Sciences) AS o1, (SELECT Occupation, B_SWE AS Bachelors_Earnings2, M_SWE AS Masters_Earnings2 FROM Engineering) AS o2 WHERE o1.Occupation = o2.Occupation  and STRCMP(o1.Bachelors_Earnings1, '$100,000') >=0 and STRCMP(o2.Bachelors_Earnings2, '$100,000') >=0 and STRCMP(o1.Masters_Earnings1, '$100,000') >=0 and STRCMP(o2.Masters_Earnings2, '$100,000') >=0  ORDER BY o1.Masters_Earnings1, o2.Masters_Earnings2, o1.Bachelors_Earnings1, o2.Bachelors_Earnings2 DESC LIMIT 3;
SELECT DISTINCT * FROM Major WHERE Major_Subgroup = 'Animal sciences' OR Major_Subgroup = 'Mechanical engineering'
SELECT c.INSTNM,c.InStateGradTut,c.OutStateGradTut FROM College c WHERE c.INSTNM = "Rutgers University-New Brunswick" or c.INSTNM = "Alabama A & M University"ORDER BY c.INSTNM ASC
SELECT (c1.InStateGradTut - c2.InStateGradTut) as sub1, (c1.OutStateGradTut - c2.OutStateGradTut) as sub2 FROM College c1 CROSS JOIN College c2 WHERE c1.INSTNM = "Alabama A & M University" and c2.INSTNM = "Rutgers University-New Brunswick";
SELECT maj.Major_Subgroup, maj.Median_Annual_Wages FROM Major maj WHERE maj.CIPCode in (SELECT Off.CIPCODE FROM Offers Off WHERE Off.UNITID = (SELECT c.UNITID FROM College c WHERE c.INSTNM = "Rutgers University-New Brunswick")) ORDER BY maj.Median_Annual_Wages DESC LIMIT 10;
SELECT maj.Major_Subgroup, maj.Median_Annual_Wages FROM Major maj WHERE maj.CIPCode in (SELECT Off.CIPCODE FROM Offers Off WHERE Off.UNITID = (SELECT c.UNITID FROM College c WHERE c.INSTNM = "Alabama A & M University")) ORDER BY maj.Median_Annual_Wages DESC LIMIT 10;