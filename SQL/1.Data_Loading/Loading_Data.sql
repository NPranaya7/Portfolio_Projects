use portfolio;

create table coviddeaths(
iso_code	text,
continent	text,
location	text,
date	date,
population	double,
total_cases	double,
new_cases	double,
new_cases_smoothed	decimal(25 , 2),
total_deaths	double,
new_deaths	double,
new_deaths_smoothed	decimal(25 , 2),
total_cases_per_million	decimal(25 , 2),
new_cases_per_million	decimal(25 , 2),
new_cases_smoothed_per_million	decimal(25 , 2),
total_deaths_per_million	decimal(25 , 2),
new_deaths_per_million	decimal(25 , 2),
new_deaths_smoothed_per_million	decimal(25 , 2),
reproduction_rate	decimal(25 , 2),
icu_patients	double,
icu_patients_per_million	decimal(25 , 2),
hosp_patients	double,
hosp_patients_per_million	decimal(25 , 2),
weekly_icu_admissions	double,
weekly_icu_admissions_per_million	decimal(25 , 2),
weekly_hosp_admissions	double,
weekly_hosp_admissions_per_million decimal(25 , 2)
);

select * from coviddeaths;

-- ----------------------------------------------------------------------------------------------------------------------
use portfolio;

create table covidvaccine(
iso_code	varchar(255),
continent	varchar(255),
location	varchar(255),
date	date,
population	double,
total_tests	double,
new_tests	double,
total_tests_per_thousand	decimal(25 , 4),
new_tests_per_thousand	decimal(25 , 4),
new_tests_smoothed	double,
new_tests_smoothed_per_thousand	decimal(25 , 4),
positive_rate	decimal(25 , 4),
tests_per_case	decimal(25 , 4),
tests_units	varchar(255),
total_vaccinations	double,
people_vaccinated	double,
people_fully_vaccinated	double,
total_boosters	double,
new_vaccinations	double,
new_vaccinations_smoothed	double,
total_vaccinations_per_hundred	decimal(25 , 4),
people_vaccinated_per_hundred	decimal(25 , 4),
people_fully_vaccinated_per_hundred	decimal(25 , 4),
total_boosters_per_hundred	decimal(25 , 4),
new_vaccinations_smoothed_per_million	double,
new_people_vaccinated_smoothed	double,
new_people_vaccinated_smoothed_per_hundred	decimal(25 , 4),
stringency_index	decimal(25 , 4),
population_density	decimal(25 , 4),
median_age	decimal(25 , 4),
aged_65_older	decimal(25 , 4),
aged_70_older	decimal(25 , 4),
gdp_per_capita	decimal(25 , 4),
extreme_poverty	decimal(25 , 4),
cardiovasc_death_rate	decimal(25 , 4),
diabetes_prevalence	decimal(25 , 4),
female_smokers	decimal(25 , 4),
male_smokers	decimal(25 , 4),
handwashing_facilities	decimal(25 , 4),
hospital_beds_per_thousand	decimal(25 , 4),
life_expectancy	decimal(25 , 4),
human_development_index	decimal(25 , 4),
excess_mortality_cumulative_absolute	decimal(25 , 4),
excess_mortality_cumulative	decimal(25 , 4),
excess_mortality	decimal(25 , 4),
excess_mortality_cumulative_per_million decimal(25 , 4)
);

show variables like 'local_infile';

load data local infile "/Users/prana/Downloads/portfolio/Data/covidvaccinations.csv"
into table covidvaccine
fields terminated by ','
ignore 1 rows;

select count(*) from covidvaccine;

select * from covidvaccine;