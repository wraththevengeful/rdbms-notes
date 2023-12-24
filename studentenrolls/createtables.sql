-- Create database;
create table studentenrolls;

--Create Tables:

create table student(ROLLNO SMALLINT primary key, name varchar(30), dob date, gender char(1),doa date,bcode smallint);
create table branch(bcode smallint primary key, bname varchar(30),dno smallint);
create table department(dno smallint primary key, dname varchar(30));
create table course(ccode smallint, cname varchar(30),credits smallint,dno smallint,primary key(ccode,cname));
create table branch_course(bcode smallint, ccode smallint, semester smallint,primary key(bcode,ccode));
create table prerequisite_course(ccode smallint,pccode smallint, primary key(ccode,pccode));
create table enrolls(rollno smallint,ccode smallint,sess smallint,grade char(1),primary key(rollno,ccode,sess));

-- Add constraints:
alter table student add constraint gender_check check(gender IN('m','f'));
alter table enrolls add constraint grade_check check(grade in('s','a','b','c','d','e','u'));
alter table branch rename column bocde to bcode;

-- Alter Table;
alter table enrolls alter column sess TYPE varchar(30);

--Alter table to set foreign key:
alter table student add constraint student_fk foreign key (bcode) references branch;
alter table branch add constraint branch_fk foreign key (bcode) references branch_course(bcode);
