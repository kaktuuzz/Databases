CREATE DATABASE advanced_lab;

-- 1. Create tables with proper data types, primary keys, and defaults
CREATE TABLE IF NOT EXISTS departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    budget INTEGER,
    manager_id INTEGER
);

CREATE TABLE IF NOT EXISTS employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    department VARCHAR(100),
    salary INTEGER,
    hire_date DATE,
    status VARCHAR(50) DEFAULT 'Active'
);

CREATE TABLE IF NOT EXISTS projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id),
    start_date DATE,
    end_date DATE,
    budget INTEGER
);

-- INSERT with column specification
INSERT INTO departments (dept_name, budget, manager_id) VALUES
('IT', 120000, 1),
('Sales', 95000, 2),
('HR', 80000, 3);

INSERT INTO employees (first_name, last_name, department, salary, hire_date, status) VALUES
('Alice', 'Smith', 'IT', 75000, '2018-05-15', 'Active'),
('Bob', 'Johnson', 'Sales', 55000, '2021-03-10', 'Active'),
('Charlie', 'Brown', 'HR', 45000, '2023-06-20', 'Active'),
('Diana', 'Prince', 'IT', 85000, '2019-11-01', 'Inactive'),
('Eve', 'Davis', 'Sales', 38000, '2023-02-15', 'Terminated');



-- 2. INSERT with column specification (inserting only specific columns)
INSERT INTO employees (emp_id, first_name, last_name, department)
OVERRIDING SYSTEM VALUE
VALUES (100, 'Frank', 'Castle', 'Security');

-- 3. INSERT with DEFAULT values for salary and status
INSERT INTO employees (first_name, last_name, department, salary, hire_date, status)
VALUES ('Grace', 'Hopper', 'IT', DEFAULT, '2022-01-10', DEFAULT);

-- 4. INSERT multiple rows in a single statement
INSERT INTO departments (dept_name, budget, manager_id) VALUES
('Marketing', 110000, 4),
('Finance', 150000, 5),
('R&D', 200000, 6);

-- 5. INSERT with expressions 
INSERT INTO employees (first_name, last_name, department, salary, hire_date, status)
VALUES ('Hank', 'Pym', 'R&D', 50000 * 1.1, CURRENT_DATE, DEFAULT);

-- 6. INSERT from SELECT (subquery)
CREATE TEMP TABLE temp_employees AS
SELECT * FROM employees
WHERE department = 'IT';

-- 7. UPDATE with arithmetic expressions 
UPDATE employees
SET salary = salary * 1.10;

-- 8. UPDATE with WHERE clause and multiple conditions
UPDATE employees
SET status = 'Senior'
WHERE salary > 60000 AND hire_date < '2020-01-01';

-- 9. UPDATE using CASE expression 
UPDATE employees
SET department = CASE 
    WHEN salary > 80000 THEN 'Management'
    WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
    ELSE 'Junior'
END;

-- 10. UPDATE with DEFAULT 
UPDATE employees
SET department = DEFAULT
WHERE status = 'Inactive';

-- 11. UPDATE with subquery 
UPDATE departments d
SET budget = (
    SELECT ROUND(AVG(e.salary) * 1.20)
    FROM employees e
    WHERE e.department = d.dept_name
)
WHERE dept_name IN (SELECT DISTINCT department FROM employees WHERE department IS NOT NULL);

-- 12. UPDATE multiple columns
UPDATE employees
SET salary = salary * 1.15, 
    status = 'Promoted'
WHERE department = 'Sales';

-- 13. DELETE with simple WHERE condition 
DELETE FROM employees
WHERE status = 'Terminated';

-- 14. DELETE with complex WHERE clause
DELETE FROM employees
WHERE salary < 40000 AND hire_date > '2023-01-01' AND department IS NULL;

-- 15. DELETE with subquery 
DELETE FROM departments
WHERE dept_name NOT IN (
    SELECT DISTINCT department 
    FROM employees 
    WHERE department IS NOT NULL
);

-- 16. DELETE with RETURNING clause 
DELETE FROM projects
WHERE end_date < '2023-01-01'
RETURNING *;

-- 17. INSERT with explicit NULL values
INSERT INTO employees (first_name, last_name, department, salary, hire_date, status)
VALUES ('Ian', 'Malcolm', NULL, NULL, '2023-09-01', 'Active');

-- 18. UPDATE NULL handling 
UPDATE employees
SET department = 'Unassigned'
WHERE department IS NULL;

-- 19. DELETE with NULL conditions 
DELETE FROM employees
WHERE salary IS NULL OR department IS NULL;

-- 20. INSERT with RETURNING
INSERT INTO employees (first_name, last_name, department, salary, hire_date, status)
VALUES ('Jack', 'Reacher', 'Security', 70000, '2023-10-01', 'Active')
RETURNING emp_id, (first_name || ' ' || last_name) AS full_name;

-- 21. UPDATE with RETURNING 
UPDATE employees
SET salary = salary + 5000
WHERE department = 'IT'
RETURNING emp_id, (salary - 5000) AS old_salary, salary AS new_salary;

-- 22. DELETE with RETURNING all columns 
DELETE FROM employees
WHERE hire_date < '2020-01-01'
RETURNING *;

-- 23. Conditional INSERT 
INSERT INTO employees (first_name, last_name, department, salary, hire_date, status)
SELECT 'Alice', 'Smith', 'IT', 80000, '2022-05-15', 'Active'
WHERE NOT EXISTS (
    SELECT 1 FROM employees 
    WHERE first_name = 'Alice' AND last_name = 'Smith'
);

-- 24. UPDATE with JOIN logic using subqueries
UPDATE employees e
SET salary = salary * CASE 
    WHEN d.budget > 100000 THEN 1.10 
    ELSE 1.05 
END
FROM departments d
WHERE e.department = d.dept_name;

-- 25. Bulk operations 
INSERT INTO employees (first_name, last_name, department, salary, hire_date, status) VALUES
('User1', 'Test', 'HR', 50000, CURRENT_DATE, 'Active'),
('User2', 'Test', 'HR', 52000, CURRENT_DATE, 'Active'),
('User3', 'Test', 'HR', 54000, CURRENT_DATE, 'Active'),
('User4', 'Test', 'HR', 56000, CURRENT_DATE, 'Active'),
('User5', 'Test', 'HR', 58000, CURRENT_DATE, 'Active');

UPDATE employees
SET salary = salary * 1.10
WHERE last_name = 'Test';

-- 26. Data migration simulation 
CREATE TABLE IF NOT EXISTS employee_archive (LIKE employees INCLUDING ALL);

INSERT INTO employee_archive
SELECT * FROM employees
WHERE status = 'Inactive';

DELETE FROM employees
WHERE status = 'Inactive';

-- 27. Complex business logic 
UPDATE projects p
SET end_date = end_date + INTERVAL '30 days'
WHERE p.budget > 50000 
  AND p.dept_id IN (
      SELECT dept_id 
      FROM employees e
      JOIN departments d ON e.department = d.dept_name
      GROUP BY dept_id
      HAVING COUNT(*) > 3
  );
  