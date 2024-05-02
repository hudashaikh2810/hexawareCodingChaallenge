/*1. Provide a SQL script that initializes the database for the Job Board scenario “CareerHub”. */
/*4. Ensure the script handles potential errors, such as if the database or tables already exist. */
drop database if exists CareerHub;
create database if not exists CareerHub;
use CareerHub;
/*2. Create tables for Companies, Jobs, Applicants and Applications. */
/*3. Define appropriate primary keys, foreign keys, and constraints. */
create table companies(companyId int,companyName varchar(100),location varchar(50),primary key(companyId));

create table jobs(jobId int,companyId int,jobTitle varchar(100),jobDescription varchar(100),jobLocation varchar(100),salary decimal (4,2),
jobType enum ('FullTime','Part-time','Contract'),postedDate datetime);
alter table jobs add foreign key(companyId) references companies(companyId);
alter table jobs add primary key(jobId);
alter table jobs modify column salary decimal(7,2);
create table applicants(applicantId int primary key,firstname varchar(100),lastname varchar(100),email varchar(255),phone varchar(20),
resume text);

create table applications(applicationId int primary key,jobId int,applicantId int,applicationDate datetime,coverLetter text,
foreign key (jobId) references jobs(jobId),foreign key(applicantId) references applicants(applicantId));
/*insert values in tables*/
insert into companies values(1,'Hexaware','Chennai'),
(2,'Hexagone','Mumbai'),
(3,'Coagnizant','Banglore'),
(4,'Infosys','Pune'),
(5,'Accenture','Mumbai'),
(6,'Capgemini','Pune'),
(7,'TCS','Chennai'),
(8,'Google','Hyderabad'),
(9,'Amazon','Banglore'),
(10,'Deloitte','Hyderabad')
;


insert into jobs values(1,1,'Data Analyst','Analyze data and find trends','Chennai',37500,'FullTime','2024-02-05'),
(2,10,'Analyst-Trainee','Trainee to work on different technology','Hyderabad',23000,'Contract','2024-09-05'),
(3,5,'Packaged App Developer','To develop applications','Pune',37500,'FullTime','2024-02-10'),
(4,8,'Software Engineer','To develop software','Chennai',70000,'FullTime','2024-02-05'),
(5,9,'Data Scientist','To extract meaning insights from data','Banglore',12500,'Part-time','2024-09-15'),
(6,2,'Java Full Stack','To develop java based application','Mumbai',37500,'FullTime','2024-01-26'),
(7,7,'Data Analyst','Analyze data and find trends','Chennai',27500,'FullTime','2024-03-22'),
(8,8,'Data Analyst','To develop software','Hyderabad',90000,'FullTime','2024-02-25'),
(9,10,'Software Engineer','To develop software','Hyderabad',70000,'FullTime','2024-02-05'),
(10,4,'Software Engineer','To develop software','Pune',70000,'Contract','2024-04-21'),
(11,6,'Package App Developer','To develop software','Mumbai',80000,'Contract','2024-02-05')
;
insert into applicants values(1,'Huda','Shaikh','shaikhhuda2810@gmail.com',123456,'XYZ'),
(2,'Sanjay','Sharma','sanjay@gmail.com',234561,'ABC'),
(3,'Mohan','Sharma','mohan@gmail.com',345621,'BCD'),
(4,'Aviraal','Bajpayee','aviral@gmail.com',1234563,'CDE'),
(5,'Suman','Mehta','suman@gmail.com',1234567,'EFG'),
(6,'Kasiya','Mehta','kasiya@gmail.com',12345689,'HIC'),
(7,'Shagun','Jhawar','shagun@gmail.com',12345612,'HIJ'),
(8,'Ravi','Dubey','ravi@gmail.com',12345615,'PQR'),
(9,'Manan','Jain','manan@gmail.com',12345678,'ABE'),
(10,'Sanjay','Mehta','Mehtasanjay@gmail.com',12345612,'BBC')
;
insert into applications values (1,1,10,'2024-04-05','AWS'),
(2,1,9,'2024-05-01','WSA'),
(3,2,5,'2024-04-29','ABC'),
(4,5,5,'2024-04-05','ABC'),
(5,4,4,'2024-03-26','HXC'),
(6,4,9,'2024-01-25','AWS'),
(7,6,6,'2024-04-05','WSA'),
(8,2,9,'2024-01-15','SWA'),
(9,8,8,'2024-04-05','JHK'),
(10,10,4,'2024-06-15','WSAK')
;
/*5. Write an SQL query to count the number of applications received for each job listing in the 
"Jobs" table. Display the job title and the corresponding application count. Ensure that it lists all 
jobs, even if they have no applications. */
select * from applications;

select jobs.jobId,jobs.jobTitle,case when jobCount.count is null then 0 else jobCount.count end NoOfApplications 
from jobs left join (select jobId,count(*) as count from applications group by jobId) as jobCount on jobs.jobId=jobCount.jobId;
/*6. Develop an SQL query that retrieves job listings from the "Jobs" table within a specified salary 
range. Allow parameters for the minimum and maximum salary values. Display the job title, 
company name, location, and salary for each matching job. */
select jobs.jobTitle,companies.companyName,companies.location,jobs.salary from jobs inner join companies
on jobs.companyId=companies.CompanyId where jobs.salary between 9000 and 70000;
/*7. Write an SQL query that retrieves the job application history for a specific applicant. Allow a 
parameter for the ApplicantID, and return a result set with the job titles, company names, and 
application dates for all the jobs the applicant has applied to. */


select applications.applicationDate,jobs.jobTitle,jobs.companyName from applications inner join (select jobs.jobId,jobs.jobTitle,companies.companyName from companies inner join jobs on companies.companyId=jobs.companyId) as jobs
on applications.jobId=jobs.jobId where applications.applicantId=5;
/*8. Create an SQL query that calculates and displays the average salary offered by all companies for 
job listings in the "Jobs" table. Ensure that the query filters out jobs with a salary of zero*/
select avg(salary) as AverageSalaryOffered,companyId from jobs group by companyId;
select companies.companyName,t.AverageSalary from companies inner join 
(select avg(salary) as AverageSalary,companyId from jobs group by companyId) 
as t on companies.companyId=t.companyId; 
/*9. Write an SQL query to identify the company that has posted the most job listings. Display the 
company name along with the count of job listings they have posted. Handle ties if multiple 
companies have the same maximum count. */

select countT.count as JobOpeningPosted,companies.companyName from companies inner join 
(select count(*) as Count,companyId from jobs group by companyId having count(*)=(select max(count) from (select count(*) as Count,companyId from jobs group by companyId) as t)) as countT
on companies.companyId=countT.companyId;
/*10. Find the applicants who have applied for positions in companies located in 'CityX' and have at 
least 3 years of experience. */
/*11. Retrieve a list of distinct job titles with salaries between $60,000 and $80,000.*/
select distinct jobTitle from jobs where salary between 60000 and 80000;
/*12. Find the jobs that have not received any applications.*/
select jobs.* from jobs left join applications
on jobs.jobId=applications.jobId where applications.applicationId is null;
/*13. Retrieve a list of job applicants along with the companies they have applied to and the positions 
they have applied for*/


select applicantData.*,companies.companyName from 
companies inner join 
(select jobs.companyId,jobs.jobTitle,applicant.* from jobs inner join
(select applicants.*,applications.jobId from applicants inner join applications on 
applicants.applicantId=applications.applicantId) as applicant
on jobs.jobId=applicant.jobId)
as applicantData 
on companies.companyId=applicantData.companyId;
/*14. Retrieve a list of companies along with the count of jobs they have posted, even if they have not 
received any applications. */

select companies.*,case when jobCount.count is null then 0 else jobCount.count end 'JobCount' from 
companies left join (select count(*) as count,companyId from jobs group by companyId
) 
as jobCount on companies.companyId=jobCount.companyId;

/*15. List all applicants along with the companies and positions they have applied for, including those 
who have not applied. */

select case when companies.companyName is null then 'Did Not Apply to Any' else companies.companyName end 'CompanyName',
app.firstname,app.lastname,app.applicantId,app.JobTitle from 
(select applicant.firstname,applicant.lastname,applicant.applicantId,case when jobs.jobTitle is null then 'Not Applied' else jobs.jobTitle end 'JobTitle',
case when jobs.companyId is null then 0 else jobs.companyId end 'companyId' from 
(select applicants.applicantId,applicants.firstname,applicants.lastname,
case when applications.jobId is null then 0 else applications.jobId end 'JobId' from applicants left join applications on 
applicants.applicantId=applications.applicantId)
as applicant left join jobs 
on applicant.jobId=jobs.jobId)
as app left join companies 
on app.companyId=companies.companyId;
 /*16. Find companies that have posted jobs with a salary higher than the average salary of all jobs. 
*/

select distinct companies.companyName from companies inner join (select * from jobs where salary>(select avg(salary) from jobs ))
as jobs
on companies.companyId=jobs.companyId;
/*17. Display a list of applicants with their names and a concatenated string of their city and state. 
*/
alter table applicants add city varchar(20);
alter table applicants add state varchar(50);
update applicants set city='Indore',state='Madhya Pradesh' where applicantId=1;
update applicants set city='Indore',state='Madhya Pradesh' where applicantId=10;
update applicants set city='Banglore',state='Karanataka' where applicantId=2;
update applicants set city='Banglore',state='Karanataka' where applicantId=9;
update applicants set city='Mumbai',state='Maharastra' where applicantId=3;
update applicants set city='Mumbai',state='Maharastra' where applicantId=4;
update applicants set city='Pune',state='Maharastra' where applicantId=7;
update applicants set city='Pune',state='Maharastra' where applicantId=8;
update applicants set city='Noida',state='Uttar Pradesh' where applicantId=5;
update applicants set city='Noida',state='Uttar Pradesh' where applicantId=6;
select concat(firstname,' ',lastname) as name,concat(city,' ',state) as PlaceOfResidence from applicants;

/*18. Retrieve a list of jobs with titles containing either 'Developer' or 'Engineer'. 
*/
select * from jobs where jobTitle like "%Engineer%" or jobTitle like "%Developer%";
/*19. Retrieve a list of applicants and the jobs they have applied for, including those who have not 
applied and jobs without applicants. */

select applicant.firstname,applicant.lastname,applicant.applicantId,

case when jobs.jobTitle is null then 'Not Applied To Any' else jobs.jobTitle end 'JobTitle' 
 from 
(select applicants.*,case when applications.jobId is null then 0 else applications.jobId end 'JobId' from applicants left join applications 
on applicants.applicantId=applications.applicantId) 
as applicant
left join jobs
on applicant.jobId=jobs.jobId union 

select case when applicants.firstname is null then 'No one applied' else applicants.firstname end 'firstname',
case when applicants.lastname is null then 'No one Applied' else applicants.lastname end 'lastname',
case when applicants.applicantId is null then 0 else applicants.applicantId end 'applicantId',job.jobTitle
from 
(select jobs.jobId,jobs.jobTitle,case when applications.applicantId is null then 0 else applicantId end 'ApplicantId' from jobs left join applications 
on jobs.jobId=applications.jobId where applications.applicationId is null)
as job left join applicants
on job.applicantId=applicants.applicantId;


