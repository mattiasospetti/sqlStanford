create view JordanFriend as
select distinct h1.name,h1.grade from friend f1
join highschooler h1 on h1.id=f1.id1
join highschooler h2 on h2.id=f1.id2 and h2.name='Jordan';

CREATE TRIGGER Update_JordanFriend
INSTEAD OF UPDATE ON JordanFriend
FOR EACH ROW
WHEN NEW.grade BETWEEN 9 AND 12
AND NOT EXISTS (
    SELECT * FROM Highschooler 
    WHERE name = NEW.name AND grade = NEW.grade 
    AND ID <> (SELECT ID FROM Highschooler WHERE name = OLD.name AND grade = OLD.grade)
)
BEGIN
    UPDATE Highschooler
    SET name = NEW.name, grade = NEW.grade
    WHERE ID = (SELECT ID FROM Highschooler WHERE name = OLD.name AND grade = OLD.grade);
END;

create view olderfriend as
select h1.id as id1,h1.name as name1 ,h1.grade as grade1,h2.id as id2, h2.name as name2,h2.grade as grade2 from friend f1
join highschooler h1 on f1.id1=h1.id
join highschooler h2 on f1.id2=h2.id
where h2.grade-h1.grade>=2;

create trigger t1
instead of delete on olderfriend
for each row
begin
	delete from friend
    where (friend.id1=OLD.id1 and friend.id2=OLD.id2) or (friend.id2=OLD.id1 and friend.id1=OLD.id2);
end;

create trigger t2
instead of insert on olderfriend
for each row
when new.grade2-new.grade1>=2
and not exists
(select * from friend where (friend.id1=new.id1 and friend.id2=new.id2) or (friend.id1=new.id2 and friend.id2=new.id1))
AND EXISTS (SELECT 1 FROM Highschooler WHERE ID = NEW.ID1 AND name = NEW.name1 AND grade = NEW.grade1)
AND EXISTS (SELECT 1 FROM Highschooler WHERE ID = NEW.ID2 AND name = NEW.name2 AND grade = NEW.grade2)
begin
	insert into friend
    values(new.id1,new.id2);
    insert into friend
    values(new.id2,new.id1);
end;