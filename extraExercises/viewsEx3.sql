create view post80 as
select title, year from movie
where year>1980;
-- with check option;

insert into post80
values('godfather',1979);

create view above3 as
select distinct movie.mID, movie.title from movie
join rating r on movie.mid=r.mid
where r.stars>3;  -- JOIN --> VIEW IS NOT MODIFIABLE

-- different version
create view above3 as
select movie.mID, movie.title from movie
where movie.mid in (select r.mid from rating r where r.stars>3);
-- with check option;

select * from above3;

insert into above3 values(110,'godfather');

update above3 set mID='110' where title='Avatar';

update Above3 set mID = 110 where mID = 101;

create view nodate as
select movie.title, reviewer.name from movie
join rating r on r.mid=movie.mid and r.ratingdate=null
join reviewer on reviewer.rid=r.rid;

select * from nodate;
select * from reviewer;

create view nodate as
select movie.title, rr.name from movie
join rating r on r.mid=movie.mid and r.ratingdate is NULL
join reviewer rr on rr.rid=r.rid;
select * from nodate; -- JOIN AGAIN!!!

-- modifiable version --> just updates, as we're referring to title and name, leaving out keys of reviewer and movie --> ambiguity at insertion and deletion
create view nodate as
select movie.title, reviewer.name from movie, rating, reviewer
where movie.mid=rating.mid and reviewer.rid=rating.rid and rating.ratingDate is null;
-- 'with check option' will disallow _mishandled_ updates too (as 'update NoDate set mID = 110 where mID = 106' was, for ex).

create view liked as
select movie.title, reviewer.name from movie, reviewer, rating
where movie.mid=rating.mid and reviewer.rid=rating.rid and rating.stars>3;
-- no insertions, no deletions, malicious updates allowed, as 'update liked set title='Jaws' where name='Daniel Lewis';'
-- with check option will still allow malicious updates as defined above

select * from liked;