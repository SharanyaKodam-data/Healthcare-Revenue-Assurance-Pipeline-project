--============================================================================
--PROJECT: Healthcare Revenue Assurance & Patient Attrition Analysis
--PURPOSE:Advanced cohort Slicing & Financial Leakage Auditing
--============================================================================

--1.Database initialization & layout configuration
create database if not exists healthcare_analytics;
use healthcare_analytics;

--2.Create Enterprise Schema Structure
create table if not exists patient_data(
patientid varchar(50) primary key,
age int,
gender varchar(50),
state varchar(50),
tenure_months int,
specialty varchar(50),
insurance_type varchar(50),
visits_last_year int,
missed_opportunities int,
days_since_last_visit int,
last_interaction_date varchar(50),
overall_satisfaction float,
wait_time_satisfaction float,
staff_satisfaction float,
provider_rating float,
avg_out_of_pocket_cost int,
billing_issues int,
portal_usage int,
referrals_made int,
distance_to_facility_miles float,
churned int
);

--3.How it occurred: ADVANCED MULTI-LAYER ANALYTICAL CTE PIPELINE
--This complex layout uses partitioning and Window functions to segment data cleanly.
with CohortFrictionMapping as (
   select 
       patientid,
       specialty,
       state,
       avg_out_of_pocket_cost,
       days_since_last_visit,
       missed_appointments,
       churned,
--"How":Window functions to find history of department benchmarks
       avg(overall_satisfaction)over (partition by specialty)as avg_speciality_satisfaction,
       max(days_since_last_visit)over (partition by state)as max_state_absence_delay
   from patient_data),
 OPerationalRiskMetrics as (
   select*,
 --"Where and Why":Map deterministic risk groups using logical case switching
        case 
        	when churned=1 and days_since_last_visit > 90 then 'Active Attrition'
        	when churned=0 and days_since_last_visit > 60 and missed_appointments >=2 then'High Operational Flight Risk'
        	else'Stable Active Cohort'
        end as patient_risk_segment,
 --"What": Quantifying annualized financial leakage metrics directly
        case 
        	when churned=1 then round(avg_out_of_pocket_cost*12,2)
        	else 0.00
         end as  annualized_revenue_leakage
    from CohortFrictionMapping
)
-- 4. Insight Extraction Layer
select
    patientid,
    specialty,       
    state,
    patient_risk_segment,
    annualized_revenue_leakage
from OperationalRiskMetrics
where annualized_revenue_leakage > 0 
   or patient_risk_segment  = 'High Operational Flight Risk'
order by annualized_revenue_leakage desc, missed_appointments desc;
       
