-- 1a display first and last names from actor table
USE sakila;
SELECT 
    first_name, last_name
FROM
    actor;

-- 1b display first and last name from actor table in single column
SELECT 
    UPPER(CONCAT(first_name, ' ', last_name)) AS ACTOR_NAME
FROM
    actor;

-- 2a id  number, first name, and last name of actor Joe
SELECT 
    first_name, last_name, actor_id
FROM
    actor
WHERE
    first_name LIKE 'Joe';

-- 2b find all actors whos last name contain letters GEN
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    last_name LIKE '%GEN%';

-- 2c find all actors whose last name contain LI order by last name and first name
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    last_name LIKE '%LI%'
ORDER BY last_name , first_name;

-- 2d using IN, display country id and country for afghanistan, bangladesh, and china
SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('afghanistan' , 'bangladesh', 'china');

-- 3a description of actor with new column description using BLOB
ALTER TABLE actor
ADD COLUMN description BLOB
AFTER first_name;

-- 3b delete column description
ALTER TABLE Actor
DROP COLUMN description;

-- 4a list last name of actors and number of actors with that last name
SELECT 
    last_name, COUNT(last_name) AS last_name_count
FROM
    actor
GROUP BY last_name;


-- 4b List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT 
    last_name, COUNT(last_name) AS last_name_count
FROM
    actor
GROUP BY last_name
HAVING last_name_count >= 2;

-- 4c Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor 
SET 
    first_name = 'harpo'
WHERE
    first_name = 'groucho'
        AND last_name = 'williams';

-- 4d Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE actor
SET first_name = 
CASE
WHEN first_name ='harpo'
  THEN 'groucho'
 ELSE 'mucho groucho'
END
WHERE actor_id = 172;
END CASE;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE ADDRESS;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT s.first_name, s.last_name, a.address
FROM staff s
INNER JOIN address a
ON (s.address_id = a.address_id);

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT s.first_name, s.last_name, SUM(p.amount) as 'Sum Payment Amount'
FROM staff s
INNER JOIN payment p
ON p.staff_id = s.staff_id
WHERE month(p.payment_date) = 08 AND year(p.payment_date) = 2005
GROUP BY s.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.title, COUNT(fa.actor_id) as 'Actors'
FROM film_actor fa
INNER JOIN film f
ON f.film_id = fa.film_id
GROUP BY f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title, COUNT(inventory_id) as 'Number of Copies'
FROM film
INNER JOIN inventory
USING (film_id)
WHERE title = 'Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.first_name, c.last_name, SUM(p.amount) as 'Total Amount Paid'
FROM payment p
JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
FROM film
WHERE title like'K%'
OR title like 'Q%'
AND language_id in
(SELECT language_id
FROM language
WHERE name = 'English'
);

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id in
(
SELECT actor_id
FROM film_actor
WHERE film_id =
 (
	SELECT film_id
    FROM film
    WHERE title = 'Alone Trip'
    )
);
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT first_name, last_name, email, country
FROM customer cust
JOIN address a
ON (cust.address_id = a.address_id)
JOIN city cit
ON (a.city_id = cit.city_id)
JOIN country ctr
ON (cit.country_id = ctr.country_id)
WHERE ctr.country = 'canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT title, c.name
FROM film f
JOIN film_category fc
ON (f.film_id = fc.film_id)
JOIN category c
ON (c.category_id = fc.category_id)
WHERE name = 'family';

-- 7e. Display the most frequently rented movies in descending order.
SELECT title, count(title)
FROM film
GROUP BY title
ORDER BY COUNT(title);

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(amount) AS Gross
FROM payment p
JOIN rental r
ON (p.rental_id = r.rental_id)
JOIN inventory i
ON ( i.inventory_id = r.inventory_id)
JOIN store s
ON (s.store_id = i.store_id)
GROUP BY s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT store_id, city, country
FROM store s
JOIN address a
ON  (s.address_id = a.address_id)
JOIN city c
ON (a.city_id = c.city_id)
JOIN country co
ON (c.country_id = co.country_id); 

-- 7h. list the top five genres in gross revenue in descending order

SELECT SUM(amount) AS 'Gross_Revenue', c.name AS 'Genre'
FROM payment p
JOIN rental r
ON (p.rental_id = r.rental_id)
JOIN inventory i
ON (r.inventory_id = i.inventory_id)
JOIN film_category fc  
ON(i.film_id = fc.film_id)
JOIN category c
ON (fc.category_id = c.category_id)
GROUP BY c.name
ORDER BY SUM(amount) DESC
LIMIT 5;

-- Question 8a: In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE 
	VIEW top_five_genres
	AS
	SELECT SUM(amount) AS 'Gross_Revenue', c.name AS 'Genre'
	FROM payment p
	JOIN rental r
	ON (p.rental_id = r.rental_id)
	JOIN inventory i
	ON (r.inventory_id = i.inventory_id)
	JOIN film_category fc  
	ON(i.film_id = fc.film_id)
	JOIN category c
	ON (fc.category_id = c.category_id)
	GROUP BY c.name
	ORDER BY SUM(amount) DESC
	LIMIT 5;
    
-- 8b How would you display the view you created in 8a
SELECT 
    *
FROM
    top_five_genres;

-- 8c you find that you no longer need top_five_generes. write a query to delete it.
DROP VIEW top_five_genres;