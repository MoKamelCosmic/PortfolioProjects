Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4
--Select * 
--From PortfolioProject..CovidVaccinations
--order by 3,4
--Select the data we'll use
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2
--total cases vs total deaths and likelihood of dying if one contracted covid in his/her country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where Location like '%states%' and continent is not null
order by 1,2
--shows percentage of poplation contracted covid
Select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--where Location like '%states%'
order by 1,2

--Countries with highest infection rates compared to population
Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--where Location like '%states%'
Group by Location, population
order by PercentPopulationInfected desc

--showing countries with highest death count per population
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
--where Location like '%states%'
Group by Location
order by TotalDeathCount desc

--By continent


--showing continents with the highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
--where Location like '%states%'
Group by continent
order by TotalDeathCount desc


--Global numbers:

Select SUM(new_cases)as total_cases ,SUM(cast(new_deaths as int)) as total_deaths ,SUM(cast(new_deaths as int))/SUM
(New_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--where Location like '%states%' and
where continent is not null
--Group By date
order by 1,2

--total population vs vaccinations
Select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location, dea.date)
as RollingPeopleVaccinated -- (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.Location = vac.Location
	and dea.date = vac.date 
	where dea.continent is not null
	order by 2,3




	--CTE
	with PopvsVac (Continent, Location, Date, Population, new_vaccinations ,RollingPeopleVaccinated)
	as
	(
	Select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location, dea.date)
as RollingPeopleVaccinated -- (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.Location = vac.Location
	and dea.date = vac.date 
	where dea.continent is not null
	--order by 2,3
	)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--Temp table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric,
)
Insert into #PercentPopulationVaccinated
Select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location, dea.date)
as RollingPeopleVaccinated -- (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.Location = vac.Location
	and dea.date = vac.date 
	--where dea.continent is not null

	Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--view for making visualizations

Create View PercentPopulationVaccinated as
Select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location, dea.date)
as RollingPeopleVaccinated -- (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.Location = vac.Location
	and dea.date = vac.date 
	--where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated
