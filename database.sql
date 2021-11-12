--
-- File generated with SQLiteStudio v3.3.3 on Fri Nov 12 17:26:55 2021
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: meta
CREATE TABLE meta (
    meta_id    INTEGER       PRIMARY KEY AUTOINCREMENT,
    meta_key   VARCHAR (200),
    meta_value VARCHAR (200)
);


-- Table: show
CREATE TABLE show (
    show_id            INTEGER       PRIMARY KEY AUTOINCREMENT,
    date               STRING,
    venue              VARCHAR (500),
    city               VARCHAR (500),
    state              VARCHAR (100),
    date_last_modified INTEGER       DEFAULT (datetime('now') ),
    artist             VARCHAR (50)
);


-- Table: show_song
CREATE TABLE show_song (
    show_song_id       INTEGER       PRIMARY KEY AUTOINCREMENT,
    show_id            INTEGER       REFERENCES show (show_id),
    song_id            INTEGER       REFERENCES song (song_id),
    track_number       DECIMAL,
    date_last_modified INTEGER       DEFAULT (datetime('now') ),
    modifier           VARCHAR (200)
);


-- Table: song
CREATE TABLE song (
    song_id            INTEGER       PRIMARY KEY AUTOINCREMENT,
    title              VARCHAR (500),
    date_last_modified INTEGER       DEFAULT (datetime('now') )
);


-- Trigger: SHOW_SONG_update_date_last_modified
CREATE TRIGGER SHOW_SONG_update_date_last_modified
         AFTER UPDATE OF show_id,
                         song_id,
                         track_number,
                         modifier
            ON show_song
      FOR EACH ROW
BEGIN
    UPDATE show
       SET date_last_modified = datetime('now')
     WHERE show_song_id = NEW.show_song_id;
END;


-- Trigger: SHOW_update_date_last_modified
CREATE TRIGGER SHOW_update_date_last_modified
         AFTER UPDATE OF date,
                         venue,
                         city,
                         state,
                         artist
            ON show
      FOR EACH ROW
BEGIN
    UPDATE show
       SET date_last_modified = datetime('now')
     WHERE show_id = NEW.show_id;
END;


-- Trigger: SONG_update_date_last_modified
CREATE TRIGGER SONG_update_date_last_modified
         AFTER UPDATE OF title
            ON song
      FOR EACH ROW
BEGIN
    UPDATE song
       SET date_last_modified = datetime('now')
     WHERE song_id = OLD.song_id;
END;


-- View: database_last_modified
CREATE VIEW database_last_modified AS
    SELECT MAX(date)
      FROM (
               SELECT MAX(date_last_modified) AS date
                 FROM song
               UNION ALL
               SELECT MAX(date_last_modified) AS date
                 FROM show
               UNION ALL
               SELECT MAX(date_last_modified) AS date
                 FROM show_song
           );


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;



--
-- File generated with SQLiteStudio v3.3.3 on Sat Oct 30 19:29:53 2021
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: meta
CREATE TABLE meta (
    meta_id    INTEGER       PRIMARY KEY AUTOINCREMENT,
    meta_key   VARCHAR (200),
    meta_value VARCHAR (200)
);

INSERT INTO meta (
                     meta_id,
                     meta_key,
                     meta_value
                 )
                 VALUES (
                     1,
                     'schema_version',
                     '1.0.0'
                 );

INSERT INTO meta (
                     meta_id,
                     meta_key,
                     meta_value
                 )
                 VALUES (
                     2,
                     'database_repo',
                     'https://github.com/Syco54645/TagBot.Database'
                 );




COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
