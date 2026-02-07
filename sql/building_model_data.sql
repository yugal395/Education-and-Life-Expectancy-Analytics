-- main idea we take base table as life_both and then 
--slowly add each tables based on a composite key of country and year.
--so that we can have a panel data set with all the variables we need for our model.

DROP TABLE IF EXISTS panel_1;

CREATE TABLE panel_1 AS
SELECT Country, Year, LifeExp_Both
FROM life_both;

SELECT COUNT(*) AS n FROM panel_1;
SELECT * FROM panel_1

--adding primary table an renaming it to panel_2
DROP TABLE IF EXISTS panel_2;

CREATE TABLE panel_2 AS
SELECT p.Country,p.Year,p.LifeExp_Both,pr.Enroll_Primary 
FROM panel_1 p
LEFT JOIN primary_enroll pr
ON p.Country=pr.Country AND p.Year=pr.Year;

SELECT COUNT(*) AS n FROM panel_2;
SELECT COUNT(Enroll_Primary) AS rows_with_primary FROM panel_2;


DROP TABLE IF EXISTS panel_3;

CREATE TABLE panel_3 AS
SELECT
  p.*,
  s.Enroll_Secondary
FROM panel_2 p
LEFT JOIN secondary s
  ON p.Country = s.Country
 AND p.Year = s.Year;


SELECT COUNT(*) AS n FROM panel_3;
SELECT COUNT(Enroll_Secondary) AS rows_with_secondary FROM panel_3;



DROP TABLE IF EXISTS panel_4;

CREATE TABLE panel_4 AS
SELECT
  p.*,
  t.Enroll_Tertiary
FROM panel_3 p
LEFT JOIN tertiary t
  ON p.Country = t.Country
 AND p.Year = t.Year;

SELECT COUNT(*) AS n FROM panel_4;
SELECT COUNT(Enroll_Tertiary) AS rows_with_tertiary FROM panel_4;



DROP TABLE IF EXISTS panel_5;
CREATE TABLE panel_5 AS
SELECT
    p.*,
    e.EduExp_GDP
FROM panel_4 p
LEFT JOIN exp_gdp e
    ON p.Country = e.Country
   AND p.Year = e.Year;

SELECT COUNT(*) AS n FROM panel_5;
SELECT COUNT(EduExp_GDP) AS rows_with_exp_gdp FROM panel_5;


DROP TABLE IF EXISTS panel_6;

CREATE TABLE panel_6 AS
SELECT
  p.*,
  et.EduExp_Total
FROM panel_5 p
LEFT JOIN exp_total et
  ON p.Country = et.Country
 AND p.Year = et.Year;

SELECT COUNT(*) AS n FROM panel_6;
SELECT COUNT(EduExp_Total) AS rows_with_exp_total FROM panel_6;



DROP TABLE IF EXISTS panel;
ALTER TABLE panel_6 RENAME TO panel;

SELECT COUNT(*) AS n FROM panel;
SELECT * FROM panel LIMIT 10;



-- i notice that the names of countires are way different across tables so we have to map them
SELECT DISTINCT lb.Country
FROM life_both lb
LEFT JOIN primary_enroll pr
  ON lb.Country = pr.Country
WHERE pr.Country IS NULL
LIMIT 50;

SELECT DISTINCT pr.Country
FROM primary_enroll pr
LEFT JOIN life_both lb
  ON pr.Country = lb.Country
WHERE lb.Country IS NULL
LIMIT 50;
-- here i see the countires that are in life_both but not in primary_enroll and vice versa. we can do this for all tables and then create a mapping table to standardize the country names across tables.



-- we are gonna create a edu_countries table with only the countries for the education tables
DROP TABLE IF EXISTS edu_countries;

CREATE TABLE edu_countries AS
SELECT DISTINCT Country
FROM primary_enroll;

SELECT COUNT(*) AS n_edu_countries FROM edu_countries;

-- then we are filtering the life_both table to only include the countries in edu_countries

DROP TABLE IF EXISTS life_filtered;

CREATE TABLE life_filtered AS
SELECT lb.*
FROM life_both lb
INNER JOIN edu_countries ec
  ON lb.Country = ec.Country;

  
SELECT COUNT(*) AS n_life_filtered FROM life_filtered;
SELECT * FROM life_filtered LIMIT 5;


-- now we are gonna create the last panel table by joining the life_fileredd table with other tables
DROP TABLE IF EXISTS panel;

DROP TABLE IF EXISTS panel;

CREATE TABLE panel AS
SELECT
  lf.Country,
  lf.Year,
  lf.LifeExp_Both,
  p.Enroll_Primary,
  s.Enroll_Secondary,
  t.Enroll_Tertiary,
  g.EduExp_GDP,
  et.EduExp_Total
FROM life_filtered lf
INNER JOIN primary_enroll p
  ON lf.Country = p.Country AND lf.Year = p.Year
INNER JOIN secondary s
  ON lf.Country = s.Country AND lf.Year = s.Year
INNER JOIN tertiary t
  ON lf.Country = t.Country AND lf.Year = t.Year
INNER JOIN exp_gdp g
  ON lf.Country = g.Country AND lf.Year = g.Year
INNER JOIN exp_total et
  ON lf.Country = et.Country AND lf.Year = et.Year;


SELECT COUNT(*) AS n_panel FROM panel;
SELECT * FROM panel LIMIT 10;



-- now we are gonna prepare the data for modeling

-- main idea would be to create a model dataset that we can use to train 
-- for that we will join the exisitng panel table with the 
-- the life expectancy column for 5 years later or something

DROP TABLE IF EXISTS model_data;

CREATE TABLE model_data AS
SELECT
  p.*,
  lf2.LifeExp_Both AS LifeExp_Both_lead_5
FROM panel p
INNER JOIN life_filtered lf2
  ON p.Country = lf2.Country
 AND lf2.Year = p.Year + 5;

SELECT COUNT(*) AS n_model_data FROM model_data;

SELECT Country, Year, LifeExp_Both, LifeExp_Both_lead_5
FROM model_data
LIMIT 20;
-- we are verifying our table that  we made
SELECT Country, Year, LifeExp_Both, LifeExp_Both_lead_5
FROM model_data
WHERE Country = 'Albania'
ORDER BY Year
LIMIT 10;
SELECT LifeExp_Both
FROM life_filtered
WHERE Country = 'Albania' AND Year = 2005;
