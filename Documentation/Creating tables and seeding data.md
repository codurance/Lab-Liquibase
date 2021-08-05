# Creating tables and seeding data
**changeSet** is the basic block where we define changes to perform to the database schema as atomic update

- author - provide name/user of who create changes
- id - identifier of the migration, must be unique

```xml
<?xml version="1.0" encoding="UTF-8"?>  
<databaseChangeLog  
  xmlns="http://www.liquibase.org/xml/ns/dbchangelog"  
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  
  xmlns:pro="http://www.liquibase.org/xml/ns/pro"  
  xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.2.xsd
      http://www.liquibase.org/xml/ns/pro http://www.liquibase.org/xml/ns/pro/liquibase-pro-4.2.xsd">

    <changeSet author="liquibase" id="1">
        <createTable tableName="Users">
            <column autoIncrement="true" name="id" type="INTEGER">
                <constraints nullable="false" primaryKey="true" primaryKeyName="user_pkey"/>
            </column>
            <column name="Name" type="VARCHAR(255)"/>
            <column name="User-Email" type="VARCHAR(255)"/>
            <column name="Status" type="VARCHAR(100)"/>
        </createTable>
    </changeSet>

</databaseChangeLog>
```

### Data Seeding using Changelog

For seeding data use *loadData* tag, point to the CSV file with data, specify separator and table to insert data into 

*(pass the proper path to the seed file matching the mounted volume in the Liquibase container)*

```xml
<changeSet author="liquibase" id="2">
    <loadData encoding="UTF-8"
        file="./changelog/data/users.csv"
        separator=","
        tableName="Users">
    </loadData>
</changeSet>
```

Example of CSV:

*Note that first row holds columns names for mapping*

```
"Name","User-Email","Status"
"John Doe","j.doe@example.com","basic"
"Marry Doe","m.doe@example.com","silver"
```

### Deleting seeded data

Not all types of operations on DB liquibase can rollback automatically. 

One example is *loadData*, Liquibase provide option to define custom rollback for any *changeSet* using **rollback** tag inside XML, inside you can define rollback instructions using Liquibase syntax

```xml
<changeSet author="liquibase" id="3">
    <loadData encoding="UTF-8"
        file="./changelog/data/users.csv"
        separator=","
        tableName="Users"/>
    <rollback>
        <delete tableName="Users">
        </delete>
    </rollback>
</changeSet>
```