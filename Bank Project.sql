
----1. First we will clean the data ----

use Bank

---Remove unknown values from income column---

select *
from customers
where Income_Category = 'Unknown'

delete from Customers
where Income_Category = 'Unknown'


--- Fix the Income category to only include the max income for each person.---

--Extract only the max income

select *, 
'$' + PARSENAME(replace(income_category, '$', '.'),1) max_income
from Customers

update Customers
set Income_Category = '$' + PARSENAME(replace(income_category, '$', '.'),1)


--Remove additional delimiter

Select REPLACE(income_category, '+', ' ')
from Customers

update Customers
set Income_Category = REPLACE(income_category, '+', ' ')

select * from Customers

----2.  Analyze the Data ----


--
--Total customers by gender count with a credit score of over 10000

select COUNT(ID) AS total_customers, (SELECT count(gender) from customers where gender = 'm' AND Credit_Limit > 10000) total_males
				, (Select count(gender) from customers where gender = 'f' AND Credit_Limit > 10000) total_females
				, round(avg(credit_limit),2) avg_credit_limit
from Customers
WHERE credit_limit > 10000;

select * from customers;


--From the result above, tag risk level based on their income levels and credit limit


select ID, Gender,  Income_Category, Card_Category, Credit_Limit, avg_utilization_ratio,
CASE
	WHEN Avg_Utilization_Ratio > 0.30 THEN 'High Risk'
	WHEN Avg_Utilization_Ratio >= 0.15 THEN 'Average Risk'
	ELSE 'Low Risk'
END 'Risk_Level'
from Customers
WHERE credit_limit > 10000 AND Avg_Utilization_Ratio > 0
ORDER BY Avg_Utilization_Ratio, Income_Category;



/*Show which customers having a revolving balance with more than 4 months of inactivity
and more than .8 utilization rate for exisiting customers*/

Select ID, Income_Category, months_inactive_12_mon AS months_inactive
			, Credit_Limit, total_revolving_bal, avg_utilization_ratio
FROM Customers
WHERE Months_Inactive_12_mon > 4 
		AND Avg_Utilization_Ratio > .8 
		AND Attrition_Flag LIKE 'Exist%'
ORDER BY Total_Revolving_Bal desc, Income_Category;





