# Using Contexts
Liquibase provide option to scope specific migrations to context using *context* tag in the XML

```xml
<changeSet author="liquibase" id="3" context="test">
    <loadData encoding="UTF-8"
        file="./changelog/data/users.csv"
        separator=","
        tableName="Users"
    />
    <rollback>
        <delete tableName="Users">
        </delete>
    </rollback>
</changeSet>
```

To run specify the context to run add **—contexts** flag to liquibase command:

```bash
docker-compose run --rm liquibase --defaultsFile=/liquibase/changelog/liquibase.properties --contexts="test" rollbackCount <value>
```

**IMPORTANT** if there is not context specify Liquibase will run *ALL* migrations no matter what context they belong to!

To prevent this situation you can specify default context in [liquibase.properties](http://liquibase.properties) using:

```bash
contexts: <context-name>
```

[Documentation](https://docs.liquibase.com/concepts/advanced/contexts.html)