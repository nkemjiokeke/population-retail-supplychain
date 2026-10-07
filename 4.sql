SELECT Geography, Year, Qtr, "Pop_Yoy"
FROM Cleaned_Data
WHERE (Year, Qtr) IN ((2026,2),(2026,1),(2025,4))
  AND Geography NOT IN ('Yukon','Nunavut 5')
ORDER BY Geography, Year, Qtr;