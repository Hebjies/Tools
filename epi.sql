
SELECT name, 
SUBSTRING(episode, 2, instr(episode, "E")-2) AS season,
SUBSTRING(episode, instr(episode, "E") + 1, 5) AS episode,

REGEXP_replace(characters,".[a-z]+|/|:|'|\\[|\\]", "") as characters
from  rick_morty.episodes