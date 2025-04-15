-- PART III: PLAYER CAREER ANALYSIS
-- 1. View the players table and find the number of players in the table
SELECT * FROM players;

SELECT COUNT(*) as num_players
FROM players;

-- 2. For each player, calculate their age at their first game, their last game, and their career length (all in years). 
-- Sort from longest career to shortest career.
SELECT	nameGiven, 
		TIMESTAMPDIFF(YEAR, CAST(CONCAT(birthYear, '-', birthMonth, '-', birthDay, '-') AS DATE), debut)
        AS starting_age,
        TIMESTAMPDIFF(YEAR, CAST(CONCAT(birthYear, '-', birthMonth, '-', birthDay, '-') AS DATE), finalGame)
        AS ending_age,
        TIMESTAMPDIFF(YEAR, debut, finalGame)
        AS career_length
FROM players
ORDER BY career_length DESC;


-- 3. What team did each player play on for their starting and ending years?
SELECT * FROM players;
SELECT * FROM salaries;

SELECT p.nameGiven, 
	   s.yearID as starting_year, s.teamID as starting_team, 
       e.yearID as ending_year, e.teamID as starting_team
FROM players p
JOIN salaries s
	ON p.playerID = s.playerID
    AND YEAR(p.debut) = s.yearID
JOIN salaries e
	ON p.playerID = e.playerID
    AND YEAR(p.finalGame) = e.yearID;

-- 4. How many players started and ended on the same team and also played for over a decade?
SELECT p.nameGiven, 
	   s.yearID as starting_year, s.teamID as starting_team, 
       e.yearID as ending_year, e.teamID as starting_team
FROM players p
JOIN salaries s
	ON p.playerID = s.playerID
    AND YEAR(p.debut) = s.yearID
JOIN salaries e
	ON p.playerID = e.playerID
    AND YEAR(p.finalGame) = e.yearID
WHERE s.teamID = e.teamID and e.yearID - s.yearID > 10;