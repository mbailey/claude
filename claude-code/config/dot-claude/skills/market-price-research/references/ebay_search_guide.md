# eBay Australia Sold Listings Search Guide

## Base URL Pattern

eBay Australia sold listings use this URL structure:

```
https://www.ebay.com.au/sch/i.html?_nkw=SEARCH_TERMS&_sacat=0&LH_Sold=1&LH_Complete=1&rt=nc
```

### Key Parameters

- `_nkw=` - Search keywords (URL encoded, spaces as `+` or `%20`)
- `_sacat=0` - All categories (can be specific category ID)
- `LH_Sold=1` - Show sold listings
- `LH_Complete=1` - Show completed listings (includes sold and unsold)
- `rt=nc` - Real-time results
- `_sop=13` - Sort by "Time: newly listed" (optional)
- `_ipg=200` - Items per page (max 200)

## Location Filtering

### Melbourne/Victoria Filter

Add these parameters to filter for Melbourne/Victoria:

```
&_sadis=200&_stpos=3000&_fspt=1
```

- `_sadis=200` - Distance in km (200km from postcode)
- `_stpos=3000` - Melbourne CBD postcode
- `_fspt=1` - Enable location search

**Example with location:**
```
https://www.ebay.com.au/sch/i.html?_nkw=macbook+pro&_sacat=0&LH_Sold=1&LH_Complete=1&_sadis=200&_stpos=3000&_fspt=1
```

## Common Item Categories

Use `_sacat=` with category IDs for more specific searches:

- Electronics: `_sacat=15032`
- Computers/Tablets: `_sacat=4618`
- Photography: `_sacat=625`
- Sporting Goods: `_sacat=382`
- Home & Garden: `_sacat=11700`
- Musical Instruments: `_sacat=619`
- Clothing: `_sacat=11450`
- Collectables: `_sacat=1`
- Baby: `_sacat=2984`

## Search Best Practices

### 1. Be Specific

Use exact model numbers when possible:
- Good: `macbook+pro+m1+13+inch+2020`
- Poor: `apple+laptop`

### 2. Include Condition Keywords

Add condition terms to the search when relevant:
- `used`, `refurbished`, `like+new`, `parts`, `broken`

### 3. Use Negative Keywords

Exclude unwanted results with minus sign:
- `macbook+pro+-case+-skin+-screen` (excludes accessories)

### 4. Date Range Filtering

Use these parameters for time-based filtering:
- `LH_PrefLoc=3` - Items located in Australia
- Sort by time: `_sop=13` (newly listed) or `_sop=10` (ending soonest)

### 5. Price Range Filtering

Add price limits:
- `_udlo=100` - Minimum price (e.g., $100)
- `_udhi=500` - Maximum price (e.g., $500)

## Example Searches

### 1. MacBook Pro in Melbourne

```
https://www.ebay.com.au/sch/i.html?_nkw=macbook+pro+m1&_sacat=0&LH_Sold=1&LH_Complete=1&_sadis=200&_stpos=3000&_fspt=1&_ipg=200
```

### 2. Canon Camera Bodies (Australia-wide)

```
https://www.ebay.com.au/sch/i.html?_nkw=canon+eos+r5&_sacat=625&LH_Sold=1&LH_Complete=1&LH_PrefLoc=3&_ipg=200
```

### 3. iPhone with Price Range

```
https://www.ebay.com.au/sch/i.html?_nkw=iphone+14+pro&_sacat=0&LH_Sold=1&LH_Complete=1&_udlo=800&_udhi=1200&_ipg=200
```

## Tips for Effective Price Research

### 1. Review Multiple Pages

Don't rely on just the first page - review at least 2-3 pages (40-60 listings) for a good sample.

### 2. Note Sale Dates

Recent sales (last 30 days) are most relevant for current market pricing. Older sales may not reflect current market conditions.

### 3. Check Item Condition in Descriptions

eBay's condition categories can be subjective. Read descriptions to verify actual condition.

### 4. Watch for Bundled Items

Some listings include accessories, cases, or multiple items. Adjust pricing accordingly.

### 5. Identify Outliers

Extremely low prices might be:
- Parts/broken items
- Items with defects
- Auctions that ended at unusual times

Extremely high prices might be:
- Rare variants
- Bundled packages
- Buy-it-now listings that sat for a while

### 6. Consider Shipping

Note whether prices include shipping or are pickup-only. Add $10-30 for typical shipping costs in price comparisons.

## URL Encoding Reference

When constructing search URLs, encode special characters:

- Space: `+` or `%20`
- Quotes: `%22`
- Ampersand: `%26`
- Slash: `%2F`
- Question mark: `%3F`

## Troubleshooting

### No Results?

- Try broader search terms
- Remove location filters (search Australia-wide)
- Check spelling of brand/model
- Try alternative model names or numbers

### Too Many Results?

- Add more specific model details
- Use category filtering
- Add condition keywords
- Apply price range filters
- Add location filtering

### Old Listings?

- eBay shows sold items from approximately 90 days
- Very niche items may have fewer recent sales
- Consider expanding search radius or removing location filter
