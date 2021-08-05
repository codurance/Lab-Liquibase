# Change Table Name

Performing changes of Table name requires specific Transition period to perform update and rollback securely

 

![](../DocImages/Change%20Table%20Name.jpg)

First rename table and create view, add proper tags to the database for easy rollback with next changeSet:

```xml
<changeSet author="liquibase" id="6">
    <renameTable schemaName="public"
        newTableName="Customers"
        oldTableName="Users"/>
    <createView schemaName="public"
        encoding="UTF-8"
        viewName="Users">
        select * from public."Customers"
    </createView>
</changeSet>

<changeSet author="liquibase" id="7">
    <tagDatabase tag="rename_table_Users_to_Customers_transition_start"/>
</changeSet>
```

When transition period is over and all applications are using updated table name, drop View from the DB, remember to tag properly changes to be able to easily rollback

```xml
<changeSet author="liquibase" id="8">
    <dropView schemaName="public"
        viewName="Users"/>
</changeSet>

<changeSet author="liquibase" id="9">
    <tagDatabase tag="rename_table_Users_to_Customers_transition_end"/>
</changeSet>
```