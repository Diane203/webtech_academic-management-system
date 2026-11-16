University Course Registration and Academic Management System

Web Technology and Internet: Individual Assignment

	
Student Name	IGIRANEZA Diane
Registration No.	27895
Course	Web Technology and Internet
Date  16 November 2026
Scope	Model and Repository layers




Table of Contents
Project Overview
Technology Stack
Problem Analysis and Identified Entities
Identified Attributes
Relationships and Cardinality
Foreign Keys, Join Table and Join Entity
Entity Relationship Diagram (ERD)
Relational Database Schema
Why These Entities and Relationships Were Selected
Hibernate/JPA Implementation
Local Setup and Configuration
Running and Testing the Project
Verifying the Database in PostgreSQL
Screenshots
Submission Checklist
1. Project Overview

A university currently manages academic information manually, which makes it hard to maintain student records, organize courses, assign lecturers, and track registrations. This project designs and implements the data model and repository layers of a University Course Registration and Academic Management System using Spring Boot, Spring Data JPA/Hibernate and PostgreSQL.

The system manages:

Academic departments, each with a head lecturer
Students, each assigned to a department and having exactly one personal profile
Lecturers, employed by departments and teaching multiple courses
Courses, offered by departments and taught by multiple lecturers
Registrations of students for courses, with date, academic year, semester, status and grade

At this stage only the Model and Repository layers are implemented. Service and controller layers can be added later.

2. Technology Stack
Category	Technology
Language	Java 17 or later
Framework	Spring Boot (generated with Spring Initializr)
Persistence / ORM	Spring Data JPA / Hibernate
Database	PostgreSQL, database name: university_academic_db
Build Tool	Maven
IDE	Visual Studio Code
Version Control	Git and GitHub
3. Problem Analysis and Identified Entities

The main actors and business objects in the problem statement are:

Department
Runs academic activities, offers courses, and employs lecturers.
Has one lecturer who serves as head.
Can have many students, many courses and many lecturers.
Student
Belongs to exactly one department.
Has exactly one personal profile.
Can register for many courses across multiple academic periods.
StudentProfile
Stores date of birth, gender, phone number and residential address.
One-to-one with a single student.
Lecturer
Employed by one department.
Can teach multiple courses; a course can be taught by multiple lecturers.
This many-to-many relationship is handled with a join table only, with no separate entity (as the assignment requires).
Course
Belongs to one department.
Can be taught by several lecturers and taken by many students.
Registration
Represents the student-course relationship.
Stores data that cannot fit in a simple relationship: registration date, academic year, semester, status and grade.
This is the join entity for the student-course relationship.
4. Identified Attributes
Department

id, name, location, headLecturer

Student

id, studentNumber, firstName, lastName, email, department

StudentProfile

id, dateOfBirth, gender, phoneNumber, residentialAddress, student

Lecturer

id, staffNumber, firstName, lastName, email, department, courses

Course

id, courseCode, title, creditHours, department, lecturers

Registration

id, registrationDate, academicYear, semester, status, grade, student, course

Enumerations
Enum	Values
Gender	MALE, FEMALE
RegistrationStatus	PENDING, APPROVED, REJECTED
5. Relationships and Cardinality
#	Relationship	Cardinality	Why
1	Department to Lecturer	One-to-many	One department employs many lecturers; each lecturer belongs to one department.
2	Department to Course	One-to-many	One department offers many courses; each course belongs to one department.
3	Department to Student	One-to-many	One department has many students; each student is assigned to one department.
4	Department to Head Lecturer	One-to-one	Each department has exactly one head lecturer.
5	Student to StudentProfile	One-to-one	Each student has exactly one profile and each profile belongs to one student.
6	Lecturer to Course	Many-to-many	A lecturer teaches several courses and a course can have several lecturers.
7	Student to Course (via Registration)	Many-to-many with extra attributes	Needs a join entity to hold date, year, semester, status and grade.
8	Registration to Student	Many-to-one	Many registrations belong to one student.
9	Registration to Course	Many-to-one	Many registrations belong to one course.
6. Foreign Keys, Join Table and Join Entity
Relationships that require a foreign key
Foreign key	References
departments.head_lecturer_id	lecturers.id
students.department_id	departments.id
student_profiles.student_id (UNIQUE)	students.id
lecturers.department_id	departments.id
courses.department_id	departments.id
registrations.student_id	students.id
registrations.course_id	courses.id

Note: departments.head_lecturer_id and lecturers.department_id reference each other. To avoid a circular insert problem, head_lecturer_id is nullable: create the department first, then the lecturer, then assign the lecturer as head.

Join table (many-to-many without extra data)

course_lecturer resolves the Lecturer to Course many-to-many relationship. It contains only two foreign keys, lecturer_id and course_id, which together form the composite primary key. No separate entity class is created for it.

Join entity (many-to-many with extra data)

registrations is required for the Student to Course relationship because the relationship carries its own attributes: registrationDate, academicYear, semester, status and grade. A plain join table cannot store these.

7. Entity Relationship Diagram (ERD)

Entity Relationship Diagram

8. Relational Database Schema

Relational Schema

PK = primary key, FK = foreign key, UK = unique. Numbered arrows point from the foreign key to the primary key it references.

The same schema in text form:

sql
departments (
    id                BIGSERIAL PRIMARY KEY,
    name              VARCHAR UNIQUE NOT NULL,
    location          VARCHAR NOT NULL,
    head_lecturer_id  BIGINT UNIQUE REFERENCES lecturers(id)   -- nullable
)

students (
    id              BIGSERIAL PRIMARY KEY,
    student_number  VARCHAR UNIQUE NOT NULL,
    first_name      VARCHAR NOT NULL,
    last_name       VARCHAR NOT NULL,
    email           VARCHAR UNIQUE NOT NULL,
    department_id   BIGINT NOT NULL REFERENCES departments(id)
)

student_profiles (
    id                   BIGSERIAL PRIMARY KEY,
    date_of_birth        DATE NOT NULL,
    gender               VARCHAR NOT NULL,
    phone_number         VARCHAR,
    residential_address  VARCHAR NOT NULL,
    student_id           BIGINT UNIQUE NOT NULL REFERENCES students(id)
)

lecturers (
    id             BIGSERIAL PRIMARY KEY,
    staff_number   VARCHAR UNIQUE NOT NULL,
    first_name     VARCHAR NOT NULL,
    last_name      VARCHAR NOT NULL,
    email          VARCHAR UNIQUE NOT NULL,
    department_id  BIGINT NOT NULL REFERENCES departments(id)
)

courses (
    id             BIGSERIAL PRIMARY KEY,
    course_code    VARCHAR UNIQUE NOT NULL,
    title          VARCHAR NOT NULL,
    credit_hours   INTEGER NOT NULL,
    department_id  BIGINT NOT NULL REFERENCES departments(id)
)

course_lecturer (
    lecturer_id  BIGINT NOT NULL REFERENCES lecturers(id),
    course_id    BIGINT NOT NULL REFERENCES courses(id),
    PRIMARY KEY (lecturer_id, course_id)
)

registrations (
    id                 BIGSERIAL PRIMARY KEY,
    registration_date  DATE NOT NULL,
    academic_year      VARCHAR NOT NULL,
    semester           VARCHAR NOT NULL,
    status             VARCHAR NOT NULL,      -- PENDING | APPROVED | REJECTED
    grade              NUMERIC(5,2),          -- nullable until a grade is awarded
    student_id         BIGINT NOT NULL REFERENCES students(id),
    course_id          BIGINT NOT NULL REFERENCES courses(id),
    UNIQUE (student_id, course_id, academic_year, semester)
)
9. Why These Entities and Relationships Were Selected

The design follows the problem statement closely.

Department is the main academic unit, so it is its own entity. The head lecturer is a one-to-one link back to a lecturer.
Student and Lecturer are separate entities because they play different roles and carry different data.
StudentProfile is separate because the personal information (date of birth, gender, phone, address) is a distinct set of attributes with a strict one-to-one link; keeping it in its own table keeps the student table focused on academic identity.
Course belongs to one department and is taught by lecturers, so it is a standalone entity.
Lecturer to Course is a pure many-to-many. The assignment states it must be maintained without a separate entity, so a @JoinTable is used.
Registration is a join entity rather than a join table because the student-course link must store registration date, academic year, semester, status and grade. It uses two @ManyToOne relationships, one to Student and one to Course.
A unique constraint on (student_id, course_id, academic_year, semester) prevents a student from registering twice for the same course in the same period, while still allowing a retake in a later period.
10. Hibernate/JPA Implementation
Annotation mapping
Entity	Field	Annotation
All entities	id	@Id + @GeneratedValue(strategy = GenerationType.IDENTITY)
Department	headLecturer	@OneToOne + @JoinColumn(name = "head_lecturer_id")
Department	students, lecturers, courses	@OneToMany(mappedBy = "department")
Student	department	@ManyToOne + @JoinColumn(name = "department_id")
Student	profile	@OneToOne(mappedBy = "student", cascade = CascadeType.ALL)
Student	registrations	@OneToMany(mappedBy = "student")
StudentProfile	student	@OneToOne + @JoinColumn(name = "student_id", unique = true)
StudentProfile	gender	@Enumerated(EnumType.STRING)
Lecturer	department	@ManyToOne + @JoinColumn(name = "department_id")
Lecturer	courses	@ManyToMany + @JoinTable(name = "course_lecturer", joinColumns = @JoinColumn(name = "lecturer_id"), inverseJoinColumns = @JoinColumn(name = "course_id"))
Course	department	@ManyToOne + @JoinColumn(name = "department_id")
Course	lecturers	@ManyToMany(mappedBy = "courses")
Course	registrations	@OneToMany(mappedBy = "course")
Registration	student	@ManyToOne + @JoinColumn(name = "student_id")
Registration	course	@ManyToOne + @JoinColumn(name = "course_id")
Registration	status	@Enumerated(EnumType.STRING)

Lecturer is the owning side of the many-to-many relationship; Course is the inverse side.

Data types
Attribute type	Java type
Identifiers	Long
Names, codes, email, phone, address	String
Date of birth, registration date	LocalDate
Credit hours	Integer
Grade	Double or BigDecimal (nullable)
Gender, status	Enums stored as STRING
Repositories

Each entity has a Spring Data repository extending JpaRepository<Entity, Long>:

DepartmentRepository, StudentRepository, StudentProfileRepository, LecturerRepository, CourseRepository, RegistrationRepository.

No repository is created for course_lecturer because it is a join table, not an entity.

11. Local Setup and Configuration
Prerequisites
Java 17 or later
Maven 3.8+
PostgreSQL installed and running
Git
1. Clone the repository
bash
git clone <your-repository-url>
cd university-academic-system
2. Create the database
sql
CREATE DATABASE university_academic_db;
3. Configure the connection

src/main/resources/application.properties:

properties
spring.application.name=university-academic-system

spring.datasource.url=jdbc:postgresql://localhost:5432/university_academic_db
spring.datasource.username=postgres
spring.datasource.password=${DB_PASSWORD}
spring.datasource.driver-class-name=org.postgresql.Driver

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect

Make sure spring.datasource.username matches your PostgreSQL user. With ddl-auto=update, Hibernate creates or updates the tables when the application starts.

4. Set the database password

The password is read from the DB_PASSWORD environment variable. Do not commit passwords to the repository.

PowerShell (current session):

powershell
$env:DB_PASSWORD = "your-database-password"

macOS / Linux:

bash
export DB_PASSWORD="your-database-password"
12. Running and Testing the Project

Run the tests:

bash
mvn test

Start the application (PostgreSQL must be running):

bash
mvn spring-boot:run

On startup, Hibernate logs the create table and alter table ... add constraint statements. This confirms that the entity mappings, primary keys, foreign keys and the join table were generated successfully.

13. Verifying the Database in PostgreSQL

Connect with psql, pgAdmin or the VS Code PostgreSQL extension, then run:

sql
-- List all generated tables
\dt

-- Inspect each table, including its keys and constraints
\d departments
\d students
\d student_profiles
\d lecturers
\d courses
\d course_lecturer
\d registrations

List every foreign key relationship:

sql
SELECT conrelid::regclass AS table_name,
       conname            AS constraint_name,
       pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE contype = 'f'
ORDER BY conrelid::regclass::text;

Expected result: seven tables (departments, students, student_profiles, lecturers, courses, course_lecturer, registrations) and the foreign keys listed in Section 6.

14. Screenshots

Replace these with your own screenshots stored in the screenshots/ folder.

Description	Screenshot
Application started successfully and Hibernate generated the tables	Startup
All tables created in university_academic_db	Tables
Foreign key relationships	Foreign keys
course_lecturer join table with composite primary key	Join table
15. Submission Checklist
[x] Problem analysis and identified entities (Sections 3 to 4)
[x] Relationships and cardinality (Section 5)
[x] Foreign keys, join table and join entity (Section 6)
[x] Entity Relationship Diagram (Section 7)
[x] Relational database schema (Section 8)
[x] Complete Spring Boot project source code (src/)
[ ] PostgreSQL database generated and verified (Section 13)
[ ] Screenshots added (Section 14)
[ ] Repository is public or shared with the lecturer
[ ] Repository link submitted before Monday, 16 November 2026, 6:00 PM

This structure covers the model and repository stage of the assignment and can be extended later with service and controller layers.
