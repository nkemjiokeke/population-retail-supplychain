# Project 03 - Does Immigration Move Canada's Economy? A Provincial Test, Applied to a Store Plan
### Build guide (real Statistics Canada and IRCC data; you build it; this is the map)

Goal: two things in order. First, test whether Canada's provincial economies actually move with population and immigration, and by how much (the hypothesis). Second, apply that relationship to a real business decision - where a national retailer should grow, hold, or pull back as population falls. Built entirely on official data. No simulation.

## 1. Business context and the hypothesis
For most of 2022 to 2024 Canada had the fastest population growth in decades, almost all of it immigration and non-permanent residents. Retail, food services and jobs grew alongside it. That has now reversed: growth slowed from 3.0% in the year to July 2024 to 0.9% a year later, the population fell by about 102,000 in 2025, and the federal plan projects a decline in 2025 and 2026 - roughly 1.4 million fewer residents by 2027 than expected.

The hypothesis this project tests: **immigration contributes tellingly to Canada's economic growth, and the rise and fall of immigration moves the economy.** Note up front what the data can and cannot do. Observational data cannot *prove* causation - too many things move together. What it can show is the strength and consistency of the relationship, and a decomposition of how much growth came from more people versus more output per person. That is strong evidence for or against the hypothesis, stated honestly. Then the business question follows: if the relationship holds and population is now falling, where does a retailer act. Sources are in `data/SOURCES.md`.

## 2. Audience and decision-maker
Two readers. For the hypothesis, the reader is anyone weighing the economic effect of immigration policy - an analyst, a planner, a policy team. For the decision, the reader is a national retailer's **network planning and real estate lead** (with demand planning and the CFO), who decides where to grow, hold, or pull back stores and inventory.

## 3. Problem statement
The claim that immigration drives growth is asserted often and tested rarely with the numbers. This project measures the relationship between population, immigration and the provincial economy (GDP and retail), decomposes recent growth into a population part and a per-person part, and then uses the result to decide where a retailer should invest as population falls.

## 4. Key questions
**Part A - the relationship (the hypothesis)**
1. How much of each province's population growth came from immigrants and non-permanent residents?
2. Do provincial GDP and retail sales move with population and immigration, and how strongly (correlation across provinces and years)?
3. Growth decomposition: how much of provincial GDP and retail growth came from more people versus more output or spending per person?
4. Does the timing line up - the boom with the surge, the slowdown now - and is the pattern consistent across provinces, or driven by one or two?

**Part B - the decision (the application)**
5. Which provinces are most exposed to the population reversal, in demand terms, for a retailer?
6. On the projected population path, what is the demand outlook by province, and where should the retailer grow, hold, or pull back?

## 5. Data model
Two grains, kept separate.
- **Relationship layer (province x year):** Population and its annual growth (17-10-0009); Immigrants and Net non-permanent residents by province (17-10-0151, filtered to provinces); GDP by province, annual (36-10-0222). Derive annual growth rates and per-capita GDP.
- **Decision layer (province x quarter):** Population, quarterly (17-10-0009); retail sales by province (20-10-0056-01) and food services (21-10-0019), aggregated to quarterly. Derive retail per person and the population-vs-per-person split.
Clean each StatCan "as displayed" wide file by unpivoting (see `POWER_QUERY_WALKTHROUGH.md`).

Derived fields: population growth; immigration + NPR share of population change; GDP growth and GDP per person; retail growth and retail per person; the population-vs-per-person decomposition; a population-to-GDP and population-to-retail relationship (correlation and a simple elasticity); a demand exposure score; and a grow / hold / pull-back flag by province.

## 6. KPIs
| KPI | How it is measured | Why it matters |
|---|---|---|
| Population growth | year-over-year change, by province | The driver. |
| Immigration + NPR share | immigrants + net NPR / total population change | How much of growth was newcomers. |
| GDP growth and GDP per person | provincial GDP and GDP / population | The "economy" side of the hypothesis. |
| Retail growth and per person | retail sales and retail / population | The consumer economy. |
| Population-to-GDP relationship | correlation and elasticity across provinces | The core test of the hypothesis. |
| Growth split | population part vs per-person part | Whether growth was people or productivity. |
| Demand exposure score | size, trajectory and per-person strength | Which markets are most at risk. |
| Grow / hold / pull-back | the recommended call by province | The decision. |

## 7. Build it - step by step
- **Power Query:** clean and unpivot each wide table. Build two combined tables: a province-by-year table (population, immigration, NPR, GDP) and a province-by-quarter table (population, retail, food services). Add the growth, per-capita and decomposition fields.
- **SQL / Python:** for Part A, correlation and a simple elasticity of GDP and retail against population and immigration, plus the growth decomposition; for Part B, the exposure score and the outlook on the projected population path. Python is the right tool for the correlation, elasticity and any regression.
- **Datawrapper:**
  | Question | Chart | Datawrapper type |
  |---|---|---|
  | What drove population | immigration + NPR share by province | Stacked bar |
  | Does GDP track population | GDP growth vs population growth, by province | Scatter |
  | People or per person | growth decomposition | Stacked bar |
  | Exposure | demand exposure score by province | Choropleth or ranked bar |
  | Outlook | provincial demand projected to 2027 | Line with scenarios |
  | Decision | grow / hold / pull-back by province | Colour-coded table |

## 8. How to read it
For the hypothesis: expect population and immigration to correlate strongly with retail and with GDP across provinces, and the decomposition to show that much of the recent growth was more people rather than more per person. That supports the hypothesis while being clear it is association, not proof. For the decision: the provinces that grew most on population are the most exposed now, and the outlook sorts the country into grow, hold, and pull-back markets.

## 9. Recommendation and impact
State the hypothesis result plainly - how strong the relationship is and how much of growth was population - with the causation caveat. Then give the retailer a grow, hold, or pull-back call by province, tied to market size, the population outlook and per-person strength, with the demand outlook quantified as a range under the projected population path. Sales are in current dollars.

## 10. Limitations
This is the important one for the hypothesis: **the analysis shows association and decomposition, not proof of causation.** Population, immigration, GDP and retail all move with the business cycle, interest rates, the pandemic and commodity prices, any of which can drive the correlation. Nominal-dollar series mix price and volume; use real GDP where possible and note it. The relationship layer is annual and the decision layer is quarterly - keep them separate. The projection is a scenario on the government's stated population path, not a behavioural forecast. A causal claim would need a proper econometric design (controls, instruments), which is beyond a portfolio analysis and is stated as such.
