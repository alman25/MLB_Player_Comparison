-- PART II: SALARY ANALYSIS
-- 1. View the salaries table
SELECT * FROM salaries;

-- 2. Return the top 20% of teams in terms of average annual spending
WITH ts AS (SELECT teamID, yearID, SUM(salary) as total_spend
			FROM salaries
            GROUP by teamID, yearID),
	 sp AS (SELECT teamID, AVG(total_spend) as avg_spend,
			NTILE(5) OVER(ORDER BY AVG(total_spend)) as spend_pct
			FROM ts
            GROUP BY teamID)
SELECT	teamID, ROUND(avg_spend / 1000000, 1) AS avg_spend_millions
FROM	sp
WHERE	spend_pct = 1;

-- 3. For each team, show the cumulative sum of spending over the years
WITH ts AS (SELECT teamID, yearID, SUM(salary) as total_spend
			FROM salaries
            GROUP by teamID, yearID)
SELECT	teamID, yearID,
		ROUND(SUM(total_spend) OVER (PARTITION BY teamID ORDER BY yearID) / 1000000, 1) as cumulative_sum_millions
FROM	ts
GROUP BY teamID, yearID;

-- 4. Return the first year that each team's cumulative spending surpassed 1 billion
WITH ts AS (SELECT teamID, yearID, SUM(salary) as total_spend
			FROM salaries
            GROUP by teamID, yearID),
      cs as (SELECT	teamID, yearID,
			SUM(total_spend) OVER (PARTITION BY teamID ORDER BY yearID) as cumulative_sum
			FROM	ts),
	  rn as (SELECT	teamID, yearID, cumulative_sum,
			 ROW_NUMBER() OVER(PARTITION BY teamID ORDER BY cumulative_sum) as rn
             FROM cs
             WHERE	cumulative_sum > 1000000000)
SELECT	teamID, yearID,
		ROUND(cumulative_sum / 1000000000, 2) AS cumulative_sum_billions
FROM	rn
WHERE	rn = 1;