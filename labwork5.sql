
-- Task 1.1: Age must be 18..65; salary must be greater than 0.
CREATE TABLE employees (
    employee_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    age INTEGER,
    salary NUMERIC,
    CONSTRAINT employees_age_check CHECK (age BETWEEN 18 AND 65),
    CONSTRAINT employees_salary_check CHECK (salary > 0)
);

INSERT INTO employees VALUES
(1, 'Anna', 'Brown', 25, 350000),
(2, 'David', 'Smith', 42, 520000);

-- Expected failures:
-- Violates employees_age_check: age is below 18.
-- INSERT INTO employees VALUES (3, 'Tom', 'Green', 16, 200000);
-- Violates employees_age_check: age is above 65.
-- INSERT INTO employees VALUES (4, 'Mary', 'White', 70, 300000);
-- Violates employees_salary_check: salary must be > 0.
-- INSERT INTO employees VALUES (5, 'Sam', 'Black', 30, 0);

-- Task 1.2: Named CHECK constraint for prices and discount.
CREATE TABLE products_catalog (
    product_id INTEGER,
    product_name TEXT,
    regular_price NUMERIC,
    discount_price NUMERIC,
    CONSTRAINT valid_discount CHECK (
        regular_price > 0
        AND discount_price > 0
        AND discount_price < regular_price
    )
);

INSERT INTO products_catalog VALUES
(1, 'Keyboard', 25000, 20000),
(2, 'Mouse', 12000, 9500);

-- Each statement violates valid_discount:
-- regular_price is not greater than 0.
-- INSERT INTO products_catalog VALUES (3, 'Bad product A', 0, 5);
-- discount_price is not greater than 0.
-- INSERT INTO products_catalog VALUES (4, 'Bad product B', 100, 0);
-- discount_price is not less than regular_price.
-- INSERT INTO products_catalog VALUES (5, 'Bad product C', 100, 120);

-- Task 1.3: Guest count and date ordering.
CREATE TABLE bookings (
    booking_id INTEGER,
    check_in_date DATE,
    check_out_date DATE,
    num_guests INTEGER,
    CONSTRAINT bookings_guest_count_check CHECK (num_guests BETWEEN 1 AND 10),
    CONSTRAINT bookings_dates_check CHECK (check_out_date > check_in_date)
);

INSERT INTO bookings VALUES
(1, DATE '2026-11-01', DATE '2026-11-05', 2),
(2, DATE '2026-12-10', DATE '2026-12-12', 5);

-- Violates bookings_guest_count_check: 0 is outside 1..10.
-- INSERT INTO bookings VALUES (3, DATE '2026-11-01', DATE '2026-11-02', 0);
-- Violates bookings_guest_count_check: 11 is outside 1..10.
-- INSERT INTO bookings VALUES (4, DATE '2026-11-01', DATE '2026-11-02', 11);
-- Violates bookings_dates_check: checkout is not after check-in.
-- INSERT INTO bookings VALUES (5, DATE '2026-11-05', DATE '2026-11-04', 2);

-- Task 1.4: Review valid data and the commented invalid examples.
SELECT * FROM employees;
SELECT * FROM products_catalog;
SELECT * FROM bookings;

-- Task 2.1: customer_id, email, registration_date are NOT NULL.
-- Named customers_basic to avoid conflict with Part 6 customers.
CREATE TABLE customers_basic (
    customer_id INTEGER NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);

INSERT INTO customers_basic VALUES
(1, 'alice@example.com', '+7-700-111-2233', DATE '2026-01-10'),
(2, 'bob@example.com', NULL, DATE '2026-02-15');

-- Expected failures: NOT NULL columns cannot contain NULL.
-- INSERT INTO customers_basic VALUES (NULL, 'bad@example.com', NULL, DATE '2026-03-01');
-- INSERT INTO customers_basic VALUES (3, NULL, NULL, DATE '2026-03-01');
-- INSERT INTO customers_basic VALUES (4, 'bad-date@example.com', NULL, NULL);
-- Valid: phone is nullable.
INSERT INTO customers_basic VALUES
(5, 'charlie@example.com', NULL, DATE '2026-03-20');

-- Task 2.2: NOT NULL plus CHECK constraints.
CREATE TABLE inventory (
    item_id INTEGER NOT NULL,
    item_name TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price > 0),
    last_updated TIMESTAMP NOT NULL
);

INSERT INTO inventory VALUES
(1, 'Notebook', 100, 750.00, TIMESTAMP '2026-10-01 10:00:00'),
(2, 'Pen', 250, 120.00, TIMESTAMP '2026-10-02 11:30:00');

-- Expected failures:
-- NOT NULL violation: item_id.
-- INSERT INTO inventory VALUES (NULL, 'Pencil', 10, 50, CURRENT_TIMESTAMP);
-- NOT NULL violation: item_name.
-- INSERT INTO inventory VALUES (3, NULL, 10, 50, CURRENT_TIMESTAMP);
-- NOT NULL violation: quantity.
-- INSERT INTO inventory VALUES (3, 'Pencil', NULL, 50, CURRENT_TIMESTAMP);
-- CHECK violation: quantity must be >= 0.
-- INSERT INTO inventory VALUES (3, 'Pencil', -1, 50, CURRENT_TIMESTAMP);
-- NOT NULL violation: unit_price.
-- INSERT INTO inventory VALUES (3, 'Pencil', 10, NULL, CURRENT_TIMESTAMP);
-- CHECK violation: unit_price must be > 0.
-- INSERT INTO inventory VALUES (3, 'Pencil', 10, 0, CURRENT_TIMESTAMP);
-- NOT NULL violation: last_updated.
-- INSERT INTO inventory VALUES (3, 'Pencil', 10, 50, NULL);

SELECT * FROM customers_basic;
SELECT * FROM inventory;


-- Task 3.1 and 3.3: named UNIQUE constraints on username and email.
CREATE TABLE users (
    user_id INTEGER,
    username TEXT,
    email TEXT,
    created_at TIMESTAMP,
    CONSTRAINT unique_username UNIQUE (username),
    CONSTRAINT unique_email UNIQUE (email)
);

INSERT INTO users VALUES
(1, 'kaktuz_01', 'user1@example.com', TIMESTAMP '2026-01-01 09:00:00'),
(2, 'student_02', 'user2@example.com', TIMESTAMP '2026-01-02 10:00:00'),
(3, 'reader_03', 'user3@example.com', TIMESTAMP '2026-01-03 11:00:00');

-- Expected failures:
-- Violates unique_username: username already exists.