## Using PreCoditions
PreCoditions are used for pre checks of database, can validate if schema is in proper state, and control what changesets to run or not.

example changeset with precondition checking if table contains specific column:

```xml
<changeSet id="test-1" author="liquibase" context="test">
    <preConditions onFail="HALT" onError="HALT">
        <sqlCheck expectedResult="0">
        SELECT COUNT(1) FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME='User-Email'
        </sqlCheck>
    </preConditions>
</changeSet>
```

for more depth information please check official [documentation]([https://docs.liquibase.com/concepts/advanced/preconditions.html](https://docs.liquibase.com/concepts/advanced/preconditions.html))