use moviedb;

select distinct r1.name as r1name, r2.name as r2name
from rating rt1
join rating rt2 on rt1.mID=rt2.mID
				and rt1.rID<rt2.rID
join reviewer r1 on rt1.rID=r1.rID
join reviewer r2 on rt2.rID=r2.rID
order by r1name,r2name;

select reviewer.name, movie.title, rating.stars
from rating
join reviewer on rating.rID=reviewer.rID
join movie on rating.mID=movie.mID
where rating.stars <= all (
	select rating.stars
	from rating
	join reviewer on rating.rID=reviewer.rID
	join movie on rating.mID=movie.mID
    );
    
select m.title, avg(r.stars) as avg
from rating r
join movie m on r.mID=m.mID
group by m.title
order by avg DESC, m.title;

select r.name
from rating
join reviewer r on rating.rID=r.rID
group by r.name
having count(*) >=3;

SELECT m1.director, m1.title
FROM Movie m1
WHERE m1.director IN (
    SELECT director
    FROM Movie
    GROUP BY director
    HAVING COUNT(mID) > 1
)
ORDER BY m1.director, m1.title;

SELECT m.title, AVG(r.stars) AS avg_rating
FROM Rating r
JOIN Movie m ON r.mID = m.mID
GROUP BY m.title
HAVING AVG(r.stars) = (
    SELECT MAX(avg_rating)
    FROM (
        SELECT AVG(r.stars) AS avg_rating
        FROM Rating r
        GROUP BY r.mID
    ) sub
);

SELECT m.title, AVG(r.stars) AS avg_rating
FROM Rating r
JOIN Movie m ON r.mID = m.mID
GROUP BY m.title
HAVING AVG(r.stars) = (
    SELECT MIN(avg_rating)
    FROM (
        SELECT AVG(r.stars) AS avg_rating
        FROM Rating r
        GROUP BY r.mID
    ) sub
);

select distinct title from movie;

SELECT distinct M.director, M.title, MAX_Rating.max_stars
FROM Movie M
JOIN (
    SELECT M.director, MAX(R.stars) AS max_stars
    FROM Movie M
    JOIN Rating R ON M.mID = R.mID
    WHERE M.director IS NOT NULL
    GROUP BY M.director
) AS MAX_Rating 
ON M.director = MAX_Rating.director
JOIN Rating R ON M.mID = R.mID AND R.stars = MAX_Rating.max_stars
WHERE M.director IS NOT NULL
order by M.director;

UPDATE Movie
SET year = year + 25
WHERE mID IN (
    SELECT mID
    FROM Rating
    GROUP BY mID
    HAVING AVG(stars) >= 4
);

DELETE FROM Rating
WHERE mID IN (
    SELECT mID 
    FROM Movie
    WHERE (year < 1970 OR year > 2000)
) 
AND stars < 4;
