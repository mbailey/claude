---
name: calendar-manager
description: Manage macOS Calendar events - add, view, and edit calendar events. Use when users ask to add appointments, check their schedule, view upcoming events, or manage calendar entries.
---

# Calendar Manager

## Overview

Manage macOS Calendar events through Python scripts that create ICS files and interact with EventKit. Supports adding events with alarms, viewing upcoming events, and checking schedules.

## Core Capabilities

### 1. Adding Events

Use `scripts/add_event.py` to create calendar events. The script generates an ICS file that can be imported into Calendar.

**Basic usage:**
```bash
uv run scripts/add_event.py "Event Title" "2025-10-22 10:40" "2025-10-22 11:30"
```

**With location and alarm:**
```bash
uv run scripts/add_event.py "Ultrasound Appointment" "2025-10-22 10:40" "2025-10-22 11:30" \
    --location "Doncaster-Templestowe, 2-4 George Street" \
    --description "Arrive by 10:25 AM" \
    --alarm 15 \
    --output ~/ultrasound.ics
```

**Parameters:**
- `summary`: Event title (required)
- `start`: Start date/time in format "YYYY-MM-DD HH:MM" (required)
- `end`: End date/time in format "YYYY-MM-DD HH:MM" (required)
- `--location`: Event location (optional)
- `--description`: Event description/notes (optional)
- `--alarm`: Alarm in minutes before event (optional)
- `--output`: Output file path (default: ~/event.ics)

**Supported date formats:**
- `YYYY-MM-DD HH:MM` (recommended)
- `YYYY-MM-DD HH:MM:SS`
- `YYYY-MM-DD` (for all-day events, set same time for start/end)
- `MM/DD/YYYY HH:MM`
- `MM/DD/YYYY`

**After creating the event:**
The script outputs the path to the ICS file. To add it to Calendar, either:
1. Use `open ~/event.ics` to automatically import
2. Tell the user to double-click the file

### 2. Viewing Events

Use `scripts/view_events.py` to view calendar events using EventKit.

**View today's events:**
```bash
uv run scripts/view_events.py
```

**View next 7 days:**
```bash
uv run scripts/view_events.py --days 7
```

**View specific date:**
```bash
uv run scripts/view_events.py --date 2025-10-22
```

**Note about permissions:**
The first time this script runs, macOS will prompt for Calendar access permission. If access is denied, instruct the user to:
1. Open System Settings
2. Go to Privacy & Security → Calendar
3. Enable access for Terminal or the application running the script

**Output format:**
Events are displayed with:
- Event title
- Start and end times
- Location (if present)
- Notes/description (if present)

### 3. Editing Events

To edit an existing event:
1. Use `view_events.py` to find the event
2. Create a new event with `add_event.py` with the updated details
3. Instruct the user to delete the old event and import the new one

Future enhancement: Add a dedicated edit script using EventKit to modify events in place.

## Workflow Examples

### Adding an appointment from a task
When a user has an appointment in a task and wants to add it to their calendar:

1. Get task details using taskmaster tools
2. Extract: title, date, time, location, description
3. Run `add_event.py` with the extracted information
4. Open the generated ICS file with `open ~/event.ics`

### Checking today's schedule
When a user asks "What's on today?" or "What's my schedule?":

1. Run `view_events.py` without arguments
2. Format and present the events to the user
3. If using voice mode, speak the summary

### Finding a specific appointment
When a user asks about a specific appointment:

1. Use `view_events.py --days 30` for a wider search
2. Search output for the appointment details
3. Present the relevant information

## Technical Notes

### Dependencies
- **icalendar**: For creating ICS files (add_event.py)
- **pyobjc-framework-EventKit**: For reading Calendar events (view_events.py)

All dependencies are declared in PEP 723 inline script metadata and automatically installed by `uv run`.

### Why ICS files for adding events?

AppleScript support for Calendar is unreliable in recent macOS versions. Creating ICS files is:
- More reliable across macOS versions
- Doesn't require special permissions initially
- Can be easily inspected before import
- Works with any calendar application

### EventKit for viewing

EventKit provides reliable read access to calendar events but requires:
- Calendar permission grant (one-time)
- PyObjC framework
- More complex code structure

For read-only operations, this complexity is justified by the reliability.

## Future Enhancements

1. **Edit events in place** - Use EventKit to modify existing events
2. **Delete events** - Add script to remove events by title/date
3. **Recurring events** - Support RRULE for repeating events
4. **Multiple calendars** - Support targeting specific calendars
5. **Event search** - Find events by keyword across date ranges
6. **Batch operations** - Add multiple events from a file
