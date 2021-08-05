# Using Partials XML

Liquibase provide option to split the changelong into multiple files using *include* tag:

```xml
<include file="./changelog/partials/create-users-table.xml"/>
```

Each partial file must have *xml version* tag and *databaseChangeLog* tag:

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

<changeSet author="liquibase" id="2">
    <tagDatabase tag="create_users_table"/>
</changeSet>

</databaseChangeLog>
```