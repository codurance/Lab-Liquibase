# Tagging specific versions of database state

Liquibase provides rollback options for user defined tags in the database

To mark specific state of database use:

```xml
<changeSet author="liquibase" id="2">
    <tagDatabase tag="v1"/>
</changeSet>
```

Liquibase doesn't allow to put **tagDatabase** in the same **changeSet** as schema updates. First perform schema changes, then create another operation to tag state of DB:

```xml
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
```

Tags are VARCHAR type so can, and should, be descriptive.