/* Marcelo Batista, HW8 */

/* Query 5.2.11 */
select 		buildingid, aptno
from 		apartment
where 		ccid = (select ccid from corpclient where ccname = 'WindyCT');

/* Query 5.2.12 */
select 		distinct i.insid, i.insname
from 		inspector i
join 		inspecting ins on i.insid = ins.insid
where 		ins.datenext > '2025-04-01';

/* Query 5.2.13 */
select 		managerid, mfname, mlname, msalary
from 		manager
where 		msalary > (select avg(msalary) from manager);

/* Query 5.2.14 */
select 		m.managerid, m.mfname, m.mlname, count(b.buildingid) as num_buildings
from 		manager m
left join 	building b on m.managerid = b.bmanagerid
group by 	m.managerid;

/* Query 5.2.15 */
select 		m.managerid, m.mfname, m.mlname, count(b.buildingid) as num_buildings
from 		manager m
left join 	building b on m.managerid = b.bmanagerid
group by 	m.managerid
having 		count(b.buildingid) > 1;

/* Query 5.2.16 */
select 		s.smemberid, s.smembername, count(c.buildingid) as num_apartments
from 		staffmember s
left join 	cleaning c on s.smemberid = c.smemberid
group by 	s.smemberid;

/* Query 5.2.17 */
select 		distinct s.smemberid, s.smembername
from 		staffmember s
join 		cleaning c on s.smemberid = c.smemberid
join 		apartment a on c.buildingid = a.buildingid and c.aptno = a.aptno
join 		corpclient cc on a.ccid = cc.ccid
where 		cc.cclocation = 'Chicago';

/* Query 5.2.18 */
select 		cc.ccname as client_name, ref.ccname as referred_by
from 		corpclient cc
left join 	corpclient ref on cc.ccidreferredby = ref.ccid
where 		ref.ccindustry = 'Music';

/* Query 5.2.19 */
select 		buildingid, aptno, anoofbedrooms
from 		apartment
where 		ccid is null;

/* Query 5.2.20 */
select 		cc.ccid, cc.ccname, sum(a.anoofbedrooms) as TotalCapacityRentedBedrooms
from 		corpclient cc
left join 	apartment a on cc.ccid = a.ccid
group by 	cc.ccid, cc.ccname;
