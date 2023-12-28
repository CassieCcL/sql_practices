-- A movie theater gave you two tables: seats that are available for an 
-- upcoming screening and neighboring seats for each seat listed. 
-- You are asked to find all pairs of seats that are both adjacent and available.
-- Output only distinct pairs of seats in two columns such that the seat with the 
-- lower number is always in the first column and the one with the higher number 
-- is in the second column.

-- filter all the available seats numbers then join with theater_seatmap to find the corresponding seats next to it. Due to every seat showed up in seat_number, we just need to look for either the seats on the left or on the right
WITH available_seats AS (
    SELECT 
        theater_availability.seat_number,
        seat_right
    FROM 
        theater_availability
    JOIN 
        theater_seatmap
    ON 
        theater_availability.seat_number = theater_seatmap.seat_number
    WHERE 
        is_available = true
)
-- self join on different columns to find the available seats next to each available seat
SELECT 
    a.seat_number,
    b.seat_number AS next_available_seat
FROM 
    available_seats a
JOIN
    available_seats b 
ON 
    a.seat_right = b.seat_number