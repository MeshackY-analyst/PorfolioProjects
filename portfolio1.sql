Select * from Meshack..CovidDeaths
order by 3,4

SELECT * FROM Meshack..CovidVaccinations
order by 3,4

Select location,date,population,total_cases,new_cases,total_deaths
from Meshack ..CovidDeaths
order by 1,2

-- looking at total Cases vs total deaths
-- Also Contract for your country or Continent 

Select location,date,total_cases,new_cases,total_deaths,(total_deaths/total_cases)*100 as deathPercentage
,population 
from Meshack ..CovidDeaths
where location like 'Asi%'
order by 1,2

-- looking at total cases vs Population 
-- Shos what percentage of population got Covid 

SELECT location,date,population,total_cases, (total_cases/Population) as Percent_population_infected  
from meshack ..CovidDeaths
order by 1,2 

--Looking at Countries with highest infection rate compared to population

SELECT location , population ,max(total_cases) as HighestInfectedCount, max((total_cases/population))*100
as Highest_infected_percentage from Meshack ..CovidDeaths
where location like 'India%'
group by location,population
order by Highest_infected_percentage desc


-- Showing highest Death Count per Population

SELECT location , population ,max(cast(total_deaths as int)) as TotalDesthCounts
from Meshack ..CovidDeaths
-- where location like 'India%' and
where continent is not null 
group by location,population
order by TotalDesthCounts desc -- removing the null Continents 

-- ANALYSIS ON CONTINENT

SELECT continent  ,max(cast(total_deaths as int)) as TotalDesthCounts
from Meshack ..CovidDeaths
-- where location like 'India%' and
where continent is not null 
group by continent
order by TotalDesthCounts desc -- removing the null Continents 


-- Global Numbers

-- showing global deaths across the continents 
select date,sum(new_cases),sum(cast(new_deaths as int )), sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from Meshack..CovidDeaths
where continent is not null
group by date 
order by 1,2

select cod.date, cod.location, cod.continent, cod.population , vac.new_vaccinations
from Meshack..CovidDeaths cod 
join Meshack..CovidVaccinations vac
on cod.location = vac.location and cod.date = vac.date

-- creating CTE 
with Vacvspop(continent,location,date,population,new_vaccinations,rollingpeoplevacinated)
as 
(
select cod.continent,cod.location,cod.date,cod.population,
vac.new_vaccinations,sum(convert(int, vac.new_vaccinations))
over (partition by cod.location order by cod.location,cod.date)as Rollingpeoplevacinated 
from Meshack..CovidDeaths cod 
join Meshack..CovidVaccinations vac
on cod.location = vac.location and 
   cod.date=vac.date
where cod.continent is not null 
)
select * ,(rollingpeoplevacinated/population)*100
from  Vacvspop where location  like 'india%'



drop talbe if exists
CREATE TABLE PopulationvsVaccinations ( 
Continent varchar(25),
location varchar(45),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevacinated numeric)


insert into PopulationvsVaccinations
select cod.continent,cod.location,cod.date,cod.population,
vac.new_vaccinations,sum(convert(int, vac.new_vaccinations))
over (partition by cod.location order by cod.location,cod.date)as Rollingpeoplevacinated 
from Meshack..CovidDeaths cod 
join Meshack..CovidVaccinations vac
on cod.location = vac.location and 
   cod.date=vac.date
where cod.continent is not null 

select * from PopulationvsVaccinations

