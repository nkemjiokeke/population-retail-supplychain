# Does Immigration Move Canada's Economy? A Provincial Test, Applied to a Store Plan

> Sector: Macroeconomics and Retail. Data: Statistics Canada and IRCC (official, Open Government Licence - Canada). Tools: Power Query, SQL (SQLite), Python, Datawrapper. Method: GDP decomposition, correlation testing and provincial exposure scoring.

All figures come from official sources. Citations are in `data/SOURCES.md`. Written in my own voice.

## The question
Immigration is often credited with growing Canada's economy. I wanted to test that with real numbers for the ten provinces from 2018 to 2024, and then ask what it means for retailers now that immigration levels are being cut.

## What I found
**Population growth was almost entirely immigration.** In 2023, newcomers were 100% or more of the population increase in every province, because deaths had caught up with births. Without immigration, most provinces would have lost people.

**GDP grew because the population grew, not because output per person rose.** I split each province's real GDP growth into growth from more people and growth from higher output per person. Ontario's real GDP grew 11.6% over the period with no gain per person. Alberta's population rose 12.8% while its output per person fell 4.7%.

**Immigration and GDP moved together (r = 0.53).** Provinces with more immigration grew GDP faster. This is correlation, not cause: strong economies also attract immigrants, and this data cannot separate the two directions.

**Retail follows people.** Retail sales are the number of people in a market times what each person spends. Spending per person was already flat, so as population falls, retail demand falls with it.

## The decision
I scored each province on how exposed its retail demand is, using market size, the latest population trend and spending per person, and turned the scores into a store plan:

- **Grow in Alberta**, the only province still adding people.
- **Hold** in provinces where population is flat.
- **Pull back on new stores** in Ontario, Quebec, British Columbia, Manitoba and Newfoundland and Labrador, where population has started to shrink, while **defending existing stores in Ontario**, still the largest market by far.

For a retailer, the number to watch is population, not GDP.

## Data
| Measure | Statistics Canada table |
|---|---|
| Population, quarterly | 17-10-0009 |
| Components of population change | 17-10-0040, 17-10-0151 |
| Retail trade sales by province | 20-10-0056-01 |
| Food services and drinking places receipts | 21-10-0019 |
| Employment and average weekly earnings by province | 14-10-0332 |
| Provincial GDP, annual | 36-10-0222 |

Two grains are kept separate: province by year for the hypothesis test, and province by quarter for the retail decision layer.

## How I built it
1. Downloaded the StatCan tables as CSV and cleaned and reshaped them in Power Query (see `POWER_QUERY_WALKTHROUGH.md`).
2. Loaded the cleaned data into SQLite and built the measures one query per question (`*.sql`).
3. Ran the correlation and GDP decomposition in Python (`data/Project03_PartA.ipynb`).
4. Charted the results in Datawrapper (`datawrapper/`).

## Limitations
- The analysis shows association, not causation.
- Provincial totals hide differences between cities and regions.
- Nominal retail dollars and real GDP measure different things; each is used only for the question it fits.
