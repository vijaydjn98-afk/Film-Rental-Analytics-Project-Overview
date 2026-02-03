use sakila;
-- List the top 10 customers who spent the most money.
select * from customer;
select * from payment;
select p.customer_id, concat(c.first_name," ",c.last_name) as Full_name, sum(p.amount) as Total_spend
from customer c
left join payment p
on c.customer_id = p.customer_id
group by p.customer_id, Full_name
limit 10;
-- Find the number of active vs inactive customers.
SELECT active, COUNT(*) AS customer_count FROM customer GROUP BY active;
select Case
			When active = 1 then "Active"
            Else "Inactive"
		end as status,
        count(*) as customer_count
from customer
group by Status;
-- Show the average payment amount per customer.
select c.customer_id, concat(first_name," ",last_name)as Full_name, avg(p.amount) as Average_amount
from customer c
left join payment p
on c.customer_id = p.customer_id
group by c.customer_id, Full_name;
-- Which customers made the highest number of rentals?
select c.customer_id, concat(first_name," ",last_name) as Full_name,count(r.rental_id) as Number_of_rentals
from customer c
left join rental r
on c.customer_id = r.customer_id
group by c.customer_id, Full_name
order by Number_of_rentals desc
limit 10;
-- Find the most popular film category by rental count
select fc.category_id, c.name, count(r.rental_id) as Number_of_rental
from category c
join film_category fc
on c.category_id = fc.category_id
join film f
on fc.film_id = f.film_id
join inventory inv
on f.film_id = inv.film_id
join rental r
on inv.inventory_id = r.inventory_id
group by fc.category_id, c.name
order by Number_of_rental desc
limit 1;
select * from film_category;
select * from rental;
select * from film;
select * from inventory;
select * from category;
select * from payment;
-- Show the total revenue per film category.
select c.name, c.category_id, sum(p.amount) as Total_revenue
from category c
join film_category fc
on c.category_id = fc.category_id
join film f
on fc.film_id = f.film_id
join inventory i
on f.film_id = i.film_id
join rental r
on i.inventory_id = r.inventory_id
join payment p
on r.rental_id = p.rental_id
group by c.name, c.category_id
order by Total_revenue desc;
-- List films available in each language.
select * from film;
select * from language;
select f.title as Film_Title, l.language_id, l.name as Language
from film f
left join language l
on f.language_id = l.language_id
order by f.title;
-- Which category generates the highest average payment per rental?
select * from category;
select * from payment;
select * from rental;
select * from inventory;
select * from film;
select * from film_category;
select c.name as Category_Name, avg(p.amount) as Average_payment_per_rental
from category c
join film_category fc
on c.category_id = fc.category_id
join film f
on fc.film_id = f.film_id
join inventory i
on f.film_id = i.film_id
join rental r
on i.inventory_id = r.inventory_id
join payment p
on r.rental_id = p.rental_id
group by Category_Name
order by Average_payment_per_rental desc
limit 10;
-- Compare total revenue per store.  
select * from store;
select * from staff;
select * from payment;
select s.store_id as Store_number, sum(p.amount) as Total_Revenue
from store s
left join staff st
on s.store_id = st.store_id
right join payment p
on st.staff_id = p.staff_id
group by Store_number
order by Total_Revenue desc;
-- Find the top performing staff member (by revenue collected).
select * from staff;
select * from payment;
select concat(st.first_name," ", st.last_name) as Full_name, sum(p.amount) as Revenue_collection
from staff st
left join payment p
on st.staff_id = p.staff_id
group by Full_name
order by Revenue_collection desc
limit 10;
-- Show the number of customers per store.
select * from customer;
select * from store;
select c.store_id as Store, count(c.customer_id) as Customers_per_store
from store s
left join customer c
on s.store_id = c.store_id
group by Store;
-- Which store has the largest inventory?
select * from store;
select * from inventory;
select i.store_id as Store, count(i.inventory_id) as Inventory
from store s
right join inventory i
on s.store_id = i.store_id
group by Store
order by Inventory desc
limit 10;
-- Find the monthly revenue trend (group by month/year).
select * from rental;
select concat(extract(month from payment_date), "--", extract(year from payment_date)) as Months,
sum(amount) as Monthly_Revenue from payment group by Months;
-- Show the peak rental hours in a day.
select hour(rental_date) as Rental_hours, count(*) as Total_rentals
from rental group by Rental_hours order by Total_rentals desc;
-- Find the average rental duration per customer.
select r.customer_id,
avg(timestampdiff(hour, r.rental_date, r.return_date)) as Average_rental_duration
from rental r group by r.customer_id order by Average_rental_duration desc;
-- Which month had the highest number of rentals?
select count(rental_id) as Total_Rentals, month(rental_date) as Months from rental
group by Months
order by Total_Rentals desc
limit 10;
-- List customers name who rented films in multiple categories. 
select * from rental;
select * from customer;
select * from category;
select * from inventory;
select * from film_category;
select cu.customer_id, cu.first_name, cu.last_name, count(distinct  c.category_id) as Category_count
from category c
join film_category fc
on c.category_id = fc.category_id
join inventory i
on fc.film_id = i.film_id
join rental r
on i.inventory_id = r.inventory_id
join customer cu
on r.customer_id = cu.customer_id
group by cu.customer_id, cu.first_name, cu.last_name
having count(distinct  c.category_id) > 1
order by Category_count desc, cu.first_name, cu.last_name;
-- Find films rented by customers from a specific city. 
select * from rental;
SELECT cu.first_name, cu.last_name, ci.city, r.rental_date, f.title AS film_title 
FROM customer cu 
JOIN address a 
ON cu.address_id = a.address_id 
JOIN city ci 
ON a.city_id = ci.city_id 
JOIN rental r 
ON cu.customer_id = r.customer_id 
JOIN inventory i 
ON r.inventory_id = i.inventory_id 
JOIN film f 
ON i.film_id = f.film_id 
WHERE ci.city = 'York' 
ORDER BY cu.first_name, cu.last_name, f.title;
select * from city;
-- Show the top 5 countries by revenue.
select co.country, sum(py.amount) as Total_Revenue
from payment py
join customer cu
on py.customer_id = cu.customer_id
join address ad
on cu.address_id = ad.address_id
join city ci
on ad.city_id = ci.city_id
join country co
on ci.country_id = co.country_id
group by co.country_id
order by Total_Revenue desc;
-- Find the most common actor pairings (actors appearing together in films).
select ac1.actor_id AS actor1_id,
ac1.first_name AS actor1_first,
ac1.last_name AS actor1_last,
ac2.actor_id AS actor2_id,
ac2.first_name AS actor2_first,
ac2.last_name AS actor2_last,
COUNT(*) AS films_together
from film_actor fi1
join film_actor fi2
on fi1.film_id = fi2.film_id
and fi1.film_id < fi2.film_id
join actor ac1
on fi1.actor_id = ac1.actor_id
join actor ac2
on fi2.actor_id = ac2.actor_id
group by ac1.actor_id, ac2.actor_id, ac1.first_name, ac1.last_name, ac2.first_name, ac2.last_name
order by films_together
limit 10;


