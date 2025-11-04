---
name: market-price-research
description: Research fair market prices for second-hand items in Melbourne, Australia by analyzing recent sold listings on eBay.com.au. Use when users ask about pricing, value, or "what's it worth" for used items.
---

# Market Price Research

## Overview

This skill enables research of fair market prices for second-hand items in Melbourne, Australia by analyzing recent sold listings on eBay.com.au. Provides price ranges, typical selling prices, and market insights based on actual completed sales.

## When to Use This Skill

Use this skill when users request:
- "What's the fair price for [item]?"
- "How much is my [item] worth?"
- "What do [items] sell for in Melbourne?"
- "Research prices for [item]"
- Any query about second-hand item valuation in Melbourne

## Research Workflow

### 1. Understand the Item

Gather specific details about the item:
- Brand and model (exact model numbers if available)
- Condition (new, like new, good, fair, poor)
- Age or year of manufacture
- Any notable features or accessories
- Any defects or missing components

### 2. Search eBay.com.au Sold Listings

Construct searches using the eBay Australia sold listings filter. See `references/ebay_search_guide.md` for detailed search URL construction patterns.

**Key search parameters:**
- Use specific brand/model terms
- Include condition keywords when relevant
- Filter to "Sold items" to see actual sale prices (not just asking prices)
- Consider location filtering to Melbourne/Victoria for local market insights
- Look at listings from the past 30-90 days for current market trends

### 3. Analyze Price Data

Review 10-20 recent sold listings to identify:
- Price range (lowest to highest)
- Median/typical selling price
- Outliers (unusually high or low, with reasons)
- Condition correlation (how condition affects price)
- Seasonal trends if applicable
- Shipping vs pickup prices

### 4. Provide Market Price Assessment

Present findings in a clear format:
- **Fair Market Price Range**: Based on typical sales
- **Condition Impact**: How condition affects pricing
- **Recent Sales Data**: Number of items analyzed, date range
- **Market Observations**: Any notable trends or factors
- **Recommended Pricing**: For selling or buying

## Using WebFetch for eBay Research

Use the WebFetch tool to retrieve and analyze eBay sold listings:

```
WebFetch(
  url="[eBay search URL for sold items]",
  prompt="Extract the sold prices, item conditions, and sale dates for this search. List each item with its sale price and condition."
)
```

Multiple searches may be needed to gather sufficient data across different conditions or variations.

## Resources

### references/ebay_search_guide.md

Reference documentation containing:
- eBay.com.au sold listings URL patterns
- Search filter parameters
- Location filtering for Melbourne/Victoria
- Tips for effective price research
- Common item categories and search strategies
