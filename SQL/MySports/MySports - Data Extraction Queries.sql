-- ename, job, hiredate and deptno for employees hired since 1st Jan 2012
SELECT ename, job, hiredate, deptno
FROM emp
WHERE hiredate >= "2012-01-01";

-- ename and the total annual salary + commission for employees in department 30
SELECT ename AS [Employee Name], 
    monthly_sal*12+IFNULL(commission,0) AS [Annual Earnings]
FROM emp
WHERE deptno = 30;

-- empno and ename in the same column and another column showing their salary with an increase of 20%
SELECT empno ||' '|| ename AS Employee, 
    monthly_sal*1.2 AS [Monthly Salary + 20%]
FROM emp
WHERE deptno = 30;

-- prodid, description, start date, price, and end date for items with no end date(NULL). This are the current prices for products
SELECT product.prodid, descrip AS description, startdate, PRINTF("£%.2f",stdprice) AS [current price], enddate
FROM product
    INNER JOIN price ON product.prodid=price.prodid
WHERE enddate IS NULL
ORDER BY product.prodid;

-- sales representative name, customer, ordid and date for ALLEN's orders since 1st Jan 2005
SELECT ename AS Rep, name, ordid, orderdate
FROM emp
    INNER JOIN customer ON emp.empno=customer.repid
    INNER JOIN ord ON customer.custid=ord.custid
WHERE Rep='ALLEN' AND orderdate >= '2005-01-01'
ORDER BY name;

-- sales representative name, customer, order date and id, item and product id, and description for all items in order 612
SELECT ename AS Rep, name AS Customer, orderdate, ord.ordid, itemid, prodid, descrip
FROM emp
    INNER JOIN customer ON emp.empno=customer.repid
    INNER JOIN ord ON customer.custid=ord.custid
    INNER JOIN item ON ord.ordid=item.ordid
    INNER JOIN product ON item.prodid=product.prodid
WHERE ord.ordid=612;

-- ordid, itemid, ordered qty, delid, delivered qty for order 612
SELECT item.ordid, item.itemid, item.qty AS [qty ordered], delid, delivered_item.qty AS [qty delivered]
FROM item
    INNER JOIN delivered_item ON item.ordid=delivered_item.ordid
                            AND item.itemid=delivered_item.itemid
WHERE item.ordid = 612;

-- prodid, description and current price for all products even the ones not yet set up
SELECT product.prodid, descrip, IFNULL(stdprice,'Not yet set up') AS [Current Price]
FROM product
    LEFT OUTER JOIN price ON product.prodid=price.prodid
WHERE enddate IS NULL
ORDER BY product.prodid;

-- deptno, ename, manager empno and name for employees managed by someone
SELECT e.deptno, e.ename AS [Employee Name], e.mgr AS [Manager Empno], m.ename AS [Manager Name]
FROM emp e
    INNER JOIN emp m ON e.mgr=m.empno
WHERE e.deptno IN (10,20)
ORDER BY e.deptno,m.ename;

-- ordid, total value, number of items and average qty of items ordered in orders until 605
SELECT ordid, PRINTF("£%.2f",SUM(qty*actualprice)) AS [Order Value], COUNT(itemid) AS [No of Items], AVG(qty) AS [Average Qty]
FROM item
WHERE ordid <= 605
GROUP BY ordid;

-- prodid, description and qty sold for all products sold
SELECT item.prodid, descrip, SUM(qty) AS [Quantity Sold]
FROM item
LEFT JOIN product ON item.prodid=product.prodid
LEFT JOIN ord ON item.ordid=ord.ordid
GROUP BY item.prodid;

-- customer, number of items ordered and order value for orders made since 2nd Feb 2005
SELECT name, COUNT(itemid) AS [No of Items Ordered], PRINTF("£%.2f",SUM(qty*actualprice)) AS [Order Value]
FROM customer
LEFT JOIN ord ON customer.custid=ord.custid
LEFT JOIN item ON ord.ordid=item.ordid
WHERE ord.orderdate >= '2005-02-02'
GROUP BY customer.custid
ORDER BY customer.name;

-- ename, dept name, number of items ordered and orders value for orders made since 2nd Feb 2005, only display representatives with at least 3 items ordered and at least £1000 of value
SELECT ename, dname, COUNT(itemid) AS [No of Items Ordered], PRINTF("£%.2f",SUM(qty*actualprice)) AS [Orders Value]
FROM dept
LEFT JOIN emp ON dept.deptno=emp.deptno
LEFT JOIN customer ON emp.empno=customer.repid
LEFT JOIN ord ON customer.custid=ord.custid
LEFT JOIN item ON ord.ordid=item.ordid
WHERE ord.orderdate >= '2005-02-02'
GROUP BY empno
HAVING COUNT(ord.ordid) >= 3 AND SUM(qty*actualprice) >= 1000
ORDER BY ename;

-- ename, job and monthly salary for the employees with the lowest salary in each job type
SELECT ename, job, monthly_sal
FROM emp
WHERE (monthly_sal, job) IN (SELECT MIN(monthly_sal), job FROM emp GROUP BY job)
ORDER BY monthly_sal DESC;
-- and using correlated sub-query
SELECT ename, job, monthly_sal
FROM emp e1
WHERE (monthly_sal, job) IN (SELECT MIN(monthly_sal), job 
                            FROM emp e2 
                            WHERE e2.job=e1.job)
ORDER BY monthly_sal DESC;

-- deptno and name for the department with no employees in it
SELECT deptno, dname
FROM dept
WHERE deptno NOT IN(SELECT deptno FROM emp);
--and using correlated sub-query
SELECT deptno, dname
FROM dept d
WHERE NOT EXISTS (SELECT deptno
                FROM emp e
                WHERE e.deptno = d.deptno);
                    
-- department name and total remuneration for the dept with the highest remuneration
SELECT deptno, MAX(remuneration) AS 'remuneration'
FROM (SELECT deptno, SUM(monthly_sal *12) + IFNULL(commission,0) AS 'remuneration'
        FROM emp
        GROUP BY deptno);
-- and using in-line query
SELECT deptno, SUM(monthly_sal*12) + IFNULL(commission,0) AS 'remuneration'
FROM emp
GROUP BY deptno
HAVING remuneration = (SELECT MAX(remuneration) 
                        FROM (SELECT deptno, SUM(monthly_sal *12) + 
                            IFNULL(commission,0) AS 'remuneration'
                            FROM emp
                            GROUP BY deptno));


--


