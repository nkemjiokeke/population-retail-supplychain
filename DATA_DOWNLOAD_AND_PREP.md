# Data download and prep - Project 03

Five real StatCan tables. Start with the three core ones (population, components, retail) to get moving; food services and employment add the ripple. On each StatCan page use "Add/Remove data" to trim, then "Download options -> CSV (as displayed)".

## Core three (download first)
1. **Population, quarterly - 17-10-0009**
   - Geography: Canada + all provinces. Time: 2018 to latest. Value is persons.
2. **Components of population change, quarterly - 17-10-0040**
   - Geography: provinces. Components: keep Immigrants, Net non-permanent residents, and Natural increase (births minus deaths). Time: 2018 to latest.
3. **Retail sales by province, monthly - 20-10-0056-01**
   - Geography: provinces. Industry (NAICS): Retail trade [44-45] total (you can add sub-industries later). Adjustment: **Unadjusted** (so months sum cleanly to quarters). Value: Sales, in thousands of dollars. Time: 2018 to latest.

## Two more (the ripple)
4. **Food services and drinking places receipts - 21-10-0019**
   - Geography: provinces if offered (or Canada). Total food services. Unadjusted. Thousands of dollars.
5. **Employment by industry and province, monthly - 14-10-0355**
   - Geography: provinces. Industry: Retail trade, Food services, and Total, if you want. Value: employment (persons). Unadjusted or 3-month average.

## Prep in Power Query (the combine plan)
Goal: one **Province x Quarter** table with population and each business signal side by side.
1. Load each CSV. Drop the status, scalar, DGUID, UOM and vector columns. Rename to Geography, Date (REF_DATE), a category column where relevant, and Value. Set types. Trim Geography.
2. **Make a Quarter key.** Population is already quarterly. For the monthly tables (retail, food services, employment), add a Quarter column (e.g. Year & "-Q" & Rounddown((Month-1)/3)+1) and **Group By Geography + Quarter**: Sum the dollar values, Average the employment counts. This aligns everything to quarters.
3. For 17-10-0040, keep the components as columns (Pivot the component column) so you have Immigrants, Net NPR and Natural increase per Province-Quarter.
4. **Merge** the quarterly retail, food services and employment onto the population table on **Geography + Quarter**. Then merge the components too.
5. Derived columns: retail per person = retail_thousands * 1000 / population; year-over-year growth for population, retail, food services and employment (value vs four quarters earlier); and the population-vs-per-person split.
6. Exclude the territories roll-up when ranking provinces; keep Canada only for the national line.

## Watch-outs
- Values are in thousands of dollars - keep the unit labelled.
- Use unadjusted series so quarterly sums are valid; do not mix seasonally adjusted and unadjusted.
- StatCan suppresses small cells - keep them null, not zero.
- Recent quarters get revised.
