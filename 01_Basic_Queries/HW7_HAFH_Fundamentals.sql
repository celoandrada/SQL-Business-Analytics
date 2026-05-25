/* HAFH - CREATE TABLE statements Ed 3.0 */

CREATE TABLE manager
(
    managerid CHAR(4) NOT NULL,
    mfname VARCHAR(15) NOT NULL,
    mlname VARCHAR(15) NOT NULL,
    mbdate DATE NOT NULL,
    msalary NUMERIC(9,2) NOT NULL,
    mbonus NUMERIC(9,2),
    mresbuildingid CHAR(3),
    PRIMARY KEY (managerid)
);

CREATE TABLE managerphone
(
    managerid CHAR(4) NOT NULL,
    mphone CHAR(11) NOT NULL,
    PRIMARY KEY (managerid, mphone),
    FOREIGN KEY (managerid)
    REFERENCES manager(managerid)
);

CREATE TABLE building
(
    buildingid CHAR(3) NOT NULL,
    bnooffloors INT NOT NULL,
    bmanagerid CHAR(4) NOT NULL,
    PRIMARY KEY (buildingid),
    FOREIGN KEY (bmanagerid)
    REFERENCES manager(managerid)
);

CREATE TABLE inspector
(
    insid CHAR(3) NOT NULL,
    insname VARCHAR(15) NOT NULL,
    PRIMARY KEY (insid)
);

CREATE TABLE inspecting
(
    insid CHAR(3) NOT NULL,
    buildingid CHAR(3) NOT NULL,
    datelast DATE NOT NULL,
    datenext DATE NOT NULL,
    PRIMARY KEY (insid, buildingid),
    FOREIGN KEY (insid)
    REFERENCES inspector(insid),
    FOREIGN KEY (buildingid)
    REFERENCES building(buildingid)
);

CREATE TABLE corpclient
(
    ccid CHAR(4) NOT NULL,
    ccname VARCHAR(25) NOT NULL,
    ccindustry VARCHAR(25) NOT NULL,
    cclocation VARCHAR(25) NOT NULL,
    ccidreferredby CHAR(4),
    PRIMARY KEY (ccid),
    UNIQUE(ccname),
    FOREIGN KEY (ccidreferredby)
    REFERENCES corpclient(ccid)
);

CREATE TABLE apartment
(
    buildingid CHAR(3) NOT NULL,
    aptno CHAR(5) NOT NULL,
    anoofbedrooms INT NOT NULL,
    ccid CHAR(4),
    PRIMARY KEY (buildingid, aptno),
    FOREIGN KEY (buildingid)
    REFERENCES building(buildingid),
    FOREIGN KEY (ccid)
    REFERENCES corpclient(ccid)
);

CREATE TABLE staffmember
(
    smemberid CHAR(4) NOT NULL,
    smembername VARCHAR(15) NOT NULL,
    PRIMARY KEY (smemberid)
);

CREATE TABLE cleaning
(
    buildingid CHAR(3) NOT NULL,
    aptno CHAR(5) NOT NULL,
    smemberid CHAR(4) NOT NULL,

    CONSTRAINT cleaningpk
    PRIMARY KEY (buildingid, aptno, smemberid),

    CONSTRAINT cleaningfk1
    FOREIGN KEY (buildingid, aptno)
    REFERENCES apartment(buildingid, aptno),

    CONSTRAINT cleaningfk2
    FOREIGN KEY (smemberid)
    REFERENCES staffmember(smemberid)
);

/* INSERT DATA */

INSERT INTO manager VALUES
('M12','Boris','Grant','6/Jun/1988',60000,NULL,NULL);

INSERT INTO manager VALUES
('M23','Austin','Lee','2/Feb/1983',50000,5000,NULL);

INSERT INTO manager VALUES
('M34','George','Sherman','8/July/1984',52000,2000,NULL);

INSERT INTO managerphone VALUES
('M12','555-2222');

INSERT INTO managerphone VALUES
('M12','555-3232');

INSERT INTO managerphone VALUES
('M23','555-9988');

INSERT INTO managerphone VALUES
('M34','555-9999');

INSERT INTO building VALUES
('B1',5,'M12');

INSERT INTO building VALUES
('B2',6,'M23');

INSERT INTO building VALUES
('B3',4,'M23');

INSERT INTO building VALUES
('B4',4,'M34');

INSERT INTO inspector VALUES
('I11','Jane');

INSERT INTO inspector VALUES
('I22','Niko');

INSERT INTO inspector VALUES
('I33','Mick');

INSERT INTO inspecting VALUES
('I11','B1','5/May/2025','5/May/2026');

INSERT INTO inspecting VALUES
('I11','B2','2/Feb/2025','2/Feb/2026');

INSERT INTO corpclient VALUES
('C111','BlingNotes','Music','Chicago',NULL);

INSERT INTO corpclient VALUES
('C222','SkyJet','Airline','Oak Park','C111');

INSERT INTO apartment VALUES
('B1','21',1,'C111');

INSERT INTO apartment VALUES
('B1','41',1,NULL);

INSERT INTO staffmember VALUES
('5432','Brian');

INSERT INTO staffmember VALUES
('9876','Boris');

INSERT INTO staffmember VALUES
('7652','Caroline');

INSERT INTO cleaning VALUES
('B1','21','5432');

INSERT INTO cleaning VALUES
('B1','41','9876');

ALTER TABLE manager
ADD CONSTRAINT fkresidesin
FOREIGN KEY (mresbuildingid)
REFERENCES building(buildingid);

UPDATE manager
SET mresbuildingid='B1'
WHERE managerid='M12';

UPDATE manager
SET mresbuildingid='B2'
WHERE managerid='M23';

UPDATE manager
SET mresbuildingid='B4'
WHERE managerid='M34';

ALTER TABLE manager
ALTER COLUMN mresbuildingid
SET NOT NULL;

/* Marcelo Batista, HW7 */

/* Query 5.2.1 */
/* Display all staff members */

SELECT *
FROM staffmember;


/* Query 5.2.2 */
/* Show building IDs and number of floors */

SELECT BuildingID, bnooffloors
FROM building;


/* Query 5.2.3 */
/* Display corporate clients alphabetically */

SELECT CCID, CCName, CCIndustry
FROM corpclient
ORDER BY CCName ASC;


/* Query 5.2.4 */
/* Find staff members whose names begin with B */

SELECT *
FROM staffmember
WHERE SMemberName LIKE 'B%';


/* Query 5.2.5 */
/* Show apartments with more than one bedroom */

SELECT BuildingID, aptno, anoofbedrooms
FROM apartment
WHERE anoofbedrooms > 1
ORDER BY BuildingID, aptno;


/* Query 5.2.6 */
/* Count buildings that have four floors */

SELECT COUNT(*) AS NumberofBuildingsWith4Floors
FROM Building
WHERE bnooffloors = 4;


/* Query 5.2.7 */
/* Calculate total manager salary and bonus amounts */

SELECT SUM(msalary) AS TotalSalary,
       SUM(mbonus) AS TotalBonus
FROM manager;


/* Query 5.2.8 */
/* Find managers earning above 50000 salary with bonus above 1000 */

SELECT ManagerID,
       MFName,
       MLName,
       MSalary,
       MBonus
FROM manager
WHERE msalary > 50000
AND mbonus > 1000;


/* Query 5.2.9 */
/* Match buildings with their assigned managers */

SELECT b.buildingID,
       b.bnooffloors,
       m.mfname,
       m.mlname
FROM building AS b
JOIN manager AS m
ON b.bmanagerid = m.managerid
ORDER BY buildingID;


/* Query 5.2.10 */
/* Count managed buildings for lower salary managers */

SELECT m.managerid,
       m.mfname,
       m.mlname,
       m.msalary,
       COUNT(b.buildingid) AS NumberOfManagedBuildings
FROM manager AS m
LEFT JOIN building AS b
ON b.bmanagerid = m.managerid
WHERE m.msalary < 55000
GROUP BY m.managerid,
         m.mfname,
         m.mlname,
         m.msalary
ORDER BY m.managerid;
