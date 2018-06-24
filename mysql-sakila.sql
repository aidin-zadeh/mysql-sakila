-- list the databases on MySQL server
SHOW DATABASES;

-- Tell MySQL to use sakila.
USE sakila;

SHOW COLUMNS FROM sakila.actor;

-- 1a. Query actor for all the first and last names.
SELECT 
	first_name, last_name
FROM 
	sakila.actor;

-- 1b. Query actor for all fist name and last name displayed in uppercase.
SELECT 
	concat(UPPER(first_name)," " ,UPPER(last_name))
AS 
	full_name
FROM 
	sakila.actor;

-- 2a. Query actor for the actors whose first name are "Joe".
SELECT
	*
FROM
	sakila.actor
WHERE 
	first_name = "Joe";

-- 2b. Query actor for the actors whose last name contains "GEN".
SELECT
	*
FROM
	sakila.actor
WHERE
	last_name
LIKE
	"%GEN%";

-- 2c. Query actor for the actors whose last name contains "LI".
SELECT
	*
FROM
	sakila.actor
WHERE
	last_name
LIKE
	"%LI%"
ORDER BY
	last_name, first_name;

-- 2d. Query country for the countries in ("Afghanista", "Bangladesh", "China")
Select
	*
FROM
	sakila.country
WHERE
	country
in
	("Afghanistan", "Bangladesh", "China");

-- 3a. Add a "middle_name" column to the "actor" table.
ALTER TABLE
	sakila.actor
ADD
	middle_name VARCHAR(30)
AFTER
	first_name;

-- 3b. Modify data type of "middle_name" column "BLOB" in the "actor" table.
ALTER TABLE
	sakila.actor
MODIFY
	middle_name BLOB;

-- 3c. Drop "middle_name" column from the "actor" table.
ALTER TABLE
	actor
DROP
	middle_name;

-- 4a. Query actor for the count last names.
SELECT
	last_name, COUNT(last_name)
AS
	number_of_actors
FROM
	actor
GROUP BY
	last_name;

-- 4b. Query actor for last names shared more than two times.
SELECT
	last_name, COUNT(last_name)
AS
	number_of_actors
FROM
	sakila.actor
GROUP BY
	last_name
HAVING
	number_of_actors > 1;

-- 4c. Update actor by changing first_name of "GROUCHO WILLIAMS" to "HARPO".
UPDATE
	actor
SET
	first_name = "HARPO" 
WHERE
	first_name = "GROUCHO" AND last_name = "WILLIAMS";



-- 4d. Update actor by changing first_name of "HARPO WILLIAMS": 
-- (first_name = "HARPO") ? "GROUCHO" : "MUCHO GROUCHO" 
SELECT
	actor_id
FROM
	actor
WHERE
	first_name = "HARPO";

UPDATE
	actor
SET
	first_name =
		CASE
			WHEN first_name = "HARPO" THEN "GROUCHO"
			ELSE "MUCHO GROUCHO"
		END
WHERE
	actor_id
IN
	(172);

-- 5a. re-create the table "address" in sakila database
SHOW CREATE TABLE sakila.address;


-- 6a. Query staff-address for first_name, last_name and address.
SHOW COLUMNS FROM sakila.address; # show address columns
SHOW COLUMNS FROM sakila.staff; # show staff columns


SELECT
	s.first_name, s.last_name, a.address
FROM
	staff AS s
INNER JOIN
	address AS a
ON
	s.address_id = a.address_id;

-- 6b. query staff-payment for the total amount rung up by each staff during 08-2005.
SHOW COLUMNS FROM sakila.staff; # show address columns
SHOW COLUMNS FROM sakila.payment; # show staff columns

SELECT
	s.staff_id, s.first_name, s.last_name, SUM(p.amount) AS staff_total_amount
FROM
	staff AS s
RIGHT JOIN
	payment AS p
ON
	s.staff_id = p.staff_id
WHERE 
	p.payment_date
LIKE 
	"%2005-08%"
GROUP BY
	s.staff_id;
-- 
-- 6c. Query film-film_actor for the films and the number of actors listed in
SHOW COLUMNS FROM sakila.film; # show address columns
SHOW COLUMNS FROM sakila.film_actor; # show film_actor columns

SELECT
	f.film_id, f.title, COUNT(fa.actor_id) AS film_actor_count
FROM
	film AS f
INNER JOIN
	film_actor AS fa
ON
	f.film_id = fa.film_id
GROUP BY
	f.film_id;

-- 6d. Query film-inventory for copies counts of "Hunchback Impossible"
SHOW COLUMNS FROM sakila.film; # show address columns
SHOW COLUMNS FROM sakila.inventory; # show inventory columns

SELECT
	f.film_id, f.title, COUNT(i.store_id) AS film_copy_count
FROM
	sakila.film AS f
INNER JOIN
	sakila.inventory AS i
ON
	f.film_id = i.film_id
GROUP BY
	f.film_id
HAVING
	f.title = "Hunchback Impossible";
    
-- 6e. query payment for the total payments made by each customer
SHOW COLUMNS FROM sakila.payment; # show payment columns
SHOW COLUMNS FROM sakila.customer; # show coustomer columns

SELECT
	c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS customer_total_amount
FROM
	sakila.customer AS c
INNER JOIN
	sakila.payment AS p
ON
	c.customer_id = p.customer_id
GROUP BY
	c.customer_id
ORDER BY
	c.last_name, c.first_name;
    
-- 7a. query film-language for titles starting with either "K" or "Q" in English 
SELECT
	title
FROM
	sakila.film
WHERE
	language_id
IN
	(
    SELECT 
		language_id
	FROM
		sakila.language
	WHERE
		name = "English"
	)
AND 
	(title LIKE "K%")
OR
	(title LIKE "Q%");
    
-- 7b. query actor-actor_id-film for actors listed in "Alone Trip"
SELECT
	first_name, last_name
FROM
	sakila.actor
WHERE 
	actor_id
IN
	(
    SELECT
		actor_id
    FROM
		sakila.film_actor
	WHERE
		film_id
	IN
		(
        SELECT
			film_id
		FROM
			sakila.film
		WHERE
			title = "Alone Trip"
		)
	);


-- 7c. Query customer-address-city-country for first_name, last_name, email and country of customer from canada
SELECT 
	c.first_name, c.last_name, c.email, co.country
FROM sakila.customer AS c
LEFT JOIN
	sakila.address AS a
ON
	c.address_id = a.address_id
LEFT JOIN 
	sakila.city AS ct
ON 
	ct.city_id = a.city_id
LEFT JOIN
	sakila.country AS co
ON
	co.country_id = ct.country_id
WHERE
	country = "Canada";

-- 7d. Query film-film_category-category for family films
SELECT
	*
FROM
	sakila.film
WHERE
	film_id
IN
	(
    SELECT
		film_id
	FROM
		sakila.film_category
	WHERE
		category_id
    IN
		(
        SELECT
			category_id
		FROM
			sakila.category
		WHERE
			name = "Family"
		)
	);

-- 7e. Query film-inventory-rental for rented films in descending order
SELECT
	f.title , COUNT(r.rental_id)
AS
	number_of_rentals
FROM
	sakila.film AS f
RIGHT JOIN
	sakila.inventory AS i
ON
	f.film_id = i.film_id
JOIN
	sakila.rental AS r 
ON
	r.inventory_id = i.inventory_id
GROUP BY
	f.title
ORDER BY
	number_of_rentals DESC;
    
-- 7f. Query store-staff-payment for total amount bought in each store
SELECT
	st.store_id, sum(p.amount) AS store_revenue
FROM
	 sakila.store AS st
RIGHT JOIN
	sakila.staff AS sf
ON
	st.store_id = sf.store_id
LEFT JOIN
	sakila.payment AS p
ON
	sf.staff_id = p.staff_id
GROUP BY
	st.store_id;

-- 7g. Query store-address-city-country for store_id, city and country of each store
SELECT
	s.store_id, ci.city, co.country
FROM
	sakila.store AS s
JOIN
	sakila.address AS a
ON
	s.address_id = a.address_id
JOIN
	sakila.city AS ci
ON
	a.city_id = ci.city_id
JOIN
	country AS co
ON
	ci.country_id = co.country_id;
    
-- 7h. Query category-film_category-inventory-rental-payment for 5 top genres by revenue in descending order 
SELECT
	c.name, sum(p.amount) AS category_revenue
FROM
	sakila.category AS c
JOIN
	sakila.film_category AS fc
ON
	c.category_id = fc.category_id
JOIN
	sakila.inventory AS i
ON
	fc.film_id = i.film_id
JOIN
	sakila.rental AS r
ON
	r.inventory_id = i.inventory_id
JOIN
	sakila.payment AS p
ON
	p.rental_id = r.rental_id
GROUP BY
	c.name
ORDER BY
	category_revenue DESC;

-- 8a. Create a view for 5 top genres by revenue in descending order 
CREATE VIEW
	top_5_genres_by_revenue
AS SELECT
	c.name, sum(p.amount) AS category_revenue
FROM
	sakila.category AS c
JOIN
	sakila.film_category AS fc
ON
	c.category_id = fc.category_id
JOIN
	sakila.inventory AS i
ON
	fc.film_id = i.film_id
JOIN
	sakila.rental AS r
ON
	r.inventory_id = i.inventory_id
JOIN
	sakila.payment AS p
ON
	p.rental_id = r.rental_id
GROUP BY
	c.name
ORDER BY
	category_revenue DESC
LIMIT 5;

-- 8b. Display view.
SELECT
	*
FROM
	top_5_genres_by_revenue;

-- 8c. Drop view.
DROP VIEW
	top_5_genres_by_revenue;


