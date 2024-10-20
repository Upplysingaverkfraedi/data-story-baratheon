-- Fjöldi persóna eftir kyni
SELECT gender, COUNT(*) as COUNT
FROM family
GROUP BY gender;

-- Hversu margir eru útvaldir
SELECT chosen_one, COUNT(*) as COUNT
FROM family
GROUP BY chosen_one;

-- Aldur persóna
SELECT
    name,
    COALESCE(death, 2024) - birth AS age
FROM family
WHERE birth IS NOT NULL;

-- Tengsl fjölskyldumeðlima
SELECT id, name, mom, dad
FROM family
WHERE mom IS NOT NULL OR dad IS NOT NULL;

-- Góðar vs. illar persónur
SELECT
    COALESCE(chosen_one, 'Unknown') AS nature,
    COUNT(*) AS COUNT
FROM family
GROUP BY COALESCE(chosen_one, 'Unknown');