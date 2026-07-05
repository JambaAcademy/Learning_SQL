-- =============================================================================
-- END-OF-BOOK CUMULATIVE CAPSTONE CHALLENGE
-- The Science of Learning SQL: An Evidence-Based, Step-by-Step Guide to
-- Mastering Databases, Queries, Joins, and Real-World Data Analysis for
-- Complete Beginners
--
-- PURPOSE:
--   This capstone challenge tests every major concept introduced across all
--   eight chapters of the book. Each section is clearly labelled with the
--   chapter(s) it draws from. Work through the exercises in order because,
--   just as the book explains, progressive skill layering means each new
--   challenge rests on the foundation you built in the previous one.
--
-- HOW TO USE THIS SCRIPT:
--   1. Run the SETUP section first to create and populate all tables.
--   2. Attempt each challenge query on your own BEFORE reading the solution.
--   3. Compare your output to the expected results described in the comments.
--   4. Revisit any section where your output differs and use the error message
--      as diagnostic feedback, not as a failure signal.
--
-- DATABASE CONTEXT:
--   A fictional online learning platform called LearnBridge. It tracks
--   students, courses, instructors, enrollments, and quiz scores. This
--   mirrors the kind of real-world relational data the book prepares you
--   to analyse professionally.
-- =============================================================================


-- =============================================================================
-- SETUP: CREATE AND POPULATE THE LEARNBRIDGE DATABASE SCHEMA
-- Chapters 2 and 3 — Relational architecture, primary keys, foreign keys,
-- and the table-row-column structure that every SELECT statement operates on.
-- =============================================================================

-- Drop tables if they already exist so the script is safely re-runnable.
-- The order matters: child tables (those with foreign keys) must be dropped
-- before the parent tables they reference.

DROP TABLE IF EXISTS quiz_scores;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS instructors;

-- -----------------------------------------------------------------------
-- TABLE: instructors
-- Each row is one instructor. instructor_id is the primary key — the
-- unique, permanent address the book describes in Chapter 2.
-- -----------------------------------------------------------------------

CREATE TABLE instructors (
    instructor_id   INTEGER     PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    department      VARCHAR(80) NOT NULL,
    hire_date       DATE        NOT NULL,
    active          BOOLEAN     NOT NULL DEFAULT TRUE
);

INSERT INTO instructors (instructor_id, first_name, last_name, department, hire_date, active) VALUES
(1,  'Amara',   'Osei',       'Data Science',          '2018-03-12', TRUE),
(2,  'Dmitri',  'Volkov',     'Software Engineering',  '2019-07-01', TRUE),
(3,  'Priya',   'Nair',       'Data Science',          '2020-01-15', TRUE),
(4,  'Carlos',  'Mendez',     'Business Analytics',    '2017-11-20', TRUE),
(5,  'Yuki',    'Tanaka',     'Software Engineering',  '2021-05-08', TRUE),
(6,  'Fatima',  'Al-Hassan',  'Data Science',          '2016-09-30', FALSE),
(7,  'Lena',    'Brandt',     'Business Analytics',    '2022-02-14', TRUE),
(8,  'Marcus',  'Webb',       'Software Engineering',  '2015-06-03', FALSE);

-- -----------------------------------------------------------------------
-- TABLE: students
-- Each row is one student. Notice country and signup_date columns —
-- these will be used for range-based and text-based filtering in
-- Chapter 4 challenges below.
-- -----------------------------------------------------------------------

CREATE TABLE students (
    student_id      INTEGER      PRIMARY KEY,
    first_name      VARCHAR(50)  NOT NULL,
    last_name       VARCHAR(50)  NOT NULL,
    email           VARCHAR(120) NOT NULL UNIQUE,
    country         VARCHAR(60)  NOT NULL,
    signup_date     DATE         NOT NULL,
    membership_tier VARCHAR(20)  NOT NULL DEFAULT 'free'
);

INSERT INTO students (student_id, first_name, last_name, email, country, signup_date, membership_tier) VALUES
(101, 'Sofia',    'Andersen',  'sofia.a@mail.com',    'Denmark',      '2022-01-10', 'premium'),
(102, 'James',    'Okafor',    'james.o@mail.com',    'Nigeria',      '2022-03-22', 'free'),
(103, 'Mei',      'Lin',       'mei.l@mail.com',      'China',        '2021-11-05', 'premium'),
(104, 'Arjun',    'Sharma',    'arjun.s@mail.com',    'India',        '2023-02-18', 'free'),
(105, 'Hannah',   'Mueller',   'hannah.m@mail.com',   'Germany',      '2022-07-30', 'premium'),
(106, 'Tobias',   'Eriksson',  'tobias.e@mail.com',   'Sweden',       '2021-09-14', 'free'),
(107, 'Aisha',    'Diallo',    'aisha.d@mail.com',    'Senegal',      '2023-05-01', 'premium'),
(108, 'Lucas',    'Ferreira',  'lucas.f@mail.com',    'Brazil',       '2022-12-19', 'free'),
(109, 'Nadia',    'Kowalski',  'nadia.k@mail.com',    'Poland',       '2021-06-08', 'premium'),
(110, 'Ben',      'Tran',      'ben.t@mail.com',      'Vietnam',      '2023-08-25', 'free'),
(111, 'Chiara',   'Romano',    'chiara.r@mail.com',   'Italy',        '2022-04-11', 'premium'),
(112, 'Omar',     'Hassan',    'omar.h@mail.com',     'Egypt',        '2021-12-03', 'free'),
(113, 'Ingrid',   'Larsen',    'ingrid.l@mail.com',   'Norway',       '2023-01-29', 'premium'),
(114, 'Kwame',    'Asante',    'kwame.a@mail.com',    'Ghana',        '2022-09-17', 'free'),
(115, 'Elena',    'Popescu',   'elena.p@mail.com',    'Romania',      '2021-07-22', 'free');

-- -----------------------------------------------------------------------
-- TABLE: courses
-- Each row is one course. price and duration_hours will be used for
-- aggregate function challenges. instructor_id is a foreign key linking
-- back to the instructors table — the cross-table relationship described
-- in Chapter 2.
-- -----------------------------------------------------------------------

CREATE TABLE courses (
    course_id       INTEGER      PRIMARY KEY,
    title           VARCHAR(120) NOT NULL,
    category        VARCHAR(60)  NOT NULL,
    instructor_id   INTEGER      NOT NULL REFERENCES instructors(instructor_id),
    price           DECIMAL(8,2) NOT NULL,
    duration_hours  INTEGER      NOT NULL,
    published_date  DATE         NOT NULL,
    difficulty      VARCHAR(20)  NOT NULL
);

INSERT INTO courses (course_id, title, category, instructor_id, price, duration_hours, published_date, difficulty) VALUES
(201, 'SQL Foundations',                    'Data',        1, 49.99,  18, '2022-01-05', 'beginner'),
(202, 'Python for Data Analysis',           'Data',        3, 79.99,  32, '2022-03-10', 'intermediate'),
(203, 'Business Intelligence Dashboards',   'Business',    4, 59.99,  24, '2021-11-20', 'intermediate'),
(204, 'Advanced SQL and Query Optimisation','Data',        1, 99.99,  40, '2022-08-15', 'advanced'),
(205, 'Introduction to Machine Learning',  'Data',        3, 89.99,  36, '2023-01-12', 'intermediate'),
(206, 'Web Development Bootcamp',           'Engineering', 2, 119.99, 60, '2021-06-01', 'beginner'),
(207, 'Data Visualisation with Tableau',   'Business',    4, 54.99,  20, '2022-05-18', 'beginner'),
(208, 'Cloud Architecture Fundamentals',   'Engineering', 5, 74.99,  28, '2023-03-22', 'intermediate'),
(209, 'Statistics for Data Science',       'Data',        1, 44.99,  22, '2021-09-09', 'beginner'),
(210, 'Agile Project Management',          'Business',    7, 39.99,  16, '2023-07-04', 'beginner'),
(211, 'Deep Learning Specialisation',      'Data',        3, 129.99, 55, '2022-10-30', 'advanced'),
(212, 'DevOps Essentials',                 'Engineering', 2, 69.99,  30, '2022-02-14', 'intermediate');

-- -----------------------------------------------------------------------
-- TABLE: enrollments
-- Each row records one student enrolling in one course. This is a
-- classic junction table — it resolves the many-to-many relationship
-- between students and courses using two foreign keys, exactly as
-- Chapter 2 describes relational design.
-- -----------------------------------------------------------------------

CREATE TABLE enrollments (
    enrollment_id   INTEGER      PRIMARY KEY,
    student_id      INTEGER      NOT NULL REFERENCES students(student_id),
    course_id       INTEGER      NOT NULL REFERENCES courses(course_id),
