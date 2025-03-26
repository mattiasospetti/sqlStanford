create view TNS as
select m.title,rr.name, r.stars from Movie m
join Rating r on r.mid=m.mid
join Reviewer rr on rr.rid=r.rid;

select year from TNS
join movie m on tns.title=m.title
where name='Chris Jackson'
order by m.year desc
limit 1;

create view RatingStats as
select TNS.title as title, count(*) as conteggio, avg(TNS.stars) as media
from TNS
group by TNS.title;

select r.title from RatingStats r
where r.conteggio > 2 
order by r.media desc
limit 1;

CREATE VIEW Favorites AS
SELECT r.rID, r.mID
FROM Rating r
WHERE r.stars = (
    SELECT MAX(r2.stars) 
    FROM Rating r2 
    WHERE r2.rID = r.rID
);

select r1.name, r2.name, m.title from Favorites f1
join Favorites f2 on f1.mid=f2.mid and f1.rid < f2.rid
join reviewer r1 on r1.rid=f1.rid
join reviewer r2 on r2.rid=f2.rid
join movie m on m.mid=f1.mid;