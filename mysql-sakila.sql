-- list the databases on MySQL server
SHOW DATABASES;

-- tell MySQL to use sakila
USE sakila;

SHOW COLUMNS FROM sakila.actor;

-- 1a. Query actor for all the first and last names.
SELECT 
	first_name, last_name
FROM 
	actor;

-- 1b. Query actor for all fist name and last name / convert to uppercase
SELECT 
	concat(UPPER(first_name)," " ,UPPER(last_name))
AS 
	full_name
FROM 
	actor;

-- 2a. Query actor whose first name is "Joe" 
SELECT
	*
FROM
	actor
WHERE 
	first_name = "Joe";

-- 2b. Query actors whose last name contains "GEN" 
SELECT
	*
FROM
	actor
WHERE
	last_name
LIKE
	"%GEN%";

-- 2c. Query actor whose last name contains "LI" 
SELECT
	*
FROM
	actor
WHERE
	last_name
LIKE
	"%LI%"
ORDER BY
	last_name, first_name;

-- 2d. Query country for ("Afghanista", "Bangladesh", "China")
Select
	* FROM
	country
WHERE
	country
in
	("Afghanistan", "Bangladesh", "China");

-- 3a. Add a "middle_name" column to the "actor" table
ALTER TABLE
	actor
ADD
	middle_name VARCHAR(30)
AFTER
	first_name;

-- 3b. Modify data type of "middle_name" column "BLOB" in the "actor" table
ALTER TABLE
	actor
MODIFY
	middle_name BLOB;

-- 3c. Drop "middle_name" column from the "actor" table
ALTER TABLE
	actor
DROP
	middle_name;

-- 4a. Query/Group-by actor for last name / count last names
SELECT
	last_name, COUNT(last_name)
AS
	number_of_actors
FROM
	actor
GROUP BY
	last_name;

-- 4b. Query/Group-by actor for last names shared more than two times
SELECT
	last_name, COUNT(last_name)
AS
	number_of_actors
FROM
	actor
GROUP BY
	last_name
HAVING
	number_of_actors > 1;

-- 4c. Update actor by changing first_name of "GROUCHO WILLIAMS" to "HARPO"
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


-- 6a. 
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

-- 6b. 
SHOW COLUMNS FROM sakila.staff; # show address columns
SHOW COLUMNS FROM sakila.payment; # show staff columns

SELECT
	s.staff_id, s.first_name, s.last_name, SUM(p.amount) AS staff_total_amount
FROM
	staff AS s
INNER JOIN
	payment AS p
ON
	s.staff_id = p.staff_id
GROUP BY
	s.staff_id;
-- HAVING
-- 	p.payment_date = "2005-05-25 11:30:37";
-- 
-- 6c. 
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

-- 6d. 
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
    
-- 6e. 
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
    
-- 7a.
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
    
-- 7b.
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


-- 7c. 
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
	country AS co
ON
	co.country_id = ct.country_id
WHERE
	country = "Canada";

-- 7d.
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

-- 7e.
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

-- 7e.
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
    
-- 7f.
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

-- 7g.
SELECT
	s.store_id, ci.city, co.country
FROM
	sakila.store AS s
JOIN
	sakila.address AS a
ON
	s.address_id = a.address_id
JOIN
	city AS ci
ON
	a.city_id = ci.city_id
JOIN
	country AS co
ON
	ci.country_id = co.country_id;
    
-- 7h.
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

-- 8a.
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

-- 8b.
SELECT
	*
FROM
	top_5_genres_by_revenue;

-- 8c.
DROP VIEW
	top_5_genres_by_revenue;


