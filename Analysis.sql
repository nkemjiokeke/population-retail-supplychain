-- How hard is a province exposed in terms of market size?--
WITH metrics AS (
  SELECT Geography,
         SUM(CASE WHEN Year=2025 THEN retailsaleQ END)                                          AS annual_retail,
         SUM(CASE WHEN Year=2025 THEN retailsaleQ END)*1000.0
           / AVG(CASE WHEN Year=2025 THEN Population END)                                       AS rpp,
         AVG(CASE WHEN Year=2025 THEN "Pop_Yoy" END)                                            AS traj
		 AVG(CASE WHEN Year=2026 AND Qtr=2 THEN "Pop_Yoy" END) 									AS traj_now
  FROM Cleaned_Data
  WHERE Geography NOT IN ('Yukon','Nunavut 5')
  GROUP BY Geography
),
lim AS (
  SELECT MIN(annual_retail) rmin, MAX(annual_retail) rmax,
         MIN(rpp) pmin,  MAX(rpp) pmax,
         MIN(traj) tmin, MAX(traj) tmax
  FROM metrics
)
SELECT m.Geography,
       (annual_retail - rmin)*1.0/(rmax-rmin)                       AS size_norm,
       1 - (rpp  - pmin)*1.0/(pmax-pmin)                            AS perperson_norm,   -- lower spend = more exposed
       1 - (traj - tmin)*1.0/(tmax-tmin)                            AS trajectory_norm,  -- steeper drop = more exposed
       ROUND(100*( 0.40*((annual_retail-rmin)*1.0/(rmax-rmin))
                 + 0.40*(1-(traj-tmin)*1.0/(tmax-tmin))
                 + 0.20*(1-(rpp-pmin)*1.0/(pmax-pmin)) ), 1)        AS exposure_score
FROM metrics m CROSS JOIN lim
ORDER BY exposure_score DESC;