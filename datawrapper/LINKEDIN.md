# Project 03 - LinkedIn write-up and chart annotations

## LinkedIn post (connected story, first person)

Immigration is often credited with growing Canada's economy. I wanted to test that with real numbers, and to see what it means for retailers now that immigration is being pulled back. I used Statistics Canada and IRCC data for the ten provinces from 2018 to 2024.

Population growth was almost entirely immigration. In 2023, newcomers were 100% or more of the population increase in every province, because deaths had caught up with births. Without immigration, most provinces would have lost people.

I then split each province's real GDP growth into two parts: growth from more people, and growth from higher output per person. Almost all of it was more people. Ontario grew 11.6% over the period with no gain per person. The economy got bigger because it added people, while output per person stayed flat.

Retail sales are the number of people in a market times what each person spends. The growth was people, those people are now leaving, and spending per person was already flat, so retail demand falls with the population.

I scored the ten provinces on how exposed their retail demand is, using market size, the population trend, and spending per person, then turned the scores into a call. Alberta is the only province still adding people, so that is where I would open stores. Ontario, Quebec, British Columbia, Manitoba and Newfoundland have started to shrink, so I would stop expanding there and defend the stores already in Ontario, which is still the largest market by far.

For a retailer, the number to watch is population, not GDP. GDP tracked population for six years, so as population falls, retail demand falls with it. The money should go where people are still arriving.

One caveat: this shows immigration and the economy moving together, not one causing the other. Strong economies also attract immigrants, and this data cannot separate the two.

Cleaned in Power Query, measured in SQLite, tested in Python, charted in Datawrapper. Full write-up and code in the comments.

## Carousel slides

1. Does immigration grow Canada's economy, and what does that mean for retail? Real StatCan and IRCC data, ten provinces, 2018 to 2024.
2. The question. I hear that immigration grows the economy, so I tested it, then asked what it means for retailers now that immigration is being reduced.
3. I checked where population growth came from (Chart 2). In 2023, newcomers were 100% or more of the increase in every province.
4. I split GDP growth into people and output per person (Chart 1). Ontario grew 11.6%, none of it per person. Immigration grows the economy by adding people.
5. I checked immigration against GDP (Chart 3). They move together, r = 0.53. Correlation, not proof; economies attract immigrants too.
6. I traced it into retail (Chart 4). Retail is people times spend per person. Population was the driver, and it is now falling.
7. I turned it into a decision (Chart 5). Grow Alberta. Hold the flat provinces. Pull back where population is falling, but defend Ontario.
8. The insight. For a retailer, the number to watch is population, not GDP. GDP tracked population for six years, so as population falls, retail demand falls with it. Put the money where people are still arriving.
9. How I built it. Power Query to clean, SQLite for the measures, Python for the correlation and decomposition, Datawrapper for the charts. It shows association, not causation.

## Chart annotations

### Chart 1 - Decomposition
- Ontario bar: "Ontario's real GDP grew 11.6%. Almost none of that was output per person. It was population."
- Alberta bar: "Alberta's population rose 12.8%, but its output per person fell 4.7%."
- Caption: "Blue is growth from more people. Green is growth from output per person. Blue dominates in every province, so the growth came from adding people."

### Chart 2 - Immigration and population
- On the 100% line: "At 100%, newcomers equal the entire population increase."
- Caption: "Every province is at or above 100% in 2023. Immigration covered both the growth and a natural decline, where deaths had passed births."

### Chart 3 - Immigration and GDP
- By the trend line: "Provinces with more immigration grew GDP faster. r = 0.53."
- Caveat: "This is correlation, not cause. Strong economies also attract immigrants, and this data can't separate the two directions."

### Chart 4 - Exposure
- Ontario: "Ontario is the most exposed: largest market, fastest slowdown, lowest retail spend per person."
- Caption: "The score combines market size, the population trend, and spend per person. Higher means more retail demand at risk."

### Chart 5 - The decision
- Alberta: "Still growing its population. The province to expand in."
- Ontario: "Population now falling. Pull back on new stores, but keep defending the largest market in the country."
- Caption: "Direction comes from the latest quarter's population trend. The exposure score sets the priority."
