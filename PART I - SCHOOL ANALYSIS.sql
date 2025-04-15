-- PART I: SCHOOL ANALYSIS
-- 1. View the schools and school details tables
SELECT * FROM schools;
SELECT * FROM school_details;

-- 2. In each decade, how many schools were there that produced players?
SELECT FLOOR(yearID/10)*10 as decade, count(DISTINCT schoolID) as num_schools
FROM schools
GROUP BY decade
ORDER BY decade;

-- 3. What are the names of the top 5 schools that produced the most players?
SELECT sd.name_full, count(DISTINCT s.playerID) as num_players
FROM schools s
LEFT JOIN school_details sd
	ON s.schoolID = sd.schoolID
GROUP BY s.schoolID
ORDER by num_players DESC
LIMIT 5;

-- 4. For each decade, what were the names of the top 3 schools that produced the most players?
WITH ds AS	(SELECT FLOOR(yearID/10)*10 as decade, sd.name_full, count(DISTINCT s.playerID) as num_players
			FROM schools s LEFT JOIN school_details sd
					 ON s.schoolID = sd.schoolID
			GROUP BY decade, s.schoolID),
	sr as  (SELECT decade, name_full, num_players,
			DENSE_RANK() OVER(PARTITION BY decade ORDER by num_players DESC) as school_rank
            FROM ds)
SELECT decade, name_full, num_players
FROM sr
WHERE school_rank <= 3
ORDER BY decade DESC, school_rank;
            