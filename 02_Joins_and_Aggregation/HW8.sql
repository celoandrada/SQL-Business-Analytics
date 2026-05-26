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
PRIMARY KEY (managerid,mphone),
FOREIGN KEY(managerid)
REFERENCES manager(managerid)
);

CREATE TABLE building
(
buildingid CHAR(3) NOT NULL,
bnooffloors INT NOT NULL,
bmanagerid CHAR(4) NOT NULL,
PRIMARY KEY(buildingid),
FOREIGN KEY(bmanagerid)
REFERENCES manager(managerid)
);

CREATE TABLE inspector
(
insid CHAR(3) NOT NULL,
insname VARCHAR(15) NOT NULL,
PRIMARY KEY(insid)
);

CREATE TABLE inspecting
(
insid CHAR(3) NOT NULL,
buildingid CHAR(3) NOT NULL,
datelast DATE NOT NULL,
datenext DATE NOT NULL,
PRIMARY KEY(insid,buildingid),

FOREIGN KEY(insid)
REFERENCES inspector(insid),

FOREIGN KEY(buildingid)
REFERENCES building(buildingid)
);

CREATE TABLE corpclient
(
ccid CHAR(4) NOT NULL,
ccname VARCHAR(25) NOT NULL,
ccindustry VARCHAR(25) NOT NULL,
cclocation VARCHAR(25) NOT NULL,
ccidreferredby CHAR(4),

PRIMARY KEY(ccid),

UNIQUE(ccname),

FOREIGN KEY(ccidreferredby)
REFERENCES corpclient(ccid)
);

CREATE TABLE apartment
(
buildingid CHAR(3) NOT NULL,
aptno CHAR(5) NOT NULL,
anoofbedrooms INT NOT NULL,
ccid CHAR(4),

PRIMARY KEY(buildingid,aptno),

FOREIGN KEY(buildingid)
REFERENCES building(buildingid),

FOREIGN KEY(ccid)
REFERENCES corpclient(ccid)
);

CREATE TABLE staffmember
(
smemberid CHAR(4) NOT NULL,
smembername VARCHAR(15) NOT NULL,

PRIMARY KEY(smemberid)
);

CREATE TABLE cleaning
(
buildingid CHAR(3) NOT NULL,
aptno CHAR(5) NOT NULL,
smemberid CHAR(4) NOT NULL,

CONSTRAINT cleaningpk
PRIMARY KEY(buildingid,aptno,smemberid),

CONSTRAINT cleaningfk1
FOREIGN KEY(buildingid,aptno)
REFERENCES apartment(buildingid,aptno),

CONSTRAINT cleaningfk2
FOREIGN KEY(smemberid)
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

INSERT INTO inspecting VALUES
('I22','B2','3/Apr/2025','2/Feb/2026');

INSERT INTO inspecting VALUES
('I22','B3','9/Aug/2025','3/Mar/2026');

INSERT INTO inspecting VALUES
('I33','B3','4/Apr/2025','4/Apr/2026');

INSERT INTO inspecting VALUES
('I33','B4','5/May/2025','4/Apr/2026');

INSERT INTO corpclient VALUES
('C111','BlingNotes','Music','Chicago',NULL);

INSERT INTO corpclient VALUES
('C222','SkyJet','Airline','Oak Park','C111');

INSERT INTO corpclient VALUES
('C777','WindyCT','Music','Chicago','C222');

INSERT INTO corpclient VALUES
('C888','SouthAlps','Sports','Rosemont','C777');

INSERT INTO apartment VALUES
('B1','21',1,'C111');

INSERT INTO apartment VALUES
('B1','41',1,NULL);

INSERT INTO apartment VALUES
('B2','11',2,'C222');

INSERT INTO apartment VALUES
('B2','31',2,NULL);

INSERT INTO apartment VALUES
('B3','11',2,'C777');

INSERT INTO apartment VALUES
('B4','11',2,'C777');

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

INSERT INTO cleaning VALUES
('B2','11','9876');

INSERT INTO cleaning VALUES
('B2','31','5432');

INSERT INTO cleaning VALUES
('B3','11','5432');

INSERT INTO cleaning VALUES
('B4','11','7652');

ALTER TABLE manager
ADD CONSTRAINT fkresidesin
FOREIGN KEY(mresbuildingid)
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

/* Marcelo Andrada Batista HW 8 */

/* Query 5.2.16 */
/* Count how many apartments each staff member cleans */

SELECT s.smemberid,
       s.smembername,
       COUNT(c.buildingid) AS num_apartments
FROM staffmember s
LEFT JOIN cleaning c
ON s.smemberid = c.smemberid
GROUP BY s.smemberid,
         s.smembername;


/* Query 5.2.17 */
/* Find staff members assigned to apartments rented by Chicago corporate clients */

SELECT DISTINCT s.smemberid,
                s.smembername
FROM staffmember s
JOIN cleaning c
ON s.smemberid = c.smemberid

JOIN apartment a
ON c.buildingid = a.buildingid
AND c.aptno = a.aptno

JOIN corpclient cc
ON a.ccid = cc.ccid

WHERE cc.cclocation = 'Chicago';


/* Query 5.2.18 */
/* Show corporate clients and who referred them */

SELECT cc.ccname AS client_name,
       ref.ccname AS referred_by

FROM corpclient cc

LEFT JOIN corpclient ref
ON cc.ccidreferredby = ref.ccid

WHERE ref.ccindustry = 'Music';


/* Query 5.2.19 */
/* Find apartments that are currently vacant */

SELECT buildingid,
       aptno,
       anoofbedrooms

FROM apartment

WHERE ccid IS NULL;


/* Query 5.2.20 */
/* Calculate total rented bedroom capacity per corporate client */

SELECT cc.ccid,
       cc.ccname,

SUM(a.anoofbedrooms)
AS TotalCapacityRentedBedrooms

FROM corpclient cc

LEFT JOIN apartment a
ON cc.ccid = a.ccid

GROUP BY cc.ccid,
         cc.ccname;
