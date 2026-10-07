WITH metrics AS (
  SELECT Geography,
         SUM(CASE WHEN Year=2025 THEN retailsaleQ END)                          AS annual_retail,
         SUM(CASE WHEN Year=2025 THEN retailsaleQ END)*1000.0
           / AVG(CASE WHEN Year=2025 THEN Population END)                       AS rpp,
         AVG(CASE WHEN Year=2025 THEN "Pop_Yoy" END)                            AS traj,
         AVG(CASE WHEN Year=2026 AND Qtr=2 THEN "Pop_Yoy" END)                  AS traj_now
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
  SELECT m.*,
         ROUND(100*( 0.40*((m.annual_retail-rmin)*1.0/(rmax-rmin))
                   + 0.40*(1-(m.traj-tmin)*1.0/(tmax-tmin))
                   + 0.20*(1-(m.rpp-pmin)*1.0/(pmax-pmin)) ), 1) AS exposure_score
  FROM metrics m CROSS JOIN lim
)
SELECT Geography,
       ROUND(annual_retail/1000.0, 0)   AS retail_millions,
       ROUND(rpp, 0)                     AS retail_per_person,
       ROUND(traj_now*100, 2)            AS pop_growth_latest_pct,
       exposure_score,
       CASE
         WHEN traj_now < -0.002  THEN 'Pull back'   -- population actually shrinking
         WHEN traj_now >  0.005  THEN 'Grow'        -- still clearly adding people
         ELSE 'Hold'                                -- flat: defend, don't expand
       END AS decision
FROM scored
ORDER BY exposure_score DESC;