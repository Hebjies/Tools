
select 
name, type, dimension,
REGEXP_replace(residents,".[a-z]+|/|:|'|\\[|\\]", "") as residents
from rick_morty.locations