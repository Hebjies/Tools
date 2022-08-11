select ep_char.name as Episode_Name,
ep_char.season, ep_char.episode, characters.name, characters.id, characters.status
from ep_char
join characters
on ep_char.characters = characters.id
