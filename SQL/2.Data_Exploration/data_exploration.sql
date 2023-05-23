# To View entire DataSet
select * from portfolio.coviddeaths
where continent not like '';

# To View Dataset with Particular colummns
select continent, location, date, population, total_cases, new_cases, total_deaths
from portfolio.coviddeaths;

# To View the daily percentage of deaths
select continent, location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage 
from portfolio.coviddeaths;

# To View Dataset with Particular colummns in particular location
select continent, location, date, population, total_cases, new_cases, total_deaths
from portfolio.coviddeaths
where location like '%states%';

# To View the daily percentage of deaths in particular Location'States'
select continent, location, date, population, total_cases, total_deaths,(total_deaths/total_cases)*100 as death_percentage 
from portfolio.coviddeaths
where location like '%states%';

# To View the daily percentage of total cases with respective to population
select continent, location, date, population, total_cases, (total_cases/population)*100 as infected_percentage 
from portfolio.coviddeaths;

# To View the daily percentage of total cases with respective to population in particular location
select continent, location, date, population, total_cases, (total_cases/population)*100 as infected_percentage 
from portfolio.coviddeaths
where location like '%states%';

# Which country got most affected with respective to their population
select location, population, max(total_cases) as cases,max(total_deaths) as deaths, max((total_cases/population))*100 as infected_percentage ,max((total_deaths/population))*100 as death_percentage 
from portfolio.coviddeaths
group by location, population 
order by infected_percentage desc;
 
 # Total Deaths by contries in Decsending order
select location, max(total_deaths) as deaths
from portfolio.coviddeaths
where continent not like ''
group by location 
order by deaths desc;

# Total population, infected & Deaths by world 
select  sum(population) as population, sum(total_cases) as infected, sum(total_deaths) as deaths
from portfolio.coviddeaths
where continent not like '';
# group by continent 
# order by deaths desc;

# Total Deaths by continents in Decsending order
select continent, sum(total_deaths) as deaths
from portfolio.coviddeaths
where continent not like ''
group by continent 
order by deaths desc;

# Total Deaths, cases, population by continents in Decsending order
select continent, sum(population) as population, sum(total_cases) as Cases, sum(total_deaths) as deaths
from portfolio.coviddeaths
where continent not like ''
group by continent 
order by deaths desc;

# Total percentage of Deaths, cases, population by continents in Decsending order
select continent, sum(population) as population, (sum(total_cases)/sum(population))*100 as percentage_Cases, (sum(total_deaths)/sum(population)) as percentage_deaths
from portfolio.coviddeaths
where continent not like ''
group by continent 
order by percentage_deaths desc;

# Golbal numbers by date
select date, sum(new_cases) as new_cases, sum(total_cases) as Cases , sum(new_deaths) as new_deaths, sum(total_deaths) as deaths,
 (sum(total_deaths)/sum(total_cases))*100 as percentage_deaths
from portfolio.coviddeaths
where continent not like ''
group by date
order by date asc;

-- -------------------------------------------------------------------------------------------------------------------------------------------------

select * from portfolio.covidvaccine;


# Joining to datasets
select * 
from portfolio.coviddeaths dea
join portfolio.covidvaccine vac
on dea.location = vac.location
and dea.date = vac.date;

# Showing location, date and new_Vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
from portfolio.coviddeaths dea
join portfolio.covidvaccine vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent not like '';

# Now lets find total vaccinations done till that date by each country
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) as Rolling_Vaccinated
from portfolio.coviddeaths dea
join portfolio.covidvaccine vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent not like '';

# In above we can't able to use rolling_vaccinated column to determine the percent so 
# Method-1 Using CTE----------
with rollvspop(continent, location, date, population, new_vaccinations, Rolling_Vaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) as Rolling_Vaccinated
from portfolio.coviddeaths dea
join portfolio.covidvaccine vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent not like ''
)
select * , (Rolling_Vaccinated/population)*100 as vaccinated_percent
from rollvspop;


# No of Vaccinated & Vaccinated percentage by Country
with rollvspop(continent, location, date, population, new_vaccinations, Rolling_Vaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) as Rolling_Vaccinated
from portfolio.coviddeaths dea
join portfolio.covidvaccine vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent not like ''
)
select location, max(population) as population, max(Rolling_vaccinated) as vaccinated, max((Rolling_Vaccinated/population))*100 as vaccinated_percent
from rollvspop
where continent not like ''
group by location 
order by 2 desc;


# Method-2 Temp Table-----------------------
# Drop the Table if it exits before
Drop Table if exists vaccinated_percent;
# Creating a Temp Table
Create Table vaccinated_percent 
(
continent	varchar(255),
location	varchar(255),
date date,
population	double,
new_vaccinations	double,
Rolling_Vaccinated decimal(25 , 2)
);

# Inserting Data into the Temp Table
insert into vaccinated_percent
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) as Rolling_Vaccinated
from portfolio.coviddeaths dea
join portfolio.covidvaccine vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent not like '';

# Showing Temp Table Data
select * , (Rolling_Vaccinated/population)*100 as vaccinated_percent
from vaccinated_percent;

# Showing Data by Country 
select location, max(population) as population, max(Rolling_vaccinated) as vaccinated, max((Rolling_Vaccinated/population))*100 as vaccinated_percent
from vaccinated_percent
where continent not like ''
group by location 
order by 2 desc;

# Showing Data By Continent
select continent, max(population) as population, max(Rolling_vaccinated) as vaccinated, max((Rolling_Vaccinated/population))*100 as vaccinated_percent
from vaccinated_percent
where continent not like ''
group by continent 
order by 2 desc;

# Now Lets Create a View to store data for Data Vizualizations
# 1st View
Create View continentvaccine as
select continent, max(population) as population, max(Rolling_vaccinated) as vaccinated, max((Rolling_Vaccinated/population))*100 as vaccinated_percent
from vaccinated_percent
where continent not like ''
group by continent 
order by 2 desc;

# 2nd View
create View countryvaccine as
select location, max(population) as population, max(Rolling_vaccinated) as vaccinated, max((Rolling_Vaccinated/population))*100 as vaccinated_percent
from vaccinated_percent
where continent not like ''
group by location 
order by 2 desc;

# 3rd View
create view dailyvaccine as
select * , (Rolling_Vaccinated/population)*100 as vaccinated_percent
from vaccinated_percent;

# 4th View
create view dailyglobalnums as
select date, sum(new_cases) as new_cases, sum(total_cases) as Cases , sum(new_deaths) as new_deaths, sum(total_deaths) as deaths,
 (sum(total_deaths)/sum(total_cases))*100 as percentage_deaths
from portfolio.coviddeaths
where continent not like ''
group by date
order by date asc;

# 5th View
drop view if exists continentdeaths;
create view continentdeaths as
select continent, max(population) as population, sum(total_cases) as cases, (sum(total_cases)/sum(population))*100 as percentage_Cases, sum(total_deaths) as deaths, (sum(total_deaths)/sum(population)) as percentage_deaths
from portfolio.coviddeaths
where continent not like ''
group by continent 
order by percentage_deaths desc;

# 6th View
create view countrydeaths  as
select location, max(total_deaths) as deaths
from portfolio.coviddeaths
where continent not like ''
group by location 
order by deaths desc;

# 7th View
drop view if exists countrydeathspopulation;
create view countrydeathspopulation as
select location, max(population) as population,  sum(total_cases) as cases, sum(total_deaths) as deaths
from portfolio.coviddeaths
where continent not like ''
group by location 
order by 2 desc;

# 8th view
create view countrypercentinfected as
select location, max(population) as population, max(total_cases) as cases,max(total_deaths) as deaths, max((total_cases/population))*100 as infected_percentage ,max((total_deaths/population))*100 as death_percentage 
from portfolio.coviddeaths
where continent not like ''
group by location
order by population desc;