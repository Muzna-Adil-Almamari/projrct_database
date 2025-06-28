create database codeline
use codeline

-- Table 1: Trainee
create table Trainee(
trainee_id int primary key identity(1,1),
name varchar(100),
gender char(1) check (gender in  ('M', 'F')),
email varchar(100),
background varchar(255)
)
-- Table 2: Trainer
create table Trainer(
trainer_id int primary key identity(1,1),
name varchar(100),
specialty varchar(100),
phone varchar(20),
email varchar(100)
)
-- Table 3: Course
create table Course(
course_id int primary key identity(1,1),
title varchar(100),
category varchar(100),
duration_H int,
level varchar(100) check (level in ('Beginner','Intermediate','Advanced'))
)
-- Table 4: Schedule
create table Schedule (
schedule_id int primary key identity(1,1),
course_id int,
trainer_id int,
start_D date,
end_D date,
time_slot VARCHAR(100) CHECK (time_slot in ('Morning', 'Evening', 'Weekend')),
foreign key (course_id) REFERENCES Course(course_id),
foreign key (trainer_id) REFERENCES Trainer(trainer_id)
)
-- Table 5: Enrollment
create table Enrollment(
enrollment_id int primary key identity(1,1),
trainee_id int,
course_id int ,
enrollment_D date
foreign key (trainee_id) references Trainee(trainee_id),
foreign key (course_id) references Course(course_id),
)



--DML 
insert into Trainee (name, gender, email, background) values
('Aisha Al-Harthy','F','aisha@example.com','Engineering'),
('Sultan Al-Farsi','M','sultan@example.com','Business'),
('Mariam Al-Saadi','F','mariam@example.com','Marketing'),
('Omar Al-Balushi','M','omar@example.com','Computer Science'),
('Fatma Al-Hinai','F',' fatma@example.com','Data Science')

insert into Trainer (name, specialty, phone, email)values
('Khalid Al-Maawali','Databases','96891234567','khalid@example.com'),
('Noura Al-Kindi','Web Development','96892345678','noura@example.com'),
('Salim Al-Harthy ','Data Science','96893456789','salim@example.com')

insert into  Course ( title, category, duration_H, level) VALUES
('Database Fundamentals','Databases',20,'Beginner'),
('Web Development Basics','Web',30,'Beginner'),
('Data Science Introduction',' Data Science',25,'Intermediate'),
('Advanced SQL Queries','Databases',15,'Advanced')

insert into Schedule (course_id, trainer_id, start_D, end_D, time_slot) VALUES 
(1,1,'2025-07-01','2025-07-10','Morning'),
( 2,2 ,'2025-07-05 ','2025-07-20','Evening'),
( 3, 3,'2025-07-10','2025-07-25','Weekend'),
( 4, 1,'2025-07-15','2025-07-22','Morning')

insert into  Enrollment (trainee_id,course_id,enrollment_D) values
(1,1,'2025-06-01'),
(2,1,'2025-06-02'),
(3,2,'2025-06-03'),
(4,3,'2025-06-04'),
(5,3,'2025-06-05'),
(1,4,'2025-06-06')

--DQL
select * from Trainee
select * from Trainer
select * from Course
select * from Schedule
select * from Enrollment


--------------------Trainee Perspective--------------------------------
-- trainee id =1 
--1. Show all available courses (title, level, category)
select  title, level, category
from Course
--2. View beginner-level Data Science courses
select  title, level, category
from Course
where category= 'Data Science' and level ='Beginner'

--3. Show courses this trainee is enrolled in
select title
from Enrollment e join Course c
on c.course_id = e.course_id
where trainee_id =1

--4. View the schedule (start_date, time_slot) for the trainee's enrolled courses
select start_D, end_Dfrom Enrollment e join Schedule son e.course_id = s.course_idwhere trainee_id = 1order by start_D--5. Count how many courses the trainee is enrolled in
select COUNT(*) AS My_enrolled_courses 
from Enrollment
where trainee_id = 1

--6. Show course titles, trainer names, and time slots the trainee is attending

select title, t.name as trainer_name, time_slot
from Enrollment e join Course c 
on c.course_id = e.course_id
join Schedule s
on c.course_id = s.course_id
join Trainer t 
on t.trainer_id =s.trainer_id
where trainee_id= 1

select * from Enrollment
select * from Course
select * from Trainer
select * from Schedule
--------------------Trainer Perspective--------------------------------
--1. List all courses the trainer is assigned to 'Noura Al-Kindi'
select  title
from Schedule s join Course c
on c.course_id = s.course_id
where trainer_id = 2

--2. Show upcoming sessions (with dates and time slots)
select title , start_D ,end_D ,time_slot
from Schedule s join Course c
on c.course_id = s.course_id
where trainer_id = 1 and start_D > GETDATE()
-- GETDATE() is giting the crent date  example  2025-06-26 so we can see the upcoming sessions

--3. See how many trainees are enrolled in each of your courses
select title , COUNT(trainee_id) as total_num
from Enrollment e join Course c
on c.course_id = e.course_id
join Schedule s 
on c.course_id = s.course_id
where trainer_id =1
group by  title

--4. List names and emails of trainees in each of your courses
select title, t.name,t.email
from trainee t join Enrollment e
on t.trainee_id = e.trainee_id
join Course c
on c.course_id = e.course_id
join Schedule s
on  c.course_id = s.course_id
join Trainer tr
on tr.trainer_id =s.trainer_id
where tr.trainer_id = 1

--5. Show the trainer's contact info and assigned courses

select  name ,phone,email ,title
from Trainer t join Schedule s
on t.trainer_id = s.trainer_id
join  Course c
on c.course_id = s.course_id
where t.trainer_id =2


--6. Count the number of courses the trainer teaches
select COUNT(course_id) as num_of_courses_Khalid_AlMaawali_teach
from Schedule
where trainer_id =1 

--------------------Admin Perspective----------------------------------
--1. Add a new course (INSERT statement)insert into  Course ( title, category, duration_H, level) VALUES
('Python Programming', 'Programming', 40, 'Beginner')--select * from Course--2. Create a new schedule for a trainerinsert into Schedule (course_id, trainer_id, start_D, end_D, time_slot) VALUES
(5, 2, '2025-07-25', '2025-08-10', 'Evening');
--select * from Schedule--3. View all trainee enrollments with course title and schedule info
select name as trainee_name, title as course_title, start_D,time_slot
from Enrollment e join Trainee t 
on e.trainee_id = t.trainee_id
join Course c 
on e.course_id = c.course_id
join Schedule s 
on c.course_id = s.course_id
--4. Show how many courses each trainer is assigned toselect name, COUNT(course_id)from Trainer t join Schedule son t.trainer_id =s.trainer_idgroup by name--5. List all trainees enrolled in "Data Basics"insert into  Course ( title, category, duration_H, level) VALUES
('Data Basics', 'Databases', 50, 'Beginner')select name, email
from Enrollment e join Trainee t 
on e.trainee_id = t.trainee_id
join Course c
on e.course_id = c.course_id
where title = 'Database Fundamentals'
--where title ='Data Basics'--6. Identify the course with the highest number of enrollmentsSELECT TOP 1 title, COUNT(E.trainee_id) as total_enrollments
from Enrollment e join Course c 
on e.course_id = c.course_id
group by title
order by total_enrollments DESC;
--7. Display all schedules sorted by start dateselect * from Schedule
order by  start_D asc
