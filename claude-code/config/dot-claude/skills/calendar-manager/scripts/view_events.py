#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "pyobjc-framework-EventKit",
# ]
# ///
"""
View calendar events from macOS Calendar using EventKit.

Usage:
    uv run scripts/view_events.py                    # Today's events
    uv run scripts/view_events.py --days 7           # Next 7 days
    uv run scripts/view_events.py --date 2025-10-22  # Specific date
"""

import argparse
import sys
from datetime import datetime, timedelta
from Foundation import NSDate, NSCalendar
from EventKit import EKEventStore, EKEntityTypeEvent


def request_calendar_access(store: EKEventStore) -> bool:
    """Request access to calendar events."""
    # For macOS 12+, use requestFullAccessToEventsWithCompletion
    # This is a synchronous wrapper
    access_granted = [False]
    error = [None]

    def completion_handler(granted, err):
        access_granted[0] = granted
        error[0] = err

    store.requestFullAccessToEventsWithCompletion_(completion_handler)

    # Wait a bit for the callback (in real use, this would be async)
    import time
    for _ in range(50):  # Wait up to 5 seconds
        if access_granted[0] or error[0]:
            break
        time.sleep(0.1)

    return access_granted[0]


def get_events(start_date: datetime, end_date: datetime) -> list:
    """Fetch events from Calendar."""
    store = EKEventStore.alloc().init()

    # Request access
    if not request_calendar_access(store):
        print("Error: Calendar access denied. Please grant permission in System Settings > Privacy & Security > Calendar", file=sys.stderr)
        return []

    # Convert Python datetime to NSDate
    ns_start = NSDate.dateWithTimeIntervalSince1970_(start_date.timestamp())
    ns_end = NSDate.dateWithTimeIntervalSince1970_(end_date.timestamp())

    # Get calendars
    calendars = store.calendarsForEntityType_(EKEntityTypeEvent)

    # Create predicate
    predicate = store.predicateForEventsWithStartDate_endDate_calendars_(
        ns_start, ns_end, calendars
    )

    # Fetch events
    events = store.eventsMatchingPredicate_(predicate)

    return events


def format_event(event) -> str:
    """Format event for display."""
    start = datetime.fromtimestamp(event.startDate().timeIntervalSince1970())
    end = datetime.fromtimestamp(event.endDate().timeIntervalSince1970())

    lines = [
        f"• {event.title()}",
        f"  {start.strftime('%Y-%m-%d %H:%M')} - {end.strftime('%H:%M')}",
    ]

    if event.location():
        lines.append(f"  📍 {event.location()}")

    if event.notes():
        lines.append(f"  📝 {event.notes()}")

    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description="View calendar events")
    parser.add_argument("--days", type=int, help="Number of days to show (from today)")
    parser.add_argument("--date", help="Specific date (YYYY-MM-DD)")

    args = parser.parse_args()

    # Determine date range
    if args.date:
        try:
            target_date = datetime.strptime(args.date, "%Y-%m-%d")
            start_date = target_date.replace(hour=0, minute=0, second=0)
            end_date = target_date.replace(hour=23, minute=59, second=59)
        except ValueError:
            print(f"Error: Invalid date format: {args.date}", file=sys.stderr)
            return 1
    else:
        days = args.days or 1
        now = datetime.now()
        start_date = now.replace(hour=0, minute=0, second=0)
        end_date = start_date + timedelta(days=days)

    # Get events
    events = get_events(start_date, end_date)

    if not events:
        print(f"No events found between {start_date.strftime('%Y-%m-%d')} and {end_date.strftime('%Y-%m-%d')}")
        return 0

    # Display events
    print(f"\nEvents from {start_date.strftime('%Y-%m-%d')} to {end_date.strftime('%Y-%m-%d')}:")
    print("=" * 60)

    for event in sorted(events, key=lambda e: e.startDate()):
        print(format_event(event))
        print()

    return 0


if __name__ == "__main__":
    sys.exit(main())
