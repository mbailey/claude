---
name: inventory-manager
description: Personal inventory management system for tracking possessions during decluttering and organization. Uses SQLite database for structured tracking of rooms, categories, items, and processing status. Use when organizing, decluttering, or managing personal belongings.
---

# Inventory Manager

## Overview

Systematic inventory management for personal possessions with focus on decluttering and organization workflows. Uses SQLite database to track items across rooms, categories, and processing status.

## When to Use This Skill

Use this skill when:
- Taking inventory of possessions
- Decluttering and organizing spaces
- Tracking items to keep, donate, or discard
- Managing processing sessions
- Generating reports on inventory status
- Room-by-room organization projects

## Core Capabilities

### Database Operations
- Initialize inventory database with schema
- Add rooms and define their purpose
- Create and manage item categories
- Track individual items with details
- Update item status (keep/donate/discard/process)
- Record processing sessions

### Inventory Workflow
1. **Room Setup** - Define rooms and their primary use
2. **Category Definition** - Establish taxonomy for item types
3. **Item Capture** - Record items via voice or structured input
4. **Status Tracking** - Mark items for keep/donate/discard
5. **Progress Monitoring** - Track processing sessions and completion
6. **Reporting** - Generate summaries and insights

## Database Schema

### Rooms Table
- room_id (primary key)
- name (e.g., "Living Room", "Bedroom")
- description
- created_at

### Categories Table
- category_id (primary key)
- name (e.g., "Electronics", "Clothing", "Papers")
- parent_category_id (for hierarchical categorization)
- description
- created_at

### Items Table
- item_id (primary key)
- room_id (foreign key)
- category_id (foreign key)
- name
- description
- quantity
- status (pending/keep/donate/discard/processed)
- notes
- created_at
- updated_at

### Sessions Table
- session_id (primary key)
- room_id (optional, if room-specific)
- start_time
- end_time
- items_processed
- notes

## Tools Available

### inventory_init
Initialize or connect to inventory database. Creates schema if needed.

**Usage:**
```python
inventory_init(db_path="/Users/admin/tasks/projects/inventory/INV-2_epic_declutter-and-organize-accumulated-items/inventory.db")
```

### add_room
Add a room to the inventory.

**Parameters:**
- name: Room name
- description: Optional description of room purpose

**Usage:**
```python
add_room(name="Living Room", description="Main living space with TV and couch")
```

### add_category
Add an item category.

**Parameters:**
- name: Category name
- parent_category: Optional parent for hierarchy
- description: Optional description

**Usage:**
```python
add_category(name="Electronics", description="Electronic devices and accessories")
add_category(name="Cables", parent_category="Electronics")
```

### add_item
Record an item in the inventory.

**Parameters:**
- name: Item name
- room: Room where item is located
- category: Item category
- quantity: Number of items (default: 1)
- description: Optional details
- status: pending/keep/donate/discard (default: pending)
- notes: Optional notes

**Usage:**
```python
add_item(
    name="HDMI cables",
    room="Office",
    category="Cables",
    quantity=5,
    description="Various lengths, some unused",
    status="pending",
    notes="Check which are actually needed"
)
```

### update_item_status
Change item status during processing.

**Parameters:**
- item_id: Item identifier
- status: keep/donate/discard/processed
- notes: Optional processing notes

### list_rooms
Show all rooms in inventory with item counts.

### list_categories
Show category hierarchy with item counts.

### list_items
List items with filtering options.

**Parameters:**
- room: Filter by room name
- category: Filter by category
- status: Filter by status
- limit: Max items to return

### inventory_report
Generate summary report of inventory status.

**Returns:**
- Total items by room
- Total items by category
- Status breakdown (pending/keep/donate/discard)
- Processing progress

### start_session
Begin a processing session for tracking work.

**Parameters:**
- room: Optional room focus
- notes: Session notes

### end_session
Complete current session with summary.

**Parameters:**
- notes: Completion notes

## Voice-Driven Inventory Workflow

This skill is optimized for voice-based inventory capture:

1. **User walks through room describing items**
2. **Assistant captures items in real-time**
   - Automatically determines category
   - Records quantity mentioned
   - Adds to appropriate room
3. **Assistant asks clarifying questions as needed**
4. **Items marked as pending for later processing**

## Processing Decision Framework

When helping user decide on items:

### Keep Criteria
- Used in past 6-12 months
- Has clear future use
- Significant sentimental value with display/use plan
- Hard to replace if needed later
- Part of active collection/hobby

### Donate Criteria
- Good condition but not used
- Useful to others
- No clear personal future use
- Duplicates of items you keep

### Discard Criteria
- Broken with no repair plan
- Obsolete/unusable
- Poor condition
- "Just in case" items with no specific scenario
- Papers/documents past retention need

## ADHD-Friendly Patterns

- **Small batch processing**: Process 5-10 items per session
- **Clear categories**: Simple, obvious categorization
- **Visual progress**: Regular summaries showing progress
- **Decision fatigue management**: Suggest breaks, track energy
- **Momentum maintenance**: Celebrate small wins
- **No perfectionism**: Done > perfect organization

## Integration with Task System

The inventory database lives within the INV-2 task directory:
`/Users/admin/tasks/projects/inventory/INV-2_epic_declutter-and-organize-accumulated-items/inventory.db`

Processing sessions and reports should be documented in the task directory for continuity.

## Example Session

```
User: "Let me walk through the office and tell you what's here"
Assistant: *starts_session(room="Office")*
Assistant: "Go ahead, I'm ready to capture items"

User: "There's a pile of cables, maybe 10 or 15 cables of different types"
Assistant: *add_item(name="Cables", room="Office", category="Electronics", quantity=15, notes="Mixed types in pile")*

User: "A bunch of old computer mice, I think 4 or 5"
Assistant: *add_item(name="Computer mice", room="Office", category="Electronics", quantity=5, status="pending")*

User: "Stack of papers and bills, probably 50 sheets"
Assistant: *add_item(name="Papers and bills", room="Office", category="Documents", quantity=50, notes="Need to sort for important docs")*
```

## Database Location

Default path: Task directory within INV-2 epic
Backup: Automatic via git versioning of task directory

## Tools Directory

The `tools/` directory contains:
- `inventory.py` - Main Python script with all database operations
- Database initialization and schema management
- CRUD operations for all tables
- Query and reporting functions
