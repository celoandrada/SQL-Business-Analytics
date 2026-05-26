/* EXTRUCTA Database - Schema and Sample Data */

CREATE TABLE INGREDIENT
(
    IngID VARCHAR(10) NOT NULL,
    IngName VARCHAR(100) NOT NULL,
    PRIMARY KEY (IngID)
);

CREATE TABLE PRODUCT
(
    ProductID VARCHAR(10) NOT NULL,
    ProductName VARCHAR(100) NOT NULL,
    PRIMARY KEY (ProductID)
);

CREATE TABLE EMPLOYEE
(
    EmpID VARCHAR(10) NOT NULL,
    EmpName VARCHAR(100) NOT NULL,
    PRIMARY KEY (EmpID)
);

CREATE TABLE BATCH
(
    BatchID VARCHAR(10) NOT NULL,
    BatchDate DATE NOT NULL,
    NoOfUnits INT NOT NULL,
    ProductID VARCHAR(10) NOT NULL,
    EmpID VARCHAR(10) NOT NULL,
    PRIMARY KEY (BatchID),
    FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID),
    FOREIGN KEY (EmpID) REFERENCES EMPLOYEE(EmpID)
);

CREATE TABLE USES
(
    UQuantity FLOAT NOT NULL,
    IngID VARCHAR(10) NOT NULL,
    BatchID VARCHAR(10) NOT NULL,
    PRIMARY KEY (IngID, BatchID),
    FOREIGN KEY (IngID) REFERENCES INGREDIENT(IngID),
    FOREIGN KEY (BatchID) REFERENCES BATCH(BatchID)
);

CREATE TABLE SUPPLIER
(
    SupID VARCHAR(10) NOT NULL,
    SupType VARCHAR(100) NOT NULL,
    SupName VARCHAR(100) NOT NULL,
    ParentCoSupID VARCHAR(10),
    PRIMARY KEY (SupID),
    FOREIGN KEY (ParentCoSupID) REFERENCES SUPPLIER(SupID)
);

CREATE TABLE DELIVERY
(
    DeliveryID VARCHAR(10) NOT NULL,
    DeliveryDate DATE NOT NULL,
    SupID VARCHAR(10) NOT NULL,
    PRIMARY KEY (DeliveryID),
    FOREIGN KEY (SupID) REFERENCES SUPPLIER(SupID)
);

CREATE TABLE INCLUDES
(
    DQuantity FLOAT NOT NULL,
    DeliveryID VARCHAR(10) NOT NULL,
    IngID VARCHAR(10) NOT NULL,
    PRIMARY KEY (DeliveryID, IngID),
    FOREIGN KEY (DeliveryID) REFERENCES DELIVERY(DeliveryID),
    FOREIGN KEY (IngID) REFERENCES INGREDIENT(IngID)
);

/* INSERT DATA */

INSERT INTO ingredient VALUES ('I1','Milk');
INSERT INTO ingredient VALUES ('I2','Toffee');
INSERT INTO ingredient VALUES ('I3','Strawberry');
INSERT INTO ingredient VALUES ('I4','Blueberry');
INSERT INTO ingredient VALUES ('I5','Sugar');
INSERT INTO ingredient VALUES ('I6','Whey');
INSERT INTO ingredient VALUES ('I7','Honey');
INSERT INTO ingredient VALUES ('I8','Raspberry');

INSERT INTO product VALUES ('P1','Greek Greatness');
INSERT INTO product VALUES ('P2','Berry Blast');
INSERT INTO product VALUES ('P3','Tropical Bonanza');
INSERT INTO product VALUES ('P4','Strawberry Sunset');
INSERT INTO product VALUES ('P5','Hercules Protein');
INSERT INTO product VALUES ('P6','Creamy Classic');

INSERT INTO employee VALUES ('E1','Barry Constantine');
INSERT INTO employee VALUES ('E2','Alexandra Hayes');
INSERT INTO employee VALUES ('E3','Nicholas Lifka');
INSERT INTO employee VALUES ('E4','Agnes Egan');
INSERT INTO employee VALUES ('E5','Theo White');

INSERT INTO batch VALUES ('B1','2025-07-08',10,'P6','E2');
INSERT INTO batch VALUES ('B2','2025-07-09',3,'P4','E1');
INSERT INTO batch VALUES ('B3','2025-07-09',9,'P2','E1');
INSERT INTO batch VALUES ('B4','2025-07-10',8,'P1','E3');
INSERT INTO batch VALUES ('B5','2025-07-10',5,'P1','E5');

INSERT INTO uses VALUES (20,'I1','B1');
INSERT INTO uses VALUES (12,'I1','B2');
INSERT INTO uses VALUES (2,'I3','B2');
INSERT INTO uses VALUES (18,'I1','B3');
INSERT INTO uses VALUES (3,'I3','B3');
INSERT INTO uses VALUES (3,'I4','B3');
INSERT INTO uses VALUES (3,'I8','B3');
INSERT INTO uses VALUES (20,'I1','B4');
INSERT INTO uses VALUES (3,'I7','B4');
INSERT INTO uses VALUES (15,'I1','B5');
INSERT INTO uses VALUES (2,'I5','B5');

INSERT INTO supplier VALUES ('S1','Milk Farm','All-American Milk', NULL);
INSERT INTO supplier VALUES ('S2','Sugar Producer','United Brazilian Sugar', NULL);
INSERT INTO supplier VALUES ('S3','Fruit Grower','Tropical Taste Partners', NULL);
INSERT INTO supplier VALUES ('S4','Fruit Grower','Sunbelt Cooperative', NULL);
INSERT INTO supplier VALUES ('S5','Milk Farm','Pleasant Prairie Inc','S1');
INSERT INTO supplier VALUES ('S6','Sugar Producer','Honey Harvest Co','S2');
INSERT INTO supplier VALUES ('S7','Milk Farm','Udder Delights LP','S1');

INSERT INTO delivery VALUES ('D1','2025-07-01','S1');
INSERT INTO delivery VALUES ('D2','2025-07-02','S3');
INSERT INTO delivery VALUES ('D3','2025-07-03','S2');
INSERT INTO delivery VALUES ('D4','2025-07-05','S1');
INSERT INTO delivery VALUES ('D5','2025-07-05','S4');
INSERT INTO delivery VALUES ('D6','2025-07-08','S6');

INSERT INTO includes VALUES (20,'D1','I1');
INSERT INTO includes VALUES (7,'D2','I3');
INSERT INTO includes VALUES (3,'D2','I8');
INSERT INTO includes VALUES (3,'D2','I4');
INSERT INTO includes VALUES (5,'D3','I5');
INSERT INTO includes VALUES (25,'D4','I1');
INSERT INTO includes VALUES (3,'D5','I8');
INSERT INTO includes VALUES (3,'D5','I4');
INSERT INTO includes VALUES (2,'D6','I5');
INSERT INTO includes VALUES (6,'D6','I7');
INSERT INTO includes VALUES (20,'D6','I1');


/* Marcelo Batista, HW9 */


/* Query 5.3.4 */
/* Find ingredients with names ending in berry */

SELECT IngID, IngName
FROM Ingredient
WHERE IngName LIKE '%berry'
ORDER BY IngID;


/* Query 5.3.5 */
/* Count how many batches each employee managed */

SELECT EmpID,
       COUNT(*) AS NumberOfBatchesManaged
FROM Batch
GROUP BY EmpID
ORDER BY EmpID;


/* Query 5.3.7 */
/* Show berry-related ingredient deliveries with supplier information */

SELECT i.DeliveryID,
       ing.IngName,
       sup.SupName,
       i.DQuantity
FROM Includes i
JOIN Ingredient ing
ON ing.IngID = i.IngID
JOIN Delivery d
ON d.DeliveryID = i.DeliveryID
JOIN Supplier sup
ON sup.SupID = d.SupID
WHERE ing.IngName LIKE '%berry'
ORDER BY i.DeliveryID, ing.IngName;


/* Query 5.3.8 */
/* Count the number of ingredients used in each batch */

SELECT b.BatchID,
       b.BatchDate,
       COUNT(u.IngID) AS NumberOfIngredients
FROM Batch b
LEFT JOIN Uses u
ON u.BatchID = b.BatchID
GROUP BY b.BatchID, b.BatchDate
ORDER BY b.BatchID;


/* Query 5.3.9 */
/* Find batches that use more than one ingredient */

SELECT b.BatchID,
       b.BatchDate,
       COUNT(u.IngID) AS NumberOfIngredients
FROM Batch b
JOIN Uses u
ON u.BatchID = b.BatchID
GROUP BY b.BatchID, b.BatchDate
HAVING COUNT(u.IngID) > 1
ORDER BY b.BatchID;


/* Query 5.3.10 */
/* Find the batch with the highest number of units produced */

SELECT BatchID,
       BatchDate,
       NoOfUnits
FROM Batch
WHERE NoOfUnits = (
    SELECT MAX(NoOfUnits)
    FROM Batch
);


/* Query 5.3.11 */
/* Find suppliers whose parent company is a milk farm */

SELECT s.SupName
FROM Supplier s
JOIN Supplier parent
ON s.ParentCoSupID = parent.SupID
WHERE parent.SupType = 'Milk Farm'
ORDER BY s.SupName;


/* Query 5.3.14 */
/* Show products and their related production batches */

SELECT p.ProductID,
       p.ProductName,
       b.BatchID,
       b.BatchDate,
       b.NoOfUnits
FROM Product p
JOIN Batch b
ON b.ProductID = p.ProductID
ORDER BY p.ProductID, b.BatchID;


/* Query 5.3.15 */
/* Show all products, including products without batches */

SELECT p.ProductID,
       p.ProductName,
       b.BatchID,
       b.BatchDate,
       b.NoOfUnits
FROM Product p
LEFT JOIN Batch b
ON b.ProductID = p.ProductID
ORDER BY p.ProductID, b.BatchID;


/* Query 5.3.17 */
/* Find ingredients that were never included in any delivery */

SELECT IngID,
       IngName
FROM Ingredient
WHERE IngID NOT IN (
    SELECT IngID
    FROM Includes
)
ORDER BY IngID;


/* Query 5.3.18 */
/* Count how many batches were produced for each product */

SELECT p.ProductID,
       p.ProductName,
       COUNT(b.BatchID) AS NumberOfBatches
FROM Product p
LEFT JOIN Batch b
ON b.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY p.ProductID;
