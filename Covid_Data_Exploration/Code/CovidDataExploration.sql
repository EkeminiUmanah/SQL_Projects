/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Aggregate Functions, Creating Views, Converting Data Types
*/

-- Query 1: Retrieve all data from CovidDeaths table
SELECT *
FROM pt..CovidDeaths
ORDER BY location, date;

-- Query 2: Retrieve data from CovidDeaths table excluding null continent values
SELECT *
FROM pt..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY location, date;

-- Query 3: Retrieve data from CovidDeaths table excluding null and 'N/A' continent values
SELECT *
FROM pt..CovidDeaths
WHERE continent IS NOT NULL AND continent <> '';

-- Query 4: Retrieve specific columns from CovidDeaths table for non-null continents
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL AND continent <> ''
ORDER BY location, date;

-- Query 5: Calculate death percentage based on total cases in CovidDeaths table
SELECT location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 AS DeathPercentage
FROM pt..CovidDeaths
WHERE continent IS NOT NULL AND continent <> ''
ORDER BY location, date;

-- Query 6: Retrieve daily new cases and deaths from CovidDeaths table
SELECT location, date, new_cases, new_deaths
FROM pt..CovidDeaths
WHERE continent IS NOT NULL AND continent <> ''
ORDER BY location, date;

-- Query 7: Retrieve total cases, total deaths and Death Percentage in Nigeria from CovidDeaths table
SELECT location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 AS DeathPercentage
FROM pt..CovidDeaths
WHERE location LIKE '%Nigeria%'
ORDER BY location, date;

-- Query 8: Calculate percentage of population infected with COVID-19 in CovidDeaths table
SELECT location, date, population, total_cases, (total_cases / population) * 100 AS PercentPopulationInfected
FROM pt..CovidDeaths
WHERE continent IS NOT NULL AND continent <> ''
ORDER BY location, date;

-- Query 9: Retrieve countries with the highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases / population) * 100 AS PercentPopulationInfected
FROM pt..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;

-- Query 10: Retrieve countries with the highest death count per population
SELECT Location, MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM pt..CovidDeaths
WHERE continent IS NOT NULL AND continent <> ''
GROUP BY Location  
ORDER BY TotalDeathCount DESC;

-- Query 11: Retrieve continents with the highest death count per population
SELECT continent, population, MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL AND continent <> ''
GROUP BY continent, population
ORDER BY TotalDeathCount DESC;

-- Query 12: Retrieve global numbers for total cases, total deaths, and death percentage
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths) / SUM(new_cases) * 100 AS DeathPercentage
FROM pt..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 1, 2;

-- Query 13: Retrieve vaccination data and rolling people vaccinated using CTE
WITH PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
           SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
    FROM pt..CovidDeaths AS dea
    JOIN pt..CovidVaccinations AS vac ON dea.location = vac.location AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL AND dea.continent <> ''
)
SELECT *, (RollingPeopleVaccinated / population) * 100 AS RollingPercentageVaccinated
FROM PopvsVac;


-- Query 14: Retrieve vaccination data and rolling people vaccinated using temporary table
DROP TABLE IF EXISTS #PercentPopulationVaccinated;
CREATE TABLE #PercentPopulationVaccinated
(
    Continent VARCHAR(255),
    Location VARCHAR(255),
    Date DATE,
    Population NUMERIC,
    New_Vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM pt..CovidDeaths AS dea
JOIN pt..CovidVaccinations AS vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.continent <> '';

SELECT *, (RollingPeopleVaccinated / population) * 100 AS RollingPercentageVaccinated
FROM #PercentPopulationVaccinated;


-- Query 15: Create view for vaccination data and rolling people vaccinated
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM pt..CovidDeaths AS dea
JOIN pt..CovidVaccinations AS vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.continent <> '';

SELECT * 
FROM PercentPopulationVaccinated;


-- Query 15: Create view for vaccination data and rolling people vaccinated

CREATE VIEW dbo.PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM pt..CovidDeaths AS dea
JOIN pt..CovidVaccinations AS vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.continent <> '';


SELECT * 
FROM dbo.PercentPopulationVaccinated;