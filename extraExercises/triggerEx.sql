/* Delete the tables if they already exist */
drop table if exists Highschooler;
drop table if exists Friend;
drop table if exists Likes;

/* Create the schema for our tables */
create table Highschooler(ID int, name text, grade int);
create table Friend(ID1 int, ID2 int);
create table Likes(ID1 int, ID2 int);

/* Populate the tables with our data */
insert into Highschooler values (1510, 'Jordan', 9);
insert into Highschooler values (1689, 'Gabriel', 9);
insert into Highschooler values (1381, 'Tiffany', 9);
insert into Highschooler values (1709, 'Cassandra', 9);
insert into Highschooler values (1101, 'Haley', 10);
insert into Highschooler values (1782, 'Andrew', 10);
insert into Highschooler values (1468, 'Kris', 10);
insert into Highschooler values (1641, 'Brittany', 10);
insert into Highschooler values (1247, 'Alexis', 11);
insert into Highschooler values (1316, 'Austin', 11);
insert into Highschooler values (1911, 'Gabriel', 11);
insert into Highschooler values (1501, 'Jessica', 11);
insert into Highschooler values (1304, 'Jordan', 12);
insert into Highschooler values (1025, 'John', 12);
insert into Highschooler values (1934, 'Kyle', 12);
insert into Highschooler values (1661, 'Logan', 12);

insert into Friend values (1510, 1381);
insert into Friend values (1510, 1689);
insert into Friend values (1689, 1709);
insert into Friend values (1381, 1247);
insert into Friend values (1709, 1247);
insert into Friend values (1689, 1782);
insert into Friend values (1782, 1468);
insert into Friend values (1782, 1316);
insert into Friend values (1782, 1304);
insert into Friend values (1468, 1101);
insert into Friend values (1468, 1641);
insert into Friend values (1101, 1641);
insert into Friend values (1247, 1911);
insert into Friend values (1247, 1501);
insert into Friend values (1911, 1501);
insert into Friend values (1501, 1934);
insert into Friend values (1316, 1934);
insert into Friend values (1934, 1304);
insert into Friend values (1304, 1661);
insert into Friend values (1661, 1025);
insert into Friend select ID2, ID1 from Friend;

insert into Likes values(1689, 1709);
insert into Likes values(1709, 1689);
insert into Likes values(1782, 1709);
insert into Likes values(1911, 1247);
insert into Likes values(1247, 1468);
insert into Likes values(1641, 1468);
insert into Likes values(1316, 1304);
insert into Likes values(1501, 1934);
insert into Likes values(1934, 1501);
insert into Likes values(1025, 1101);

/*
-- Trigger per mantenere la simmetria dopo un'INSERT
CREATE TRIGGER T1
AFTER INSERT ON Friend
FOR EACH ROW
BEGIN
    -- Controlla se (new.ID2, new.ID1) non esiste già prima di inserirlo
    INSERT INTO Friend (ID1, ID2)
    SELECT NEW.ID2, NEW.ID1
    WHERE NOT EXISTS (
        SELECT * FROM Friend WHERE ID1 = NEW.ID2 AND ID2 = NEW.ID1
    );
END;

-- Trigger per mantenere la simmetria dopo un'UPDATE
CREATE TRIGGER T2
AFTER UPDATE ON Friend
FOR EACH ROW
BEGIN
    -- Cancella la vecchia coppia inversa
    DELETE FROM Friend WHERE ID1 = OLD.ID2 AND ID2 = OLD.ID1;

    -- Inserisce la nuova coppia inversa se non esiste già
    INSERT INTO Friend (ID1, ID2)
    SELECT NEW.ID2, NEW.ID1
    WHERE NOT EXISTS (
        SELECT * FROM Friend WHERE ID1 = NEW.ID2 AND ID2 = NEW.ID1
    );
END;

-- Trigger per mantenere la simmetria dopo un DELETE
CREATE TRIGGER T3
AFTER DELETE ON Friend
FOR EACH ROW
BEGIN
    -- Cancella la coppia inversa
    DELETE FROM Friend WHERE ID1 = OLD.ID2 AND ID2 = OLD.ID1;
END;
*/

CREATE TRIGGER T1
BEFORE INSERT ON Highschooler
FOR EACH ROW
when new.grade is not null and new.grade NOT IN (9, 10, 11, 12)
	begin
		select raise(ignore);
	end;

create trigger t2
after insert on Highschooler
for each row
when new.grade is null
begin
update Highschooler
set grade=9
where Highschooler.ID=new.ID;
end;

create trigger t3
after update on Highschooler
for each row
when new.grade>12
begin
delete from Highschooler
where Highschooler.id=new.id;
end;

create trigger t4
after delete on Highschooler
for each row
begin
	delete from friend
	where friend.id1=old.id or friend.id2=old.id;
	
    delete from likes
    where likes.id1=old.id or likes.id2=old.id;
end;


create trigger t5
after update on highschooler
for each row
when old.grade=new.grade-1
begin
	update highschooler
	set grade=grade+1
	where highschooler.id in
						(select F.id2 from Friend F where F.id1=new.id
                        union
                        select F.id1 from Friend F where F.id2=new.id)
		  and highschooler.grade<12;
                        
end;
