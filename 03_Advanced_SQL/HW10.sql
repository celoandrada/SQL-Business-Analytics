/* ZAGI Database - Schema and Sample Data */

CREATE TABLE vendor
(
    vendorid CHAR(2) NOT NULL,
    vendorname VARCHAR(25) NOT NULL,
    PRIMARY KEY (vendorid)
);

CREATE TABLE category
(
    categoryid CHAR(2) NOT NULL,
    categoryname VARCHAR(25) NOT NULL,
    PRIMARY KEY (categoryid)
);

CREATE TABLE product
(
    productid CHAR(3) NOT NULL,
    productname VARCHAR(25) NOT NULL,
    productprice NUMERIC(7,2) NOT NULL,
    vendorid CHAR(2) NOT NULL,
    categoryid CHAR(2) NOT NULL,
    PRIMARY KEY (productid),
    FOREIGN KEY (vendorid) REFERENCES vendor(vendorid),
    FOREIGN KEY (categoryid) REFERENCES category(categoryid)
);

CREATE TABLE region
(
    regionid CHAR(1) NOT NULL,
    regionname VARCHAR(25) NOT NULL,
    PRIMARY KEY (regionid)
);

CREATE TABLE store
(
    storeid VARCHAR(3) NOT NULL,
    storezip CHAR(5) NOT NULL,
    regionid CHAR(1) NOT NULL,
    PRIMARY KEY (storeid),
    FOREIGN KEY (regionid) REFERENCES region(regionid)
);

CREATE TABLE customer
(
    customerid CHAR(7) NOT NULL,
    customername VARCHAR(15) NOT NULL,
    customerzip CHAR(5) NOT NULL,
    PRIMARY KEY (customerid)
);

CREATE TABLE salestransaction
(
    tid VARCHAR(8) NOT NULL,
    customerid CHAR(7) NOT NULL,
    storeid VARCHAR(3) NOT NULL,
    tdate DATE NOT NULL,
    PRIMARY KEY (tid),
    FOREIGN KEY (customerid) REFERENCES customer(customerid),
    FOREIGN KEY (storeid) REFERENCES store(storeid)
);

CREATE TABLE includes
(
    productid CHAR(3) NOT NULL,
    tid VARCHAR(8) NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (productid, tid),
    FOREIGN KEY (productid) REFERENCES product(productid),
    FOREIGN KEY (tid) REFERENCES salestransaction(tid)
);

/* INSERT DATA */

INSERT INTO vendor VALUES ('PG','Pacifica Gear');
INSERT INTO vendor VALUES ('MK','Mountain King');

INSERT INTO category VALUES ('CP','Camping');
INSERT INTO category VALUES ('FW','Footwear');

INSERT INTO product VALUES ('1X1','Zzz Bag',100,'PG','CP');
INSERT INTO product VALUES ('2X2','Easy Boot',70,'MK','FW');
INSERT INTO product VALUES ('3X3','Cosy Sock',15,'MK','FW');
INSERT INTO product VALUES ('4X4','Dura Boot',90,'PG','FW');
INSERT INTO product VALUES ('5X5','Tiny Tent',150,'MK','CP');
INSERT INTO product VALUES ('6X6','Biggy Tent',250,'MK','CP');

INSERT INTO region VALUES ('C','Chicagoland');
INSERT INTO region VALUES ('T','Tristate');

INSERT INTO store VALUES ('S1','60600','C');
INSERT INTO store VALUES ('S2','60605','C');
INSERT INTO store VALUES ('S3','35400','T');

INSERT INTO customer VALUES ('1-2-333','Tina','60137');
INSERT INTO customer VALUES ('2-3-444','Tony','60605');
INSERT INTO customer VALUES ('3-4-555','Pam','35400');

INSERT INTO salestransaction VALUES ('T111','1-2-333','S1','01/Jan/2025');
INSERT INTO salestransaction VALUES ('T222','2-3-444','S2','01/Jan/2025');
INSERT INTO salestransaction VALUES ('T333','1-2-333','S1','02/Jan/2025');
INSERT INTO salestransaction VALUES ('T444','3-4-555','S3','02/Jan/2025');
INSERT INTO salestransaction VALUES ('T555','2-3-444','S3','02/Jan/2025');

INSERT INTO includes VALUES ('1X1','T111',1);
INSERT INTO includes VALUES ('2X2','T222',1);
INSERT INTO includes VALUES ('3X3','T333',5);
INSERT INTO includes VALUES ('1X1','T333',1);
INSERT INTO includes VALUES ('4X4','T444',1);
INSERT INTO includes VALUES ('2X2','T444',2);
INSERT INTO includes VALUES ('4X4','T555',4);
INSERT INTO includes VALUES ('5X5','T555',2);
INSERT INTO includes VALUES ('6X6','T555',1);


/* Marcelo Batista, HW10 */


/* Query 5.1.17 */
/* Find Pacifica Gear products sold at stores in zip code 60600 */

SELECT DISTINCT
       p.productid,
       p.productname,
       p.productprice
FROM product p
JOIN vendor v
ON p.vendorid = v.vendorid
JOIN includes i
ON i.productid = p.productid
JOIN salestransaction s
ON s.tid = i.tid
JOIN store st
ON st.storeid = s.storeid
WHERE v.vendorname = 'Pacifica Gear'
AND st.storezip = '60600'
ORDER BY p.productid;


/* Query 5.1.22 */
/* Calculate total number of items purchased by category */

SELECT
       c.categoryid,
       SUM(i.quantity) AS NumberOfItemsPurchased
FROM category c
JOIN product p
ON p.categoryid = c.categoryid
JOIN includes i
ON i.productid = p.productid
GROUP BY c.categoryid
ORDER BY c.categoryid;


/* Query 5.1.25 */
/* Find vendors with total sales greater than 700 */

SELECT
       v.vendorid,
       v.vendorname,
       SUM(i.quantity * p.productprice) AS TotalSales
FROM vendor v
JOIN product p
ON p.vendorid = v.vendorid
JOIN includes i
ON i.productid = p.productid
GROUP BY v.vendorid, v.vendorname
HAVING SUM(i.quantity * p.productprice) > 700;


/* Query 5.1.28 */
/* Compare each product price to the most expensive product */

SELECT
       p.productid,
       p.productname,
       p.productprice,
       (
           (SELECT MAX(productprice) FROM product)
           - p.productprice
       ) AS PriceDifferenceFromMostExpensive
FROM product p
ORDER BY p.productprice;


/* Query 5.1.29 */
/* Find stores where customers purchased from a store in their own zip code */

SELECT DISTINCT
       s.storeid,
       s.storezip,
       s.regionid
FROM store s
JOIN salestransaction t
ON t.storeid = s.storeid
JOIN customer c
ON c.customerid = t.customerid
WHERE c.customerzip = s.storezip
ORDER BY s.storeid;


/* Query 5.1.30 */
/* Find stores without purchases from customers in the same zip code */

SELECT
       s.storeid,
       s.storezip,
       s.regionid
FROM store s
WHERE s.storeid NOT IN
(
    SELECT DISTINCT s2.storeid
    FROM store s2
    JOIN salestransaction t2
    ON t2.storeid = s2.storeid
    JOIN customer c2
    ON c2.customerid = t2.customerid
    WHERE c2.customerzip = s2.storezip
)
ORDER BY s.storeid;


/* Query 5.1.31 */
/* Find products with more than two total units sold */

SELECT
       p.productid,
       p.productname
FROM product p
JOIN includes i
ON i.productid = p.productid
GROUP BY p.productid, p.productname
HAVING SUM(i.quantity) > 2
ORDER BY p.productid;


/* Query 5.1.33 */
/* List all zip codes where the business operates through stores or customers */

SELECT ZipCodesOfOperation
FROM
(
      SELECT storezip AS ZipCodesOfOperation
      FROM store
      UNION
      SELECT customerzip
      FROM customer
) AS z
ORDER BY ZipCodesOfOperation;


/* Query 5.1.34 */
/* Find zip codes that have both stores and customers */

SELECT ZipCodesWithStoresAndCustomers
FROM
(
      SELECT storezip AS ZipCodesWithStoresAndCustomers
      FROM store
      INTERSECT
      SELECT customerzip
      FROM customer
) AS z
ORDER BY ZipCodesWithStoresAndCustomers;


/* Query 5.1.38 */
/* Show each product with the average product price in its category */

SELECT
       p.productid,
       p.productname,
       p.productprice,
       p.categoryid,
       (
           SELECT AVG(p2.productprice)
           FROM product p2
           WHERE p2.categoryid = p.categoryid
       ) AS Avg_P_Price_Per_Category
FROM product p
ORDER BY p.categoryid, p.productid;


/* Query 5.1.39 */
/* Rank products from highest to lowest price */

SELECT
       p1.productid,
       p1.productname,
       p1.productprice,
       p1.vendorid,
       1 +
       (
           SELECT COUNT(*)
           FROM product p2
           WHERE p2.productprice > p1.productprice
       ) AS RankByPriceHighToLow
FROM product p1
ORDER BY RankByPriceHighToLow;
