USE galaxy_cinema;

-- Without creating INDEX
CREATE INDEX idx_customer_name ON customers(customer_name);
-- ALTER TABLE customers ADD INDEX idx_customer_name (customer_name);

SELECT * FROM customers;

SELECT * FROM customers WHERE customer_name = 'Jayden';

-- ALTER TABLE customers DROP INDEX idx_customer_name;