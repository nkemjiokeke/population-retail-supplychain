-- What decision must be made based on exposure?--
WITH metrics AS (
  SELECT Geography,
         SUM(CASE WHEN Year=2025 THEN retailsaleQ END)                          AS annual_retail,
         SUM(CASE WHEN Year=2025 THEN retailsaleQ END)*1000.0
           / AVG(CASE WHEN Year=2025 THEN Population END)                       AS rpp,
         AVG(CASE WHEN Year=2025 THEN "Pop_Yoy" END)                            AS traj
  FROM Cleaned_Data
  WHERE Geography NOT IN ('Yukon','Nunavut 5')
  GROUP BY Geography
),
lim AS (
  SELECT MIN(annual_retail) rmin, MAX(annual_retail) rmax,
         MIN(rpp) pmin,  MAX(rpp) pmax,
         MIN(traj) tmin, MAX(traj) tmax
  FROM metrics
),
scored AS (
  SELECT m.Geography,
         m.annual_retail,
         m.rpp,
         m.traj,
         ROUND(100*( 0.40*((m.annual_retail-rmin)*1.0/(rmax-rmin))
                   + 0.40*(1-(m.traj-tmin)*1.0/(tmax-tmin))
                   + 0.20*(1-(m.rpp-pmin)*1.0/(pmax-pmin)) ), 1) AS exposure_score
  FROM metrics m CROSS JOIN lim
)
SELECT Geography,
       ROUND(annual_retail/1000.0, 0)      AS retail_millions,
       ROUND(rpp, 0)                        AS retail_per_person,
       ROUND(traj*100, 2)                   AS pop_growth_2025_pct,
       exposure_score,
       CASE
         WHEN exposure_score <= 33 AND traj > 0       THEN 'Grow'
         WHEN exposure_score >= 66 OR  traj < -0.005  THEN 'Pull back'
         ELSE 'Hold'
       END                                  AS decision
FROM scored
ORDER BY exposure_score DESC;