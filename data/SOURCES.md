# Sources - Project 03: Population Growth and the Outlook for Canadian Retail and Supply Chain (REAL data)

All data is real, from Statistics Canada and Immigration, Refugees and Citizenship Canada (IRCC), under the Open Government Licence - Canada. No simulation.

## The situation in numbers (context)
- Canada's population grew about **3.0%** in the year to July 2024, then slowed to **0.9%** in the year to July 2025, and **fell by roughly 102,000 people during 2025** - the first annual decline in decades.
- The federal government projects the population will **decline about 0.2% in both 2025 and 2026**, returning to growth of about 0.8% in 2027. This is roughly **1.4 million fewer residents by the end of 2027** than the previous outlook.
- Permanent resident targets were cut from **464,265 (2024) to 395,000 (2025), 380,000 (2026) and 365,000 (2027)**.
- The plan aims to reduce **non-permanent residents (NPRs) to 5% of the population by the end of 2026**, down from about 7%. The **international student cap was cut to 437,000 for 2025**.
- Most of the 2025 NPR decline came from **study-permit holders**.
- On spending: recent newcomers were mostly temporary residents in lower-wage roles with less discretionary income, so **per-person retail spending fell during the population boom and is only now recovering**. Consumer spending is about half of GDP, so fewer people weighs on the retail total even if per-person spending rises.

Links:
- IRCC - 2025-2027 Immigration Levels Plan (reduction announcement): https://www.canada.ca/en/immigration-refugees-citizenship/news/2024/10/government-of-canada-reduces-immigration.html
- Parliamentary Budget Officer - Demographic implications of the Immigration Levels Plan: https://www.pbo-dpb.ca/en/publications/RP-2425-028-S--impact-assessment-2025-2027-immigration-level-plan--evaluation-incidence-plan-niveaux-immigration-2025-2027
- CIC News - Canada's population contracts in 2025: https://www.cicnews.com/2025/12/canadas-population-shrinks-for-the-first-time-in-2025-driven-by-tightened-immigration-policy-1263630.html

## The tables to download (Statistics Canada, CSV)
- **Population, quarterly** - Table 17-10-0009: https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1710000901
- **Components of population change (immigrants, net non-permanent residents, natural increase), quarterly** - Table 17-10-0040: https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1710004001
- **Monthly retail trade sales by province and territory** - Table 20-10-0056-01: https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=2010005601
- **Monthly wholesale trade sales** (supply-chain proxy) - Table 20-10-0074: https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=2010007401

## How to pull (a few minutes each)
1. Open each table, use Add/Remove data to select Canada and the provinces and the recent years (roughly 2018 to latest).
2. For 17-10-0040, keep the components: immigrants, net non-permanent residents, and natural increase, so you can show what drove the population change.
3. Download as CSV into `data/`. Note the retail and wholesale values are in thousands of dollars; population is in persons.

## Additional tables for the holistic, cross-sector view
To trace the ripple into the businesses that depend on population growth, add:
- **Monthly retail trade sales by province** - Table 20-10-0056-01 (already listed).
- **Monthly wholesale trade sales** - Table 20-10-0074 (already listed).
- **Food services and drinking places receipts** - Table 21-10-0019: https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=2110001901
- **Employment by industry and province, monthly (Labour Force Survey)** - Table 14-10-0355: https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1410035501
- (Optional) Rent component of the Consumer Price Index, by province - Table 18-10-0004, to show the household cost side of population growth.

These let you compare provinces and connect the population driver to the sectors that survive on it: retail, food services and restaurants, wholesale and logistics, and the jobs in each.

## Added for the hypothesis-test layer (immigration and the economy)
- **Gross domestic product, provincial and territorial, annual - Table 36-10-0222** (expenditure-based, x 1,000,000): https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3610022201
  - Use this to test whether provincial GDP moves with population and immigration. Nominal and real (chained) versions exist; pick one and keep it consistent. Real GDP is the cleaner "economy" measure; nominal aligns with the nominal retail dollars.
- **Components of population change - you already have 17-10-0151** (by economic region, annual). Filter it to the 10 provinces and use the **Immigrants** and **Net non-permanent residents** columns. This gives immigration and NPR flows by province and year, aligned to annual GDP. (Cleaner quarterly-by-province alternative for later: Table 17-10-0040.)

Grain note: the hypothesis-test layer works at **province x year** (annual GDP and components). The retailer decision layer works at **province x quarter** (population and retail). Keep the two grains separate and clearly labelled.
