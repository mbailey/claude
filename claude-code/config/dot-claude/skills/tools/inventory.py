#!/usr/bin/env python3
"""
Personal inventory management system with SQLite backend.
Supports decluttering workflows with room, category, and item tracking.
"""

import sqlite3
import json
from datetime import datetime
from pathlib import Path
from typing import Optional, List, Dict, Any

# Default database location
DEFAULT_DB_PATH = Path.home() / "tasks/projects/inventory/INV-2_epic_declutter-and-organize-accumulated-items/inventory.db"

class InventoryDB:
    def __init__(self, db_path: str = None):
        self.db_path = db_path or str(DEFAULT_DB_PATH)
        Path(self.db_path).parent.mkdir(parents=True, exist_ok=True)
        self.conn = None
        self.init_db()

    def init_db(self):
        """Initialize database connection and create schema if needed."""
        self.conn = sqlite3.connect(self.db_path)
        self.conn.row_factory = sqlite3.Row
        self._create_schema()

    def _create_schema(self):
        """Create database schema."""
        cursor = self.conn.cursor()

        # Rooms table
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS rooms (
            room_id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE,
            description TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        ''')

        # Categories table with hierarchy support
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS categories (
            category_id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE,
            parent_category_id INTEGER,
            description TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (parent_category_id) REFERENCES categories(category_id)
        )
        ''')

        # Items table
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS items (
            item_id INTEGER PRIMARY KEY AUTOINCREMENT,
            room_id INTEGER,
            category_id INTEGER,
            name TEXT NOT NULL,
            description TEXT,
            quantity INTEGER DEFAULT 1,
            status TEXT DEFAULT 'pending' CHECK(status IN ('pending', 'keep', 'donate', 'discard', 'processed')),
            notes TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (room_id) REFERENCES rooms(room_id),
            FOREIGN KEY (category_id) REFERENCES categories(category_id)
        )
        ''')

        # Processing sessions table
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS sessions (
            session_id INTEGER PRIMARY KEY AUTOINCREMENT,
            room_id INTEGER,
            start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            end_time TIMESTAMP,
            items_processed INTEGER DEFAULT 0,
            notes TEXT,
            FOREIGN KEY (room_id) REFERENCES rooms(room_id)
        )
        ''')

        self.conn.commit()

    def add_room(self, name: str, description: str = None) -> int:
        """Add a room to the inventory."""
        cursor = self.conn.cursor()
        cursor.execute(
            'INSERT INTO rooms (name, description) VALUES (?, ?)',
            (name, description)
        )
        self.conn.commit()
        return cursor.lastrowid

    def add_category(self, name: str, parent_category: str = None, description: str = None) -> int:
        """Add an item category."""
        cursor = self.conn.cursor()
        parent_id = None

        if parent_category:
            cursor.execute('SELECT category_id FROM categories WHERE name = ?', (parent_category,))
            result = cursor.fetchone()
            if result:
                parent_id = result[0]

        cursor.execute(
            'INSERT INTO categories (name, parent_category_id, description) VALUES (?, ?, ?)',
            (name, parent_id, description)
        )
        self.conn.commit()
        return cursor.lastrowid

    def add_item(
        self,
        name: str,
        room: str,
        category: str,
        quantity: int = 1,
        description: str = None,
        status: str = 'pending',
        notes: str = None
    ) -> int:
        """Add an item to the inventory."""
        cursor = self.conn.cursor()

        # Get or create room
        cursor.execute('SELECT room_id FROM rooms WHERE name = ?', (room,))
        room_result = cursor.fetchone()
        if room_result:
            room_id = room_result[0]
        else:
            room_id = self.add_room(room)

        # Get or create category
        cursor.execute('SELECT category_id FROM categories WHERE name = ?', (category,))
        cat_result = cursor.fetchone()
        if cat_result:
            category_id = cat_result[0]
        else:
            category_id = self.add_category(category)

        # Insert item
        cursor.execute('''
            INSERT INTO items (room_id, category_id, name, description, quantity, status, notes)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', (room_id, category_id, name, description, quantity, status, notes))

        self.conn.commit()
        return cursor.lastrowid

    def update_item_status(self, item_id: int, status: str, notes: str = None):
        """Update item processing status."""
        cursor = self.conn.cursor()
        update_parts = ['status = ?', 'updated_at = CURRENT_TIMESTAMP']
        params = [status]

        if notes:
            update_parts.append('notes = ?')
            params.append(notes)

        params.append(item_id)
        cursor.execute(
            f'UPDATE items SET {", ".join(update_parts)} WHERE item_id = ?',
            params
        )
        self.conn.commit()

    def list_rooms(self) -> List[Dict]:
        """List all rooms with item counts."""
        cursor = self.conn.cursor()
        cursor.execute('''
            SELECT r.room_id, r.name, r.description, COUNT(i.item_id) as item_count
            FROM rooms r
            LEFT JOIN items i ON r.room_id = i.room_id
            GROUP BY r.room_id, r.name, r.description
            ORDER BY r.name
        ''')
        return [dict(row) for row in cursor.fetchall()]

    def list_categories(self) -> List[Dict]:
        """List all categories with item counts."""
        cursor = self.conn.cursor()
        cursor.execute('''
            SELECT c.category_id, c.name, c.parent_category_id, c.description,
                   COUNT(i.item_id) as item_count
            FROM categories c
            LEFT JOIN items i ON c.category_id = i.category_id
            GROUP BY c.category_id, c.name, c.parent_category_id, c.description
            ORDER BY c.name
        ''')
        return [dict(row) for row in cursor.fetchall()]

    def list_items(
        self,
        room: str = None,
        category: str = None,
        status: str = None,
        limit: int = None
    ) -> List[Dict]:
        """List items with optional filtering."""
        cursor = self.conn.cursor()

        query = '''
            SELECT i.item_id, i.name, i.description, i.quantity, i.status, i.notes,
                   r.name as room, c.name as category, i.created_at, i.updated_at
            FROM items i
            LEFT JOIN rooms r ON i.room_id = r.room_id
            LEFT JOIN categories c ON i.category_id = c.category_id
            WHERE 1=1
        '''
        params = []

        if room:
            query += ' AND r.name = ?'
            params.append(room)

        if category:
            query += ' AND c.name = ?'
            params.append(category)

        if status:
            query += ' AND i.status = ?'
            params.append(status)

        query += ' ORDER BY i.created_at DESC'

        if limit:
            query += ' LIMIT ?'
            params.append(limit)

        cursor.execute(query, params)
        return [dict(row) for row in cursor.fetchall()]

    def inventory_report(self) -> Dict[str, Any]:
        """Generate comprehensive inventory report."""
        cursor = self.conn.cursor()

        # Total items by room
        cursor.execute('''
            SELECT r.name, COUNT(i.item_id) as count, SUM(i.quantity) as total_quantity
            FROM rooms r
            LEFT JOIN items i ON r.room_id = i.room_id
            GROUP BY r.name
            ORDER BY count DESC
        ''')
        by_room = [dict(row) for row in cursor.fetchall()]

        # Total items by category
        cursor.execute('''
            SELECT c.name, COUNT(i.item_id) as count, SUM(i.quantity) as total_quantity
            FROM categories c
            LEFT JOIN items i ON c.category_id = i.category_id
            GROUP BY c.name
            ORDER BY count DESC
        ''')
        by_category = [dict(row) for row in cursor.fetchall()]

        # Status breakdown
        cursor.execute('''
            SELECT status, COUNT(*) as count, SUM(quantity) as total_quantity
            FROM items
            GROUP BY status
            ORDER BY count DESC
        ''')
        by_status = [dict(row) for row in cursor.fetchall()]

        # Overall stats
        cursor.execute('SELECT COUNT(*) as total_items, SUM(quantity) as total_quantity FROM items')
        overall = dict(cursor.fetchone())

        cursor.execute('SELECT COUNT(*) as total_rooms FROM rooms')
        overall['total_rooms'] = cursor.fetchone()[0]

        cursor.execute('SELECT COUNT(*) as total_categories FROM categories')
        overall['total_categories'] = cursor.fetchone()[0]

        return {
            'overall': overall,
            'by_room': by_room,
            'by_category': by_category,
            'by_status': by_status
        }

    def start_session(self, room: str = None, notes: str = None) -> int:
        """Start a processing session."""
        cursor = self.conn.cursor()
        room_id = None

        if room:
            cursor.execute('SELECT room_id FROM rooms WHERE name = ?', (room,))
            result = cursor.fetchone()
            if result:
                room_id = result[0]

        cursor.execute(
            'INSERT INTO sessions (room_id, notes) VALUES (?, ?)',
            (room_id, notes)
        )
        self.conn.commit()
        return cursor.lastrowid

    def end_session(self, session_id: int, notes: str = None):
        """End a processing session."""
        cursor = self.conn.cursor()
        cursor.execute('''
            UPDATE sessions
            SET end_time = CURRENT_TIMESTAMP, notes = COALESCE(?, notes)
            WHERE session_id = ?
        ''', (notes, session_id))
        self.conn.commit()

    def get_current_session(self) -> Optional[Dict]:
        """Get currently active session (no end_time)."""
        cursor = self.conn.cursor()
        cursor.execute('''
            SELECT s.session_id, s.room_id, r.name as room, s.start_time, s.notes
            FROM sessions s
            LEFT JOIN rooms r ON s.room_id = r.room_id
            WHERE s.end_time IS NULL
            ORDER BY s.start_time DESC
            LIMIT 1
        ''')
        result = cursor.fetchone()
        return dict(result) if result else None

    def close(self):
        """Close database connection."""
        if self.conn:
            self.conn.close()


def main():
    """CLI interface for inventory management."""
    import sys

    if len(sys.argv) < 2:
        print("Usage: inventory.py <command> [args]")
        print("Commands: init, add-room, add-category, add-item, list-rooms, list-items, report")
        sys.exit(1)

    db = InventoryDB()
    command = sys.argv[1]

    if command == "init":
        print(f"Database initialized at: {db.db_path}")

    elif command == "add-room":
        if len(sys.argv) < 3:
            print("Usage: inventory.py add-room <name> [description]")
            sys.exit(1)
        name = sys.argv[2]
        description = sys.argv[3] if len(sys.argv) > 3 else None
        room_id = db.add_room(name, description)
        print(f"Added room: {name} (ID: {room_id})")

    elif command == "list-rooms":
        rooms = db.list_rooms()
        for room in rooms:
            print(f"{room['name']}: {room['item_count']} items")
            if room['description']:
                print(f"  {room['description']}")

    elif command == "list-items":
        items = db.list_items(limit=50)
        for item in items:
            print(f"{item['name']} ({item['quantity']}x) - {item['room']} / {item['category']} - {item['status']}")

    elif command == "report":
        report = db.inventory_report()
        print("\n=== INVENTORY REPORT ===\n")
        print(f"Total Items: {report['overall']['total_items']} ({report['overall']['total_quantity']} units)")
        print(f"Total Rooms: {report['overall']['total_rooms']}")
        print(f"Total Categories: {report['overall']['total_categories']}")

        print("\n--- By Status ---")
        for stat in report['by_status']:
            print(f"{stat['status']}: {stat['count']} items ({stat['total_quantity']} units)")

        print("\n--- By Room ---")
        for room in report['by_room'][:10]:
            if room['count'] > 0:
                print(f"{room['name']}: {room['count']} items ({room['total_quantity']} units)")

        print("\n--- By Category ---")
        for cat in report['by_category'][:10]:
            if cat['count'] > 0:
                print(f"{cat['name']}: {cat['count']} items ({cat['total_quantity']} units)")

    db.close()


if __name__ == '__main__':
    main()
