--Where has population growth rolled over and is retail following it down?--
SELECT Geography, Year,
       AVG("Pop_Yoy")    AS pop_growth,
       AVG("Retail_YoY") AS retail_growth
FROM Cleaned_Data
WHERE Year IN (2023,2024,2025)
  AND Geography NOT IN ('Yukon','Nunavut 5')
GROUP BY Geography, Year
ORDER BY Geography, Year;