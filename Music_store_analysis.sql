-- DROP DATABASE MUSIC_STORE;
CREATE DATABASE IF NOT EXISTS music_store;
use music_store;
-- 1. Genre and MediaType
CREATE TABLE Genre (
	genre_id INT AUTO_INCREMENT PRIMARY KEY ,
	name VARCHAR(120)
);

CREATE TABLE MediaType (
	media_type_id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(120)
);

-- 2. Employee
CREATE TABLE Employee (
	employee_id INT AUTO_INCREMENT PRIMARY KEY,
	last_name VARCHAR(120),
	first_name VARCHAR(120),
	title VARCHAR(120),
	reports_to INT,
  levels VARCHAR(255),
	birthdate DATE,
	hire_date DATE,
	address VARCHAR(255),
	city VARCHAR(100),
	state VARCHAR(100),
	country VARCHAR(100),
	postal_code VARCHAR(20),
	phone VARCHAR(50),
	fax VARCHAR(50),
	email VARCHAR(100)
);

-- 3. Customer
CREATE TABLE Customer (
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(120),
	last_name VARCHAR(120),
	company VARCHAR(120),
	address VARCHAR(255),
	city VARCHAR(100),
	state VARCHAR(100),
	country VARCHAR(100),
	postal_code VARCHAR(20),
	phone VARCHAR(50),
	fax VARCHAR(50),
	email VARCHAR(100),
	support_rep_id INT,
	FOREIGN KEY (support_rep_id) REFERENCES Employee(employee_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- 4. Artist
CREATE TABLE Artist (
	artist_id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(120)
);

-- 5. Album
CREATE TABLE Album (
	album_id INT AUTO_INCREMENT PRIMARY KEY,
	title VARCHAR(160),
	artist_id INT,
	FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- 6. Track
CREATE TABLE Track (
	track_id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(200),
	album_id INT,
	media_type_id INT,
	genre_id INT,
	composer VARCHAR(220),
	milliseconds INT,
	bytes INT,
	unit_price DECIMAL(10,2),
	FOREIGN KEY (album_id) REFERENCES Album(album_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (media_type_id) REFERENCES MediaType(media_type_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (genre_id) REFERENCES Genre(genre_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- 7. Invoice
CREATE TABLE Invoice (
	invoice_id INT AUTO_INCREMENT PRIMARY KEY,
	customer_id INT,
	invoice_date DATE,
	billing_address VARCHAR(255),
	billing_city VARCHAR(100),
	billing_state VARCHAR(100),
	billing_country VARCHAR(100),
	billing_postal_code VARCHAR(20),
	total DECIMAL(10,2),
	FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- 8. InvoiceLine
CREATE TABLE InvoiceLine (
	invoice_line_id INT AUTO_INCREMENT PRIMARY KEY,
	invoice_id INT,
	track_id INT,
	unit_price DECIMAL(10,2),
	quantity INT,
	FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (track_id) REFERENCES Track(track_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- 9. Playlist
CREATE TABLE Playlist (
 	playlist_id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(255)
);

-- 10. PlaylistTrack
CREATE TABLE PlaylistTrack (
	playlist_id INT,
	track_id INT,
	PRIMARY KEY (playlist_id, track_id),
	FOREIGN KEY (playlist_id) REFERENCES Playlist(playlist_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (track_id) REFERENCES Track(track_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);
DELETE FROM TRACK;
select * from playlisttrack;
SHOW VARIABLES LIKE 'secure_file_priv';
-- C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\
LOAD DATA INFILE  'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/track.csv'
INTO TABLE  track
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(track_id, name, album_id, media_type_id, genre_id, composer, milliseconds, bytes, unit_price);

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE playlisttrack;
SET FOREIGN_KEY_CHECKS = 1;

select count(track_id) from track;

-- 1. Who is the senior most employee based on job title? 
SELECT CONCAT(last_name, ' ', first_name) AS employee_name, title
FROM Employee
ORDER BY 
    CASE title
        WHEN 'General Manager' THEN 1
        WHEN 'Sales Manager' THEN 2
        WHEN 'IT Manager' THEN 3
        WHEN 'Sales Support Agent' THEN 4
        WHEN 'IT Staff' THEN 5
        ELSE 99
    END
LIMIT 1;
-- 2. Which countries have the most Invoices?
SELECT BILLING_COUNTRY,COUNT(*) AS INVOICE_COUNT
FROM INVOICE
GROUP BY BILLING_COUNTRY 
ORDER BY INVOICE_COUNT DESC;
-- 3. What are the top 3 values of total invoice?
SELECT *
FROM INVOICE
ORDER BY TOTAL DESC
LIMIT 3;


-- 4. Which city has the best customers? - We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals
SELECT BILLING_CITY AS CITY, SUM(TOTAL) AS INVOICE_TOTAL
FROM INVOICE
GROUP BY CITY
ORDER BY INVOICE_TOTAL DESC
LIMIT 1;
-- 5. Who is the best customer? - The customer who has spent the most money will be declared the best customer. 
-- Write a query that returns the person who has spent the most money
SELECT CONCAT(C.FIRST_NAME,' ',C.LAST_NAME) AS CUSTOMER_NAME,SUM(I.TOTAL) AS TOTAL_SPENT
FROM CUSTOMER C
JOIN INVOICE I
USING(CUSTOMER_ID)
GROUP BY C.CUSTOMER_ID
ORDER BY TOTAL_SPENT DESC
LIMIT 1;
-- 6. Write a query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A
SELECT DISTINCT C.EMAIL,FIRST_NAME,LAST_NAME,G.NAME AS GENRE
FROM CUSTOMER C
JOIN INVOICE I 
USING(CUSTOMER_ID)
JOIN INVOICELINE INL
USING(INVOICE_ID)
JOIN TRACK T
USING(TRACK_ID)
JOIN GENRE G
USING(GENRE_ID) 
WHERE G.NAME = 'ROCK'
ORDER BY C.EMAIL ASC;
-- 7. Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands 
SELECT A.NAME,COUNT(T.TRACK_ID) AS TOTAL_TRACK_COUNT
FROM ARTIST A
JOIN ALBUM AB
USING(ARTIST_ID)
JOIN TRACK T
USING(ALBUM_ID)
JOIN GENRE G
USING(GENRE_ID)
WHERE G.NAME = 'ROCK'
GROUP BY A.ARTIST_ID
ORDER BY TOTAL_TRACK_COUNT DESC
LIMIT 10;

-- 8. Return all the track names that have a song length longer than the average song length.
-- Return the Name and Milliseconds for each track. Order by the song length, with the longest songs listed first
SELECT NAME,MILLISECONDS
FROM TRACK
WHERE MILLISECONDS > (SELECT AVG(MILLISECONDS) FROM TRACK)
ORDER BY MILLISECONDS DESC;
-- 9. Find how much amount is spent by each customer on artists? Write a query to return customer name, artist name and total spent 
SELECT CONCAT(C.FIRST_NAME,' ',C.LAST_NAME) AS CUSTOMER_NAME,A.NAME AS ARTIST_NAME,SUM(I.TOTAL) AS TOTAL_SPENT
FROM CUSTOMER C
JOIN INVOICE I
USING(CUSTOMER_ID)
JOIN INVOICELINE INL
USING(INVOICE_ID)
JOIN TRACK T
USING(TRACK_ID)
JOIN ALBUM AB
USING(ALBUM_ID)
JOIN ARTIST A
USING(ARTIST_ID)
GROUP BY C.CUSTOMER_ID,A.ARTIST_ID
ORDER BY TOTAL_SPENT DESC;

-- 10. We want to find out the most popular music Genre for each country. 
-- We determine the most popular genre as the genre with the highest amount of purchases. 
-- Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared, 
-- return all Genres
WITH GenreSales AS (
    SELECT C.country, G.name AS genre, COUNT(IL.invoice_line_id) AS purchases
    FROM Customer C
    JOIN Invoice I ON C.customer_id = I.customer_id
    JOIN InvoiceLine IL ON I.invoice_id = IL.invoice_id
    JOIN Track T ON IL.track_id = T.track_id
    JOIN Genre G ON T.genre_id = G.genre_id
    GROUP BY C.country, G.name
)
SELECT country, genre, purchases
FROM GenreSales gs
WHERE purchases = (
    SELECT MAX(purchases)
    FROM GenreSales
    WHERE country = gs.country
);

-- 11. Write a query that determines the customer that has spent the most on music for each country. 
-- Write a query that returns the country along with the top customer and how much they spent. 
-- For countries where the top amount spent is shared, provide all customers who spent this amount
WITH CustomerSpending AS (
    SELECT C.country, C.first_name, C.last_name, SUM(I.total) AS total_spent
    FROM Customer C
    JOIN Invoice I ON C.customer_id = I.customer_id
    GROUP BY C.country, C.customer_id
)
SELECT country, first_name, last_name, total_spent
FROM CustomerSpending cs
WHERE total_spent = (
    SELECT MAX(total_spent)
    FROM CustomerSpending
    WHERE country = cs.country
);	


