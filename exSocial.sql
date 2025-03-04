use social;

select distinct h.name
from friend f
join highschooler h
on f.ID1=h.ID
join highschooler h1
on f.ID2=h1.ID
where h1.name='Gabriel'
union
select distinct h1.name
from friend f
join highschooler h
on f.ID1=h.ID
join highschooler h1
on h1.ID=f.ID2
where h.name='Gabriel';

select h1.name, h1.grade, h2.name, h2.grade
from likes l
join highschooler h1
on l.ID1=h1.ID
join highschooler h2
on l.ID2=h2.ID
where h1.grade-h2.grade>=2;

SELECT DISTINCT h1.name, h1.grade, h2.name, h2.grade
FROM likes l1
JOIN likes l2 
    ON l1.ID1 = l2.ID2 
    AND l1.ID2 = l2.ID1
JOIN highschooler h1 ON h1.ID = l1.ID1
JOIN highschooler h2 ON h2.ID = l1.ID2
WHERE h1.name < h2.name
ORDER BY h1.name, h2.name;

select h.name, h.grade
from highschooler h
where h.ID not in 
(select ID1
from likes)
and h.ID not in (
select ID2 from likes)
order by h.grade,h.name;

select h1.name, h1.grade, h2.name, h2.grade
from likes
join highschooler h1
on likes.ID1=h1.ID
join highschooler h2
on likes.ID2=h2.ID
where ID2 not in (select ID1 from likes);

select distinct h1.name, h1.grade, h2.name, h2.grade
from friend f
join highschooler h1
on f.ID1=h1.ID
join highschooler h2
on f.ID2=h2.ID
where h1.grade=h2.grade and h1.name<h2.name
order by h1.grade, h1.name;


select h1.name, h1.grade
from friend f
join highschooler h1
on f.ID1=h1.ID
join highschooler h2
on f.ID2=h2.ID
group by h1.name, h1.grade
having max(h2.grade)=min(h2.grade)
order by h1.grade, h1.name;

SELECT DISTINCT 
    h1.name AS A_name, h1.grade AS A_grade, 
    h2.name AS B_name, h2.grade AS B_grade, 
    h3.name AS C_name, h3.grade AS C_grade
FROM Likes l
JOIN Highschooler h1 ON h1.ID = l.ID1  -- A
JOIN Highschooler h2 ON h2.ID = l.ID2  -- B
JOIN Friend f1 ON f1.ID1 = l.ID1       -- A's friend (C)
JOIN Friend f2 ON f1.ID2 = f2.ID1 AND f2.ID2 = l.ID2  -- B's friend (C)
JOIN Highschooler h3 ON h3.ID = f1.ID2 -- C (common friend)
WHERE NOT EXISTS (
    SELECT 1 
    FROM Friend f 
    WHERE f.ID1 = l.ID1 AND f.ID2 = l.ID2
);

select (select count(*)
from highschooler) - (select count(distinct h1.name)
from highschooler h1) as diff;



select h1.name, h1.grade
from highschooler h1
where h1.name in (
	select h1.name
	from likes l1
	join highschooler h1
	on l1.ID2=h1.ID
	group by h1.name
	having (count(h1.name)>1)
);

SELECT DISTINCT 
    h1.name AS A_name, h1.grade AS A_grade, 
    h2.name AS B_name, h2.grade AS B_grade, 
    h3.name AS C_name, h3.grade AS C_grade
FROM Likes l1
JOIN Likes l2 ON l1.ID2 = l2.ID1  -- B è colui che riceve un "like" da A e che dà un "like" a C
JOIN Highschooler h1 ON h1.ID = l1.ID1  -- A
JOIN Highschooler h2 ON h2.ID = l1.ID2  -- B
JOIN Highschooler h3 ON h3.ID = l2.ID2  -- C
WHERE l1.ID1 <> l2.ID2;  -- A e C devono essere diversi

SELECT DISTINCT h1.name, h1.grade
FROM Highschooler h1
JOIN Friend f ON h1.ID = f.ID1
JOIN Highschooler h2 ON f.ID2 = h2.ID
LEFT JOIN Friend f_same ON h1.ID = f_same.ID1 
    AND f_same.ID2 IN (SELECT ID FROM Highschooler WHERE grade = h1.grade)
WHERE f_same.ID1 IS NULL;


select avg(somma) as media
from(
select count(distinct f.ID2) as somma
from friend f
group by f.ID1) mean; -- need for alias


SELECT COUNT(distinct h1.ID)  
FROM Highschooler h1  
LEFT JOIN Friend f1 ON h1.ID = f1.ID1  
LEFT JOIN Highschooler h2 ON f1.ID2 = h2.ID  
LEFT JOIN Friend f2 ON h2.ID = f2.ID1  
LEFT JOIN Highschooler h3 ON f2.ID2 = h3.ID  
WHERE (h2.name = 'Cassandra' OR h3.name = 'Cassandra')  
AND h1.name <> 'Cassandra';

SELECT MAX(friend_count) 
    FROM (
        SELECT COUNT(f.ID2) AS friend_count
        FROM Friend f
        GROUP BY f.ID1
    ) AS max_counts;


select h.name, h.grade
from highschooler h
join (
	select f.ID1 as studid, count(f.ID2) as fcount
    from friend f
    group by f.ID1
) table1 on h.ID=table1.studid
where table1.fcount=(
select max(conteggio) as maxfriend
from(
select count(*) as conteggio
from friend f
group by f.ID1
)alias);

delete from highschooler
where grade=12;

DELETE FROM Likes l
WHERE EXISTS (
    SELECT 1
    FROM Friend f, Likes l
    WHERE f.ID1 = l.ID1 AND f.ID2 = l.ID2
)
AND NOT EXISTS (
    SELECT 1
    FROM Likes l2
    WHERE l2.ID1 = l.ID2 AND l2.ID2 = l.ID1
);
