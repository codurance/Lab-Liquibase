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