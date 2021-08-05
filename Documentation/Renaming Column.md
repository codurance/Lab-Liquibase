# Renaming Column       
Simple migration performing change of the column name, in this example we are changing **User-Email** to **Email** column. 

Note that we are not providing any transition period so application using previous column name won't work

```xml
<changeSet author="liquibase" id="4">
    <renameColumn columnDataType="VARCHAR(255)"
        newColumnName="Email"
        oldColumnName="User-Email"
        tableName="Users"
    />
</changeSet>
```