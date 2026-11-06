-- Source of truth for the local database (SQLite). Drift tables mirror this in Phase 3.
-- Deleting rows here NEVER touches files on disk; file deletion is a separate,
-- explicitly confirmed code path.
PRAGMA foreign_keys = ON;

CREATE TABLE library_roots (
  id INTEGER PRIMARY KEY,
  uri TEXT NOT NULL UNIQUE,            -- Windows: path; Android: SAF tree URI
  display_name TEXT NOT NULL,
  auto_scan INTEGER NOT NULL DEFAULT 1,
  last_scan_at INTEGER
);

CREATE TABLE series (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT,
  type TEXT NOT NULL DEFAULT 'unknown' CHECK (type IN ('manga','manhwa','manhua','unknown')),
  is_favourite INTEGER NOT NULL DEFAULT 0,
  is_completed INTEGER NOT NULL DEFAULT 0,
  cover_comic_id INTEGER,
  manual_override INTEGER NOT NULL DEFAULT 0,  -- user corrected grouping; scanner must not undo it
  created_at INTEGER NOT NULL
);
CREATE INDEX idx_series_title ON series(title COLLATE NOCASE);

CREATE TABLE comics (
  id INTEGER PRIMARY KEY,
  series_id INTEGER REFERENCES series(id) ON DELETE SET NULL,
  root_id INTEGER REFERENCES library_roots(id) ON DELETE SET NULL,
  uri TEXT NOT NULL UNIQUE,
  file_name TEXT NOT NULL,
  format TEXT NOT NULL CHECK (format IN ('cbz','zip','cbr','cb7','pdf','folder','image')),
  size_bytes INTEGER NOT NULL,
  content_hash TEXT,                   -- partial hash (size + head/tail blocks) for duplicate detection
  chapter_number REAL,
  chapter_title TEXT,
  page_count INTEGER,
  cover_cache_path TEXT,
  added_at INTEGER NOT NULL,
  missing INTEGER NOT NULL DEFAULT 0   -- file vanished; keep progress, flag in UI
);
CREATE INDEX idx_comics_series ON comics(series_id, chapter_number);
CREATE INDEX idx_comics_hash ON comics(content_hash);
CREATE INDEX idx_comics_added ON comics(added_at);

CREATE TABLE reading_progress (
  comic_id INTEGER PRIMARY KEY REFERENCES comics(id) ON DELETE CASCADE,
  page_index INTEGER NOT NULL DEFAULT 0,
  scroll_offset REAL NOT NULL DEFAULT 0,   -- exact vertical position within the page
  percent REAL NOT NULL DEFAULT 0,
  completed INTEGER NOT NULL DEFAULT 0,
  last_read_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);
CREATE INDEX idx_progress_last_read ON reading_progress(last_read_at);

CREATE TABLE bookmarks (
  id INTEGER PRIMARY KEY,
  comic_id INTEGER NOT NULL REFERENCES comics(id) ON DELETE CASCADE,
  page_index INTEGER NOT NULL,
  scroll_offset REAL NOT NULL DEFAULT 0,
  note TEXT,
  created_at INTEGER NOT NULL
);
CREATE INDEX idx_bookmarks_comic ON bookmarks(comic_id);

CREATE TABLE collections (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL
);
CREATE TABLE collection_series (
  collection_id INTEGER NOT NULL REFERENCES collections(id) ON DELETE CASCADE,
  series_id INTEGER NOT NULL REFERENCES series(id) ON DELETE CASCADE,
  PRIMARY KEY (collection_id, series_id)
);

CREATE TABLE settings (key TEXT PRIMARY KEY, value TEXT NOT NULL);

-- Per-series reader overrides (direction, zoom, image adjustments); NULL = use global default.
CREATE TABLE reader_overrides (
  series_id INTEGER PRIMARY KEY REFERENCES series(id) ON DELETE CASCADE,
  direction TEXT, zoom_mode TEXT,
  brightness REAL, contrast REAL, saturation REAL, invert INTEGER
);
