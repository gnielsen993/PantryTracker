# Project: Smart Pantry + Meal Planner
## Local-First Personal Food Operating System

---

# 0) Core Philosophy

This app is designed around one truth:

> I am a habit eater.

Instead of just tracking groceries, the app:
- Tracks pantry inventory
- Learns consumption patterns
- Forecasts depletion dates
- Cross-references meals with inventory
- Auto-builds grocery lists
- Estimates upcoming grocery cost

All local-first.
No cloud required.
AI optional for recipe import.

---

# 1) System Overview

The app has 4 core engines:

1. Pantry Engine (Inventory + Forecasting)
2. Meal Planner Engine (Ingredient Aggregation)
3. Grocery List Engine (Auto-Generated + Manual)
4. Cost Intelligence Engine (Spending Awareness)

Future:
- AI Recipe Parser
- Store Profiles
- Barcode Scanning

---

# 2) Pantry Engine (Inventory + Forecasting)

## 2.1 PantryItem Model

PantryItem:
- id
- name (Eggs, Milk, Rice)
- category (Produce, Dairy, Meat, Pantry, Frozen, etc.)
- unitType (count | grams | ounces | liters)
- quantityOnHand (Double)
- lowThreshold (Double)
- averageDailyUse (Double optional)
- lastPurchasedDate
- expirationDate (optional)
- priceLastPaid (Double optional)
- storeProfileId (optional)
- isRecurring (Bool)
- createdAt
- updatedAt

---

## 2.2 Consumption Logic

### v1 (Simple Forecasting)

User defines:
- quantityOnHand
- averageDailyUse

System computes:
- estimatedDaysRemaining = quantityOnHand / averageDailyUse
- projectedOutDate = today + estimatedDaysRemaining

If:
projectedOutDate < nextShoppingDate
→ auto-add to grocery list

---

### v2 (Adaptive Average)

System tracks:
- quantity purchased
- quantity consumed over time

Compute rolling 14-day average use:
- averageDailyUse = totalUsedLast14Days / 14

This auto-adjusts behavior over time.

---

## 2.3 Visuals

Pantry Dashboard:
- "Running Low" section
- Items expiring soon
- Depletion timeline view
- Consumption graph (units per week)

---

# 3) Meal Planner Engine

## 3.1 Meal Model

Meal:
- id
- name
- servings
- ingredients: [MealIngredient]
- category (breakfast/lunch/dinner)
- notes

MealIngredient:
- name
- quantityRequired
- unitType
- linkedPantryItemId (optional)

---

## 3.2 Weekly Meal Plan

User:
- Assigns meals to days

System:
- Aggregates total ingredient requirements for week
- Cross-references with pantry inventory
- Calculates shortages
- Sends shortages to Grocery List Engine

---

## 3.3 Cross-Reference Example

Pantry:
- Eggs: 12
- averageDailyUse: 3

Meal Plan:
- Omelet (6 eggs)
- Pancakes (4 eggs)

Total required: 10 eggs

Remaining: 2 eggs

System:
- predicts depletion soon
- auto-adds Eggs to list

---

# 4) Grocery List Engine

## 4.1 GroceryItem Model

GroceryItem:
- id
- name
- quantityNeeded
- unitType
- category
- sourceType:
  - manual
  - pantryLow
  - mealGenerated
- estimatedCost (optional)
- storeProfileId (optional)
- isChecked (Bool)

---

## 4.2 Auto-Generation Rules

Items added from:
- Pantry forecast
- Meal shortages
- Manual entry

Rules:
- Combine duplicates
- Sum quantities
- Flag auto-generated vs manual
- Allow user override

---

# 5) Cost Intelligence Engine

## 5.1 StoreProfile Model

StoreProfile:
- id
- name (Costco, Trader Joe’s, Local Market)
- defaultTaxRate (optional)

PantryItem:
- can track priceLastPaid per store

---

## 5.2 Known Cost Logic

Each GroceryItem:
- pulls last known price
- multiplies by quantityNeeded

Shopping Mode:
- shows estimated total
- shows projected weekly grocery cost
- shows monthly estimate

---

## 5.3 Cost Dashboard

Visuals:
- Weekly grocery cost (bar chart)
- Monthly average
- Top 10 most expensive items
- Price change tracking

---

# 6) Shopping Mode

When activated:

- Auto-sorted by category
- Collapsible sections
- Large tap targets
- Running total estimate
- “Why is this here?” badge:
  - Low pantry
  - Meal plan
  - Manual

Quick Add field at top:
- Add item instantly
- Suggest from pantry history

Widget:
- Remaining items count
- Quick “Add item”

---

# 7) AI Recipe Import (Future)

Flow:
1. Take photo of recipe
2. Send image to AI API
3. Parse ingredient list
4. Extract:
   - name
   - quantity
   - unit
5. User confirms edits
6. Save as Meal

AI only used for parsing.
All storage local.

---

# 8) Forecasting Intelligence

For each PantryItem:

Compute:
- projectedOutDate
- daysUntilNextShopping
- weeklyBurnRate

If:
projectedOutDate < nextShoppingDay
→ add to list

Optional:
- Allow user to define Shopping Day (e.g., Sunday)
- App auto-prepares list Saturday

---

# 9) Widgets

Small:
- Pantry health ring
- Grocery items remaining

Medium:
- 3 low inventory items
- Estimated total cost
- Quick add

Lock Screen:
- Grocery count
- Quick “Add item”
- Start Shopping Mode

---

# 10) Visual Dashboards

## Pantry Dashboard
- Low inventory timeline
- Consumption chart
- Expiration alerts

## Meal Dashboard
- Weekly plan overview
- Ingredient demand summary

## Grocery Dashboard
- Weekly spending graph
- Monthly average
- Cost breakdown by category

---

# 11) Why This Is Powerful

This is not:
- Just a grocery list
- Just a meal planner

It is:
- Inventory forecasting
- Predictive restocking
- Cost awareness
- Behavior tracking

It benefits directly from:
- Habit-based eating
- Consistent grocery cycles
- Personal routines

---

# 12) MVP Scope (Realistic v1)

Phase 1:
- Pantry tracking
- Manual averageDailyUse
- Simple forecast + auto add
- Manual grocery list
- Estimated cost via lastPaidPrice

Phase 2:
- Meal planner + cross reference
- Weekly dashboard

Phase 3:
- Adaptive averages
- Cost charts

Phase 4:
- AI recipe import


