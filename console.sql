-- What are all the types of pokemon that a pokemon can have?
SELECT name
FROM pokemon.types;

-- What is the name of the pokemon with id 45?
SELECT name
FROM pokemon.pokemons
WHERE id=45;

-- How many pokemon are there?
SELECT COUNT(ALL id)
FROM pokemon.pokemons;

-- How many types are there?
SELECT COUNT(ALL name)
FROM types;

-- How many pokemon have a secondary type?
SELECT COUNT(ALL secondary_type) AS secTyp
FROM pokemon.pokemons;
-- SELECT COUNT(*) AS secTyp
-- FROM pokemon.pokemons
-- WHERE secondary_type IS NOT NULL;

-- What is each pokemon's primary type?
SELECT pp.name,
       pt.name
FROM pokemon.pokemons pp
LEFT JOIN pokemon.types pt
ON pp.primary_type = pt.id;

-- What is Rufflet's secondary type?
SELECT pp.name AS name,
       pt.name AS secondary_type
FROM pokemon.pokemons pp
LEFT JOIN pokemon.types pt
ON pp.secondary_type = pt.id
WHERE pp.name = 'Rufflet';

-- What are the names of the pokemon that belong
-- to the trainer with trainerID 303? (ACE Duo Elina & Sean)
SELECT pt.trainername AS trainer_name,
       pt.trainerID AS trainer_id,
       pp_t.pokemon_id AS pokemon_id,
       pp.name AS name
FROM pokemon.trainers pt
RIGHT JOIN pokemon.pokemon_trainer pp_t
ON pt.trainerID = pp_t.trainerID
RIGHT JOIN pokemon.pokemons pp
ON pokemon_id = id
WHERE pt.trainerID = '303';

-- How many pokemon have a secondary type Poison
SELECT COUNT(ALL pp.name) AS secondary_type_Poison
FROM pokemon.pokemons pp
LEFT JOIN pokemon.types pt
ON pp.secondary_type = pt.id
WHERE pt.name = 'Poison';


-- What are all the primary types and
-- how many pokemon have that type?
SELECT pt.name AS type,
       COUNT(ALL pp.primary_type) AS numberOfFirstType
FROM pokemon.types pt
JOIN pokemon.pokemons pp
ON pt.id = pp.primary_type
GROUP BY pp.primary_type;

-- How many pokemon at level 100 does each trainer
-- with at least one level 100 pokemon one have?
-- (Hint: your query should not display a trainer
SELECT pt.trainerID,
       COUNT(ALL pt.trainerID) AS numberOfPokemonsAt100Level
FROM pokemon.pokemon_trainer pt
WHERE pokelevel = '100'
GROUP BY pt.trainerID;

-- How many pokemon only belong to one trainer and no other?
SELECT COUNT(pokemonWithOnlyOneTrainer) AS numberOfpokemonWithOnlyOneTrainer
FROM (
       SELECT COUNT(id) AS pokemonWithOnlyOneTrainer
       FROM (
              SELECT DISTINCT tr,id
              FROM (
                     SELECT pp.pokemon_id AS id,
                            pp.trainerID  AS tr
                     FROM pokemon.pokemon_trainer pp
                     ORDER BY pokemon_id
                   ) x
            ) y
       GROUP BY id
       HAVING COUNT(id) < 2
     )
z;

-- How many pokemon only belong to one trainer and no other?
SELECT COUNT(*) AS uniqueTrainer
FROM (
       SELECT DISTINCT pokemon.pokemon_trainer.pokemon_id,
                       COUNT(DISTINCT pokemon.pokemon_trainer.trainerID) AS total
       FROM pokemon.pokemon_trainer
       GROUP BY pokemon_id
                # ORDER BY total ASC
       HAVING total = 1
     )x;



-- Directions: Write a query that returns the following columns:
-- | Pokemon Name   | Trainer Name   |	Level         |	Primary Type      | Secondary Type
-- | Pokemon's name | Trainer's name | Current Level |	Primary Type Name | Secondary Type Name
-- Explanation: The criteria used in this query was to get the average of pokelevel, hp, maxhp,
-- Explanation: attack, defense, spatk, spdef and speed for each row
-- Explanation: from pokemon.pokemon_trainer table. The weakest are at the beginning.
-- Explanation: Pokemons with low pokelevel are at the begin of the query as it is expected.
-- Explanation: On the other hand, Pokemons with high pokelevel are at the end of the query as it is expected.
-- Explanation: In addition, Pokemons with only one primary_type are at the begin of the table
-- Explanation: which indicate that it is more probable to be weaker because they do not
-- Explanation: have another skill to fight. That is not the case for Pokemons that have
-- Explanation: more that one type (generally speaking).

SELECT pokemon.pokemons.name,
       pokemon.trainers.trainername,
       x.average,
       pokemon.pokemon_trainer.pokelevel,
       pokemon.pokemons.primary_type,
       pokemon.pokemons.secondary_type,
       pokemon.pokemon_trainer.trainerID
FROM (
            SELECT pokemon.pokemon_trainer.pokemon_id AS p_id,
                   AVG(pokemon.pokemon_trainer.pokelevel + pokemon.pokemon_trainer.hp +
                       pokemon.pokemon_trainer.maxhp + pokemon.pokemon_trainer.attack +
                       pokemon.pokemon_trainer.defense + pokemon.pokemon_trainer.spatk +
                       pokemon.pokemon_trainer.spdef + pokemon.pokemon_trainer.speed) AS average
            FROM pokemon.pokemon_trainer
            GROUP BY pokemon_id
     )x
JOIN pokemon.pokemons
ON x.p_id = pokemon.pokemons.id
JOIN pokemon.pokemon_trainer
ON x.p_id = pokemon.pokemon_trainer.pokemon_id
JOIN pokemon.trainers
ON pokemon.pokemon_trainer.trainerID = pokemon.trainers.trainerID
ORDER BY average ASC









