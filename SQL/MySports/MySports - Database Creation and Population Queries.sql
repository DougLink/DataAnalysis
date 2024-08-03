DROP TABLE IF EXISTS delivered_item;
DROP TABLE IF EXISTS delivery;
DROP TABLE IF EXISTS item;
DROP TABLE IF EXISTS price;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS ord;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS salgrade;
DROP TABLE IF EXISTS emp;
DROP TABLE IF EXISTS dept;


CREATE TABLE dept 
(
 	deptno              INTEGER PRIMARY KEY AUTOINCREMENT,
 	dname               TEXT,
 	location            TEXT
);


-- self referencing foreign key relating an employee to his/her manager
-- (managers are also employees).  Represented on ERD by a "sow's ear" relationship

CREATE TABLE emp 
(
 	empno               INTEGER PRIMARY KEY AUTOINCREMENT,
 	ename               TEXT,
 	job                 TEXT,
 	mgr                 INTEGER,  
 	hiredate            TEXT,
 	monthly_sal         REAL,
 	commission          REAL,
 	deptno              INTEGER 		NOT NULL,
 CONSTRAINT emp_dept_FK FOREIGN KEY (deptno) REFERENCES dept (deptno),
 CONSTRAINT emp_mgr_SELF_KEY FOREIGN KEY (mgr) REFERENCES emp (empno),
 CONSTRAINT emp_hiredate_CHECK CHECK (hiredate IS DATE(hiredate))
);


CREATE TABLE salgrade 
(
 	grade               INTEGER,
 	losal               INTEGER,
 	hisal               INTEGER,
CONSTRAINT salgrade_PK PRIMARY KEY (grade)
);

CREATE TABLE customer 
(
 	custid              INTEGER PRIMARY KEY AUTOINCREMENT,
 	name                TEXT,
 	add1                TEXT,
 	add2                TEXT,
 	postcode            TEXT,
 	area                TEXT,
 	phone               TEXT,
 	repid               INTEGER,
 	creditlimit         REAL,
 	comments            TEXT,
 CONSTRAINT cust_emp_FK FOREIGN KEY (repid) REFERENCES emp (empno),
 CONSTRAINT cust_custid_CHECK CHECK (custid > 0)
);

 
CREATE TABLE ord  
(
 	ordid               INTEGER PRIMARY KEY AUTOINCREMENT,
 	orderdate           TEXT,
 	commplan            TEXT,	
 	shipdate            TEXT,
 	total               REAL,
        custid              INTEGER NOT NULL,
 CONSTRAINT ord_custid_FK FOREIGN KEY (custid) REFERENCES customer (custid),
 CONSTRAINT ord_shipdate_CHECK CHECK (shipdate IS DATE(shipdate))
);


CREATE TABLE product 
(
 	prodid              INTEGER PRIMARY KEY AUTOINCREMENT,
 	descrip             TEXT
);

-- two separate foreign key declarations here
-- representing the two relationships shown on the ERD

CREATE TABLE item  
(
 	ordid               INTEGER,
 	itemid              INTEGER,
 	prodid              INTEGER		NOT NULL,
 	actualprice         REAL		NOT NULL,
 	qty                 INTEGER		NOT NULL,
 	itemtot             REAL,
	CONSTRAINT item_PK      PRIMARY KEY (ordid,itemid),
	CONSTRAINT item_ordid_FK  FOREIGN KEY (ordid)  REFERENCES ord (ordid),
	CONSTRAINT item_prodid_FK FOREIGN KEY (prodid) REFERENCES product (prodid)
);



CREATE TABLE price 
(
 	prodid              INTEGER,
 	startdate           TEXT,
 	stdprice            REAL	NOT NULL,
 	minprice            REAL	NOT NULL,
 	enddate             TEXT,
 CONSTRAINT price_prodid_FK FOREIGN KEY (prodid) REFERENCES product (prodid),
 CONSTRAINT price_startdate_CHECK CHECK (startdate IS DATE(startdate)),
 CONSTRAINT price_enddate_CHECK CHECK (enddate IS DATE(enddate))
);

CREATE UNIQUE INDEX price_index ON price(prodid, startdate);

CREATE TABLE delivery
(
	delid	   	   INTEGER PRIMARY KEY AUTOINCREMENT,
        deliverydate	   TEXT,
 CONSTRAINT deliverydate_CHECK CHECK (deliverydate IS DATE(deliverydate))
);

 

CREATE TABLE delivered_item
(
       ordid		   INTEGER,
       itemid		   INTEGER,
       delid	   	   INTEGER,
       qty		   INTEGER	NOT NULL,
 CONSTRAINT DEL_item_PK PRIMARY KEY (ordID, itemid, delid),
 CONSTRAINT DEL_item_item_FK FOREIGN KEY (ordid, itemid) REFERENCES item (ordid, itemid),
 CONSTRAINT DEL_item_DEL_FK FOREIGN KEY (delid) REFERENCES delivery (delid)
);


INSERT INTO dept (deptno, dname, location) VALUES (10,'ACCOUNTING','OXFORD');
INSERT INTO dept (deptno, dname, location) VALUES (20,'RESEARCH','SOTON');
INSERT INTO dept (deptno, dname, location) VALUES (30,'SALES','BRISTOL');
INSERT INTO dept (deptno, dname, location) VALUES (40,'OPERATIONS','SOTON');

INSERT INTO emp (empno, ename, job, mgr, hiredate, monthly_sal, commission, deptno)
    	VALUES (7839,'KING','PRESIDENT',NULL, '2011-11-17',5000,NULL,10);

INSERT INTO emp (empno, ename, job, mgr, hiredate, monthly_sal, commission, deptno)
    	VALUES (7698,'BLAKE','MANAGER',7839, '2011-05-01',2850,NULL,30);

INSERT INTO emp (empno, ename, job, mgr, hiredate, monthly_sal, commission, deptno)
	VALUES (7782,'CLARK','MANAGER',7839, '2011-06-09',2450,NULL,10);

INSERT INTO emp (empno, ename, job, mgr, hiredate, monthly_sal, commission, deptno)
    	VALUES (7566,'JONES','MANAGER',7839,'2011-04-02',2975,NULL,20);

INSERT INTO emp (empno, ename, job, mgr, hiredate, monthly_sal, commission, deptno)
    	VALUES (7654,'MARTIN','SALESREP',7698,'2011-09-28',1250,1400,30);

INSERT INTO emp (empno, ename, job, mgr, hiredate, monthly_sal, commission, deptno)
    	VALUES (7499,'ALLEN','SALESREP',7698,'2011-02-20',1600,300,30);

INSERT INTO emp (empno, ename, job, mgr, hiredate, monthly_sal, commission, deptno)
    	VALUES (7844,'TURNER','SALESREP',7698,'2011-09-08',1500,0,30);

INSERT INTO emp (empno, ename, job, mgr, hiredate, monthly_sal, commission, deptno)
    	VALUES (7900,'JAMES','CLERK',7698,'2011-12-03',950,NULL,30);

INSERT INTO emp (empno, ename, job, mgr, hiredate, monthly_sal, commission, deptno)
    	VALUES (7521,'WARD','SALESREP',7698,'2011-02-22',1250,500,30);

INSERT INTO emp (empno, ename, job, mgr, hiredate, monthly_sal, commission, deptno)
    	VALUES (7902,'FORD','ANALYST',7566,'2011-12-03',3000,NULL,20);

INSERT INTO emp (empno, ename, job, mgr, hiredate, monthly_sal, commission, deptno)
    	VALUES (7369,'SMITH','CLERK',7902,'2010-12-17',800,NULL,20);

INSERT INTO emp (empno, ename, job, mgr, hiredate, monthly_sal, commission, deptno)
    	VALUES (7788,'SCOTT','ANALYST',7566,'2012-12-09',3000,NULL,20);

INSERT INTO emp (empno, ename, job, mgr, hiredate, monthly_sal, commission, deptno)
    	VALUES (7876,'ADAMS','CLERK',7788,'2013-01-12',1100,NULL,20);

INSERT INTO emp (empno, ename, job, mgr, hiredate, monthly_sal, commission, deptno)
    	VALUES (7934,'MILLER','CLERK',7782,'2012-01-23',1300,NULL,10);

INSERT INTO salgrade (GRADE, LOSAL, HISAL) VALUES (1,700,1200);
INSERT INTO salgrade (GRADE, LOSAL, HISAL) VALUES (2,1201,1400);
INSERT INTO salgrade (GRADE, LOSAL, HISAL) VALUES (3,1401,2000);
INSERT INTO salgrade (GRADE, LOSAL, HISAL) VALUES (4,2001,3000);
INSERT INTO salgrade (GRADE, LOSAL, HISAL) VALUES (5,3001,9999);


INSERT INTO customer (CUSTID, NAME, ADD1, ADD2, POSTCODE, AREA, PHONE, REPID,CREDITLIMIT, COMMENTS) VALUES (100, 'JOCKSPORTS','8 Furlong Road', 
'Horfield, Bristol', 'BS16 8GX', 'AVON', '01179 546352', 7844,5000, 
'Very friendly people to work with -- sales rep likes to be called Mike.');

INSERT INTO customer (CUSTID, NAME, ADD1, ADD2, POSTCODE, AREA, PHONE, REPID,CREDITLIMIT, COMMENTS)  VALUES (101, 'TKB SPORT SHOP', 
'89 London Road','Southampton','SO18 7GC', 'HANT', '023 80763141', 7654, 10000, 
'Rep called 8/5/03 about change in order - contact shipping.'); 

INSERT INTO customer (CUSTID, NAME, ADD1, ADD2, POSTCODE, AREA, PHONE, REPID,CREDITLIMIT, COMMENTS) VALUES  (102, 'VOLLEYRITE', '4 The Ferns, Gloucester Rd', 'Horfield, Bristol', 'BS12 8RE', 'AVON','01179 372637', 7654, 7000, 
'Company doing heavy promotion beginning 10/89. Prepare for large orders during winter.');

INSERT INTO customer (CUSTID, NAME, ADD1, ADD2, POSTCODE, AREA, PHONE, REPID,CREDITLIMIT, COMMENTS) VALUES (103, 'JUST TENNIS', 'Unit 5, Harling Ind Estate', 'Southampton',
'SO28 5FL', 'HANT','023 80574632', 7521, 3000, 
'Contact rep about new line of tennis rackets.');

INSERT INTO customer (CUSTID, NAME, ADD1, ADD2, POSTCODE, AREA, PHONE, REPID,CREDITLIMIT, COMMENTS) VALUES (104, 'EVERY MOUNTAIN', '98 Church Street', 'Hadley, Oxford','OX9 6SD', 'OXON', '0647 748232', 7499, 10000, 
'Customer with high market share (23%) due to aggressive advertising.');

INSERT INTO customer (CUSTID, NAME, ADD1, ADD2, POSTCODE, AREA, PHONE, REPID,CREDITLIMIT, COMMENTS) VALUES (105, 'K + T SPORTS', 'Unit 48, The Precint', 'Southampton', 'SO56 3DF', 'HANT', '023 80563522', 7844, 5000,
'Tends to order large amounts of merchandise at once. Accounting is considering raising their credit limit. Usually pays on time.'); 

INSERT INTO customer (CUSTID, NAME, ADD1, ADD2, POSTCODE, AREA, PHONE, REPID,CREDITLIMIT, COMMENTS) VALUES (106, 'SHAPE UP', '56 Birmingham Road', 'Oxford', 'OX2 6ML', 'OXON', '0647 2837492', 7521, 6000, 
'Support intensive. Orders small amounts (< 800) of merchandise at a time.');

INSERT INTO customer (CUSTID, NAME, ADD1, ADD2, POSTCODE, AREA, PHONE, REPID,CREDITLIMIT, COMMENTS) VALUES (107, 'WOMENS SPORTS', '8 Bristol Road', 
'Portishead, Bristol', 'BS7 7BN','AVON', '0117 935273',  7499, 10000, 
'First sporting goods store geared exclusively towards women. Unusual promotional style and very willing to take chances towards new products!');

INSERT INTO customer (CUSTID, NAME, ADD1, ADD2, POSTCODE, AREA, PHONE, REPID,CREDITLIMIT, COMMENTS) VALUES (108, 'NORTH WOODS HEALTH AND FITNESS SUPPLY CENTRE', 'Clifton House, Whiteladies Rd', 'Bristol', 'BS2 2JP','AVON', '0117 9736273', 7844, 8000, NULL);

INSERT INTO customer (CUSTID, NAME, ADD1, ADD2, POSTCODE, AREA, PHONE, REPID,CREDITLIMIT, COMMENTS) VALUES (109, 'KW SPORTS', '12 London Road', 'Southampton', 'SO15 3FF', 'HANT', '023 80440044', NULL , 6000, 
'New customer, no rep id yet assigned');

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (98.4, '2005-01-08', 610, '2005-01-07', 101, 'A');

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (45, '2005-01-11', 611, '2005-01-11', 102, 'B');

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (5860, '2005-01-20', 612, '2005-01-15', 104, 'C');

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (2.4, '2004-05-30', 601, '2004-05-01', 106, 'A');

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (56, '2004-06-20', 602, '2004-06-05', 102, 'B');

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (550, '2004-06-30', 604, '2004-06-15', 106, 'A');

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (7524, '2004-07-30', 605, '2004-07-14', 106, 'A');

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (3.4, '2004-07-30', 606, '2004-07-14', 100, 'A');

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (97.5, '2004-08-15', 609, '2004-08-01', 100, 'B');

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (5.6, '2004-07-18', 607, '2004-07-18', 104, 'C');

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (35.2, '2004-07-25', 608, '2004-07-25', 104, 'C');

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (120, '2004-06-05', 603, '2004-06-05', 102, NULL);

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (4420, '2005-03-12', 620, '2005-03-12', 100, NULL);

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (6400, '2005-02-01', 613, '2005-02-01', 108, NULL);

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (22608, '2005-02-05',614, '2005-02-01', 102, NULL);

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (764, '2005-02-10', 616, '2005-02-03', 103, NULL);

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (1260, '2005-02-04', 619, '2005-02-22', 104, NULL);

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (46220, '2005-03-03', 617, '2005-02-05', 105, NULL);

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (710, '2005-02-06',615, '2005-02-01', 107, NULL);

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (2969.5, '2005-03-06', 618, '2005-02-15', 102, 'A');

INSERT INTO ord (TOTAL, SHIPDATE, ordID, ordERDATE, CUSTID, COMMPLAN)
 	VALUES (730, '2005-03-18', 621, '2005-03-15', 100, 'A');

INSERT INTO product (PRODID, DESCRIP)
 	VALUES (100860, 'ACE TENNIS RACKET I');

INSERT INTO product (PRODID, DESCRIP)
 	VALUES ('100861', 'ACE TENNIS RACKET II');

INSERT INTO product (PRODID, DESCRIP)
 	VALUES ('100870', 'ACE TENNIS BALLS-3 PACK');

INSERT INTO product (PRODID, DESCRIP)
 	VALUES ('100871', 'ACE TENNIS BALLS-6 PACK');

INSERT INTO product (PRODID, DESCRIP)
 	VALUES ('100890', 'ACE TENNIS NET');

INSERT INTO product (PRODID, DESCRIP)
 	VALUES ('101860', 'SP TENNIS RACKET');

INSERT INTO product (PRODID, DESCRIP)
 	VALUES ('101863', 'SP JUNIOR RACKET');

INSERT INTO product (PRODID, DESCRIP)
 	VALUES ('102130', 'RH: "GUIDE TO TENNIS"');

INSERT INTO product (PRODID, DESCRIP)
 	VALUES ('200376', 'SB ENERGY BAR-6 PACK');

INSERT INTO product (PRODID, DESCRIP)
 	VALUES ('200380', 'SB VITA SNACK-6 PACK');

INSERT INTO product (PRODID, DESCRIP)
	VALUES ('300210', 'SQUASH RACKET I');

INSERT INTO product (PRODID, DESCRIP)
	VALUES ('300211', 'SQUASH RACKET II');

INSERT INTO item (QTY, PRODID, ordID, itemTOT, itemID, ACTUALprice)
 	VALUES ('1', '100890', '610', '58', '3', '58');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ( '1', '100861', '611', '45', '1', '45');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ( '100', '100860', '612', '3000', '1', '30');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ( '1', '200376', '601', '2.4', '1', '2.4');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ( '20', '100870', '602', '56', '1', '2.8');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ( '3', '100890', '604', '174', '1', '58');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ( '2', '100861', '604', '76', '2', '38');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ( '10', '100860', '604', '300', '3', '30');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ( '4', '100860', '603', '120', '1', '30');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ( '1', '100860', '610', '32', '1', '32');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ( '3', '100870', '610', '8.4', '2', '2.8');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ( '200', '200376', '613', '440', '4', '2.2');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ( '444', '100860', '614', '14208', '1', '32');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ( '1000', '100870', '614', '2800', '2', '2.8');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ( '20', '100861', '612', '810', '2', '40.5');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('150', '101863', '612', '1500', '3', '10');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('10', '100860', '620', '320', '1', '32');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('1000', '200376', '620', '2400', '2', '2.4');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('500', '102130', '620', '1700', '3', '3.4');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ( '100', '100871', '613', '560', '1', '5.6');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('200', '101860', '613', '4800', '2', '24');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('150', '200380', '613', '600', '3', '4');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('100', '102130', '619', '340', '3', '3.4');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('50', '100860', '617', '1600', '1', '32');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('100', '100861', '617', '4500', '2', '45');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('1000', '100871', '614', '5600', '3', '5.6');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('10', '100861', '616', '450', '1', '45');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('50', '100870', '616', '140', '2', '2.8');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('2', '100890', '616', '116', '3', '58');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('10', '102130', '616', '34', '4', '3.4');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('10', '200376' , '616', '24', '5', '2.4');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('100', '200380', '619', '400', '1', '4');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('100', '200376', '619', '240', '2', '2.4');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('4', '100861', '615', '180', '1', '45');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('1', '100871', '607', '5.6', '1', '5.6');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('100', '100870', '615', '280', '2', '2.8');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('500', '100870', '617', '1400', '3', '2.8');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('500', '100871', '617', '2800', '4', '5.6');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('500', '100890', '617', '29000', '5', '58');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('100', '101860', '617', '2400', '6', '24');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('200', '101863', '617', '2500', '7', '12.5');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('100', '102130', '617', '340', '8', '3.4');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('200', '200376', '617', '480', '9', '2.4');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('300', '200380', '617', '1200', '10', '4');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('5', '100870', '609', '12.5', '2', '2.5');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('1', '100890', '609', '50', '3', '50');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('23', '100860', '618', '736', '1', '32');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('50', '100861', '618', '2205.5', '2', '44.11');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('10', '100870', '618', '28', '3', '2.8');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('10', '100861', '621', '450', '1', '45');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('100', '100870', '621', '280', '2', '2.8');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('50', '100871', '615', '250', '3', '5');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('1', '101860', '608', '24', '1', '24');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('2', '100871', '608', '11.2', '2', '5.6');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('1', '100861', '609', '35', '1', '35');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('1', '102130', '606', '3.4', '1', '3.4');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('100', '100861', '605', '3700', '1', '37');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('500', '100870', '605', '1400', '2', '2.8');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('5', '100890', '605', '290', '3', '58');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('50', '101860', '605', '1200', '4', '24');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('100', '101863', '605', '900', '5', '9.4');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('10', '102130', '605', '34', '6', '3.4');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('100', '100871', '612', '550', '4', '5.5');

INSERT INTO item ( QTY , PRODID , ordID , itemTOT , itemID , ACTUALprice)
 	VALUES ('50', '100871', '619', '280', '4', '5.6');

INSERT INTO delivery (DELID, deliveryDATE) VALUES (100001,'2005-02-02');
INSERT INTO delivery (DELID, deliveryDATE) VALUES (100002,'2005-02-14');
INSERT INTO delivery (DELID, deliveryDATE) VALUES (100003,'2005-02-20');
INSERT INTO delivery (DELID, deliveryDATE) VALUES (100004,'2005-03-18');
INSERT INTO delivery (DELID, deliveryDATE) VALUES (100005,'2005-01-12');
INSERT INTO delivery (DELID, deliveryDATE) VALUES (100006,'2005-02-15');
INSERT INTO delivery (DELID, deliveryDATE) VALUES (100007,'2005-02-25');
INSERT INTO delivery (DELID, deliveryDATE) VALUES (100008,'2005-01-25');
INSERT INTO delivery (DELID, deliveryDATE) VALUES (100009,'2005-02-10');
INSERT INTO delivery (DELID, deliveryDATE) VALUES (100010,'2005-02-28');
INSERT INTO delivery (DELID, deliveryDATE) VALUES (100011,'2005-02-15');

INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (611, 1, 100001,1);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (614, 1, 100001,400);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (614, 2, 100001,1000);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (614, 3, 100001,1000);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (614, 1, 100002,44);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (618, 1, 100003,23);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (618, 2, 100003,50);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (618, 3, 100003,10);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (620, 1, 100004,10);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (620, 2, 100004,1000);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (620, 3, 100004,500);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (621, 1, 100004,10);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (621, 2, 100004,100);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (610, 1, 100005,1);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (610, 2, 100005,3);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (610, 3, 100005,1);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (616, 1, 100006,10);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (616, 2, 100006,30);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (616, 3, 100006,2);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (616, 4, 100006,10);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (616, 5, 100006,10);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (616, 2, 100007,20);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (612, 1, 100008,75);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (612, 2, 100008,20);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (612, 3, 100008,100);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (612, 4, 100008,100);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (612, 1, 100009,25);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (612, 3, 100009,50);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (619, 1, 100010,100);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (619, 2, 100010,100);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (619, 3, 100010,100);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (619, 4, 100010,50);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (617, 1, 100011,50);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (617, 2, 100011,100);
INSERT INTO delivered_item (ordID, itemID, DELID, QTY) VALUES (617, 3, 100011,500);



INSERT INTO price (STDprice, STARTDATE, PRODID, MINprice, ENDDATE)
 VALUES ('30', '2004-01-01', '100860', '28', '2004-12-31');

INSERT INTO price (STDprice, STARTDATE, PRODID, MINprice, ENDDATE)
 VALUES ('35', '2005-01-01', '100860', '28.6', '2005-05-31');

INSERT INTO price (STDprice, STARTDATE, PRODID, MINprice, ENDDATE)
 VALUES ('37', '2005-06-01', '100860', '30', NULL);

INSERT INTO price (STDprice, STARTDATE, PRODID, MINprice, ENDDATE)
 VALUES ('39', '2004-01-01', '100861', '31.2', '2004-12-31');

INSERT INTO price (STDprice, STARTDATE, PRODID, MINprice, ENDDATE)
 VALUES ('45', '2005-01-01', '100861', '39.0', '2005-05-31');

INSERT INTO price (STDprice, STARTDATE, PRODID, MINprice, ENDDATE)
 VALUES ('47', '2005-06-01', '100861', '42', NULL);

INSERT INTO price (STDprice, STARTDATE, PRODID, MINprice, ENDDATE)
 VALUES ('2.8', '2004-01-01', '100870', '2.5', '2004-12-01');

INSERT INTO price (STDprice, STARTDATE, PRODID, MINprice, ENDDATE)
 VALUES ('3.0', '2005-01-01', '100870', '2.7', NULL);

INSERT INTO price (STDprice, STARTDATE, PRODID, MINprice, ENDDATE)
 VALUES ('5.6', '2004-01-01', '100871', '4.8', '2004-12-01');

INSERT INTO price (STDprice, STARTDATE, PRODID, MINprice, ENDDATE)
 VALUES ('5.7', '2005-01-01', '100871', '4.9', NULL);

INSERT INTO price (STDprice, STARTDATE, PRODID, MINprice, ENDDATE)
 VALUES ('54', '2003-06-01', '100890', '40.5', '2004-05-31');

INSERT INTO price (STDprice, STARTDATE, PRODID, MINprice, ENDDATE)
 VALUES ('58', '2004-01-01', '100890', '46.4', NULL);

INSERT INTO price (STDprice, STARTDATE, PRODID, MINprice, ENDDATE)
 VALUES ('24', '2004-02-15', '101860', '18', '2004-12-18');

INSERT INTO price (STDprice, STARTDATE, PRODID, MINprice, ENDDATE)
 VALUES ('25', '2004-12-19', '101860', '18', NULL);

INSERT INTO price (STDprice, STARTDATE, PRODID, MINprice, ENDDATE)
 VALUES ('12.5', '2004-02-15', '101863', '9.4', NULL);

INSERT INTO price (STDprice, STARTDATE, PRODID, MINprice, ENDDATE)
 VALUES ('3.4', '2004-04-18', '102130', '2.8', NULL);

INSERT INTO price (STDprice, STARTDATE, PRODID, MINprice, ENDDATE)
 VALUES ('2.4', '2003-11-15', '200376', '1.75', '2004-02-01');

INSERT INTO price (STDprice, STARTDATE, PRODID, MINprice, ENDDATE)
 VALUES ('2.9', '2004-02-02', '200376', '1.78', NULL);

INSERT INTO price (STDprice, STARTDATE, PRODID, MINprice, ENDDATE)
 VALUES ('4', '2003-11-15', '200380', '3.2', NULL);