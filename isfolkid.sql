-- Fjöldi persóna eftir kyni
SELECT gender, COUNT(*) as COUNT
FROM family
GROUP BY gender;

-- Aldur persóna
SELECT
    name,
    COALESCE(death, 2024) - birth AS age
FROM family
WHERE birth IS NOT NULL;

-- Meðalaldur eftir kyni
SELECT
    gender,
    AVG(COALESCE(death, 2024) - birth) AS avg_age
FROM family
WHERE birth IS NOT NULL AND gender IS NOT NULL
GROUP BY gender;

-- Meðalaldur "good" vs "evil"
SELECT 
    COALESCE(chosen_one, 'Unknown') AS nature, 
    AVG(COALESCE(death, 2024) - birth) AS avg_age
FROM family
WHERE birth IS NOT NULL
AND chosen_one IN ('good', 'evil')
GROUP BY nature;

-- Meðalaldur good vs evil eftir kyni
SELECT 
    gender, 
    COALESCE(chosen_one, 'Unknown') AS nature, 
    AVG(COALESCE(death, 2024) - birth) AS avg_age
FROM family
WHERE birth IS NOT NULL
AND chosen_one IN ('good', 'evil')
GROUP BY gender, nature;

-- Aldursdreifing good vs evil eftir kyni
SELECT 
    gender, 
    COALESCE(chosen_one, 'Unknown') AS nature, 
    COALESCE(death, 2024) - birth AS age
FROM family
WHERE birth IS NOT NULL
AND chosen_one IN ('good', 'evil');




