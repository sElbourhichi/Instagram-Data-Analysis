/*
EL-BOURHICHI Salah-Edine

Project Name : Data Exploration Using SQL 

*/




/*We want to reward our users who have been around the longest.  
Let's find the 5 oldest users.*/

SELECT TOP 5 username
FROM users 
ORDER BY created_at;

/* We need to figure out when to schedule an ad campgain.
What day of the week do most users register on? */
SELECT DATENAME(weekday, created_at) AS RegistDay, count(DATENAME(weekday, created_at)) AS total
FROM users
GROUP BY DATENAME(weekday, created_at)
ORDER BY 2 DESC;

/* We want to target our inactive users with an email campaign.
Find the users who have never posted a photo */

SELECT username
FROM users
LEFT JOIN photos
ON users.id = photos.user_id 
WHERE photos.image_url is NULL ;

/*We're running a new contest to see who can get the most likes on a single photo.
WHO are top 3 ?*/

SELECT TOP 3 users.username, photos.image_url, total_likes
FROM(
SELECT likes.photo_id, count(*) AS total_likes
FROM likes
GROUP BY photo_id
) AS temp
JOIN photos
ON photos.id = temp.photo_id
JOIN users
ON users.id = photos.user_id
ORDER BY total_likes DESC

/*Our Investors want to know...
How many times does the average user post?*/

/*so let's see the total number of photos/total number of users*/
SELECT round((SELECT count(photos.id) FROM photos)/(SELECT COUNT(users.id) FROM users),2)

/*user ranking by postings higher to lower*/

SELECT users.username, count(photos.image_url) AS total_post
FROM photos 
INNER JOIN users
ON users.id = photos.user_id
GROUP BY users.username
ORDER BY 2 DESC

/*total numbers of users who have posted at least one time */

SELECT count(DISTINCT photos.user_id) AS total_users_have_posted
FROM photos

/*A brand wants to know which hashtags to use in a post
What are the top 5 most commonly used hashtags?*/

SELECT TOP 5 tag_name, count(photo_tags.photo_id) AS total_tags
FROM tags
INNER JOIN photo_tags
ON tags.id = photo_tags.tag_id
GROUP BY tag_name
ORDER BY 2 DESC

/*We have a small problem with bots on our site...
Find users who have liked every single photo on the site*/
SELECT  users.id, count(likes.photo_id) AS total_likes_user
FROM users
INNER JOIN likes ON users.id = likes.user_id
GROUP BY users.id
HAVING count(likes.photo_id) = (SELECT count(photos.id) FROM photos)

/*We also have a problem with celebrities
Find users who have never commented on a photo*/

SELECT users.id , users.username 
FROM users 
LEFT JOIN comments
ON users.id = comments.user_id
WHERE comment_text is null

/*Are we overrun with bots and celebrity accounts?
Find the percentage of our users who have either never commented on a photo or have commented on every photo*/

SELECT (users_without_comments/(SELECT count(*) FROM users))*100 AS prc_users_without_comments, (users_commented_every_photos/(SELECT count(*) FROM users))*100 AS prc_users_commented_everypic FROM 
(SELECT count(*) AS users_without_comments FROM(
SELECT users.id , users.username 
FROM users 
LEFT JOIN comments
ON users.id = comments.user_id
WHERE comment_text is null) AS temp) AS m
,
(SELECT count(*) AS users_commented_every_photos FROM(
SELECT  users.id, count(comments.photo_id) AS total_likes_user
FROM users
inner join comments ON users.id = comments.user_id
GROUP BY users.id
HAVING count(comments.photo_id) = (SELECT count(photos.id) FROM photos)) AS temp1) AS n

