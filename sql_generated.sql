---------------------------------------------------------------------------------------------
------------------  Plain PostgreSQL SQL examples for each relationship type ----------------
---------------------------------------------------------------------------------------------

Golden rule:
SQL does not have “relationship types”.
Only foreign keys + joins.

1. ONE-TO-ONE
   ----------
	(Student → Address)
	
	a. Query: Student with Address
		SELECT s.id, s.name, a.city
		FROM student s
		INNER JOIN address a ON s.address_id = a.id;
		
		Entity:
		@OneToOne(fetch = FetchType.LAZY, optional = false)		// JPA knows Address is mandatory
		@JoinColumn(name = "address_id", nullable = false)		// DB enforces NOT NULL
		private Address address;
		
	b. Student even if Address missing
		SELECT s.id, s.name, a.city
		FROM student s
		LEFT JOIN address a ON s.address_id = a.id;
		
		Entity:
		@OneToOne(fetch = FetchType.LAZY)						// optional = true is default
		@JoinColumn(name = "address_id")						// nullable = true
		

2. ONE-TO-MANY
   -----------
	(Student → Phone)
	
	a. Query: Student with Phones
		SELECT s.id, s.name, p.number
		FROM student s
		INNER JOIN phone p ON s.id = p.student_id;
		    
		@ManyToOne(fetch = FetchType.LAZY, optional = false)
		@JoinColumn(name = "student_id", nullable = false)
		private Student student;
	
	b. All Students (even without phones)
		SELECT s.id, s.name, p.number
		FROM student s
		LEFT JOIN phone p ON s.id = p.student_id;
		 	
		@ManyToOne(fetch = FetchType.LAZY)
		@JoinColumn(name = "student_id")
		private Student student;
			
	
3. MANY-TO-ONE
   -----------
	(Phone → Student)
	
	Same join — interpreted from the opposite side.
	
	a. Query: Phone with its Student
		SELECT p.id, p.number, s.name
		FROM phone p
		INNER JOIN student s ON p.student_id = s.id;
	
	b. Phones even if Student missing
		SELECT p.id, p.number, s.name
		FROM phone p
		LEFT JOIN student s ON p.student_id = s.id;


4. MANY-TO-MANY
   ------------
	(Student ↔ Project via join table)

	Join table:
	students_projects.student_id
	students_projects.project_id
	
	a. Query: Student with Projects
		SELECT s.id, s.name, pr.project_name
		FROM student s
		INNER JOIN students_projects sp ON s.id = sp.student_id
		INNER JOIN project pr ON sp.project_id = pr.id;
	
	b. All Students even without Projects
		SELECT s.id, s.name, pr.project_name
		FROM student s
		LEFT JOIN students_projects sp ON s.id = sp.student_id
		LEFT JOIN project pr ON sp.project_id = pr.id;
	
	c. Find Projects for one Student
		SELECT pr.*
		FROM project pr
		INNER JOIN students_projects sp ON pr.id = sp.project_id
		WHERE sp.student_id = 1;
	
Cheat Table:	
| Relationship | SQL Join                          |
| ------------ | --------------------------------- |
| One-to-One   | 'student.address_id = address.id' |
| One-to-Many  | 'student.id = phone.student_id'   |
| Many-to-One  | 'phone.student_id = student.id'   |
| Many-to-Many | 'student → join → project'        |


---------------------------------------------------------------------------------------------
------------------------------------- Inner Join, Left Join, Right Join ---------------------
---------------------------------------------------------------------------------------------
STUDENT:
id | name
---------
1  | Arjun
2  | Ravi

PHONE:
id | student_id | number
------------------------
10 | 1          | 9999
11 | 1          | 8888
12 | 3          | 7777

ADDRESS:
id | student_id | city
----------------------
100 | 1         | Chennai
101 | 2         | Mumbai

INNER JOIN (strict mode): 
	What this means: 
	 - Give me students who have BOTH phone AND address.
	
	SELECT *
	FROM student s
	INNER JOIN phone p ON s.id = p.student_id
	INNER JOIN address a ON s.id = a.student_id;

	| student | phone | address |
	| ------- | ----- | ------- |
	| Arjun   | ✅     | ✅       |

	Because:
	 - Ravi has address, NO phone → excluded
	 - Student 3 has phone, NO student → excluded

LEFT JOIN (forgiving mode):

	What this means: 
	 - Give all students, even if phone or address is missing.

	SELECT *
	FROM student s
	LEFT JOIN phone p ON s.id = p.student_id
	LEFT JOIN address a ON s.id = a.student_id;

	| student | phone | address |
	| ------- | ----- | ------- |
	| Arjun   | ✅     | ✅       |
	| Ravi    | NULL  | ✅       |

	Student 3 not included (not in student table).


RIGHT JOIN (reverse forgiving)

	What this means:
	 - Give all addresses, even if student or phone is missing.

	SELECT *
	FROM student s
	RIGHT JOIN phone p ON s.id = p.student_id
	RIGHT JOIN address a ON s.id = a.student_id;

	| student | phone | address |
	| ------- | ----- | ------- |
	| Arjun   | ✅     | ✅       |
	| Ravi    | NULL  | ✅       |

TRUTH NUGGETS:
-------------
INNER - ONLY where all exist
LEFT  - ALL students survive
RIGHT - ALL of right table survive

Why RIGHT JOIN is rare:
RIGHT JOIN = LEFT JOIN but confusing.
	We prefer:

		FROM Phone
		LEFT JOIN Student
		
	instead of RIGHT JOIN.
	
| JOIN  | Keeps              |
| ----- | ------------------ |
| INNER | Only matched rows  |
| LEFT  | Left table always  |
| RIGHT | Right table always |
| FULL  | Both               |

TRICK:
Ask: "Who must survive even if no match?"
That is your LEFT or RIGHT table.


---------------------------------------------------------------------------------------------
---------------------------- SQL Queries generated (Eager fetch) ----------------------------
---------------------------------------------------------------------------------------------

Actual Query generated when getById(1) for Eager fetch:

select
	student0_.id as id1_3_0_,
	student0_.address_id as address_5_3_0_,
	student0_.email as email2_3_0_,
	student0_.first_name as first_na3_3_0_,
	student0_.last_name as last_nam4_3_0_,
	address1_.id as id1_0_1_,
	address1_.city as city2_0_1_,
	address1_.country as country3_0_1_,
	address1_.house_name as house_na4_0_1_,
	address1_.state as state5_0_1_,
	address1_.street_no as street_n6_0_1_,
	phones2_.student_id as student_4_1_2_,
	phones2_.id as id1_1_2_,
	phones2_.id as id1_1_3_,
	phones2_.phone_model as phone_mo2_1_3_,
	phones2_.phone_number as phone_nu3_1_3_,
	phones2_.student_id as student_4_1_3_,
	projects3_.student_id as student_1_4_4_,
	project4_.id as project_2_4_4_,
	project4_.id as id1_2_5_,
	project4_.project_name as project_2_2_5_
from temp.student student0_
left outer join temp.address address1_ 				on student0_.address_id = address1_.id
left outer join temp.phone phones2_  				on student0_.id = phones2_.student_id
left outer join temp.students_projects projects3_  	on student0_.id = projects3_.student_id
left outer join temp.project project4_ 				on projects3_.project_id = project4_.id
where
	student0_.id = 1;
	
==============================================================
HIBERNATE JOIN QUERY VISUALIZATION (DOCUMENTATION)
==============================================================

PURPOSE:
--------
Fetch Student with id = 1,
along with:
 - their Address (OneToOne)
 - all their Phones OneToMany)
 - all their Projects ((ManyToMany via join table)
   even if some of these don’t exist

TABLES INVOLVED:
----------------
| Alias        | Table                    | Meaning     |
| ------------ | ------------------------ | ----------- |
| `student0_`  | `temp.student`           | Main entity |
| `address1_`  | `temp.address`           | OneToOne    |
| `phones2_`   | `temp.phone`             | OneToMany   |
| `projects3_` | `temp.students_projects` | Join table  |
| `project4_`  | `temp.project`           | ManyToMany  |



LOGICAL RELATIONSHIP MODEL:
---------------------------

                    +------------+
                    |  ADDRESS   |
                    | (OneToOne) |
                    +------------+
                          |
                          |
+----------+      +----------------+
|  PHONE   |<-----|    STUDENT     |-----> STUDENTS_PROJECTS -----> PROJECT
|(Many)    |      |    (Root)      |            (Join table)       (Many)
+----------+      +----------------+


Query:
-----

select 
	*
from temp.student student0_
left outer join temp.address address1_ 				on student0_.address_id = address1_.id
left outer join temp.phone phones2_  				on student0_.id = phones2_.student_id
left outer join temp.students_projects projects3_  	on student0_.id = projects3_.student_id
left outer join temp.project project4_ 				on projects3_.project_id = project4_.id
where
	student0_.id = 1;
	
	
Query breakdown line by line:
-----------------------------
1. Root entity
	FROM temp.student student0_
	
	This is your main table. Think:
	Start at STUDENT

2. One-to-One join (Student → Address)
	LEFT OUTER JOIN temp.address address1_
	ON student0_.address_id = address1_.id
	
	Meaning:
	“If student has an address → load it.
	If not → keep student anyway.”
	
	Visual:
	Student ---> Address

3. One-to-Many join (Student → Phones)
	LEFT OUTER JOIN temp.phone phones2_
	ON student0_.id = phones2_.student_id

	Meaning:
	“Attach ALL phones that belong to this student.”

	Visual:
	Student ---> Phone1
			---> Phone2
			---> PhoneN


4. Many-to-Many (Student → Join table)
	LEFT OUTER JOIN temp.students_projects projects3_
	ON student0_.id = projects3_.student_id
	
	Meaning:
	“Find which projects belong to this student.”

	Visual:
	Student ---> students_projects


5. Join real PROJECT table
	LEFT OUTER JOIN temp.project project4_
	ON projects3_.project_id = project4_.id
	
	Meaning:
	“Load actual Project rows.”

	Visual:
	students_projects ---> Project1
					  ---> Project2


	Final mental picture:
	For student.id = 1, Hibernate constructs:
	Student (1)
	│
	├── Address (1)
	│
	├── Phones (many)
	│     ├── Phone A
	│     └── Phone B
	│
	└── Projects (many)
		  ├── Project X
		  └── Project Y


OBJECT GRAPH BUILT BY HIBERNATE:
--------------------------------

Student (id = 1)
│
├── Address
│
├── Phones (0..N)
│     ├── Phone1
│     └── Phone2
│
└── Projects (0..N)
      ├── ProjectA
      └── ProjectB


WHY SQL RETURNS MULTIPLE ROWS:
-------------------------------
When JOINing collections, SQL multiplies rows.

Example:
Phones = 2
Projects = 2

SQL RESULT = 2 × 2 = 4 ROWS

Meaning:
Each row is a combination, NOT duplicate students.

Example rows:
Phone1 + Project1
Phone1 + Project2
Phone2 + Project1
Phone2 + Project2


WHY API RETURNS ONLY ONE STUDENT:
--------------------------------
Hibernate:
- Creates 1 Student object
- Deduplicates by primary key
- Builds collections internally:
    phones[]
    projects[]


WHY LEFT OUTER JOIN IS USED:
-----------------------------
LEFT JOIN ensures:
- Student returned even if Address is missing
- Student returned even if Phones missing
- Student returned even if Projects missing


IMPORTANT PERFORMANCE NOTE:
----------------------------
This query causes CARTESIAN ROW EXPLOSION:

Student × Phones × Projects

This:
- increases memory usage
- slows queries
- breaks pagination
- makes COUNT(*) inaccurate

Use:
- LAZY fetching
- DTO projections
- SELECT DISTINCT
- JOIN FETCH only when required

---------------------------------------------------------------------------------------------
----------------- ---------- SQL Queries generated (Lazy fetch) -----------------------------
---------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- create tables
--------------------------------------------------------------------------------

create table entityrelationship.address (id bigserial not null,
	city varchar(255),
	country varchar(255),
	house_name varchar(255),
	state varchar(255),
	street_no varchar(255),
	version int8,
	primary key (id)
);

create table entityrelationship.phone (id bigserial not null,
	phone_model varchar(255),
	phone_number varchar(255),
	version int8,
	student_id int8,
	primary key (id)
);

create table entityrelationship.project (id bigserial not null,
	project_name varchar(255),
	version int8,
	primary key (id)
);

create table entityrelationship.student (id bigserial not null,
	email varchar(255),
	first_name varchar(255),
	last_name varchar(255),
	version int8,
	address_id int8,
	primary key (id)
);

create table entityrelationship.students_projects (
	student_id int8 not null,
	project_id int8 not null
);

alter table entityrelationship.phone 
add constraint FK3wql5uvlg7a9y93qpgccvh9oj 
foreign key (student_id) references entityrelationship.student;

alter table entityrelationship.student 
add constraint FKcaf6ht0hfw93lwc13ny0sdmvo 
foreign key (address_id) references entityrelationship.address;

alter table entityrelationship.students_projects 
add constraint FKkas92biqvju2143p2up77uyq6 
foreign key (project_id) references entityrelationship.project;

alter table entityrelationship.students_projects 
add constraint FK4cpwhxitnkgs0tln8bswropqh 
foreign key (student_id) references entityrelationship.student;

--------------------------------------------------------------------------------
-- create student
-- /api/v1/students
--------------------------------------------------------------------------------
/* Request/Response BODY
{
  "firstName": "Mohan",
  "lastName": "Kumar",
  "email": "mohan@gmail.com",
  "address": {
    "houseName": "Sri Lakshmi Nilaya",
    "streetNo": "4",
    "city": "Bangalore",
    "state": "Karnataka",
    "country": "India"
  },
  "phones": [
    {
      "phoneModel": "Android",
      "phoneNumber": "123"
    },
    {
      "phoneModel": "Apple",
      "phoneNumber": "456"
    }
  ],
  "projects": [
    {
      "projectName": "Azure Project"
    },
    {
      "projectName": "AWS Project"
    }
  ]
}


{
  "id": 1,
  "version": 0,
  "firstName": "Mohan",
  "lastName": "Kumar",
  "email": "mohan@gmail.com",
  "address": {
    "id": 1,
    "version": 0,
    "houseName": "Sri Lakshmi Nilaya",
    "streetNo": "4",
    "city": "Bangalore",
    "state": "Karnataka",
    "country": "India"
  },
  "phones": [
    {
      "id": 1,
      "version": 0,
      "phoneModel": "Android",
      "phoneNumber": "123"
    },
    {
      "id": 2,
      "version": 0,
      "phoneModel": "Apple",
      "phoneNumber": "456"
    }
  ],
  "projects": [
    {
      "id": 1,
      "version": 0,
      "projectName": "Azure Project"
    },
    {
      "id": 2,
      "version": 0,
      "projectName": "AWS Project"
    }
  ]
}
*/

insert into entityrelationship.address (city, country, house_name, state, street_no, version) 
values ('Bangalore', 'India', 'Sri Lakshmi Nilaya', 'Karnataka', '4', 0);

insert into entityrelationship.student (address_id, email, first_name, last_name, version) 
values (1, 'mohan@gmail.com', 'Mohan', 'Kumar', 0);

insert into entityrelationship.phone (phone_model, phone_number, student_id, version) 
values ('Android', '123', 1, 0);

insert into entityrelationship.phone (phone_model, phone_number, student_id, version)
values ('Apple', '456', 1, 0);

insert into entityrelationship.project (project_name, version) 
values ('Azure Project', 0);

insert into entityrelationship.project (project_name, version) 
values ('AWS Project', 0);

insert into entityrelationship.students_projects (student_id, project_id) 
values (1, 1);

insert into entityrelationship.students_projects (student_id, project_id) 
values (1, 2);

student
+---+----+-----------------+------------+-----------+---------+------------+
| # | id | email           | first_name | last_name | version | address_id |
+---+----+-----------------+------------+-----------+---------+------------+
| 1 |  1 | mohan@gmail.com | Mohan      | Kumar     |       0 |          1 |
+---+----+-----------------+------------+-----------+---------+------------+

address
+---+----+-----------+---------+--------------------+-----------+-----------+---------+
| # | id | city      | country | house_name         | state     | street_no | version |
+---+----+-----------+---------+--------------------+-----------+-----------+---------+
| 1 |  1 | Bangalore | India   | Sri Lakshmi Nilaya | Karnataka | 4         |       0 |
+---+----+-----------+---------+--------------------+-----------+-----------+---------+

phone
+---+----+-------------+--------------+---------+------------+
| # | id | phone_model | phone_number | version | student_id |
+---+----+-------------+--------------+---------+------------+
| 1 |  1 | Android     | 123          |       0 |          1 |
| 2 |  2 | Apple       | 456          |       0 |          1 |
+---+----+-------------+--------------+---------+------------+

project
+---+----+---------------+---------+
| # | id | project_name  | version |
+---+----+---------------+---------+
| 1 |  1 | Azure Project |       0 |
| 2 |  2 | AWS Project   |       0 |
+---+----+---------------+---------+

students_projects
+---+------------+------------+
| # | student_id | project_id |
+---+------------+------------+
| 1 |          1 |          1 |
| 2 |          1 |          2 |
+---+------------+------------+

--------------------------------------------------------------------------------
-- Get student by ID
-- /api/v1/students/{id}
--------------------------------------------------------------------------------
/* RESPONSE BODY
{
  "id": 1,
  "version": 0,
  "firstName": "Mohan",
  "lastName": "Kumar",
  "email": "mohan@gmail.com",
  "address": {
    "id": 1,
    "version": 0,
    "houseName": "Sri Lakshmi Nilaya",
    "streetNo": "4",
    "city": "Bangalore",
    "state": "Karnataka",
    "country": "India"
  },
  "phones": [
    {
      "id": 1,
      "version": 0,
      "phoneModel": "Android",
      "phoneNumber": "123"
    },
    {
      "id": 2,
      "version": 0,
      "phoneModel": "Apple",
      "phoneNumber": "456"
    }
  ],
  "projects": [
    {
      "id": 1,
      "version": 0,
      "projectName": "Azure Project"
    },
    {
      "id": 2,
      "version": 0,
      "projectName": "AWS Project"
    }
  ]
}
*/

select
	student0_.id as id1_3_0_,
	student0_.address_id as address_6_3_0_,
	student0_.email as email2_3_0_,
	student0_.first_name as first_na3_3_0_,
	student0_.last_name as last_nam4_3_0_,
	student0_.version as version5_3_0_
from
	entityrelationship.student student0_
where
	student0_.id = 1;



select
	address0_.id as id1_0_0_,
	address0_.city as city2_0_0_,
	address0_.country as country3_0_0_,
	address0_.house_name as house_na4_0_0_,
	address0_.state as state5_0_0_,
	address0_.street_no as street_n6_0_0_,
	address0_.version as version7_0_0_
from
	entityrelationship.address address0_
where
	address0_.id = 1;



select
	phones0_.student_id as student_5_1_0_,
	phones0_.id as id1_1_0_,
	phones0_.id as id1_1_1_,
	phones0_.phone_model as phone_mo2_1_1_,
	phones0_.phone_number as phone_nu3_1_1_,
	phones0_.student_id as student_5_1_1_,
	phones0_.version as version4_1_1_
from
	entityrelationship.phone phones0_
where
	phones0_.student_id = 1;



select
	projects0_.student_id as student_1_4_0_,
	projects0_.project_id as project_2_4_0_,
	project1_.id as id1_2_1_,
	project1_.project_name as project_2_2_1_,
	project1_.version as version3_2_1_
from
	entityrelationship.students_projects projects0_
inner join entityrelationship.project project1_ on
	projects0_.project_id = project1_.id
where
	projects0_.student_id = 1;
	
student
+---+----+-----------------+------------+-----------+---------+------------+
| # | id | email           | first_name | last_name | version | address_id |
+---+----+-----------------+------------+-----------+---------+------------+
| 1 |  1 | mohan@gmail.com | Mohan      | Kumar     |       0 |          1 |
+---+----+-----------------+------------+-----------+---------+------------+

address
+---+----+-----------+---------+--------------------+-----------+-----------+---------+
| # | id | city      | country | house_name         | state     | street_no | version |
+---+----+-----------+---------+--------------------+-----------+-----------+---------+
| 1 |  1 | Bangalore | India   | Sri Lakshmi Nilaya | Karnataka | 4         |       0 |
+---+----+-----------+---------+--------------------+-----------+-----------+---------+

phone
+---+----+-------------+--------------+---------+------------+
| # | id | phone_model | phone_number | version | student_id |
+---+----+-------------+--------------+---------+------------+
| 1 |  1 | Android     | 123          |       0 |          1 |
| 2 |  2 | Apple       | 456          |       0 |          1 |
+---+----+-------------+--------------+---------+------------+

project
+---+----+---------------+---------+
| # | id | project_name  | version |
+---+----+---------------+---------+
| 1 |  1 | Azure Project |       0 |
| 2 |  2 | AWS Project   |       0 |
+---+----+---------------+---------+

students_projects
+---+------------+------------+
| # | student_id | project_id |
+---+------------+------------+
| 1 |          1 |          1 |
| 2 |          1 |          2 |
+---+------------+------------+
	
--------------------------------------------------------------------------------
-- Get all students
-- /api/v1/students
--------------------------------------------------------------------------------
/* RESPONSE BODY
[
  {
    "id": 1,
    "version": 0,
    "firstName": "Mohan",
    "lastName": "Kumar",
    "email": "mohan@gmail.com",
    "address": {
      "id": 1,
      "version": 0,
      "houseName": "Sri Lakshmi Nilaya",
      "streetNo": "4",
      "city": "Bangalore",
      "state": "Karnataka",
      "country": "India"
    },
    "phones": [
      {
        "id": 1,
        "version": 0,
        "phoneModel": "Android",
        "phoneNumber": "123"
      },
      {
        "id": 2,
        "version": 0,
        "phoneModel": "Apple",
        "phoneNumber": "456"
      }
    ],
    "projects": [
      {
        "id": 1,
        "version": 0,
        "projectName": "Azure Project"
      },
      {
        "id": 2,
        "version": 0,
        "projectName": "AWS Project"
      }
    ]
  }
]
*/

select
	student0_.id as id1_3_,
	student0_.address_id as address_6_3_,
	student0_.email as email2_3_,
	student0_.first_name as first_na3_3_,
	student0_.last_name as last_nam4_3_,
	student0_.version as version5_3_
from
	entityrelationship.student student0_;



select
	address0_.id as id1_0_0_,
	address0_.city as city2_0_0_,
	address0_.country as country3_0_0_,
	address0_.house_name as house_na4_0_0_,
	address0_.state as state5_0_0_,
	address0_.street_no as street_n6_0_0_,
	address0_.version as version7_0_0_
from
	entityrelationship.address address0_
where
	address0_.id = 1;



select
	phones0_.student_id as student_5_1_0_,
	phones0_.id as id1_1_0_,
	phones0_.id as id1_1_1_,
	phones0_.phone_model as phone_mo2_1_1_,
	phones0_.phone_number as phone_nu3_1_1_,
	phones0_.student_id as student_5_1_1_,
	phones0_.version as version4_1_1_
from
	entityrelationship.phone phones0_
where
	phones0_.student_id = 1;



select
	projects0_.student_id as student_1_4_0_,
	projects0_.project_id as project_2_4_0_,
	project1_.id as id1_2_1_,
	project1_.project_name as project_2_2_1_,
	project1_.version as version3_2_1_
from
	entityrelationship.students_projects projects0_
inner join entityrelationship.project project1_ on
	projects0_.project_id = project1_.id
where
	projects0_.student_id = 1;

student
+---+----+-----------------+------------+-----------+---------+------------+
| # | id | email           | first_name | last_name | version | address_id |
+---+----+-----------------+------------+-----------+---------+------------+
| 1 |  1 | mohan@gmail.com | Mohan      | Kumar     |       0 |          1 |
+---+----+-----------------+------------+-----------+---------+------------+

address
+---+----+-----------+---------+--------------------+-----------+-----------+---------+
| # | id | city      | country | house_name         | state     | street_no | version |
+---+----+-----------+---------+--------------------+-----------+-----------+---------+
| 1 |  1 | Bangalore | India   | Sri Lakshmi Nilaya | Karnataka | 4         |       0 |
+---+----+-----------+---------+--------------------+-----------+-----------+---------+

phone
+---+----+-------------+--------------+---------+------------+
| # | id | phone_model | phone_number | version | student_id |
+---+----+-------------+--------------+---------+------------+
| 1 |  1 | Android     | 123          |       0 |          1 |
| 2 |  2 | Apple       | 456          |       0 |          1 |
+---+----+-------------+--------------+---------+------------+

project
+---+----+---------------+---------+
| # | id | project_name  | version |
+---+----+---------------+---------+
| 1 |  1 | Azure Project |       0 |
| 2 |  2 | AWS Project   |       0 |
+---+----+---------------+---------+

students_projects
+---+------------+------------+
| # | student_id | project_id |
+---+------------+------------+
| 1 |          1 |          1 |
| 2 |          1 |          2 |
+---+------------+------------+

--------------------------------------------------------------------------------
-- Update student by ID
-- /api/v1/students/{id}
--------------------------------------------------------------------------------
/* Request/Response BODY
{
  "version": 0,
  "firstName": "Mohan Updated",
  "lastName": "Kumar Updated",
  "email": "mohan.updated@gmail.com",

  "address": {
    "id": 1,
    "version": 0,
    "houseName": "Sri Lakshmi Nilaya Updated",
    "streetNo": "4 Updated",
    "city": "Bangalore Updated",
    "state": "Karnataka Updated",
    "country": "India Updated"
  },

  "phones": [
    {
      "id": 1,
      "version": 0,
      "phoneModel": "Android Updated",
      "phoneNumber": "123 Updated"
    },
    {
      "id": 2,
      "version": 0,
      "phoneModel": "Apple Updated",
      "phoneNumber": "456 Updated"
    }
  ],

  "projects": [
    {
      "id": 1,
      "version": 0,
      "projectName": "Azure Updated"
    },
    {
      "id": 2,
      "version": 0,
      "projectName": "AWS Updated"
    }
  ]
}


{
  "id": 1,
  "version": 0,
  "firstName": "Mohan Updated",
  "lastName": "Kumar Updated",
  "email": "mohan.updated@gmail.com",
  "address": {
    "id": 1,
    "version": 0,
    "houseName": "Sri Lakshmi Nilaya Updated",
    "streetNo": "4 Updated",
    "city": "Bangalore Updated",
    "state": "Karnataka Updated",
    "country": "India Updated"
  },
  "phones": [
    {
      "id": 1,
      "version": 0,
      "phoneModel": "Android Updated",
      "phoneNumber": "123 Updated"
    },
    {
      "id": 2,
      "version": 0,
      "phoneModel": "Apple Updated",
      "phoneNumber": "456 Updated"
    }
  ],
  "projects": [
    {
      "id": 1,
      "version": 0,
      "projectName": "Azure Updated"
    },
    {
      "id": 2,
      "version": 0,
      "projectName": "AWS Updated"
    }
  ]
}
*/


select
	student0_.id as id1_3_0_,
	student0_.address_id as address_6_3_0_,
	student0_.email as email2_3_0_,
	student0_.first_name as first_na3_3_0_,
	student0_.last_name as last_nam4_3_0_,
	student0_.version as version5_3_0_
from
	entityrelationship.student student0_
where
	student0_.id = 1;



select
	address0_.id as id1_0_0_,
	address0_.city as city2_0_0_,
	address0_.country as country3_0_0_,
	address0_.house_name as house_na4_0_0_,
	address0_.state as state5_0_0_,
	address0_.street_no as street_n6_0_0_,
	address0_.version as version7_0_0_
from
	entityrelationship.address address0_
where
	address0_.id = 1;



select
	phones0_.student_id as student_5_1_0_,
	phones0_.id as id1_1_0_,
	phones0_.id as id1_1_1_,
	phones0_.phone_model as phone_mo2_1_1_,
	phones0_.phone_number as phone_nu3_1_1_,
	phones0_.student_id as student_5_1_1_,
	phones0_.version as version4_1_1_
from
	entityrelationship.phone phones0_
where
	phones0_.student_id = 1;



select
	projects0_.student_id as student_1_4_0_,
	projects0_.project_id as project_2_4_0_,
	project1_.id as id1_2_1_,
	project1_.project_name as project_2_2_1_,
	project1_.version as version3_2_1_
from
	entityrelationship.students_projects projects0_
inner join entityrelationship.project project1_ on
	projects0_.project_id = project1_.id
where
	projects0_.student_id = 1;



update entityrelationship.student
set address_id = 1, email = 'mohan.updated@gmail.com', first_name = 'Mohan Updated', last_name = 'Kumar Updated', version = 1
where id = 1 and version = 0;

update entityrelationship.address
set city = 'Bangalore Updated', country = 'India Updated', house_name = 'Sri Lakshmi Nilaya Updated', state = 'Karnataka Updated', street_no = '4 Updated', version = 1
where id = 1 and version = 0;

update entityrelationship.phone
set phone_model = 'Android Updated', phone_number = '123 Updated', student_id = 1, version = 1
where id = 1 and version = 0;

update entityrelationship.phone
set phone_model = 'Apple Updated', phone_number = '456 Updated', student_id = 1, version = 1
where id = 2 and version = 0;

update entityrelationship.project
set project_name = 'Azure Updated', version = 1
where id = 1 and version = 0;

update entityrelationship.project
set project_name = 'AWS Updated', version = 1
where id = 2 and version = 0;

delete from entityrelationship.students_projects where student_id = 1;

insert into entityrelationship.students_projects (student_id, project_id)
values (1, 1);

insert into entityrelationship.students_projects (student_id, project_id)
values (1, 2);

student
+---+----+-------------------------+---------------+---------------+---------+------------+
| # | id | email                   | first_name    | last_name     | version | address_id |
+---+----+-------------------------+---------------+---------------+---------+------------+
| 1 |  1 | mohan.updated@gmail.com | Mohan Updated | Kumar Updated |       1 |          1 |
+---+----+-------------------------+---------------+---------------+---------+------------+

address
+---+----+-------------------+---------------+----------------------------+-------------------+-----------+---------+
| # | id | city              | country       | house_name                 | state             | street_no | version |
+---+----+-------------------+---------------+----------------------------+-------------------+-----------+---------+
| 1 |  1 | Bangalore Updated | India Updated | Sri Lakshmi Nilaya Updated | Karnataka Updated | 4 Updated |       1 |
+---+----+-------------------+---------------+----------------------------+-------------------+-----------+---------+

phone
+---+----+-----------------+--------------+---------+------------+
| # | id | phone_model     | phone_number | version | student_id |
+---+----+-----------------+--------------+---------+------------+
| 1 |  1 | Android Updated | 123 Updated  |       1 |          1 |
| 2 |  2 | Apple Updated   | 456 Updated  |       1 |          1 |
+---+----+-----------------+--------------+---------+------------+

project
+---+----+---------------+---------+
| # | id | project_name  | version |
+---+----+---------------+---------+
| 1 |  1 | Azure Updated |       1 |
| 2 |  2 | AWS Updated   |       1 |
+---+----+---------------+---------+

students_projects
+---+------------+------------+
| # | student_id | project_id |
+---+------------+------------+
| 1 |          1 |          1 |
| 2 |          1 |          2 |
+---+------------+------------+

--------------------------------------------------------------------------------
-- Patch
-- /api/v1/students/{id}
--------------------------------------------------------------------------------	
/* Request/Response BODY
{
  "version": 1,
  "email": "patched@email.com",
  "address": {
    "city": "Mumbai patched"
  },
  "phones": [
    {
      "id": 1,
      "phoneNumber": "777777 patched"
    },
    {
      "phoneModel": "OnePlus patched",
      "phoneNumber": "666666 patched"
    }
  ],
  "projects": [
    {
      "id": 1,
      "projectName": "Spring Cloud patched"
    },
    {
      "projectName": "Kafka Project patched"
    }
  ]
}

{
  "id": 1,
  "version": 1,
  "firstName": "Mohan Updated",
  "lastName": "Kumar Updated",
  "email": "patched@email.com",
  "address": {
    "id": 1,
    "version": 1,
    "houseName": "Sri Lakshmi Nilaya Updated",
    "streetNo": "4 Updated",
    "city": "Mumbai patched",
    "state": "Karnataka Updated",
    "country": "India Updated"
  },
  "phones": [
    {
      "id": 1,
      "version": 1,
      "phoneModel": "Android Updated",
      "phoneNumber": "777777 patched"
    },
    {
      "id": 2,
      "version": 1,
      "phoneModel": "Apple Updated",
      "phoneNumber": "456 Updated"
    },
    {
      "id": null,
      "version": null,
      "phoneModel": "OnePlus patched",
      "phoneNumber": "666666 patched"
    }
  ],
  "projects": [
    {
      "id": 1,
      "version": 1,
      "projectName": "Spring Cloud patched"
    },
    {
      "id": 2,
      "version": 1,
      "projectName": "AWS Updated"
    },
    {
      "id": null,
      "version": null,
      "projectName": "Kafka Project patched"
    }
  ]
}
*/

select
	student0_.id as id1_3_0_,
	student0_.address_id as address_6_3_0_,
	student0_.email as email2_3_0_,
	student0_.first_name as first_na3_3_0_,
	student0_.last_name as last_nam4_3_0_,
	student0_.version as version5_3_0_
from
	entityrelationship.student student0_
where
	student0_.id = 1;



select
	address0_.id as id1_0_0_,
	address0_.city as city2_0_0_,
	address0_.country as country3_0_0_,
	address0_.house_name as house_na4_0_0_,
	address0_.state as state5_0_0_,
	address0_.street_no as street_n6_0_0_,
	address0_.version as version7_0_0_
from
	entityrelationship.address address0_
where
	address0_.id = 1;



select
	phones0_.student_id as student_5_1_0_,
	phones0_.id as id1_1_0_,
	phones0_.id as id1_1_1_,
	phones0_.phone_model as phone_mo2_1_1_,
	phones0_.phone_number as phone_nu3_1_1_,
	phones0_.student_id as student_5_1_1_,
	phones0_.version as version4_1_1_
from
	entityrelationship.phone phones0_
where
	phones0_.student_id = 1;



select
	projects0_.student_id as student_1_4_0_,
	projects0_.project_id as project_2_4_0_,
	project1_.id as id1_2_1_,
	project1_.project_name as project_2_2_1_,
	project1_.version as version3_2_1_
from
	entityrelationship.students_projects projects0_
inner join entityrelationship.project project1_ on
	projects0_.project_id = project1_.id
where
	projects0_.student_id = 1;



insert into entityrelationship.phone (phone_model, phone_number, student_id, version) 
values ('OnePlus patched', '666666 patched', 1, 0);

insert into entityrelationship.project (project_name, version) 
values ('Kafka Project patched', 0);

update entityrelationship.student 
set address_id=1, email='patched@email.com', first_name='Mohan Updated', last_name='Kumar Updated', version=2 
where id=1 and version=1;

update entityrelationship.address 
set city='Mumbai patched', country='India Updated', house_name='Sri Lakshmi Nilaya Updated', state='Karnataka Updated', street_no='4 Updated', version=2 
where id=1 and version=1;

update entityrelationship.phone 
set phone_model='Android Updated', phone_number='777777 patched', student_id=1, version=2 
where id=1 and version=1;

update entityrelationship.project 
set project_name='Spring Cloud patched', version=2 
where id=1 and version=1;


delete from entityrelationship.students_projects where student_id=1;

insert into entityrelationship.students_projects (student_id, project_id) 
values (1, 1);

insert into entityrelationship.students_projects (student_id, project_id) 
values (1, 2);

insert into entityrelationship.students_projects (student_id, project_id) 
values (1, 3);


student
+---+----+-------------------+---------------+---------------+---------+------------+
| # | id | email             | first_name    | last_name     | version | address_id |
+---+----+-------------------+---------------+---------------+---------+------------+
| 1 |  1 | patched@email.com | Mohan Updated | Kumar Updated |       2 |          1 |
+---+----+-------------------+---------------+---------------+---------+------------+

address
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+
| # | id | city           | country       | house_name                 | state             | street_no | version |
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+
| 1 |  1 | Mumbai patched | India Updated | Sri Lakshmi Nilaya Updated | Karnataka Updated | 4 Updated |       2 |
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+

phone
+---+----+-----------------+----------------+---------+------------+
| # | id | phone_model     | phone_number   | version | student_id |
+---+----+-----------------+----------------+---------+------------+
| 1 |  2 | Apple Updated   | 456 Updated    |       1 |          1 |
| 2 |  3 | OnePlus patched | 666666 patched |       0 |          1 |
| 3 |  1 | Android Updated | 777777 patched |       2 |          1 |
+---+----+-----------------+----------------+---------+------------+

project
+---+----+-----------------------+---------+
| # | id | project_name          | version |
+---+----+-----------------------+---------+
| 1 |  2 | AWS Updated           |       1 |
| 2 |  3 | Kafka Project patched |       0 |
| 3 |  1 | Spring Cloud patched  |       2 |
+---+----+-----------------------+---------+

students_projects
+---+------------+------------+
| # | student_id | project_id |
+---+------------+------------+
| 1 |          1 |          1 |
| 2 |          1 |          2 |
| 3 |          1 |          3 |
+---+------------+------------+
	
--------------------------------------------------------------------------------
-- Get student with Address, Phones, Projects
-- /api/v1/students/{id}/full
--------------------------------------------------------------------------------	
/* Response Body
{
  "id": 1,
  "version": 2,
  "firstName": "Mohan Updated",
  "lastName": "Kumar Updated",
  "email": "patched@email.com",
  "address": {
    "id": 1,
    "version": 2,
    "houseName": "Sri Lakshmi Nilaya Updated",
    "streetNo": "4 Updated",
    "city": "Mumbai patched",
    "state": "Karnataka Updated",
    "country": "India Updated"
  },
  "phones": [
    {
      "id": 1,
      "version": 2,
      "phoneModel": "Android Updated",
      "phoneNumber": "777777 patched"
    },
    {
      "id": 2,
      "version": 1,
      "phoneModel": "Apple Updated",
      "phoneNumber": "456 Updated"
    },
    {
      "id": 3,
      "version": 0,
      "phoneModel": "OnePlus patched",
      "phoneNumber": "666666 patched"
    }
  ],
  "projects": [
    {
      "id": 1,
      "version": 2,
      "projectName": "Spring Cloud patched"
    },
    {
      "id": 2,
      "version": 1,
      "projectName": "AWS Updated"
    },
    {
      "id": 3,
      "version": 0,
      "projectName": "Kafka Project patched"
    }
  ]
}
*/

select
	student0_.id as id1_3_0_,
	address1_.id as id1_0_1_,
	student0_.address_id as address_6_3_0_,
	student0_.email as email2_3_0_,
	student0_.first_name as first_na3_3_0_,
	student0_.last_name as last_nam4_3_0_,
	student0_.version as version5_3_0_,
	address1_.city as city2_0_1_,
	address1_.country as country3_0_1_,
	address1_.house_name as house_na4_0_1_,
	address1_.state as state5_0_1_,
	address1_.street_no as street_n6_0_1_,
	address1_.version as version7_0_1_
from
	entityrelationship.student student0_
left outer join entityrelationship.address address1_ on
	student0_.address_id = address1_.id
where
	student0_.id = 1;



select
	distinct student0_.id as id1_3_0_,
	phones1_.id as id1_1_1_,
	student0_.address_id as address_6_3_0_,
	student0_.email as email2_3_0_,
	student0_.first_name as first_na3_3_0_,
	student0_.last_name as last_nam4_3_0_,
	student0_.version as version5_3_0_,
	phones1_.phone_model as phone_mo2_1_1_,
	phones1_.phone_number as phone_nu3_1_1_,
	phones1_.student_id as student_5_1_1_,
	phones1_.version as version4_1_1_,
	phones1_.student_id as student_5_1_0__,
	phones1_.id as id1_1_0__
from
	entityrelationship.student student0_
left outer join entityrelationship.phone phones1_ on
	student0_.id = phones1_.student_id
where
	student0_.id = 1;



select
	distinct student0_.id as id1_3_0_,
	project2_.id as id1_2_1_,
	student0_.address_id as address_6_3_0_,
	student0_.email as email2_3_0_,
	student0_.first_name as first_na3_3_0_,
	student0_.last_name as last_nam4_3_0_,
	student0_.version as version5_3_0_,
	project2_.project_name as project_2_2_1_,
	project2_.version as version3_2_1_,
	projects1_.student_id as student_1_4_0__,
	projects1_.project_id as project_2_4_0__
from
	entityrelationship.student student0_
left outer join entityrelationship.students_projects projects1_ on
	student0_.id = projects1_.student_id
left outer join entityrelationship.project project2_ on
	projects1_.project_id = project2_.id
where
	student0_.id = 1;

student
+---+----+-------------------+---------------+---------------+---------+------------+
| # | id | email             | first_name    | last_name     | version | address_id |
+---+----+-------------------+---------------+---------------+---------+------------+
| 1 |  1 | patched@email.com | Mohan Updated | Kumar Updated |       2 |          1 |
+---+----+-------------------+---------------+---------------+---------+------------+

address
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+
| # | id | city           | country       | house_name                 | state             | street_no | version |
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+
| 1 |  1 | Mumbai patched | India Updated | Sri Lakshmi Nilaya Updated | Karnataka Updated | 4 Updated |       2 |
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+

phone
+---+----+-----------------+----------------+---------+------------+
| # | id | phone_model     | phone_number   | version | student_id |
+---+----+-----------------+----------------+---------+------------+
| 1 |  2 | Apple Updated   | 456 Updated    |       1 |          1 |
| 2 |  3 | OnePlus patched | 666666 patched |       0 |          1 |
| 3 |  1 | Android Updated | 777777 patched |       2 |          1 |
+---+----+-----------------+----------------+---------+------------+

project
+---+----+-----------------------+---------+
| # | id | project_name          | version |
+---+----+-----------------------+---------+
| 1 |  2 | AWS Updated           |       1 |
| 2 |  3 | Kafka Project patched |       0 |
| 3 |  1 | Spring Cloud patched  |       2 |
+---+----+-----------------------+---------+

students_projects
+---+------------+------------+
| # | student_id | project_id |
+---+------------+------------+
| 1 |          1 |          1 |
| 2 |          1 |          2 |
| 3 |          1 |          3 |
+---+------------+------------+

--------------------------------------------------------------------------------
-- Get students by project name
-- /api/v1/students/project/{name}
--------------------------------------------------------------------------------
/* Response Body

project name: Kafka Project patched

[
  {
    "id": 1,
    "version": 2,
    "firstName": "Mohan Updated",
    "lastName": "Kumar Updated",
    "email": "patched@email.com",
    "address": {
      "id": 1,
      "version": 2,
      "houseName": "Sri Lakshmi Nilaya Updated",
      "streetNo": "4 Updated",
      "city": "Mumbai patched",
      "state": "Karnataka Updated",
      "country": "India Updated"
    },
    "phones": [
      {
        "id": 2,
        "version": 1,
        "phoneModel": "Apple Updated",
        "phoneNumber": "456 Updated"
      },
      {
        "id": 3,
        "version": 0,
        "phoneModel": "OnePlus patched",
        "phoneNumber": "666666 patched"
      },
      {
        "id": 1,
        "version": 2,
        "phoneModel": "Android Updated",
        "phoneNumber": "777777 patched"
      }
    ],
    "projects": [
      {
        "id": 2,
        "version": 1,
        "projectName": "AWS Updated"
      },
      {
        "id": 3,
        "version": 0,
        "projectName": "Kafka Project patched"
      },
      {
        "id": 1,
        "version": 2,
        "projectName": "Spring Cloud patched"
      }
    ]
  }
]
*/

select
	distinct student0_.id as id1_3_,
	student0_.address_id as address_6_3_,
	student0_.email as email2_3_,
	student0_.first_name as first_na3_3_,
	student0_.last_name as last_nam4_3_,
	student0_.version as version5_3_
from
	entityrelationship.student student0_
inner join entityrelationship.students_projects projects1_ on
	student0_.id = projects1_.student_id
inner join entityrelationship.project project2_ on
	projects1_.project_id = project2_.id
where
	project2_.project_name = 'Kafka Project patched';



select
	address0_.id as id1_0_0_,
	address0_.city as city2_0_0_,
	address0_.country as country3_0_0_,
	address0_.house_name as house_na4_0_0_,
	address0_.state as state5_0_0_,
	address0_.street_no as street_n6_0_0_,
	address0_.version as version7_0_0_
from
	entityrelationship.address address0_
where
	address0_.id = 1;



select
	phones0_.student_id as student_5_1_0_,
	phones0_.id as id1_1_0_,
	phones0_.id as id1_1_1_,
	phones0_.phone_model as phone_mo2_1_1_,
	phones0_.phone_number as phone_nu3_1_1_,
	phones0_.student_id as student_5_1_1_,
	phones0_.version as version4_1_1_
from
	entityrelationship.phone phones0_
where
	phones0_.student_id = 1;



select
	projects0_.student_id as student_1_4_0_,
	projects0_.project_id as project_2_4_0_,
	project1_.id as id1_2_1_,
	project1_.project_name as project_2_2_1_,
	project1_.version as version3_2_1_
from
	entityrelationship.students_projects projects0_
inner join entityrelationship.project project1_ on
	projects0_.project_id = project1_.id
where
	projects0_.student_id = 1;

student
+---+----+-------------------+---------------+---------------+---------+------------+
| # | id | email             | first_name    | last_name     | version | address_id |
+---+----+-------------------+---------------+---------------+---------+------------+
| 1 |  1 | patched@email.com | Mohan Updated | Kumar Updated |       2 |          1 |
+---+----+-------------------+---------------+---------------+---------+------------+

address
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+
| # | id | city           | country       | house_name                 | state             | street_no | version |
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+
| 1 |  1 | Mumbai patched | India Updated | Sri Lakshmi Nilaya Updated | Karnataka Updated | 4 Updated |       2 |
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+

phone
+---+----+-----------------+----------------+---------+------------+
| # | id | phone_model     | phone_number   | version | student_id |
+---+----+-----------------+----------------+---------+------------+
| 1 |  2 | Apple Updated   | 456 Updated    |       1 |          1 |
| 2 |  3 | OnePlus patched | 666666 patched |       0 |          1 |
| 3 |  1 | Android Updated | 777777 patched |       2 |          1 |
+---+----+-----------------+----------------+---------+------------+

project
+---+----+-----------------------+---------+
| # | id | project_name          | version |
+---+----+-----------------------+---------+
| 1 |  2 | AWS Updated           |       1 |
| 2 |  3 | Kafka Project patched |       0 |
| 3 |  1 | Spring Cloud patched  |       2 |
+---+----+-----------------------+---------+

students_projects
+---+------------+------------+
| # | student_id | project_id |
+---+------------+------------+
| 1 |          1 |          1 |
| 2 |          1 |          2 |
| 3 |          1 |          3 |
+---+------------+------------+

--------------------------------------------------------------------------------
-- Get students with phones
-- /api/v1/students/with-phones
--------------------------------------------------------------------------------
/* Response Body
[
  {
    "id": 1,
    "version": 2,
    "firstName": "Mohan Updated",
    "lastName": "Kumar Updated",
    "email": "patched@email.com",
    "address": {
      "id": 1,
      "version": 2,
      "houseName": "Sri Lakshmi Nilaya Updated",
      "streetNo": "4 Updated",
      "city": "Mumbai patched",
      "state": "Karnataka Updated",
      "country": "India Updated"
    },
    "phones": [
      {
        "id": 2,
        "version": 1,
        "phoneModel": "Apple Updated",
        "phoneNumber": "456 Updated"
      },
      {
        "id": 3,
        "version": 0,
        "phoneModel": "OnePlus patched",
        "phoneNumber": "666666 patched"
      },
      {
        "id": 1,
        "version": 2,
        "phoneModel": "Android Updated",
        "phoneNumber": "777777 patched"
      }
    ],
    "projects": [
      {
        "id": 2,
        "version": 1,
        "projectName": "AWS Updated"
      },
      {
        "id": 3,
        "version": 0,
        "projectName": "Kafka Project patched"
      },
      {
        "id": 1,
        "version": 2,
        "projectName": "Spring Cloud patched"
      }
    ]
  }
]
*/

select
	distinct student0_.id as id1_3_,
	student0_.address_id as address_6_3_,
	student0_.email as email2_3_,
	student0_.first_name as first_na3_3_,
	student0_.last_name as last_nam4_3_,
	student0_.version as version5_3_
from
	entityrelationship.student student0_
inner join entityrelationship.phone phones1_ on
	student0_.id = phones1_.student_id;



select
	address0_.id as id1_0_0_,
	address0_.city as city2_0_0_,
	address0_.country as country3_0_0_,
	address0_.house_name as house_na4_0_0_,
	address0_.state as state5_0_0_,
	address0_.street_no as street_n6_0_0_,
	address0_.version as version7_0_0_
from
	entityrelationship.address address0_
where
	address0_.id = 1;



select
	phones0_.student_id as student_5_1_0_,
	phones0_.id as id1_1_0_,
	phones0_.id as id1_1_1_,
	phones0_.phone_model as phone_mo2_1_1_,
	phones0_.phone_number as phone_nu3_1_1_,
	phones0_.student_id as student_5_1_1_,
	phones0_.version as version4_1_1_
from
	entityrelationship.phone phones0_
where
	phones0_.student_id = 1;



select
	projects0_.student_id as student_1_4_0_,
	projects0_.project_id as project_2_4_0_,
	project1_.id as id1_2_1_,
	project1_.project_name as project_2_2_1_,
	project1_.version as version3_2_1_
from
	entityrelationship.students_projects projects0_
inner join entityrelationship.project project1_ on
	projects0_.project_id = project1_.id
where
	projects0_.student_id = 1;

student
+---+----+-------------------+---------------+---------------+---------+------------+
| # | id | email             | first_name    | last_name     | version | address_id |
+---+----+-------------------+---------------+---------------+---------+------------+
| 1 |  1 | patched@email.com | Mohan Updated | Kumar Updated |       2 |          1 |
+---+----+-------------------+---------------+---------------+---------+------------+

address
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+
| # | id | city           | country       | house_name                 | state             | street_no | version |
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+
| 1 |  1 | Mumbai patched | India Updated | Sri Lakshmi Nilaya Updated | Karnataka Updated | 4 Updated |       2 |
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+

phone
+---+----+-----------------+----------------+---------+------------+
| # | id | phone_model     | phone_number   | version | student_id |
+---+----+-----------------+----------------+---------+------------+
| 1 |  2 | Apple Updated   | 456 Updated    |       1 |          1 |
| 2 |  3 | OnePlus patched | 666666 patched |       0 |          1 |
| 3 |  1 | Android Updated | 777777 patched |       2 |          1 |
+---+----+-----------------+----------------+---------+------------+

project
+---+----+-----------------------+---------+
| # | id | project_name          | version |
+---+----+-----------------------+---------+
| 1 |  2 | AWS Updated           |       1 |
| 2 |  3 | Kafka Project patched |       0 |
| 3 |  1 | Spring Cloud patched  |       2 |
+---+----+-----------------------+---------+

students_projects
+---+------------+------------+
| # | student_id | project_id |
+---+------------+------------+
| 1 |          1 |          1 |
| 2 |          1 |          2 |
| 3 |          1 |          3 |
+---+------------+------------+

--------------------------------------------------------------------------------
-- Get students without phones
-- /api/v1/students/without-phones
--------------------------------------------------------------------------------
/* Response Body
[
  {
    "id": 0,
    "version": 0,
    "firstName": "string",
    "lastName": "string",
    "email": "string",
    "address": {
      "id": 0,
      "version": 0,
      "houseName": "string",
      "streetNo": "string",
      "city": "string",
      "state": "string",
      "country": "string"
    },
    "phones": [
      {
        "id": 0,
        "version": 0,
        "phoneModel": "string",
        "phoneNumber": "string"
      }
    ],
    "projects": [
      {
        "id": 0,
        "version": 0,
        "projectName": "string"
      }
    ]
  }
]
*/

select
	student0_.id as id1_3_,
	student0_.address_id as address_6_3_,
	student0_.email as email2_3_,
	student0_.first_name as first_na3_3_,
	student0_.last_name as last_nam4_3_,
	student0_.version as version5_3_
from
	entityrelationship.student student0_
left outer join entityrelationship.phone phones1_ on
	student0_.id = phones1_.student_id
where
	phones1_.id is null;

student
+---+----+-------------------+---------------+---------------+---------+------------+
| # | id | email             | first_name    | last_name     | version | address_id |
+---+----+-------------------+---------------+---------------+---------+------------+
| 1 |  1 | patched@email.com | Mohan Updated | Kumar Updated |       2 |          1 |
+---+----+-------------------+---------------+---------------+---------+------------+

address
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+
| # | id | city           | country       | house_name                 | state             | street_no | version |
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+
| 1 |  1 | Mumbai patched | India Updated | Sri Lakshmi Nilaya Updated | Karnataka Updated | 4 Updated |       2 |
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+

phone
+---+----+-----------------+----------------+---------+------------+
| # | id | phone_model     | phone_number   | version | student_id |
+---+----+-----------------+----------------+---------+------------+
| 1 |  2 | Apple Updated   | 456 Updated    |       1 |          1 |
| 2 |  3 | OnePlus patched | 666666 patched |       0 |          1 |
| 3 |  1 | Android Updated | 777777 patched |       2 |          1 |
+---+----+-----------------+----------------+---------+------------+

project
+---+----+-----------------------+---------+
| # | id | project_name          | version |
+---+----+-----------------------+---------+
| 1 |  2 | AWS Updated           |       1 |
| 2 |  3 | Kafka Project patched |       0 |
| 3 |  1 | Spring Cloud patched  |       2 |
+---+----+-----------------------+---------+

students_projects
+---+------------+------------+
| # | student_id | project_id |
+---+------------+------------+
| 1 |          1 |          1 |
| 2 |          1 |          2 |
| 3 |          1 |          3 |
+---+------------+------------+

--------------------------------------------------------------------------------
-- Get projects of a student
-- /api/v1/students/{id}/projects
--------------------------------------------------------------------------------
/* Response Body
[
  {
    "id": 2,
    "version": 1,
    "projectName": "AWS Updated"
  },
  {
    "id": 3,
    "version": 0,
    "projectName": "Kafka Project patched"
  },
  {
    "id": 1,
    "version": 2,
    "projectName": "Spring Cloud patched"
  }
]
*/

select
	student0_.id as id1_3_0_,
	student0_.address_id as address_6_3_0_,
	student0_.email as email2_3_0_,
	student0_.first_name as first_na3_3_0_,
	student0_.last_name as last_nam4_3_0_,
	student0_.version as version5_3_0_
from
	entityrelationship.student student0_
where
	student0_.id = 1;



select
	project0_.id as id1_2_,
	project0_.project_name as project_2_2_,
	project0_.version as version3_2_
from
	entityrelationship.project project0_
inner join entityrelationship.students_projects students1_ on
	project0_.id = students1_.project_id
inner join entityrelationship.student student2_ on
	students1_.student_id = student2_.id
where
	student2_.id = 1;

student
+---+----+-------------------+---------------+---------------+---------+------------+
| # | id | email             | first_name    | last_name     | version | address_id |
+---+----+-------------------+---------------+---------------+---------+------------+
| 1 |  1 | patched@email.com | Mohan Updated | Kumar Updated |       2 |          1 |
+---+----+-------------------+---------------+---------------+---------+------------+

address
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+
| # | id | city           | country       | house_name                 | state             | street_no | version |
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+
| 1 |  1 | Mumbai patched | India Updated | Sri Lakshmi Nilaya Updated | Karnataka Updated | 4 Updated |       2 |
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+

phone
+---+----+-----------------+----------------+---------+------------+
| # | id | phone_model     | phone_number   | version | student_id |
+---+----+-----------------+----------------+---------+------------+
| 1 |  2 | Apple Updated   | 456 Updated    |       1 |          1 |
| 2 |  3 | OnePlus patched | 666666 patched |       0 |          1 |
| 3 |  1 | Android Updated | 777777 patched |       2 |          1 |
+---+----+-----------------+----------------+---------+------------+

project
+---+----+-----------------------+---------+
| # | id | project_name          | version |
+---+----+-----------------------+---------+
| 1 |  2 | AWS Updated           |       1 |
| 2 |  3 | Kafka Project patched |       0 |
| 3 |  1 | Spring Cloud patched  |       2 |
+---+----+-----------------------+---------+

students_projects
+---+------------+------------+
| # | student_id | project_id |
+---+------------+------------+
| 1 |          1 |          1 |
| 2 |          1 |          2 |
| 3 |          1 |          3 |
+---+------------+------------+

--------------------------------------------------------------------------------
-- Delete student by ID
-- /api/v1/students/{id}
--------------------------------------------------------------------------------
Before delete:
student
+---+----+-------------------+---------------+---------------+---------+------------+
| # | id | email             | first_name    | last_name     | version | address_id |
+---+----+-------------------+---------------+---------------+---------+------------+
| 1 |  1 | patched@email.com | Mohan Updated | Kumar Updated |       2 |          1 |
+---+----+-------------------+---------------+---------------+---------+------------+

address
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+
| # | id | city           | country       | house_name                 | state             | street_no | version |
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+
| 1 |  1 | Mumbai patched | India Updated | Sri Lakshmi Nilaya Updated | Karnataka Updated | 4 Updated |       2 |
+---+----+----------------+---------------+----------------------------+-------------------+-----------+---------+

phone
+---+----+-----------------+----------------+---------+------------+
| # | id | phone_model     | phone_number   | version | student_id |
+---+----+-----------------+----------------+---------+------------+
| 1 |  2 | Apple Updated   | 456 Updated    |       1 |          1 |
| 2 |  3 | OnePlus patched | 666666 patched |       0 |          1 |
| 3 |  1 | Android Updated | 777777 patched |       2 |          1 |
+---+----+-----------------+----------------+---------+------------+

project
+---+----+-----------------------+---------+
| # | id | project_name          | version |
+---+----+-----------------------+---------+
| 1 |  2 | AWS Updated           |       1 |
| 2 |  3 | Kafka Project patched |       0 |
| 3 |  1 | Spring Cloud patched  |       2 |
+---+----+-----------------------+---------+

students_projects
+---+------------+------------+
| # | student_id | project_id |
+---+------------+------------+
| 1 |          1 |          1 |
| 2 |          1 |          2 |
| 3 |          1 |          3 |
+---+------------+------------+


select
	student0_.id as id1_3_0_,
	student0_.address_id as address_6_3_0_,
	student0_.email as email2_3_0_,
	student0_.first_name as first_na3_3_0_,
	student0_.last_name as last_nam4_3_0_,
	student0_.version as version5_3_0_
from
	entityrelationship.student student0_
where
	student0_.id = 1;


select
	phones0_.student_id as student_5_1_0_,
	phones0_.id as id1_1_0_,
	phones0_.id as id1_1_1_,
	phones0_.phone_model as phone_mo2_1_1_,
	phones0_.phone_number as phone_nu3_1_1_,
	phones0_.student_id as student_5_1_1_,
	phones0_.version as version4_1_1_
from
	entityrelationship.phone phones0_
where
	phones0_.student_id = 1;


select
	address0_.id as id1_0_0_,
	address0_.city as city2_0_0_,
	address0_.country as country3_0_0_,
	address0_.house_name as house_na4_0_0_,
	address0_.state as state5_0_0_,
	address0_.street_no as street_n6_0_0_,
	address0_.version as version7_0_0_
from
	entityrelationship.address address0_
where
	address0_.id = 1;
	
	
delete from entityrelationship.students_projects where student_id=1;
delete from entityrelationship.phone where id=2 and version=1;
delete from entityrelationship.phone where id=3 and version=0;
delete from entityrelationship.phone where id=1 and version=2;
delete from entityrelationship.student where id=1 and version=2;
delete from entityrelationship.address where id=1 and version=2;



After delete:
+---+----+-------+------------+-----------+---------+------------+
| # | id | email | first_name | last_name | version | address_id |
+---+----+-------+------------+-----------+---------+------------+
+---+----+-------+------------+-----------+---------+------------+

address
+---+----+------+---------+------------+-------+-----------+---------+
| # | id | city | country | house_name | state | street_no | version |
+---+----+------+---------+------------+-------+-----------+---------+
+---+----+------+---------+------------+-------+-----------+---------+

phone
+---+----+-------------+--------------+---------+------------+
| # | id | phone_model | phone_number | version | student_id |
+---+----+-------------+--------------+---------+------------+
+---+----+-------------+--------------+---------+------------+

project
+---+----+-----------------------+---------+
| # | id | project_name          | version |
+---+----+-----------------------+---------+
| 1 |  2 | AWS Updated           |       1 |
| 2 |  3 | Kafka Project patched |       0 |
| 3 |  1 | Spring Cloud patched  |       2 |
+---+----+-----------------------+---------+

students_projects
+---+------------+------------+
| # | student_id | project_id |
+---+------------+------------+
+---+------------+------------+