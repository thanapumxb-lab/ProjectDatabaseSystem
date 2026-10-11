select * from Customer
select * from Employee
select * from Car
select * from CarType
select * from Rental
select * from Receipt


-- ค้นหารถที่พร้อมปล่อยเช่า (ไม่ติดสัญญา Active)
SELECT 
    car_id AS 'รหัสรถ', 
    license_plate AS 'ทะเบียน', 
    brand AS 'ยี่ห้อ', 
    Models AS 'รุ่น',
    rental_rate AS 'ราคา/วัน'
FROM Car
WHERE car_id NOT IN (
    SELECT car_id FROM Rental WHERE status = 'Active'
);

-- คำนวณยอดชำระเงินของใบเสร็จแต่ละใบ
SELECT 
    rc.receipt_id AS 'เลขใบเสร็จ',
    c.name AS 'ชื่อลูกค้า',
    rc.daily_rate AS 'เรทที่เช่า',
    rc.rent_days AS 'เช่า(วัน)',
    rc.late_fee AS 'ค่าปรับ',
    (rc.daily_rate * rc.rent_days) + rc.late_fee AS 'ยอดชำระจริงสุทธิ'
FROM Receipt rc
JOIN Rental r ON rc.rental_id = r.rental_id
JOIN Customer c ON r.customer_id = c.customer_id;

--การวิเคราะห์รายได้ของรถแต่ละประเภท
SELECT 
    ct.type_name AS 'ประเภทรถ',
    COUNT(rc.receipt_id) AS 'จำนวนครั้งที่ถูกเช่า',
    SUM((rc.daily_rate * rc.rent_days) + rc.late_fee) AS 'รายได้รวมทั้งหมด (บาท)'
FROM Receipt rc
JOIN Rental r ON rc.rental_id = r.rental_id
JOIN Car car ON r.car_id = car.car_id
JOIN CarType ct ON car.type_id = ct.type_id
GROUP BY ct.type_name
ORDER BY 'รายได้รวมทั้งหมด (บาท)' DESC;


