CREATE TABLE departments (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100) NOT NULL,
    head_lecturer_id BIGINT UNIQUE
);

CREATE TABLE students (
    id BIGSERIAL PRIMARY KEY,
    student_number VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    department_id BIGINT NOT NULL
);

CREATE TABLE student_profiles (
    id BIGSERIAL PRIMARY KEY,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10) NOT NULL,
    phone_number VARCHAR(15),
    residential_address VARCHAR(255) NOT NULL,
    student_id BIGINT NOT NULL UNIQUE
);

CREATE TABLE lecturers (
    id BIGSERIAL PRIMARY KEY,
    staff_number VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    department_id BIGINT NOT NULL
);

CREATE TABLE courses (
    id BIGSERIAL PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    title VARCHAR(100) NOT NULL,
    credit_hours INTEGER NOT NULL,
    department_id BIGINT NOT NULL
);

CREATE TABLE course_lecturer (
    lecturer_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    PRIMARY KEY (lecturer_id, course_id)
);

CREATE TABLE registrations (
    id BIGSERIAL PRIMARY KEY,
    registration_date DATE NOT NULL,
    academic_year VARCHAR(9) NOT NULL,
    semester VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL,
    grade VARCHAR(5),
    student_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    CONSTRAINT uq_student_course_year_semester UNIQUE (student_id, course_id, academic_year, semester)
);

ALTER TABLE departments
    ADD CONSTRAINT fk_department_head_lecturer
    FOREIGN KEY (head_lecturer_id) REFERENCES lecturers (id);

ALTER TABLE students
    ADD CONSTRAINT fk_student_department
    FOREIGN KEY (department_id) REFERENCES departments (id);

ALTER TABLE student_profiles
    ADD CONSTRAINT fk_profile_student
    FOREIGN KEY (student_id) REFERENCES students (id);

ALTER TABLE lecturers
    ADD CONSTRAINT fk_lecturer_department
    FOREIGN KEY (department_id) REFERENCES departments (id);

ALTER TABLE courses
    ADD CONSTRAINT fk_course_department
    FOREIGN KEY (department_id) REFERENCES departments (id);

ALTER TABLE course_lecturer
    ADD CONSTRAINT fk_course_lecturer_lecturer
    FOREIGN KEY (lecturer_id) REFERENCES lecturers (id),
    ADD CONSTRAINT fk_course_lecturer_course
    FOREIGN KEY (course_id) REFERENCES courses (id);

ALTER TABLE registrations
    ADD CONSTRAINT fk_registration_student
    FOREIGN KEY (student_id) REFERENCES students (id),
    ADD CONSTRAINT fk_registration_course
    FOREIGN KEY (course_id) REFERENCES courses (id);
