
Select id, name, status, species, type, gender,
`location.name` as location, `origin.name` as origin,
(LENGTH(REGEXP_replace(episode,".[a-z]+|/|:|'|\\[|\\]", "")) - LENGTH(REPLACE(REGEXP_replace(episode,".[a-z]+|/|:|'|\\[|\\]", ""),",","")) + 1) AS Num_ep, image
from rick_morty.characters