create database if not exists minitest;
use minitest;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS guests;

-- Bảng khách hàng
CREATE TABLE guests
(
    guest_id   INT PRIMARY KEY AUTO_INCREMENT,
    guest_name VARCHAR(100),
    phone      VARCHAR(20)
);

-- Bảng phòng
CREATE TABLE rooms
(
    room_id       INT PRIMARY KEY AUTO_INCREMENT,
    room_type     VARCHAR(50),
    price_per_day DECIMAL(10, 0)
);

-- Bảng đặt phòng
CREATE TABLE bookings
(
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id   INT,
    room_id    INT,
    check_in   DATE,
    check_out  DATE,
    FOREIGN KEY (guest_id) REFERENCES guests (guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms (room_id)
);

INSERT INTO guests (guest_name, phone)
VALUES ('Nguyễn Văn An', '0901111111'),
       ('Trần Thị Bình', '0902222222'),
       ('Lê Văn Cường', '0903333333'),
       ('Phạm Thị Dung', '0904444444'),
       ('Hoàng Văn Em', '0905555555');

INSERT INTO rooms (room_type, price_per_day)
VALUES ('Standard', 500000),
       ('Standard', 500000),
       ('Deluxe', 800000),
       ('Deluxe', 800000),
       ('VIP', 1500000),
       ('VIP', 2000000);

INSERT INTO bookings (guest_id, room_id, check_in, check_out)
VALUES (1, 1, '2024-01-10', '2024-01-12'),
       (1, 3, '2024-03-05', '2024-03-10'),
       (2, 2, '2024-02-01', '2024-02-03'),
       (2, 5, '2024-04-15', '2024-04-18'),
       (3, 4, '2023-12-20', '2023-12-25'),
       (3, 6, '2024-05-01', '2024-05-06'),
       (4, 1, '2024-06-10', '2024-06-11');

select guests.guest_name, guests.guest_name
from guests;
select room_type
from rooms
group by room_type;
select *
from rooms
order by price_per_day asc;
select *
from rooms
where price_per_day > 1000000;
select *
from bookings
where year(check_in) = 2024;
select r.room_type,
       (select count(*)
        from bookings
        where room_id = r.room_id) as count
from rooms r;
SELECT
    g.guest_name,
    GROUP_CONCAT(r.room_type SEPARATOR ', ') AS room_types,group_concat(b.check_in separator ',') as date
FROM bookings b
INNER JOIN guests g ON b.guest_id = g.guest_id
INNER JOIN rooms r ON b.room_id = r.room_id
GROUP BY g.guest_id, g.guest_name;
SELECT
    r.room_type,
    SUM(r.price_per_day * DATEDIFF(b.check_out, b.check_in)) AS total_price
FROM bookings b
JOIN rooms r ON b.room_id = r.room_id
GROUP BY r.room_type;
SELECT
    g.guest_id,
    g.guest_name,
    COUNT(b.booking_id) AS total_bookings
FROM guests g
JOIN bookings b ON g.guest_id = b.guest_id
GROUP BY g.guest_id, g.guest_name
HAVING COUNT(b.booking_id) >= 2;
SELECT
    r.room_type,
    COUNT(b.booking_id) AS total_bookings
FROM bookings b
JOIN rooms r ON b.room_id = r.room_id
GROUP BY r.room_type
ORDER BY total_bookings DESC
LIMIT 1;