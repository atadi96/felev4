-- CREATE
create table users (
  u_id       int not null,
  username   varchar(30),
  full_name  varchar(100),
  passwd     varchar(100),
  primary key(u_id)
);

-- INSERT
insert into users (passwd, u_id, username) values ('asd', 1, 'Lul');
insert into users values (2, 'AFDLKM', 'ASD ASD', 'asda');

-- UPDATE
update users set passwd='dsa' where u_id=1;

-- DELETE
delete from users where u_id='2';

-- DROP
drop table users;

-- ALTER
alter table users add Last_login date;

-----------------
create table orders(
  o_id    int not null,
  u_id    int not null,
  p_name  varchar(100),
  price   int,
  primary key(o_id),
  foreign key(u_id) references users(u_id)
);

insert into orders values (1, 1, 'alma', 2);
insert into orders values (2, 1, 'korte', 3);

------------------
create or replace procedure hello is
  msg varchar(100) := 'hi :3';
begin
  dbms_output.put_line(msg);
end;

set serveroutput on;

call hello();

/*
IF feltetel THEN

ELSIF felt THEN

ELSE

END IF
*/

/*
FOR i IN [REVERSE] a..b LOOP

END LOOP;
*/
/*

*/

create or replace procedure szamok is
begin
  for asdf in reverse 2..50 loop
    dbms_output.put_line(asdf);
  end loop;
end;

call szamok();

create or replace function prim(n int) return int is
begin
  for i in 2..n/2 loop
    if mod(n, i) = 0 then
      return 0;
    end if;
  end loop;
  return 1;
end;

SELECT prim(5) FROM DUAL;

create or replace function lnko(a int, b int) return int is
  r int := min( a , b );
begin
  while not (mod(a,r) and mod(b, r)) loop
    r := r - 1;
  end loop;
  return r;
end;

SELECT lnko(15, 40) FROM dual;