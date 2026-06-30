DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify(
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);


-- PRACTICE QUESTIONS
/* 
Retrieve the names of all tracks that have more than 1 billion streams.
List all albums along with their respective artists.
Get the total number of comments for tracks where licensed = TRUE.
Find all tracks that belong to the album type single.
Count the total number of tracks by each artist.

*/

SELECT track 
FROM spotify WHERE
stream > 1000000000;

SELECT artist , album 
FROM spotify;


SELECT SUM(comments)
FROM spotify WHERE
licensed = TRUE;


SELECT * FROM spotify 
WHERE album_type = 'single';

SELECT artist , COUNT(*) AS NUMBER_OF_TRACKS
FROM spotify
GROUP BY artist;


/*

PROBLEM SET 2
Calculate the average danceability of tracks in each album.
Find the top 5 tracks with the highest energy values.
List all tracks along with their views and likes where official_video = TRUE.
For each album, calculate the total views of all associated tracks.
Retrieve the track names that have been streamed on Spotify more than YouTube.
*/

SELECT album, AVG(danceability) as Average_Danceability
FROM spotify
GROUP BY album;

SELECT * FROM spotify
ORDER BY energy DESC LIMIT 5;

SELECT track, views, likes FROM spotify  WHERE 
official_video = TRUE;


SELECT album, SUM(views) as Total_Views
FROM spotify GROUP BY album;

SELECT * FROM
(SELECT 
    track,
    COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) as streamed_on_youtube,
    COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) as streamed_on_spotify
FROM spotify
GROUP BY 1) AS t1
WHERE streamed_on_spotify > streamed_on_youtube
AND streamed_on_youtube <> 0;

/*

Find the top 3 most-viewed tracks for each artist using window functions.
Write a query to find tracks where the liveness score is above the average.
Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
Find tracks where the energy-to-liveness ratio is greater than 1.2.
Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

*/


SELECT 
    artist,
    track,
    SUM(views)
FROM spotify
GROUP BY 1, 2
ORDER BY 1, 3 DESC LIMIT 3;

SELECT track FROM spotify 
WHERE liveness > (SELECT AVG(liveness) FROM spotify);



WITH cte
AS
(SELECT
    album,
    MAX(energy) AS highest_energy,
    MIN(energy) AS lowest_energy
FROM spotify
GROUP BY 1
)
SELECT
    album,
    highest_energy - lowest_energy as energy_diff
FROM cte;


SELECT track, energy / liveness as ratio FROM spotify
WHERE liveness <> 0 AND energy/liveness > 1.2;



SELECT
    track,
    views,
    likes,
    SUM(likes) OVER (ORDER BY views) AS cumulative_likes
FROM spotify;

