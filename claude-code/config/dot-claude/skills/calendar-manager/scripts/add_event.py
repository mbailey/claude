#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "icalendar",
# ]
# ///
"""
Add an event to macOS Calendar by creating an ICS file.

Usage:
    uv run scripts/add_event.py "Event Title" "2025-10-22 10:40" "2025-10-22 11:30" \\
        --location "Location" --description "Description" --alarm 15

The script creates an ICS file that can be opened to import into Calendar.
"""

import argparse
import sys
from datetime import datetime, timedelta
from pathlib import Path
from icalendar import Calendar, Event, Alarm


def parse_datetime(dt_str: str) -> datetime:
    """Parse datetime from various formats."""
    formats = [
        "%Y-%m-%d %H:%M",
        "%Y-%m-%d %H:%M:%S",
        "%Y-%m-%d",
        "%m/%d/%Y %H:%M",
        "%m/%d/%Y",
    ]

    for fmt in formats:
        try:
            return datetime.strptime(dt_str, fmt)
        except ValueError:
            continue

    raise ValueError(f"Could not parse datetime: {dt_str}")


def create_calendar_event(
    summary: str,
    start: datetime,
    end: datetime,
    location: str = "",
    description: str = "",
    alarm_minutes: int | None = None,
) -> Calendar:
    """Create an iCalendar event."""
    cal = Calendar()
    cal.add('prodid', '-//Cora Calendar Manager//EN')
    cal.add('version', '2.0')

    event = Event()
    event.add('summary', summary)
    event.add('dtstart', start)
    event.add('dtend', end)

    if location:
        event.add('location', location)

    if description:
        event.add('description', description)

    # Add alarm if requested
    if alarm_minutes is not None:
        alarm = Alarm()
        alarm.add('action', 'DISPLAY')
        alarm.add('description', f'Reminder: {summary}')
        alarm.add('trigger', timedelta(minutes=-alarm_minutes))
        event.add_component(alarm)

    cal.add_component(event)
    return cal


def main():
    parser = argparse.ArgumentParser(
        description="Create a calendar event ICS file for macOS Calendar"
    )
    parser.add_argument("summary", help="Event title/summary")
    parser.add_argument("start", help="Start date/time (YYYY-MM-DD HH:MM)")
    parser.add_argument("end", help="End date/time (YYYY-MM-DD HH:MM)")
    parser.add_argument("--location", default="", help="Event location")
    parser.add_argument("--description", default="", help="Event description")
    parser.add_argument("--alarm", type=int, help="Alarm minutes before event")
    parser.add_argument("--output", help="Output file path (default: ~/event.ics)")

    args = parser.parse_args()

    try:
        start_dt = parse_datetime(args.start)
        end_dt = parse_datetime(args.end)

        if end_dt <= start_dt:
            print("Error: End time must be after start time", file=sys.stderr)
            return 1

        cal = create_calendar_event(
            summary=args.summary,
            start=start_dt,
            end=end_dt,
            location=args.location,
            description=args.description,
            alarm_minutes=args.alarm,
        )

        # Write to file
        output_path = Path(args.output) if args.output else Path.home() / "event.ics"
        output_path.write_bytes(cal.to_ical())

        print(f"✓ Event created: {output_path}")
        print(f"  Title: {args.summary}")
        print(f"  Start: {start_dt.strftime('%Y-%m-%d %H:%M')}")
        print(f"  End: {end_dt.strftime('%Y-%m-%d %H:%M')}")
        if args.location:
            print(f"  Location: {args.location}")
        if args.alarm:
            print(f"  Alarm: {args.alarm} minutes before")
        print(f"\nDouble-click {output_path} to add to Calendar")

        return 0

    except ValueError as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
