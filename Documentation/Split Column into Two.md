# Split Column into Two 

One common operation is to split single column into two columns. In this case we should keep in the transition period original column and add new ones with database triggers to keep data in sync, when transition period is over - just drop old column and triggers

![](../DocImages/Split%20Column.jpg)

## Transition Period setup

In Liquibase we add two new columns to Users table, and provide two custom sql scripts to execute - one to split data in table using UPDATE statement *( note that in this example we don't have massive amount of records, in case of big amount data this might not be proper solution to perform transition, you might want to modify trigger to perform data motion on READ operation for example ).*

This will start our transition period where we have *Name, First Name, Last Name* columns present at same time and TRIGGERS will automatically transform data from *Name* to *First Name* and *Last Name* and other way around.

Because custom SQL script were used *rollback* must be defined manually - we should ensure that all data for *First Name* and *Last Name* are joined back to *Name* column and drop procedures and triggers.

Last step is to tag the state of Database for the rollback purposes with *tagDatabase* using descriptive name 

```xml
<changeSet author="liquibase" id="10">
    <addColumn schemaName="public"
        tableName="Customers">
        <column name="First_Name"
            afterColumn="Name"
            type="VARCHAR(120)">
        </column>
        <column name="Last_Name"
            afterColumn="First_Name"
            type="VARCHAR(120)">
        </column>
    </addColumn>
    <sqlFile path="./changelog/sql/SplitNameToFirstAndLast/split-name.sql"/>
    <sqlFile path="./changelog/sql/SplitNameToFirstAndLast/name-trigger.sql" splitStatements="false"/>

    <rollback>
        <sqlFile path="./changelog/sql/SplitNameToFirstAndLast/join-name.sql"/>
        <sqlFile path="./changelog/sql/SplitNameToFirstAndLast/drop-trigger.sql" splitStatements="false"/>
        <dropColumn schemaName="public"
            tableName="Customers">
            <column name="First_Name"/>
            <column name="Last_Name"/>
        </dropColumn>
    </rollback>
</changeSet>

<changeSet author="liquibase" id="11">
    <tagDatabase tag="split_customers_name_to_first_and_last_name_transition_start"/>
</changeSet>
```

Examples of SQL:

Split Name to First Name and Last Name

```sql
UPDATE public."Customers"
SET "First_Name" = split_part("Name", ' ', 1),
"Last_Name" = split_part("Name", ' ', 2)
```

Create Procedure and Trigger:

```sql
CREATE FUNCTION public.set_names()
    RETURNS trigger
    LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    IF NEW."Name" IS NOT NULL THEN
        NEW."First_Name" := split_part(NEW."Name", ' ', 1);
        NEW."Last_Name" := split_part(NEW."Name", ' ', 2);
    ELSE
        NEW."Name" := CONCAT(NEW."First_Name", ' ', NEW."Last_Name");
    END IF;
    RETURN NEW;
END;
$BODY$;

CREATE TRIGGER set_names
    BEFORE INSERT
    ON public."Customers"
    FOR EACH ROW
    EXECUTE FUNCTION public.set_names();
```

Join First Name and Last Name to Name:

```sql
UPDATE public."Customers"
SET "Name" = CONCAT("First_Name", ' ', "Last_Name");
```

Drop Trigger and Procedure:

```sql
DROP TRIGGER IF EXISTS set_names ON public."Customers";
DROP FUNCTION IF EXISTS public.set_names();
```

## Ending Transition

To end Transition period drop the *Name* table, Store Procedure and Trigger

In case of *dropColumn* tag Liquibase doesn't provide rollback option, same as for custom SQL scripts so we have to define rollback again by hand. We can reuse previously created SQL files.

Remember to properly tag state of database after this migration with next change set and description informing that transition period is over.

```xml
<changeSet author="liquibase" id="12">
    <dropColumn schemaName="public"
        tableName="Customers">
        <column name="Name"/>
    </dropColumn>
    <sqlFile path="./changelog/sql/SplitNameToFirstAndLast/drop-trigger.sql" splitStatements="false"/>
    <rollback>
        <addColumn schemaName="public"
            tableName="Customers">
            <column name="Name"
                position="2"
                type="VARCHAR(255)">
            </column>
        </addColumn>
        <sqlFile path="./changelog/sql/SplitNameToFirstAndLast/name-trigger.sql" splitStatements="false"/>
        <sqlFile path="./changelog/sql/SplitNameToFirstAndLast/join-name.sql"/>
    </rollback>
</changeSet>

<changeSet author="liquibase" id="13">
    <tagDatabase tag="split_customers_name_to_first_and_last_name_transition_end"/>
</changeSet>
```