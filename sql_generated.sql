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