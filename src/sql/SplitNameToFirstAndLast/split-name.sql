UPDATE public."Customers"
SET "First_Name" = split_part("Name", ' ', 1),
"Last_Name" = split_part("Name", ' ', 2)