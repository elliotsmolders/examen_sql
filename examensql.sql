--1. Welke brouwers hebben een omzet van minstens 140.000?

USE javadevt_DotNetVlaanderen5;
SELECT
    Name,
    Trim(Turnover/1000)+0 AS 'Turnover in Thousands of Euros'
    FROM
        Brewers
    WHERE Turnover >= 140000
;

--2. Geef de Id en naam van alle bieren waarbij de naam “fontein” bevat. Hou rekening met verschillen in Casing.

USE javadevt_DotNetVlaanderen5;
SELECT
    Id,
    Name
    FROM
        Beers
    WHERE
        Name LIKE '%fontein%'
;

--3Toon de 5 duurste bieren van de brouwer met de meeste omzet, Toon ook de 5 duurste bieren van de brouwer met de minste omzet

--highest
 USE javadevt_DotNetVlaanderen5;
 SELECT 
        Beers.Name AS beer_name, Beers.Price AS price
    FROM
        Brewers
        INNER JOIN Beers ON Brewers.Id = Beers.BrewerId
    WHERE
        Brewers.Turnover = (SELECT 
                MAX(Brewers.Turnover)
            FROM
                Brewers)
    ORDER BY Beers.Price DESC
    LIMIT 5

--lowest
 USE javadevt_DotNetVlaanderen5;
 SELECT 
        Beers.Name AS beer_name, Beers.Price AS price
    FROM
        Brewers
        INNER JOIN Beers ON Brewers.Id = Beers.BrewerId
    WHERE
        Brewers.Turnover = (SELECT 
                MIN(Brewers.Turnover)
            FROM
                Brewers)
    ORDER BY Beers.Price DESC
    LIMIT 5

-- 4. Geef de namen van alle brouwers die in Sint-Jans-Molenbeek, Leuven of Antwerpen wonen
-- Toon ook de naam en het alcoholpercentage van hun bieren.
-- Sorteer op omzet.


USE javadevt_DotNetVlaanderen5;
SELECT
    Brewers.Name AS 'Brewer Name',
    Beers.Name AS 'Beer Name',
    Alcohol
    FROM
        Brewers
    INNER JOIN Beers
    ON Brewers.Id = Beers.BrewerId
    WHERE
        Lower(City) IN ('sint-jans-molenbeek','leuven','antwerpen')
    ORDER BY
        Turnover DESC

-- 5. Geef het aantal bieren per brouwer.
-- Toon ook de naam van de brouwerij.
-- Toon enkel de brouwerijen die meer dan 5 bieren brouwen.
-- Soorteer van hoogste aantal bieren per brouwerij naar het minste.
USE javadevt_DotNetVlaanderen5;
SELECT
    Brewers.Name AS Brewer_Name,
    Count(Beers.Id) AS Amount_of_beers_owned
    FROM
        Brewers
    INNER JOIN Beers
    ON Brewers.Id = Beers.BrewerId
    GROUP BY Brewers.Id
    HAVING
        Amount_of_beers_owned >=5
    ORDER BY
        Amount_of_beers_owned DESC;

-- 6.Toon alle informatie van de bieren met een percentage van minstens 7%.
-- Toon ook alle gerelateerde data.
-- Vermijd duplicate data.
-- Geef bij kolommen met dezelfde namen een duidelijke beschrijving
-- Sorteer aflopend op het alcoholpercentage.

USE javadevt_DotNetVlaanderen5;
SELECT 
    Beers.Id AS beer_id,Beers.Name AS beer_name,
    Brewers.Name AS brewer_name,
    Categories.Category AS Category,
    Alcohol
    FROM
        Beers
    LEFT JOIN Categories
    ON Beers.CategoryId = Categories.Id
    LEFT JOIN Brewers
    ON Beers.BrewerId = Brewers.Id
    WHERE
        Alcohol >= 7
    ORDER BY
        beer_name;

-- 7. Geef de bieren met een alcoholpercentage van meer dan 7 procent van de brouwers die meer dan 65.000 omzet verdienen
-- Sorteer op omzet, daarna op alcoholpercentage
-- Toon ook de categorie van deze bieren
USE javadevt_DotNetVlaanderen5;
SELECT 
    Beers.Name AS beer_name,
    Categories.Category AS Category,
    Alcohol
FROM
    Beers
INNER JOIN Categories
ON Beers.CategoryId = Categories.Id
INNER JOIN Brewers
ON Beers.BrewerId = Brewers.Id
WHERE
    Alcohol >= 7
ORDER BY 
    Turnover DESC,
    Alcohol DESC;

-- 8.Geef het aantal bieren per categorie in een menselijk leesbare vorm.
-- Sorteer op naam van de categorie
-- Toon enkel de volgende bieren: Lambik,  AlcolholVrij, Pils, Edelbier, Amber, Light
-- Hou er rekening mee dat bovenstaande selectie makkelijk kan veranderen in de toekomst.
-- Hoe zorgen we ervoor dat deze lijst makkelijk leesbaar en aanpasbaar is?
USE javadevt_DotNetVlaanderen5;
SELECT 
    Categories.Category,
    Count(Beers.Id) AS Amount_of_beers_in_category
    FROM
        Categories
    INNER JOIN Beers
    ON Categories.Id = Beers.CategoryId
    WHERE
        Category IN ('lambik','alcolholvrij','pils','edelbier','amber','light')
    GROUP BY Category
    ORDER BY
        Category ASC

-- 9.Toon de bieren die door meer dan 1 brouwerij gebrouwen worden.
-- Toon alle relevante gerelateerde data.
-- Sla dit resultaat op als een View
-- Toon aan dat je view dynamisch is door data te wijzigen.
-- Neem screenshots van voor en na.

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `javadevt_StudVla`@`%` 
    SQL SECURITY DEFINER
VIEW `oef9` AS
    SELECT 
        `Beers`.`Id` AS `beer_id`,
        `Beers`.`Name` AS `beer_name`,
        `Brewers`.`Name` AS `brewer_name`,
        `Categories`.`Category` AS `Category`,
        `Beers`.`Price` AS `Price`,
        `Beers`.`Stock` AS `Stock`,
        `Beers`.`Alcohol` AS `Alcohol`,
        `Beers`.`Version` AS `Version`,
        `Beers`.`Image` AS `Image`
    FROM
        ((`Beers`
        JOIN `Brewers` ON ((`Beers`.`BrewerId` = `Brewers`.`Id`)))
        JOIN `Categories` ON ((`Beers`.`CategoryId` = `Categories`.`Id`)))
    WHERE
        `Beers`.`Name` IN (SELECT 
                `Beers`.`Name`
            FROM
                `Beers`
            GROUP BY `Beers`.`Name`
            HAVING (COUNT(`Beers`.`Name`) > 1))


INSERT INTO `javadevt_DotNetVlaanderen5`.`Beers` (`Id`, `Name`, `BrewerId`, `CategoryId`, `Price`, `Stock`, `Alcohol`, `Version`)
 VALUES ('2000', 'Adler', '1', '42', '2.65', '100', '6', '0');


-- 10.Maak een Stored Procedure met 2 input parameters. Laat deze query alle bieren ophalen die aan de volgende parameters voldoen:
-- Een keyword dat voorkomt in de naam van het bier
-- De maximum omzet van de brouwer
-- Het is niet voldoende om enkel de Stored Procedure in je DB te hebben. Toon ook de SQL code die je nodig had voor dit statement te maken.

CREATE DEFINER=`javadevt_StudVla`@`%` PROCEDURE `oef10`(
IN keyword TEXT,
IN maximum_turnover FLOAT
)
BEGIN
SELECT 
    Beers.Id AS beer_id,
    Beers.Name AS name
    FROM 
        Beers
    INNER JOIN Brewers
    ON Beers.BrewerId = Brewers.Id
    WHERE
        Beers.Name LIKE CONCAT('%',keyword,'%')
        AND Turnover <= maximum_turnover;
END


CALL `javadevt_DotNetVlaanderen5`.`oef10`('tripel', 100000);

--QUERYS OP NIEUWE TABELLEN


-- 1.Toon de Brouwers die aan geen enkel cafe leveren.
USE javadevt_DotNetVlaanderen5;
SELECT
    *
    FROM
        Brewers
    WHERE
        Brewers.Id NOT IN (SELECT BrewerId FROM Bars_Brewers)

--2. Toon alle cafes die geopend zijn in de voorbije 3 jaar.
-- Toon ook de bieren en hun brouwers die hier getapt worden.
-- Sla deze informatie op als View
--info nog formateren? 'duplicate' data terug
USE javadevt_DotNetVlaanderen5;
SELECT
    Bars.Name AS bar_name,
     YearOfOpening AS opened_in,
      Beers.Name AS beer_name,
      Brewers.Name as brewer_name
      FROM
        Bars
    LEFT JOIN Bars_Beers
    ON Bars.Id = Bars_Beers.BarId
    LEFT JOIN Beers
    ON Bars_Beers.BeerId = Beers.Id
    LEFT JOIN Bars_Brewers
    ON Bars.Id = Bars_Brewers.BarId
    LEFT JOIN Brewers
    ON Bars_Brewers.BrewerId = Brewers.Id
    WHERE
        YearOfOpening >= 2019

-- 3.Toon het aantal eigenaars per cafe.
USE javadevt_DotNetVlaanderen5;
SELECT
    Name,
    Count(Bars_Owners.BarId) AS owners
    FROM
        Bars
    INNER JOIN Bars_Owners
    ON Bars.Id = Bars_Owners.BarId
    GROUP BY Bars_Owners.BarId

-- 4.Geef de namen van alle brouwers die in een stad wonen waar meer dan 2 cafe’s zijn.

USE javadevt_DotNetVlaanderen5;
SELECT
    Name
    FROM
        Brewers
    WHERE
        Brewers.City IN (
            SELECT
                Bars.City
                FROM
                    Bars
                GROUP BY Bars.City
                HAVING
                    Count(Bars.City)>2)

-- 5.Toon alle cafés met mannelijke eigenaars die binnen 5 jaar op pensioen zullen gaan
-- Hiervoor mag je uitgaan dat de pensioenleeftijd 65 jaar is en ze verjaren op 1 januari
USE javadevt_DotNetVlaanderen5;
SELECT
    Bars.Name,
    Concat(Owners.Name,' ',Owners.Surname) AS owner_name,
    (2022-YEAR(DateOfBirth)) AS age
    From
        Bars
    INNER JOIN Bars_Owners
    ON Bars.Id = Bars_Owners.BarId
    INNER JOIN Owners
    On Bars_Owners.OwnerId = Owners.Id
    WHERE
        2022-YEAR(Owners.DateOfBirth)>=60
        AND Owners.Sex LIKE 'male'
    ORDER BY
        owner_name