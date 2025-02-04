Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
SELECT prescriber.npi, 
       prescriber.nppes_provider_last_org_name, 
       prescriber.nppes_provider_first_name, 
       COALESCE(SUM(prescription.total_claim_count), 0) AS total_claims
FROM prescriber 
LEFT JOIN prescription ON prescriber.npi = prescription.npi
GROUP BY prescriber.npi, prescriber.nppes_provider_last_org_name, prescriber.nppes_provider_first_name
ORDER BY total_claims DESC;

Repeat the above, but this time report the nppes_provider_first_name,   nppes_provider_last_org_name, specialty_description, and the total number of claims.
SELECT prescriber.npi, 
       prescriber.nppes_provider_last_org_name, 
       prescriber.nppes_provider_first_name, 
       prescriber.specialty_description, 
        COALESCE(SUM(prescription.total_claim_count), 0) AS total_claims
FROM prescriber 
LEFT JOIN prescription ON prescriber.npi = prescription.npi
GROUP BY prescriber.npi, 
         prescriber.nppes_provider_last_org_name, 
         prescriber.nppes_provider_first_name, 
         prescriber.specialty_description
ORDER BY total_claims DESC;
Which specialty had the most total number of claims (totaled over all drugs)?
SELECT prescriber.specialty_description, 
 COALESCE(SUM(prescription.total_claim_count), 0) AS total_claims
FROM prescriber 
LEFT JOIN prescription ON prescriber.npi = prescription.npi
GROUP BY prescriber.specialty_description
ORDER BY total_claims DESC;
.Which specialty had the most total number of claims for opioids?


. Challenge Question: Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?


. Difficult Bonus: Do not attempt until you have solved all other problems! For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?


. Which drug (generic_name) had the highest total drug cost?
SELECT 
COALESCE(prescription.drug_name, drug.drug_name) AS drug_name, 
 drug.generic_name, 
COALESCE(SUM(prescription.total_drug_cost_ge65), 0) AS total_cost
FROM prescription
FULL JOIN drug ON prescription.drug_name = drug.drug_name
GROUP BY COALESCE(prescription.drug_name, drug.drug_name), drug.generic_name
ORDER BY total_cost DESC;
. Which drug (generic_name) has the hightest total cost per day? Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.
SELECT 
    COALESCE(prescription.drug_name, drug.drug_name) AS drug_name, 
    drug.generic_name, 
    COALESCE(SUM(prescription.total_drug_cost_ge65), 0) AS total_cost, 
    COALESCE(SUM(prescription.total_day_supply), 0) AS total_day_supply
FROM prescription
FULL JOIN drug ON prescription.drug_name = drug.drug_name
GROUP BY 
    COALESCE(prescription.drug_name, drug.drug_name), 
    drug.generic_name
ORDER BY total_day_supply DESC;

For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs. Hint: You may want to use a CASE expression for this. See https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/
SELECT 
    drug_name, 
    CASE 
        WHEN opioid_drug_flag = 'Y' THEN 'opioid'
        WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
        ELSE 'neither'
    END AS drug_type
FROM drug;

Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.

SELECT 'opioid' AS drug_type, SUM(total_drug_cost)::MONEY AS total_cost
FROM drug
JOIN prescription ON drug.drug_name = prescription.drug_name
WHERE opioid_drug_flag = 'Y'
UNION ALL
SELECT 'antibiotic', SUM(total_drug_cost)::MONEY
FROM drug
JOIN prescription ON drug.drug_name = prescription.drug_name
WHERE antibiotic_drug_flag = 'Y';

How many CBSAs are in Tennessee? Warning: The cbsa table contains information for all states, not just Tennessee.
Thinking about using ILIKE%TN%
SELECT COUNT(*) 
FROM cbsa 
WHERE cbsaname LIKE '%, TN';
. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.
Select *
from cbsa
right join population
on population.fipscounty = cbsa.fipscounty 
Order by population DESC;
. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.


. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.
SELECT drug_name, total_claim_count
FROM prescription
WHERE total_claim_count >= 3000
. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.
SELECT 
prescription.drug_name, 
 prescription.total_claim_count,
drug.opioid_drug_flag
FROM prescription
LEFT JOIN drug ON prescription.drug_name = drug.drug_name
WHERE prescription.total_claim_count >= 3000;
Add another column to you answer from the previous part which gives the             prescriber first and last name associated with each row.
How do I add a 3rd table explained. Im using frug and prescription I will be adding proscriber info, can’t use a UNION ALL the column won't be equal, 
The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. Hint: The results from all 3 parts will have 637 rows.


. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). Warning: Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

SELECT 
    prescriber.npi, 
    drug.drug_name
FROM prescriber
JOIN drug  ON npi = npi
WHERE 
   prescriber.specialty_description = 'Pain Management'
    AND prescriber.nppes_provider_city = 'NASHVILLE'
    AND drug.opioid_drug_flag = 'Y';

	
. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).
	Select 
prescription.npi as prescribe.npi, 
prescriber.nppes_provider_last_org_name,
prescriber.nppes_provider_first_name,
drug.drug_name,
prescription.claims as total claims
From provider 
Join prescription on prescriber.npi= prescription.npi 
Group by prescriber.nppes_provider_last_org_name,
prescriber.nppes_provider_first_name,drug.drug_name,prescribe.npi,prescription.npi order by total_claims DESC;


. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function
 