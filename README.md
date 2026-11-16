# University Course Registration and Academic Management System




	
Student Name	IGIRANEZA Diane





Registration No.	27895





Course	Web Technology and Internet





Date:16 November 2026






Scope	Model and Repository layers




## 1. Problem analysis and identified entities

The assignment requires the design of a data model for a university academic system. The main actors and business objects in the problem statement are:

1. Department
   - A department runs academic activities, offers courses, and employs lecturers.
   - Each department has a head lecturer.
   - Each department can have many students and many courses.

2. Student
   - A student belongs to exactly one department.
   - A student has one personal profile.
   - A student can register for many courses in multiple academic periods.

3. StudentProfile
   - Stores the student’s date of birth, gender, phone number, and residential address.
   - This is a one-to-one profile attached to a single student.

4. Lecturer
   - A lecturer is employed by a department.
   - A lecturer can teach multiple courses.
   - A course can be taught by multiple lecturers.
   - The many-to-many relationship between lecturers and courses is handled using a join table and not by creating a separate entity.

5. Course
   - A course belongs to one department.
   - A course can be taught by several lecturers.
   - A course can be enrolled in by many students.

6. Registration
   - Represents the student-course relationship.
   - It stores additional data that cannot fit in the relationship alone: registration date, academic year, semester, status, and grade.
   - This is the join entity needed for the student-course relationship.

## 2. Identified attributes

### Department
- id
- name
- location
- headLecturer

### Student
- id
- studentNumber
- firstName
- lastName
- email
- department

### StudentProfile
- id
- dateOfBirth
- gender
- phoneNumber
- residentialAddress
- student

### Lecturer
- id
- staffNumber
- firstName
- lastName
- email
- department
- courses

### Course
- id
- courseCode
- title
- creditHours
- department
- lecturers

### Registration
- id
- registrationDate
- academicYear
- semester
- status
- grade
- student
- course

## 3. Relationship analysis and cardinality

| Relationship | Cardinality | Why |
|---|---|---|
| Department to Lecturer | One-to-many | One department employs many lecturers, while each lecturer belongs to one department. |
| Department to Course | One-to-many | One department offers many courses, and each course belongs to one department. |
| Department to Head Lecturer | One-to-one | Each department has exactly one head lecturer. |
| Student to StudentProfile | One-to-one | Each student has exactly one profile and each profile belongs to exactly one student. |
| Student to Department | Many-to-one | Many students are assigned to one department. |
| Lecturer to Course | Many-to-many | A lecturer can teach several courses, and a course can be taught by several lecturers. |
| Student to Course via Registration | Many-to-many with extra attributes | Students can register for many courses, and a course can be taken by many students. The extra registration details require a join entity. |
| Registration to Student | Many-to-one | Many registration records belong to the same student. |
| Registration to Course | Many-to-one | Many registration records belong to the same course. |

## 4. Foreign keys and join tables

### Foreign keys required
- departments.head_lecturer_id -> lecturers.id
- students.department_id -> departments.id
- student_profiles.student_id -> students.id
- lecturers.department_id -> departments.id
- courses.department_id -> departments.id
- registrations.student_id -> students.id
- registrations.course_id -> courses.id

### Join table required
- course_lecturer
  - This resolves the many-to-many association between Lecturer and Course.
  - It contains only the two foreign keys: lecturer_id and course_id.

### Join entity required
- registrations
  - This is required because the student-course relationship contains attributes beyond simple membership.
  - The extra attributes are registrationDate, academicYear, semester, status, and grade.

## 5. Entity Relationship Diagram (ERD)

```text
+-------------------+        1      +-------------------+
| DEPARTMENT        |<----------------| LECTURER          |
|-------------------|                |-------------------|
| id                |                | id                |
| name              |                | staffNumber       |
| location          |                | firstName         |
| head_lecturer_id  |                | lastName          |
+-------------------+                | email             |
     |                               | department_id     |
     | 1                             +-------------------+
     |                               |
     |                               | N
     |                               |
     |                            teaches
     |                               |
     v                               v
+-------------------+       N       +-------------------+
| COURSE            |<-------------->| LECTURER          |
|-------------------|                |                   |
| id                |                |                   |
| courseCode        |                |                   |
| title             |                |                   |
| creditHours       |                |                   |
| department_id     |                |                   |
+-------------------+                +-------------------+
      ^
      |
      | 1
      |
+-------------------+
| STUDENT           |
|-------------------|
| id                |
| studentNumber     |
| firstName         |
| lastName          |
| email             |
| department_id     |
+-------------------+
      |
      | 1
      v
+-------------------+
| STUDENT_PROFILE   |
|-------------------|
| id                |
| dateOfBirth       |
| gender            |
| phoneNumber       |
| residentialAddress |
| student_id        |
+-------------------+

STUDENT <----> COURSE through REGISTRATION

REGISTRATION
- id
- registrationDate
- academicYear
- semester
- status
- grade
- student_id
- course_id
```

## 6. Relational database schema

```sql
departments (
    id PK,
    name UNIQUE NOT NULL,
    location NOT NULL,
    head_lecturer_id FK -> lecturers.id
)

students (
    id PK,
    student_number UNIQUE NOT NULL,
    first_name NOT NULL,
    last_name NOT NULL,
    email UNIQUE NOT NULL,
    department_id FK -> departments.id
)

student_profiles (
    id PK,
    date_of_birth NOT NULL,
    gender NOT NULL,
    phone_number,
    residential_address NOT NULL,
    student_id UNIQUE FK -> students.id
)

lecturers (
    id PK,
    staff_number UNIQUE NOT NULL,
    first_name NOT NULL,
    last_name NOT NULL,
    email UNIQUE NOT NULL,
    department_id FK -> departments.id
)

courses (
    id PK,
    course_code UNIQUE NOT NULL,
    title NOT NULL,
    credit_hours NOT NULL,
    department_id FK -> departments.id
)

course_lecturer (
    lecturer_id PK/FK -> lecturers.id,
    course_id PK/FK -> courses.id
)

registrations (
    id PK,
    registration_date NOT NULL,
    academic_year NOT NULL,
    semester NOT NULL,
    status NOT NULL,
    grade,
    student_id FK -> students.id,
    course_id FK -> courses.id,
    UNIQUE(student_id, course_id, academic_year, semester)
)
```

## 7. Why these entities and relationships were selected

The design follows the problem statement closely. A department is the main academic unit and therefore a logical entity. Students and lecturers are separate actors because they have different roles and data. A profile is modeled as a separate entity because the student’s personal information is a distinct set of mandatory attributes and should be stored in a dedicated table. Courses belong to departments and are taught by lecturers, so they are modeled as standalone entities. The student-course relationship is not a simple many-to-many without extra fields; the assignment explicitly requires storing registration date, academic year, semester, status, and grade. That is why Registration is implemented as a join entity rather than a lightweight join table. The Course-Lecturer relationship remains a pure many-to-many because the requirement states that no separate entity is needed for it.

## 8. Project structure

This project implements the model and repository layers in Spring Boot with Hibernate and PostgreSQL.

```text
university-academic-system/
├── schema.sql
├── pom.xml
├── README.md
├── src/
│   ├── main/
│   │   ├── java/com/example/universityacademicsystem/
│   │   │   ├── UniversityAcademicSystemApplication.java
│   │   │   ├── model/
│   │   │   │   ├── Course.java
│   │   │   │   ├── Department.java
│   │   │   │   ├── Gender.java
│   │   │   │   ├── Lecturer.java
│   │   │   │   ├── Registration.java
│   │   │   │   ├── RegistrationStatus.java
│   │   │   │   ├── Student.java
│   │   │   │   └── StudentProfile.java
│   │   │   └── repository/
│   │   │       ├── CourseRepository.java
│   │   │       ├── DepartmentRepository.java
│   │   │       ├── LecturerRepository.java
│   │   │       ├── RegistrationRepository.java
│   │   │       ├── StudentProfileRepository.java
│   │   │       └── StudentRepository.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
│       ├── java/com/example/universityacademicsystem/
│       │   └── UniversityAcademicSystemApplicationTests.java
│       └── resources/
│           └── application.properties
```

## 9. Local database setup

Use a local PostgreSQL instance. Create the database manually:

```sql
CREATE DATABASE university_academic_db;
```

Ensure the database username in `src/main/resources/application.properties` matches your PostgreSQL user. Hibernate creates or updates the tables when the application starts.

Set the `DB_PASSWORD` environment variable to the password for the configured database user before starting the application. In PowerShell, for the current terminal session, run:

```powershell
$env:DB_PASSWORD = "your-database-password"
```

Do not commit database passwords to the repository.

## 10. Run the project

```bash
mvn test
```

If the PostgreSQL service is available, the application can then be started with:

```bash
mvn spring-boot:run
```



This structure is suitable for the model and repository stage of the assignment and can be extended later with service and controller layers if required.
