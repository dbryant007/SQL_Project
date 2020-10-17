/************************************************************************************/
/*                                                                                  */
/*	Date		Programmer			Description										*/
/* --------- ---------------- ------------------------------------------------------*/
/* 10/9/20		Dustin Bryant	Intial implementation of the disk inventory db.		*/
/* 10/16/20		Dustin Bryant	Inserted data into all tables						*/
/*								Added borrowDate to Primary Key on borrowedItem table */
/*								Changed borrowerLName to Null from Not Null on borrower table */
/*								Changed artistLName to Null from Not Null on artist table       */
/*                                                                                  */
/************************************************************************************/

--Create database
USE master;
DROP DATABASE IF EXISTS disk_inventoryDB;
GO
CREATE DATABASE disk_inventoryDB;
GO
USE disk_inventoryDB;

--Create User
IF SUSER_ID ('diskUserdb') IS NULL
	CREATE LOGIN diskUserdb WITH PASSWORD = 'Pa$$w0rd',
	DEFAULT_DATABASE = disk_inventoryDB;

DROP USER IF EXISTS diskUserdb;
CREATE USER diskUserdb;
ALTER ROLE db_datareader
	ADD MEMBER diskUserdb;

--Create tables
CREATE TABLE artisttype (
	artistTypeID	INT NOT NULL PRIMARY KEY IDENTITY,
	description		NVARCHAR(60) NOT NULL
);

CREATE TABLE itemtype (
	itemTypeID		INT NOT NULL PRIMARY KEY IDENTITY,
	description		NVARCHAR(60) NOT NULL
);

CREATE TABLE itemStatus (
	itemStatusID	INT NOT NULL PRIMARY KEY IDENTITY,
	description		NVARCHAR(60) NOT NULL
);

CREATE TABLE genre (
	genreID			INT NOT NULL PRIMARY KEY IDENTITY,
	description		NVARCHAR(60) NOT NULL
);

CREATE TABLE borrower (
	borrowerID		INT NOT NULL PRIMARY KEY IDENTITY,
	borrowerFName	NVARCHAR(60) NOT NULL,
	borrowerLName	NVARCHAR(60) NULL,
	borrowerPhone	VARCHAR(15) NOT NULL
);

CREATE TABLE artist (
	artistID		INT NOT NULL PRIMARY KEY IDENTITY,
	artistFName		NVARCHAR(60) NOT NULL,
	artistLName		NVARCHAR(60) NULL,
	artistTypeID	INT NOT NULL REFERENCES artistType(artistTypeID)
);

CREATE TABLE inventory (
	itemID			INT NOT NULL PRIMARY KEY IDENTITY,
	itemName		NVARCHAR(60) NOT NULL,
	releaseDate		DATE NOT NULL,
	genreID			INT NOT NULL REFERENCES genre(genreID),
	itemStatusID	INT NOT NULL REFERENCES itemstatus(itemStatusID),
	itemTypeID		INT NOT NULL REFERENCES itemtype(itemTypeID)
);

--Intersection Tables

CREATE TABLE borrowedItem (
	borrowDate		DATE NOT NULL,
	returnDate		DATE NULL,
	borrowerID		INT NOT NULL REFERENCES borrower(borrowerID),
	itemID			INT NOT NULL REFERENCES inventory(itemID),
	PRIMARY KEY		(borrowDate, borrowerID, itemID)
);

CREATE TABLE artistItem (
	artistID		INT NOT NULL REFERENCES artist(artistID),
	itemID			INT NOT NULL REFERENCES inventory(itemID),
	PRIMARY KEY		(artistID, itemID)
);

/******************** Project 3 *********************************************/
--Inserts for artist_type - See CH7 slide 12 or 13
INSERT INTO artisttype 
	(description)
VALUES
	('Solo')
	,('Group')
	;

--Inserts for itemtype

INSERT INTO itemtype 
	(description)
VALUES
	('CD')
	,('Vinyl')
	,('8Track')
	,('DVD')
	,('Blu-Ray')
	;

--Inserts for genre

INSERT INTO genre 
	(description)
VALUES
	('Classical')
	,('Indie')
	,('Rap')
	,('Techno')
	,('Rock')
	;

--Inserts for itemStatus

INSERT INTO itemStatus 
	(description)
VALUES
	('Checked In')
	,('Checked Out')
	,('Unavailable')
	,('Late')
	;

--Inserts for Borrower
--1. Insert at least 20 rows of date into the table.
--2. Delete only 1 row using a where clause.

INSERT borrower
	(borrowerFName
	,borrowerLName
	,borrowerPhone)
VALUES
	('Harry', 'Potter', '123-456-7890')
	,('Hermione', 'Granger', '234-567-8901')
	,('Ron', 'Weasley', '345-5678-9012')
	,('Neville', 'Longbottom', '456-789-0123')
	,('Albus', 'Dumbledore', '567-890-1234')
	,('Severus', 'Snape', '678-901-2345')
	,('Draco', 'Malfoy', '789-012-3456')
	,('Ginny', 'Weasley', '890-123-4567')
	,('Rubeus', 'Hagrid', '901-234-5678')
	,('Luna', 'Lovegood', '012-345-6789')
	,('Sirius', 'Black', '987-654-3210')
	,('Remus', 'Lupin', '876-543-2109')
	,('Nymphadora','Tonks', '765-432-1098')
	,('Cho', 'Chang', '654-321-0987')
	,('Minerva', 'McGonagall', '543-210-9876')
	,('Cedric', 'Diggory', '432-109-8765')
	,('Molly', 'Weasley', '321-098-7654')
	,('Alastor', 'Moody', '210-987-6543')
	,('Horace', 'Slughorn', '109-876-5432')
	,('Voldemort', NULL, '098-765-4321')
	;

--DELETE 1 row. See Ch7 slide 23

DELETE borrower
WHERE borrowerFName = 'Voldemort';

--Inserts for Artist table:
--1. Insert at least 20 rows of data into the table
--2. At least 1 artist is known by 1 name and is a group
--3. At least 1 artist is known by 1 name and is an individual artist
--4. At least 1 artist has only 2 words in the name
--5. At least 1 artist has more than 2 words in the name

INSERT artist
	(artistFName
	,artistLName
	,artistTypeID)
VALUES
	('Vampire Weekend', NULL, 2)
	,('Tool', NULL, 2)
	,('Prince', NULL, 1)
	,('Maren', 'Morris', 1)
	,('Edward Sharpe & The Magnetic Zeroes', NULL, 2)
	,('Zedd', NULL, 1)
	,('The Head and The Heart', NULL, 2)
	,('Leon', 'Bridges', 1)
	,('The Lumineers', NULL, 2)
	,('Adele', NULL, 1)
	,('Postmodern Jukebox', NULL, 2)
	,('Nathaniel Rateliff & The Night Sweats', NULL, 2)
	,('Vance', 'Joy', 1)
	,('Feist', NULL, 1)
	,('Serena', 'Ryder', 1)
	,('The Avett Brothers', NULL, 2)
	,('Lord Huron', NULL, 2)
	,('Florence + The Machine', NULL, 2)
	,('Shakey', 'Graves', 1)
	,('The Weeknd', NULL, 2)
	;

--Inserts into inventory table:
--1. Insert at least 20 rows of data into the table
--2. Update only 1 row using a where clause
--3. At least 1 disk has only 1 word in the name
--4. At least 1 disk has only 2 words in the name
--5. At least 1 disk has more than words in the name

INSERT inventory
	(itemName
	,releaseDate
	,genreID
	,itemStatusID
	,itemTypeID)
VALUES
	('Contra', '6/7/2010', 2, 3, 2)
	,('Fear Inoculum', '8/11/2019', 5, 4, 4)
	,('Purple Rain', '5/14/1984', 5, 3, 5)
	,('The Middle', '2/2/2018', 2, 1, 1)
	,('Up From Below', '5/9/2009', 2, 3, 1)
	,('Stay', '1/5/2017', 4, 2, 5)
	,('Signs of Light', '6/23/2016', 2, 2, 2)
	,('Coming Home', '3/4/1995', 2, 2, 1)
	,('Cleopatra', '9/12/2016', 2, 4, 3)
	,('25', '10/10/2016', 1, 2, 1)
	,('Selfies on Kodachrome', '12/17/2013', 1, 2, 5)
	,('Tearing At The Seams', '11/4/2018', 5, 1, 2)
	,('Dream Your Life Awake', '3/15/2014', 2, 1, 1)
	,('The Reminder', '4/8/2007', 1, 4, 3)
	,('Harmony', '8/25/2015', 1, 2, 1)
	,('I And Love And You', '7/13/2009', 2, 4, 4)
	,('Strange Trails', '6/29/2015', 2, 2, 1)
	,('Lungs', '2/11/2008', 4, 3, 2)
	,('Tomorrow', '8/2/2016', 2, 4, 2)
	,('After Hours', '5/17/2020', 1, 1, 3)
	,('The Carpenter', '9/2/2011', 2, 3, 4)
	;

--Update a row in inventory - CH7 Slide 19

UPDATE inventory
SET releaseDate = '3/14/1995'
WHERE itemName = 'Coming Home';

--borrowedItem table:
--1. Insert at least 20 rows of data into the table
--2. Insert at least 2 different disks
--3. Insert at least 2 different borrowers
--4. At least 1 disk has been borrowed by the same borrower 2 different times
--5. At least 1 disk in the disk table does not have a related row here
--6. At least 1 disk must have at least 2 different rows here
--7. At least 1 borrower in the borrower table does not have a related row here
--8. At least 1 borrower must have at least 2 different rows here

INSERT borrowedItem
	(borrowDate,
	returnDate,
	borrowerID,
	itemID)
VALUES
	('3/14/2020',  '3/17/2020', 13, 17)
	,('4/23/2020', NULL, 1, 1)
	,('7/2/2020',  '7/22/2020', 7, 16)
	,('7/2/2020',  '7/22/2020', 7, 13)
	,('7/2/2020',  '7/22/2020', 7, 9)
	,('7/14/2020', '7/21/2020', 19, 6)
	,('7/14/2020', '7/21/2020', 19, 5)
	,('8/19/2020', '8/23/2020', 1, 11)
	,('8/20/2020', '8/26/2020', 4, 15)
	,('8/20/2020', '8/26/2020', 4, 4)
	,('8/31/2020', '9/6/2020', 11, 7)
	,('8/31/2020', '9/6/2020', 11, 11)
	,('8/31/2020', NULL, 11, 18)
	,('8/31/2020', '9/6/2020', 11, 12)
	,('9/3/2020', '9/30/2020', 9, 8)
	,('9/3/2020', '9/30/2020', 9, 2)
	,('9/14/2020', '10/5/2020', 1, 19)
	,('9/14/2020', '10/5/2020', 1, 14)
	,('10/9/2020', NULL, 7, 16)
	,('10/9/2020', '10/10/2020', 7, 13)
	;

--DiskHasArtist table:
--1. Insert at least 20 rows of data into the table
--2. At least 1 disk must have at least 2 different artist rows here
--3. At least 1 artist must have at least 2 different disk rows here
--4. Correct variation of disk & artist data similar to DiskHasBorrower

INSERT artistItem
	(artistID,
	itemID)
VALUES
	(1,1)
	,(2,2)
	,(3,3)
	,(4,4)
	,(5,5)
	,(6,6)
	,(6,4)
	,(7,7)
	,(8,8)
	,(9,9)
	,(10,10)
	,(11,11)
	,(12,12)
	,(13,13)
	,(14,14)
	,(15,15)
	,(16,16)
	,(16,21)
	,(17,17)
	,(18,18)
	,(19,19)
	,(20,20)
	;

--Create a query to list the disks that are on loan and have not been returned.
--Sample Output:
--Borrower_id Disk_id Borrowed_date Return_date
--	9			2		2012-04-02	NULL
--	9			4		2012-04-02	NULL

SELECT borrowerID, itemID, borrowDate, returnDate
FROM borrowedItem
WHERE returnDate IS NULL;