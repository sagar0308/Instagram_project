use database ig_clone;

/*We want to reward our users who have been around the longest.  
Find the 5 oldest users.*/

select t.id,t.username from
(select *,
row_number() over(order by created_at) as ranking
from users) t
where t.ranking <6;
---------- ----- -----  or ----------- ----- ----- ----- 
SELECT * FROM users
ORDER BY created_at
LIMIT 5;


/*What day of the week do most users register on?
We need to figure out when to schedule an ad campgain*/
select * from users;

select dayname(CREATED_AT) week_days,count(*) as cnt
from users
group by week_days
order by cnt desc;
-- it's Thu & Sun

/*We want to target our inactive users with an email campaign.
Find the users who have never posted a photo*/
select * from photos;

select us.id,us.username,ph.user_id 
from users us
left outer join photos ph
on us.id = ph.user_id
where ph.user_id is null;

/*We're running a new contest to see who can get the most likes on a single photo.
WHO WON??!!*/
select * from likes limit 10;
select * from photos limit 10;

select photo_id, count(*) as total_likes
from likes
inner join photos
on likes.user_id = photos.user_id
group by photo_id
order by total_likes desc;
---photo_id 127 has maximum likes 95, followed by ID 145 with total likes 91.


/*Our Investors want to know...
How many times does the average user post?*/
/*total number of photos/total number of users*/
select round((select count(*) from photos)/(select count(*) from users),2) as avg_user_post;
---An avg user post approx. 2.57 times.

/*user ranking by postings higher to lower*/
select u.username, count(p.image_url) as total_post 
from users u
inner join photos p
on u.id = p.user_id
group by u.username
order by total_post desc;
---Eveline95,Clint27,Cesar93 total post 12,11,10  respectively


/*total numbers of users who have posted at least one time */

SELECT COUNT(DISTINCT(users.id)) AS total_number_of_users_with_posts
FROM users
inner JOIN photos ON users.id = photos.user_id;
---there are 74 users who have posted at least once

/*A brand wants to know which hashtags to use in a post
What are the top 5 most commonly used hashtags?*/
select tg.tag_name,count(*) as total_count
from photo_tags pt
inner join tags tg
on pt.tag_id = tg.id
group by 1
order by 2 desc limit 5;


/*We have a small problem with bots on our site...
Find users who have liked every single photo on the site*/
select u.id,username,count(*) total_likes_by_user
from users u
inner join likes l
on u.id = l.user_id
group by 1,2
having total_likes_by_user = (select count(*) from photos);

/*We also have a problem with celebrities
Find users who have never commented on a photo*/
select u.id,u.username
from users u
left outer join comments c
on u.id=c.user_id
where c.comment_text is null;

/*Are we overrun with bots and celebrity accounts?
Find the percentage of our users who have either never commented on a photo or have commented on every photo*/

