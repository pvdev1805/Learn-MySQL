USE cinema;

SELECT * FROM booking;
SELECT * FROM customer;
SELECT * FROM film;
SELECT * FROM reserved_seat;
SELECT * FROM room;
SELECT * FROM screening;
SELECT * FROM seat;

-- 1. Show films over 100mins
SELECT * 
FROM film 
WHERE length_min > 100;

-- 2. Which film over average length of all films
-- SELECT AVG(length_min) FROM film;
SELECT * 
FROM film 
WHERE length_min > (SELECT AVG(length_min) FROM film);

-- 3. Which film has name start with letter 't'
SELECT * 
FROM film 
WHERE film.name LIKE 't%';
 
 -- 4. Which film contain letter 'a'
 SELECT * 
 FROM film 
 WHERE film.name LIKE '%a%';
 
 -- 5. How many film in US?
 -- SELECT * FROM film WHERE country_code = 'US';
 SELECT COUNT(*) AS 'No films in US' 
 FROM film 
 WHERE country_code = 'US';
 
 -- 6. What is the longest, and shortest length of all film?
 -- 6.1. The longest length of all films
 SELECT length_min AS 'Longest length (minutes)' 
 FROM film 
 WHERE length_min >= ALL (SELECT length_min FROM film);
 
 -- 6.2. The shortest length of all films
 SELECT length_min AS 'Shortest length (minutes)' 
 FROM film 
 WHERE length_min <= ALL (SELECT length_min FROM film);
 
 -- 6.3. The longest and shortest length of all films
 -- Solution 1:
 SELECT t1.length_min AS 'Longest length (minutes)', t2.length_min AS 'Shortest length (minutes)' 
 FROM film t1, film t2 
 WHERE t1.length_min >= ALL (SELECT length_min FROM film)
 AND t2.length_min <= ALL (SELECT length_min FROM film);
 
 -- Solution 2:
 SELECT MAX(length_min) AS 'Longest length (minutes)', MIN(length_min) AS 'Shortest length (minutes)'
 FROM film;
 
 -- 7. Show unique film types of all film (NO DUPLICATE)
 SELECT DISTINCT type 
 FROM film;
 
 -- 8. What is the distance (in days) of the 1st and the last film?
 -- 8.1. distance of the 1st and the last film in table screening
 -- SELECT DATEDIFF(MAX(start_time), MIN(start_time)) AS 'max_distance' FROM screening;
 
 -- 8.2. distance of the 1st and the last screaning of each film in table film
 -- SELECT * FROM screening s RIGHT JOIN film f ON s.film_id = f.id;
 
 -- SELECT f.name, s.start_time FROM screening s RIGHT JOIN film f ON s.film_id = f.id;
 
--  SELECT f.name, COUNT(s.start_time) FROM screening s RIGHT JOIN film f ON s.film_id = f.id GROUP BY f.name;
 
--  SELECT f.name, DATEDIFF(MAX(start_time), MIN(start_time)) FROM screening s RIGHT JOIN film f ON s.film_id = f.id GROUP BY f.name;

 SELECT f.name, IFNULL(DATEDIFF(MAX(start_time), MIN(start_time)), 0) AS 'Distance between the first and the last screening (in days)' FROM screening s RIGHT JOIN film f ON s.film_id = f.id GROUP BY f.name;
  
 -- 9. Show all Screening Information including film name, room name, time of film "Tom&Jerry"
 -- SELECT * FROM film WHERE name = 'Tom&Jerry'; -- Get Tom&Jerry info from film
 SELECT f.name, r.name, s.start_time 
 FROM screening s 
 JOIN film f ON s.film_id = f.id 
 JOIN room r ON s.room_id = r.id;
 
 -- 10. show all screening in 2 day '2022-05-24' and '2022-05-25'
 -- SELECT * FROM screening WHERE DATE(start_time) IN ('2022-05-24', '2022-05-25');
 SELECT f.name, r.name, s.start_time 
 FROM screening s 
 JOIN film f ON s.film_id = f.id 
 JOIN room r ON s.room_id = r.id
 WHERE DATE(s.start_time) IN ('2022-05-24', '2022-05-25');
 
 -- 10.1. Show film which dont have any screening
 -- SELECT * FROM screening s LEFT JOIN film f ON s.film_id = f.id;
 
 -- SELECT id, film_id, start_time FROM screening;
 
 -- SELECT s.film_id ,f.name, COUNT(*) 
--  FROM (SELECT id, film_id FROM screening) AS s 
--  JOIN film f ON s.film_id = f.id
--  GROUP BY film_id; 
 
--  SELECT s.film_id ,f.name, COUNT(*) 
--  FROM  film f
--  JOIN screening s ON f.id = s.film_id
--  GROUP BY s.film_id; 
 
--  SELECT * FROM film f LEFT JOIN screening s ON f.id = s.film_id;
 
 -- SELECT * FROM film f LEFT JOIN screening s ON f.id = s.film_id WHERE s.id IS NULL;
 
 SELECT f.id, f.name FROM film f LEFT JOIN screening s ON f.id = s.film_id WHERE s.id IS NULL;
 
 -- 11. Who book more than 1 seat in 1 booking?
 -- SELECT * FROM booking;
 -- SELECT * FROM reserved_seat;
 -- SELECT * FROM customer;
 
 -- SELECT booking_id, COUNT(*) AS 'No seats' FROM reserved_seat GROUP BY booking_id HAVING COUNT(*) > 1;
 
 -- SELECT * FROM (SELECT booking_id, COUNT(*) AS 'No seats' FROM reserved_seat GROUP BY booking_id HAVING COUNT(*) > 1) AS rs JOIN booking b ON rs.booking_id = b.id JOIN customer c ON b.customer_id = c.id; 
 
 -- SELECT rs.booking_id, b.customer_id, c.first_name, c.last_name, rs.`No seats` FROM (SELECT booking_id, COUNT(*) AS 'No seats' FROM reserved_seat GROUP BY booking_id HAVING COUNT(*) > 1) AS rs JOIN booking b ON rs.booking_id = b.id JOIN customer c ON b.customer_id = c.id; 
 
 SELECT c.first_name, c.last_name, rs.`No seats` 
 FROM (SELECT booking_id, COUNT(*) AS 'No seats' FROM reserved_seat GROUP BY booking_id HAVING COUNT(*) > 1) AS rs 
 JOIN booking b ON rs.booking_id = b.id 
 JOIN customer c ON b.customer_id = c.id; 
 
 -- 12. Show room show more than 2 film in one day?
 -- 12.1. how many film each room show in one day
 -- 12.1.1. on each day, which room show films and what are these films
 -- SELECT * FROM screening;
 -- SELECT *, DATE(s.start_time) AS 'date' FROM screening s;
 
 -- SELECT DATE(s.start_time) AS 'date', s.room_id, s.film_id FROM screening s ORDER BY s.start_time;
 
 -- SELECT id, film_id, room_id, DATE(start_time) AS 'date' FROM screening;
 
 -- SELECT s.date, s.room_id, s.film_id FROM (SELECT id, film_id, room_id, DATE(start_time) AS 'date' FROM screening) s GROUP BY s.date, s.room_id, s.film_id ORDER BY s.date;
 
 -- SELECT s1.date, s1.room_id, COUNT(*) AS 'No films' FROM (SELECT s.date, s.room_id, s.film_id FROM (SELECT id, film_id, room_id, DATE(start_time) AS 'date' FROM screening) s GROUP BY s.date, s.room_id, s.film_id ORDER BY s.date) s1 GROUP BY s1.date, s1.room_id;

 -- SELECT s1.date, s1.room_id, COUNT(*) AS 'No films' FROM (SELECT s.date, s.room_id, s.film_id FROM (SELECT id, film_id, room_id, DATE(start_time) AS 'date' FROM screening) s GROUP BY s.date, s.room_id, s.film_id ORDER BY s.date) s1 GROUP BY s1.date, s1.room_id HAVING COUNT(*) > 2;
 
 -- 12.2. Join with table room to show room name
 /*
 SELECT s1.date, s1.room_id, r.name, COUNT(*) AS 'No films' 
 FROM (SELECT s.date, s.room_id, s.film_id FROM (SELECT id, film_id, room_id, DATE(start_time) AS 'date' FROM screening) s GROUP BY s.date, s.room_id, s.film_id ORDER BY s.date) s1 
 JOIN room r ON s1.room_id = r.id
 GROUP BY s1.date, s1.room_id HAVING COUNT(*) > 2 ORDER BY s1.date;
 */
 
 SELECT s1.date, r.name, COUNT(*) AS 'No films' 
 FROM (SELECT s.date, s.room_id, s.film_id FROM (SELECT id, film_id, room_id, DATE(start_time) AS 'date' FROM screening) s GROUP BY s.date, s.room_id, s.film_id ORDER BY s.date) s1 
 JOIN room r ON s1.room_id = r.id
 GROUP BY s1.date, s1.room_id HAVING COUNT(*) > 2 ORDER BY s1.date;
 
 -- 13. Which room show the least film ?
 -- SELECT s1.date, s1.room_id, COUNT(*) AS 'No films' FROM (SELECT s.date, s.room_id, s.film_id FROM (SELECT id, film_id, room_id, DATE(start_time) AS 'date' FROM screening) s GROUP BY s.date, s.room_id, s.film_id ORDER BY s.date) s1 GROUP BY s1.date, s1.room_id;
 
 -- 13.1. Which room show what film?
--  SELECT room_id, film_id FROM screening GROUP BY room_id, film_id ORDER BY room_id, film_id;
 
 -- 13.2. How many film each room shows?
 
 -- SELECT s.room_id, COUNT(*) AS 'No films' FROM (SELECT room_id, film_id FROM screening GROUP BY room_id, film_id ORDER BY room_id, film_id) s GROUP BY s.room_id;
 
 -- 13.3. Get the room showing the least film
 -- SELECT s.room_id, COUNT(*) AS 'No films' FROM (SELECT room_id, film_id FROM screening GROUP BY room_id, film_id ORDER BY room_id, film_id) s GROUP BY s.room_id HAVING COUNT(*) <= ALL (SELECT COUNT(*) AS 'No films' FROM (SELECT room_id, film_id FROM screening GROUP BY room_id, film_id ORDER BY room_id, film_id) s GROUP BY s.room_id);
 
 -- 13.4. Join with table room to get room name
 /*
 SELECT s.room_id, r.name, COUNT(*) AS 'No films' FROM 
 (SELECT room_id, film_id FROM screening GROUP BY room_id, film_id ORDER BY room_id, film_id) s 
 JOIN room r ON s.room_id = r.id
 GROUP BY s.room_id HAVING COUNT(*) <= ALL (SELECT COUNT(*) AS 'No films' FROM (SELECT room_id, film_id FROM screening GROUP BY room_id, film_id ORDER BY room_id, film_id) s GROUP BY s.room_id);
 */
 SELECT r.name, COUNT(*) AS 'No films' FROM 
 (SELECT room_id, film_id FROM screening GROUP BY room_id, film_id ORDER BY room_id, film_id) s 
 JOIN room r ON s.room_id = r.id
 GROUP BY s.room_id HAVING COUNT(*) <= ALL (SELECT COUNT(*) AS 'No films' FROM (SELECT room_id, film_id FROM screening GROUP BY room_id, film_id ORDER BY room_id, film_id) s GROUP BY s.room_id);
 
 -- 14. What film don't have booking?
 -- 14.1. Identify tables: film, booking, screening
 -- SELECT * FROM film;
 -- SELECT * FROM booking;
 -- SELECT * FROM screening;
 
 -- 14.2. Join
 /*
 SELECT b.screening_id, b.customer_id, s.film_id, f.name, s.start_time 
 FROM booking b 
 JOIN screening s ON b.screening_id = s.id 
 RIGHT JOIN film f ON s.film_id = f.id;
 */
 
 -- 14.3. Get films having 0 booking from customers
 SELECT f.name, COUNT(b.customer_id) AS 'No booking' 
 FROM booking b 
 JOIN screening s ON b.screening_id = s.id 
 RIGHT JOIN film f ON s.film_id = f.id
 GROUP BY f.name
 HAVING COUNT(b.customer_id) = 0;
 
 -- 15. WHAT film have show the biggest number of room?
 -- 15.1. How many times each film has been shown on each room
 -- SELECT film_id, room_id, COUNT(*) AS 'No of times' FROM screening GROUP BY film_id, room_id ORDER BY film_id;
 
 -- SELECT DISTINCT film_id, room_id FROM screening ORDER BY film_id;
 
 -- 15.2. How many rooms each film has been shown?
 SELECT s.film_id, COUNT(*) AS 'No rooms' FROM (SELECT DISTINCT film_id, room_id FROM screening ORDER BY film_id) s GROUP BY s.film_id;
 
 -- 15.3. Get the films being shown the biggest number of room?
 SELECT s.film_id, COUNT(*) AS 'No rooms' FROM (SELECT DISTINCT film_id, room_id FROM screening ORDER BY film_id) s GROUP BY s.film_id HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM (SELECT DISTINCT film_id, room_id FROM screening ORDER BY film_id) s GROUP BY s.film_id);
 
 -- 15.4. Join table film to add Name 
 /*
  SELECT s.film_id, f.name, COUNT(*) AS 'No rooms' FROM 
  (SELECT DISTINCT film_id, room_id FROM screening ORDER BY film_id) s
  JOIN film f ON s.film_id = f.id
  GROUP BY s.film_id 
  HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM (SELECT DISTINCT film_id, room_id FROM screening ORDER BY film_id) s GROUP BY s.film_id);
  */
  
  SELECT f.name, COUNT(*) AS 'No rooms' FROM 
  (SELECT DISTINCT film_id, room_id FROM screening ORDER BY film_id) s
  JOIN film f ON s.film_id = f.id
  GROUP BY s.film_id 
  HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM (SELECT DISTINCT film_id, room_id FROM screening ORDER BY film_id) s GROUP BY s.film_id);
 
 -- 16. Show number of film that show in every day of week and order descending
 -- SELECT * FROM screening ORDER BY start_time;
 -- SELECT film_id, DATE(start_time) FROM screening ORDER BY start_time;
 -- SELECT film_id, date FROM (SELECT film_id, DATE(start_time) AS 'date' FROM screening ORDER BY start_time) s ORDER BY film_id;
 -- SELECT DISTINCT film_id, date FROM (SELECT film_id, DATE(start_time) AS 'date' FROM screening ORDER BY start_time) s ORDER BY film_id;
 -- SELECT sc.film_id, COUNT(*) AS 'No days' FROM (SELECT DISTINCT s.film_id, s.date FROM (SELECT film_id, DATE(start_time) AS 'date' FROM screening ORDER BY start_time) s ORDER BY s.film_id) AS sc GROUP BY sc.film_id;

--  SELECT sc.film_id, COUNT(*) AS 'No days' FROM (SELECT DISTINCT s.film_id, s.date FROM (SELECT film_id, DATE(start_time) AS 'date' FROM screening ORDER BY start_time) s ORDER BY s.film_id) AS sc GROUP BY sc.film_id HAVING COUNT(*) = MAX(sc.date) - MIN(sc.date) + 1;
 
 /*
 SELECT sc.film_id, f.name FROM 
 (SELECT DISTINCT s.film_id, s.date FROM (SELECT film_id, DATE(start_time) AS 'date' FROM screening ORDER BY start_time) s ORDER BY s.film_id) AS sc 
 JOIN film f ON sc.film_id = f.id
 GROUP BY sc.film_id HAVING COUNT(*) = CONVERT(MAX(sc.date), UNSIGNED) - CONVERT(MIN(sc.date), UNSIGNED) + 1;
 */
 
 /*
 SELECT sc.film_id, f.name FROM 
 (SELECT DISTINCT s.film_id, s.date FROM (SELECT film_id, DATE(start_time) AS 'date' FROM screening ORDER BY start_time) s ORDER BY s.film_id) AS sc 
 JOIN film f ON sc.film_id = f.id
 GROUP BY sc.film_id HAVING COUNT(*) = 7;
*/

 -- SELECT DISTINCT s.date FROM (SELECT film_id, DATE(start_time) AS 'date' FROM screening ORDER BY start_time) s;
 
--  SELECT COUNT(*) FROM (SELECT DISTINCT s.date FROM (SELECT film_id, DATE(start_time) AS 'date' FROM screening ORDER BY start_time) s) sc2;

 SELECT sc.film_id, f.name FROM 
 (SELECT DISTINCT s.film_id, s.date FROM (SELECT film_id, DATE(start_time) AS 'date' FROM screening ORDER BY start_time) s ORDER BY s.film_id) AS sc 
 JOIN film f ON sc.film_id = f.id
 GROUP BY sc.film_id HAVING COUNT(*) = (SELECT COUNT(*) FROM (SELECT DISTINCT s.date FROM (SELECT film_id, DATE(start_time) AS 'date' FROM screening ORDER BY start_time) s) sc2);
  
 -- 17. Show total length of each film that showed in 28/5/2022
 -- SELECT film_id, COUNT(*) AS 'No times' FROM screening WHERE DATE(start_time) = '2022-05-28' GROUP BY film_id ORDER BY film_id;
 
 SELECT f.id, f.name, (COUNT(*) * f.length_min) AS 'Total legnth min in 28/05/2022'
 FROM screening s
 RIGHT JOIN film f ON s.film_id = f.id
 WHERE DATE(start_time) = '2022-05-28' 
 GROUP BY film_id ORDER BY film_id;
 
 -- 18. What film has showing time above and below average show time of all film
 -- SELECT AVG(length_min) FROM film;
 -- SELECT * FROM film WHERE length_min > (SELECT AVG(length_min) FROM film);
  
  SELECT name, length_min,
       CASE 
		WHEN length_min > (SELECT AVG(length_min) FROM film) THEN 'Above Average' ELSE 'Below Average' 
	   END AS length_category
  FROM film
  WHERE length_min != (SELECT AVG(length_min) FROM film)
  ORDER BY length_category, length_min;
  
 -- 19. What room have least number of seat?
--  SELECT * FROM seat;
 -- SELECT room_id, COUNT(*) AS 'No seat' FROM seat GROUP BY room_id;
 
 -- Solution 1:
 SELECT room_id, r.name, COUNT(*) AS 'No seat' 
 FROM seat s
 JOIN room r ON s.room_id = r.id
 GROUP BY room_id 
 HAVING COUNT(*) <= ALL (SELECT COUNT(*) AS 'No seat' FROM seat GROUP BY room_id);
 
 -- Solution 2:
SELECT room_id, r.name, COUNT(*) AS 'No seat'
FROM seat s
JOIN room r ON s.room_id = r.id
GROUP BY room_id
HAVING COUNT(*) = (
    SELECT MIN(seat_count)
    FROM (
        SELECT COUNT(*) AS seat_count
        FROM seat
        GROUP BY room_id
    ) min_seat
);
 
 -- 20. What room have number of seat bigger than average number of seat of all rooms
 -- SELECT room_id, COUNT(*) AS 'No seat' FROM seat GROUP BY room_id;
 -- SELECT AVG(`No seat`) FROM (SELECT room_id, COUNT(*) AS 'No seat' FROM seat GROUP BY room_id) avg_seat;
 
SELECT room_id, r.name, COUNT(*) AS 'No seat'
FROM seat s
JOIN room r ON s.room_id = r.id
GROUP BY room_id
HAVING COUNT(*) > (
    SELECT AVG(seat_count)
    FROM (
        SELECT COUNT(*) AS seat_count
        FROM seat
        GROUP BY room_id
    ) avg_seat
);
 
 -- 21. Except those seats that Mr. Dung has already done booking with booking id = 1, are there any other seats that he could do booking?
 -- Idea:
 -- Which seats are available in room 1 at '2022-05-24 08:00:00'?
 -- --> Show all seats that have been booked in room 1 at '2022-05-24 08:00:00'?
 -- Find booking_id  has screening_id = 1 --> booking_id = 1, 2, 3 
 -- --> Find all seats that have been booked with screening_id = 1 : look at reserved_seat of booking_id 2 and 3 --> find seat_id
 
 /*
 SELECT * FROM booking;
 SELECT * FROM reserved_seat;
 SELECT * FROM screening;
 SELECT * FROM seat;
 */
 
 -- How many seat each room has?
 -- SELECT room_id, COUNT(*) AS seat_count FROM seat GROUP BY room_id;
 
 -- Which seats did Dung book with booking_id = 1?
 -- SELECT * FROM reserved_seat WHERE booking_id = 1;
 -- SELECT DISTINCT seat_id FROM reserved_seat WHERE booking_id = 1;
 
 -- Which screening_id that booking_id = 1 belong to?
 -- SELECT DISTINCT screening_id FROM booking WHERE id = 1;
 
 -- Which room show the screening that booking_id = 1 belong to?
 -- SELECT DISTINCT room_id FROM screening s JOIN booking b ON s.id = b.screening_id WHERE b.id = 1;
 
 -- In this room, which seats have already been booked by Dung and other customers?
 /*
 SELECT * FROM screening s 
 JOIN booking b ON s.id = b.screening_id 
 JOIN reserved_seat rs ON rs.booking_id = b.id
 WHERE room_id = (SELECT DISTINCT room_id FROM screening s JOIN booking b ON s.id = b.screening_id WHERE b.id = 1) 
		AND screening_id = (SELECT DISTINCT screening_id FROM booking WHERE id = 1)
        AND seat_id NOT IN (SELECT DISTINCT seat_id FROM reserved_seat WHERE booking_id = 1);
 */
 
 /*
SELECT seat_id, se.row, se.number FROM screening s 
JOIN booking b ON s.id = b.screening_id 
JOIN reserved_seat rs ON rs.booking_id = b.id
JOIN seat se ON rs.seat_id = se.id
WHERE s.room_id = (SELECT DISTINCT s.room_id FROM screening s JOIN booking b ON s.id = b.screening_id WHERE b.id = 1) 
		AND screening_id = (SELECT DISTINCT screening_id FROM booking WHERE id = 1)
		AND seat_id NOT IN (SELECT DISTINCT seat_id FROM reserved_seat WHERE booking_id = 1);
 */
 
SELECT seat_id, se.row, se.number, r.name FROM screening s 
JOIN booking b ON s.id = b.screening_id 
JOIN reserved_seat rs ON rs.booking_id = b.id
JOIN seat se ON rs.seat_id = se.id
JOIN room r ON se.room_id = r.id
WHERE s.room_id = (SELECT DISTINCT s.room_id FROM screening s JOIN booking b ON s.id = b.screening_id WHERE b.id = 1) 
		AND screening_id = (SELECT DISTINCT screening_id FROM booking WHERE id = 1)
		AND seat_id NOT IN (SELECT DISTINCT seat_id FROM reserved_seat WHERE booking_id = 1);
 
 -- 22. Show Film with total screening and order by total screening. BUT ONLY SHOW DATA OF FILM WITH TOTAL SCREENING > 10
 -- SELECT * FROM screening;
 
 -- SELECT * FROM screening s RIGHT JOIN film f ON s.film_id = f.id;
 
 /*
 SELECT film_id, f.name, COUNT(*) AS 'No screening' 
 FROM screening s
 JOIN film f ON s.film_id = f.id
 GROUP BY film_id 
 HAVING COUNT(*) > 10
 ORDER BY COUNT(*);
 */
 
 /*
 SELECT f.id, f.name, COUNT(start_time) AS 'No screening' 
 FROM screening s
 RIGHT JOIN film f ON s.film_id = f.id
 GROUP BY f.id;
 */
 
 SELECT f.id, f.name, COUNT(start_time) AS 'No screening' 
 FROM screening s
 RIGHT JOIN film f ON s.film_id = f.id
 GROUP BY f.id 
 HAVING COUNT(start_time) > 10
 ORDER BY COUNT(start_time);
 
 -- 23. TOP 3 DAY OF WEEK based on total booking
 -- SELECT * FROM booking;
 -- SELECT * FROM screening;
 
--  SELECT id, DATE(start_time) FROM screening;
 
--  SELECT b.id, b.screening_id, start_time FROM booking b JOIN screening s ON b.screening_id = s.id;
 
--  SELECT b.id, b.screening_id, date FROM booking b JOIN (SELECT id, DATE(start_time) AS 'date' FROM screening) s ON b.screening_id = s.id;
 
 SELECT date, COUNT(*) AS 'No booking' 
 FROM booking b 
 JOIN (SELECT id, DATE(start_time) AS 'date' FROM screening) s ON b.screening_id = s.id 
 GROUP BY date 
 ORDER BY COUNT(*) DESC 
 LIMIT 3;
 
 -- 24. CALCULATE BOOKING rate over screening of each film ORDER BY RATES.
 -- SELECT * from booking;
 -- SELECT * FROM screening;
 
 -- How many screening each film has?
 -- SELECT film_id, COUNT(*) AS 'No screening' FROM screening GROUP BY film_id;
 
 -- How many booking each film has?
 -- SELECT film_id, COUNT(*) AS 'No booking' FROM booking b JOIN screening s ON b.screening_id = s.id GROUP BY film_id;
 
 -- Rate?
 SELECT f.id, f.name, IFNULL((t1.`No booking` / t2.`No screening` * 100), 0) AS 'Booking Rate'
 FROM (SELECT film_id, COUNT(*) AS 'No booking' FROM booking b JOIN screening s ON b.screening_id = s.id GROUP BY film_id) t1
 JOIN (SELECT film_id, COUNT(*) AS 'No screening' FROM screening GROUP BY film_id) t2 ON t1.film_id = t2.film_id
 RIGHT JOIN film f ON t1.film_id = f.id;
 
 -- 25. CONTINUE Q15 -> WHICH film has rate over/below/equal average ?
 
 -- 26. TOP 2 people who enjoy the least TIME (in minutes) in the cinema based on booking info - only count who has booking info (example : Dũng book film tom&jerry 4 times -> Dũng enjoy 90 mins x 4)
 