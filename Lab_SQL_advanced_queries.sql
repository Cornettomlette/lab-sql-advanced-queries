/*Lab | SQL Advanced queries
In this lab, you will be using the Sakila database of movie rentals.

Instructions
List each pair of actors that have worked together.
For each film, list actor that has acted in more films.*/

-- List each pair of actors that have worked together.
CREATE VIEW ac1 AS SELECT actor.actor_id, concat(first_name, ' ', last_name) as full_name, film_id from actor
INNER JOIN film_actor on actor.actor_id = film_actor.actor_id;

CREATE VIEW ac2 AS SELECT actor.actor_id, concat(first_name, ' ', last_name) as full_name, film_id from actor
INNER JOIN film_actor on actor.actor_id = film_actor.actor_id;

SELECT ac1.full_name, ac2.full_name FROM ac1 
JOIN ac2 on ac1.film_id = ac2.film_id and ac1.actor_id <> ac2.actor_id
ORDER BY ac1.actor_id;

SELECT distinct concat(ac1.full_name, ' - ', ac2.full_name) as pairs FROM ac1 
JOIN ac2 on ac1.film_id = ac2.film_id and ac1.actor_id < ac2.actor_id
ORDER BY ac1.actor_id;

-- For each film, list actor that has acted in more films.
CREATE TEMPORARY TABLE num_roles_actor AS SELECT actor_id, count(film_id) as num_appearances FROM film_actor
GROUP BY actor_id;

SELECT * FROM num_roles_actor;

SELECT film.film_id, title, film_actor.actor_id, concat(first_name, ' ', last_name) as full_name, num_appearances, row_number() over (partition by film_id order by num_appearances desc) as rank_num_roles
FROM film_actor
INNER JOIN num_roles_actor ON film_actor.actor_id = num_roles_actor.actor_id
INNER JOIN film ON film_actor.film_id = film.film_id
INNER JOIN actor ON film_actor.actor_id = actor.actor_id
ORDER BY film_id;

SELECT * FROM (SELECT film.film_id, title, film_actor.actor_id, concat(first_name, ' ', last_name) as full_name, num_appearances, row_number() over (partition by film_id order by num_appearances desc) as rank_num_roles
FROM film_actor
INNER JOIN num_roles_actor ON film_actor.actor_id = num_roles_actor.actor_id
INNER JOIN film ON film_actor.film_id = film.film_id
INNER JOIN actor ON film_actor.actor_id = actor.actor_id
ORDER BY film_id) as sub
WHERE rank_num_roles = 1;
