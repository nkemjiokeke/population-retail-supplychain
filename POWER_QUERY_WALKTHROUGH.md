# Power Query walkthrough - Project 03 (StatCan "as displayed" wide files)

These StatCan CSVs are WIDE: metadata rows on top, geographies down the side, time periods across the top. The cleaning pattern is: strip the top rows, promote the real header, drop the units row, keep only the geography rows, then UNPIVOT the period columns into rows. Do population first (cleanest), then repeat for retail and food services with one extra step (strip the data-quality letters).

## Query 1 - Population (17-10-0009 / `1710000901-eng (1).csv`)
1. Data -> Get Data -> From Text/CSV -> pick the file -> **Transform Data** (do not Load).
2. In Applied Steps, delete any auto "Changed Type" and "Promoted Headers" so you see the raw rows.
3. Home -> Remove Rows -> **Remove Top Rows = 8**. The first row should now be: Geography, Q2 2018, Q3 2018, ...
4. Home -> **Use First Row as Headers**.
5. The new first data row is the units row (blank Geography, "Persons"). Remove Rows -> **Remove Top Rows = 1**.
6. Keep only the geography rows: Remove Rows -> **Keep Top Rows = 14** (Canada + 10 provinces + Yukon + Northwest Territories + Nunavut). This drops the footnotes at the bottom.
7. Select the **Geography** column -> right-click -> **Unpivot Other Columns**. You now have Geography, Attribute, Value.
8. Rename Attribute -> **Quarter**, Value -> **Population**.
9. Population still has thousands commas. Select it -> Transform -> Replace Values -> find `,` replace with nothing -> then set Data Type to **Whole Number**.
10. Split the Quarter label into a join key: add a **Year** column = last 4 characters of Quarter (Add Column -> Extract -> Last Characters -> 4), and a **Qtr** column = the number after "Q" (Extract -> Text Between, or Replace "Q" and take first char). You want Year (number) and Qtr (1-4).
Result: Geography, Quarter, Population, Year, Qtr. One row per province per quarter.

## Query 2 - Retail (20-10-0056-01 / `2010005601-eng.csv`)
Same pattern, with two differences.
1. From Text/CSV -> Transform Data; delete auto steps.
2. **Remove Top Rows = 11** (there are three extra metadata rows: NAICS, Sales, Adjustments). First row should be: Geography, January 2018, February 2018, ...
3. Use First Row as Headers -> then **Remove Top Rows = 1** (the "Dollars" units row).
4. **Keep Top Rows = 14** (or filter Geography to the provinces you want; note this table also lists census metropolitan areas lower down, so filtering is safer than Keep Top Rows here - filter the Geography column to the 10 provinces).
5. Unpivot Other Columns on Geography -> rename Attribute -> **Month**, Value -> **RetailSales**.
6. **Strip the quality letters**: the values look like `1,062,560A` or `994,043B`. Select RetailSales -> Replace Values to remove `,`; then Transform -> Format -> **Trim**, and remove trailing letters by adding a column `Text.Select([RetailSales],{"0".."9"})` (Add Column -> Custom Column) or use Replace Values for A, B, C, D, F individually. Set the cleaned column to Whole Number. Cells marked `F` are "too unreliable to publish" - they become null.
7. Turn Month into Year + Qtr: add **Year** (last 4 characters of Month) and derive **Qtr** from the month name (Jan-Mar = 1, Apr-Jun = 2, Jul-Sep = 3, Oct-Dec = 4). Easiest: Add Column -> Column From Examples, type 1 next to a January row, 2 next to April, etc., and let it learn.
8. **Group By** Geography + Year + Qtr -> Sum of RetailSales. This turns three monthly rows into one quarterly row so it aligns with population. Exact clicks:
   1. Home tab -> **Group By**. Choose the **Advanced** radio button (so you can group by more than one column).
   2. Under "Group by", add three rows: **Geography**, then **Year**, then **Qtr** (use the "Add grouping" button for the second and third).
   3. Under "New column name", type `RetailSales_Q`. Set **Operation = Sum**. Set **Column = RetailSales** (the cleaned numeric column from step 6).
   4. Click OK. You now have one row per Geography-Year-Qtr with the three months summed. Rename `RetailSales_Q` back to `RetailSales` if you like.
   - Sanity check: row count should drop to about (10 provinces) x (years) x (4 quarters). Make sure you grouped on the **cleaned numeric** RetailSales (no commas or letters), or the Sum will error or return blanks.

## Query 3 - Food services (21-10-0019 / `2110001901-eng.csv`)
Identical to Retail: Remove Top Rows = 11, promote headers, remove the Dollars row, filter to provinces, unpivot, strip letters (watch for `F`), Month -> Year + Qtr, Group By to quarterly Sum. Rename the value **FoodServices**.

## Combine
1. Start from Population. Home -> **Merge Queries** -> merge with Retail on **Geography + Year + Qtr**. Expand RetailSales.
2. Merge again with Food services on the same keys. Expand FoodServices.
3. Add columns:
   - `RetailPerPerson = [RetailSales] * 1000 / [Population]`  (sales are in thousands)
   - **Year-over-year growth** = each value versus the same quarter one year earlier. Power Query has no "last year" button, so you line the table up against itself with a self-merge on the columns you already have. Your table is already one row per province-quarter, so no key column is needed. Exact steps:
     1. Add Column -> Custom Column, name it `PrevYear`, formula: `[Year] - 1`. This is the only helper you add, and you can delete it at the end. (Set its type to Whole Number so it matches `Year`.)
     2. Home -> **Merge Queries** -> in the "Merge with" dropdown pick **this same query** (a self-merge).
     3. In the **top** table, click the match columns in this order: **Geography**, then Ctrl+click **PrevYear**, then Ctrl+click **Qtr**. Little numbers 1, 2, 3 appear on them.
     4. In the **bottom** table, click in the same order: **Geography**, then **Year**, then **Qtr**. (So PrevYear on top matches Year on the bottom - that is what pulls in last year's row.) Join Kind = **Left Outer**. OK.
     5. Expand the new merged column (the little double-arrow icon), untick everything except `Population`, `RetailSales_Q`, `Foodservices`, untick "use original column name as prefix", and rename the three to `Population_Prev`, `Retail_Prev`, `Food_Prev`.
     6. Add a Custom Column for each growth rate (the null-guard keeps the earliest quarters from erroring):
        - `Pop_YoY = if [Population_Prev] = null then null else ([Population] - [Population_Prev]) / [Population_Prev]`
        - `Retail_YoY = if [Retail_Prev] = null then null else ([RetailSales_Q] - [Retail_Prev]) / [Retail_Prev]`
        - `Food_YoY = if [Food_Prev] = null then null else ([Foodservices] - [Food_Prev]) / [Food_Prev]`
     7. Set those three to **Percentage** type if you want them shown as %. Delete the `PrevYear` helper column if you like - the growth columns keep working.
     - Expect the earliest rows (2018 quarters and Q1 2019) to be blank on YoY - there is no prior year to compare to yet. That is correct, not an error.
     - Make sure `Year` and `PrevYear` are the **same type** (both Whole Number) or the merge will match nothing and every growth column comes back null.
4. For province comparisons, filter out Canada and the territories; keep Canada only for the national line.

## Notes / watch-outs
- Population quarters are point-in-time (Q1 = Jan 1, Q2 = Apr 1, Q3 = Jul 1, Q4 = Oct 1). Retail quarters are the sum of three calendar months. Aligning them on Year + Qtr is a small approximation - note it in Limitations.
- Use unadjusted retail and food services (they are), so summing months into quarters is valid.
- Keep suppressed cells (F) as null, not zero.
- Later add-ons: components by province quarterly (re-download 17-10-0040) and employment by industry/province (re-download 14-10-0355).
