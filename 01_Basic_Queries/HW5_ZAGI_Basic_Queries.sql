/* ZAGI - CREATE TABLE statements Ed 3.0 */

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

/* Marcelo Batista, HW5 */

/* Query 5.1.2 */
/* Display all store IDs and zip codes */

SELECT storeid, storezip
FROM store;


/* Query 5.1.3 */
/* List customers alphabetically with their zip codes */

SELECT customername, customerzip
FROM customer
ORDER BY customername;


/* Query 5.1.4 */
/* Show products sorted from highest to lowest price */

SELECT productid, productname, productprice
FROM product
ORDER BY productprice DESC;


/* Query 5.1.5 */
/* Find unique operating regions */

SELECT DISTINCT regionid
FROM store
ORDER BY regionid;


/* Query 5.1.6 */
/* Find stores located in region C */

SELECT *
FROM store
WHERE regionid = 'C'
ORDER BY storeid;


/* Query 5.1.7 */
/* Show products purchased in transaction T555 */

SELECT productid, quantity
FROM includes
WHERE tid = 'T555'
ORDER BY productid;


/* Query 5.1.8 */
/* Find customers whose names start with T */

SELECT customerid, customername
FROM customer
WHERE customername LIKE 'T%'
ORDER BY customerid;


/* Query 5.1.9 */
/* Find products containing letter y */

SELECT productid, productname
FROM product
WHERE productname LIKE '%y%'
ORDER BY productid;


/* Query 5.1.10 */
/* Show products priced at $100 or more */

SELECT productid, productname, vendorid, categoryid
FROM product
WHERE productprice >= 100
ORDER BY productid;


/* Query 5.1.11 */
/* Find Mountain King footwear products */

SELECT productid, productname, productprice
FROM product
WHERE vendorid = 'MK'
AND categoryid = 'FW'
ORDER BY productid;
