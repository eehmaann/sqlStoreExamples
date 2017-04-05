-- ******************************************************
-- 2016ps3.sql
--
-- Loader for PS-3 Database
--
-- Description:	This script contains the DDL to load
--              the tables of the
--              INVENTORY database
--
-- There are 6 tables on this DB
--
-- Author:  Maria R. Garcia Altobello
--
-- Student:  <<Eric Ehmann>>
--
-- Date:   October, 2016
--
-- ******************************************************

-- ******************************************************
--    SPOOL SESSION
-- ******************************************************

spool 2016ps3.lst


-- ******************************************************
--    DROP TABLES
-- Note:  Issue the appropiate commands to drop tables
-- ******************************************************
DROP TABLE tbShipment purge;
DROP TABLE tbQuote purge;
DROP TABLE tbComponent purge;
DROP TABLE tbVendor purge;
DROP TABLE tbProduct purge;
DROP TABLE tbPart purge;

-- ******************************************************
--    DROP SEQUENCES
-- Note:  Issue the appropiate commands to drop sequences
-- ******************************************************

DROP sequence seq_shipment;

-- ******************************************************
--    CREATE TABLES
-- ******************************************************

CREATE table tbProduct (
        prodNo          char(3)                 not null
        CONSTRAINT pk_tbProduct primary key,
        productDesc     varchar2(15)            not null,
        schedule        number(2,0)             not null
);

CREATE table tbPart (
        partNo          char(2)                 not null
         constraint pk_tbPart primary key CHECK (partNo between '01' and '99'),
        partDesc       varchar2(15)            not null,
        quantityOnHand  number(8,0)             not null
        CONSTRAINT rq_quantityOnHand CHECK (quantityOnHand between '0' and '1000')
);

CREATE table tbVendor (
        vendorNo        char(3)                 not null
        constraint pk_tbVendor primary key CHECK (vendorNo between '100' and '999'),
        vendorName      varchar2(25)            not null,
        vendorCity      varchar2(15)            null        
);

CREATE table tbComponent (
        prodNo          char (3)                not null
        	CONSTRAINT fk_prodNo_tbComponent references tbProduct (prodNo) on delete cascade,
        compNo          char (2)                not null
         constraint rg_compNo CHECK (compNo between '01' and '10'),
        partNo          char (2)                null
        	CONSTRAINT fk_partNo_tbComponent references tbPart (partNo),
        noPartsReq      number (2,0)            default 1     not null
         CONSTRAINT rg_noPartReq CHECK (noPartsReq between '1' and '10'),        
        CONSTRAINT PK_tbComponent PRIMARY KEY(prodNo, CompNo)
);

CREATE table tbQuote (
        vendorNo        char(3)                 not null
        constraint fk_vendorNo_tbQuote references tbVendor (vendorNo),
        partNo          char(2)                 not null
        constraint fk_partNo_tbQuote references tbPart (partNo) on delete cascade,
        priceQuote      number(11,2)            default 0     not null,
        CONSTRAINT PK_tbQuote PRIMARY KEY(vendorNo, partNo)
);


CREATE table tbShipment (
        shipmentNo      number (11,0)           not null
        CONSTRAINT pk_tbShipment primary key,
        vendorNo        char (3)                not null,
        partNo          char (2)                not null,
        quantity        number (4,0)            default 1
        constraint rq_tbShipment check (quantity between '1' and '1000'),
        shipmentDate    date                    default CURRENT_DATE     not null,
        CONSTRAINT FK_tbQuote FOREIGN KEY (vendorNo, partNo)
        REFERENCES tbQuote(vendorNo, partNo)
        ON DELETE CASCADE        
);





-- ******************************************************
--    CREATE SEQUENCES
-- ******************************************************

CREATE sequence seq_shipment
    increment by 1
    start with 1;
    
    
-- ******************************************************
--    POPULATE TABLES
--
-- Note:  Follow instructions and data provided on PS-3
--        to populate the tables
-- ******************************************************
/* inventory tbPart */
INSERT into tbPart values ('01', 'Tub', 10);
INSERT into tbPart values ('05', 'Wheel', 45);
INSERT into tbPart values ('97', 'Box', 15);
INSERT into tbPart values ('98', 'Strut', 15);
INSERT into tbPart values ('99', 'Handle', 55);

/* inventory tbProduct */
INSERT into tbProduct values ('100', 'Cart', 3);
INSERT into tbProduct values ('101', 'Wheelbarrow', 3);

/* inventory tbVendor */
INSERT into tbVendor values ('123', 'FirstOne', 'Boston');
INSERT into tbVendor values ('225', 'SomeStuff', 'Cambridge');
INSERT into tbVendor values ('747', 'LastChance', 'Belmont');
INSERT into tbVendor values ('909', 'IHaveIt', 'Boston');

/* inventory tbComponent */
INSERT into tbComponent values ('100', '01', '05', 2);
INSERT into tbComponent values ('100', '02', '97', 1);
INSERT into tbComponent values ('100', '03', '98', 1);
INSERT into tbComponent values ('100', '04', '99', 1);
INSERT into tbComponent values ('101', '01', '01', 1);
INSERT into tbComponent values ('101', '02', '05', 2);
INSERT into tbComponent values ('101', '03', '98', 1);
INSERT into tbComponent values ('101', '04', '99', 2);

/* inventory tbQuote */
INSERT into tbQuote values ('123', '01', 50.00);
INSERT into tbQuote values ('123', '98', 20.00);
INSERT into tbQuote values ('225', '99', 20.00);
INSERT into tbQuote values ('747', '05', 28.00);
INSERT into tbQuote values ('909', '01', 40.00);
INSERT into tbQuote values ('909', '05', 30.00);
INSERT into tbQuote values ('909', '97', 60.00);
INSERT into tbQuote values ('909', '98', 22.00);
INSERT into tbQuote values ('909', '99', 22.00);

/* inventory tbShipment */
INSERT into tbShipment values (seq_shipment.nextval,'909', '01', 2, to_date('10-01-2016','mm-dd-yyyy') );
INSERT into tbShipment values (seq_shipment.nextval,'747', '05', 5, to_date('10-02-2016','mm-dd-yyyy') );
INSERT into tbShipment values (seq_shipment.nextval,'909', '97', 2, to_date('10-03-2016','mm-dd-yyyy') );
INSERT into tbShipment values (seq_shipment.nextval,'123', '98', 5, to_date('10-07-2016','mm-dd-yyyy') );
INSERT into tbShipment values (seq_shipment.nextval,'225', '99', 1, to_date('10-07-2016','mm-dd-yyyy') );



-- ******************************************************
--    VIEW TABLES
--
-- Note:  Issue the appropiate commands to show your data
-- ******************************************************

SELECT * FROM tbComponent;
SELECT * FROM tbPart;
SELECT * FROM tbProduct;
SELECT * FROM tbQuote;
SELECT * FROM tbShipment;
SELECT * FROM tbVendor;


-- ******************************************************
--    QUALITY CONTROLS
--
-- Note:  Test only 2 constraints of each of
--        the following types:
--        *) Entity integrity
INSERT into tbProduct values (100, 'Shovel', 2);
INSERT into tbShipment values (null,'909', '01', 2, to_date('10-01-2016','mm-dd-yyyy') );

--        *) Referential integrity
INSERT into tbComponent values ('100', '01', '05', 2, 6);
INSERT into tbQuote values ('125', '01', 50.00);
--        *) Column constraints
INSERT into tbShipment values (11.4,'5', '99', 1, to_date('10-07-2016','mm-dd-yyyy') );
INSERT into tbVendor values ('1', 'FirstOne', 'Boston');
-- ******************************************************

-- ******************************************************
--    *) Triggers
-- ******************************************************
CREATE or REPLACE trigger TR_new_ship_IN
   /* trigger executes BEFORE an INSERT into the GIFT table */
   before insert on tbShipment
   /* trigger executes for each ROW being inserted */
   for each row
   
   /* begins a PL/SQL Block */
   begin
      /* get the next value of the PK sequence and todayís date */

      SELECT seq_shipment.nextval, sysdate
         /* insert them into the :NEW ROW columns */
           into :new.shipmentNo, :new.shipmentdate
            FROM dual;
   end TR_new_ship_IN;
.
/



CREATE OR REPLACE trigger two_quote_min_rule
   after insert or update or delete on tbPart   
   declare
      x number; /* PL/SQL variable */  
   begin
      /* projects with no tasks considered */
      select count(pricequote) into x
         from tbQuote 
         group by partNo;                         
      if x > 0 then
         dbms_output.put_line (
            '*** Warning, you must have at least two quotes - 
            two_quote_min_rule TRIGGER ');
      end if;
       end two_quote_min_rule;
/
-- *****************************************************
-- Queries
-- Query 1
--  Provide the name of those parts which are used in both product?
SELECT partDesc
	FROM tbPart
	WHERE partNo IN (SELECT partNo
				FROM tbComponent
				WHERE ProdNo = '100') AND partNo IN (SELECT partNo
											FROM tbComponent
											WHERE prodNo='101');						
	
--- Query 2 
--- Which products require the use of a box?
SELECT productDesc 
    FROM tbProduct     
    	WHERE prodNo IN(SELECT prodNo
    						FROM tbComponent
    						WHERE partNo='97');
---Query3
-- What Parts are only sold by one vendor
	SELECT P.partDesc, Q.partNo, count(Q.priceQuote) 
		FROM tbQuote Q, tbPart P
		WHERE Q.partNo=P.partNo
		GROUP BY Q.partNo, P.partDesc
		ORDER By 2, 1;
--Query4
-- What vendor offers the lowest price?
	Select  tbVendor.Vendorname, tbQuote.partNo, tbQuote.priceQuote
		FROM tbQuote
		LEFT Join tbQuote cheaperQuote on tbQuote.partNo =cheaperQuote.partNo
		AND tbQuote.priceQuote >cheaperQuote.pricequote
		Join tbVendor on tbQuote.vendorNo = tbVendor.vendorNo
		WHERE cheaperQuote.priceQuote is null
		ORDER by tbQuote.partNO;
		
--Query5 
-- What parts are being used for each product.
	SELECT secList.prodNo, secList.compNo, tbComponent.partNO,
	tbPart.partDesc
	FROM tbComponent
	FULL OUTER JOIN tbComponent secList ON tbComponent.compNo = secList.compNo
	LEFT JOIN tbPart on secList.partNo = tbPart.partNo
	AND tbComponent.partNo = tbPart.partNo
	Order by tbComponent.partNo;
	
--Query6 
-- Which Vendors are located in the same city
	SELECT tbVendor.vendorName, location.vendorName, tbVendor.vendorCity
	From tbVendor
	JOIN tbVendor location on tbVendor.vendorCity = location.vendorCity
	WHERE tbVendor.vendorNo< location.vendorNo
	ORDER BY tbvendor.vendorCity;
	
--Query 7 
-- How many weeks before inventory runs out
	
	SELECT tbPart.partDesc,
	SUM (tbPart.quantityOnHand)/((tbComponent.noPartsReq)* (tbProduct.schedule)) as Weeks_Left
	FROM tbPart
	--FROM tbComponent
	JOIN tbComponent on tbComponent.partNo = tbPart.partNo
	JOIN tbProduct on tbComponent.prodNo = tbProduct.prodNo
	GROUP BY tbComponent.partNo, tbPart.partDesc, tbComponent.noPartsReq, tbProduct.schedule,
	tbPart.quantityOnHand
	ORDER BY tbPart.partDesc;


-- ******************************************************
--    END SESSION
-- ******************************************************

spool off

 