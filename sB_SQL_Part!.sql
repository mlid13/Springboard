* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */


select name,membercost from Facilities
where membercost <> 0;


/* Q2: How many facilities do not charge a fee to members? */

4 - Sql Code:

select count(name) from Facilities
where membercost = 0;


/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

select facid, name, membercost, monthlymaintenance
from Facilities
where membercost < monthlymaintenance *.2;


/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

select *
from Facilities
where facid in (1,5);


/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance,
CASE
    WHEN monthlymaintenance > 100 THEN 'expensive'
    WHEN monthlymaintenance < 100 THEN 'cheap'
    ELSE 'The Abyss'
END AS CheepOexp
FROM Facilities; 


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

select *
from Members
order by joinDate desc;


/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT Facilities.name,concat(Members.firstname,' ',Members.surname) as memName
FROM Facilities
inner join Bookings on Bookings.facid=Facilities.facid
inner join Members on Members.memid=Bookings.memid
where (Facilities.name like 'Tennis%')
order by memName


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT
    Facilities.name as 'Facility Name',
    CONCAT(Members.firstname,' ',Members.surname) as 'Member',
    CAST(starttime as DATE) as bookedDate,
    CASE
        WHEN Bookings.memid = 0 THEN Facilities.guestcost * slots
        ELSE Facilities.membercost * slots 
    END as cost
FROM
    Bookings
LEFT JOIN Facilities ON Facilities.facid = Bookings.facid
LEFT JOIN Members on Members.memid = Bookings.memid
WHERE (CASE
        WHEN Bookings.memid = 0 THEN Facilities.guestcost * slots
        ELSE Facilities.membercost * slots 
    END) > 30
    AND cast(starttime as DATE) = '2012-09-14';


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT
    Facilities.name as 'Facility Name',
    CONCAT(Members.firstname,' ',Members.surname) as 'Member',
    CAST(starttime as DATE) as bookedDate,
    cost
FROM
    (SELECT
        Bookings.facid,
        Bookings.memid,
        Facilities.name,
        Members.firstname,
        Members.surname,
        CAST(Bookings.starttime as DATE) as bookedDate,
        CASE
            WHEN Bookings.memid = 0 THEN Facilities.guestcost * Bookings.slots
            ELSE Facilities.membercost * Bookings.slots 
        END as cost
    FROM
        Bookings
    LEFT JOIN Facilities ON Facilities.facid = Bookings.facid
    LEFT JOIN Members on Members.memid = Bookings.memid
    WHERE 
        (CASE
            WHEN Bookings.memid = 0 THEN Facilities.guestcost * Bookings.slots
            ELSE Facilities.membercost * Bookings.slots 
        END) > 30
        AND CAST(Bookings.starttime as DATE) = '2012-09-14') AS subQuery
WHERE cost > 30;
