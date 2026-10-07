--How Big is each province's retail market and how hard does each person spend?--
SELECT Geography,
		sum(retailsaleQ)        AS annual_retail,
		avg(population)         AS avg_pop,
		sum(retailsaleQ)* 1000.0/ AVG(Population)     AS retail_per_person
FROM Cleaned_Data
WHERE Year = 2025
AND Geography NOT IN ('Yukon','Nunavut 5')  --provinces only--
GROUP BY Geography
ORDER BY annual_retail DESC;