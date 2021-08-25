create table movies.Credits(
   cast text,
   crew text,
   id int
);


create table movies.Keywords(
   id int,
   keywords text
);

create table movies.Links(
   movieId int,
   imdbId int,
   tmdbId int
);

create table movies.Ratings(
   userId int,
   movieId int,
   rating varchar(10),
   timestamp int
);

create table movies.Movies_Metadata(
   adult varchar(10),
   belongs_to_collection varchar(190),
   budget int,
   genres varchar(270),
   homepage varchar(250),
   id int,
   imdb_id varchar(10),
   original_language varchar(10),
   original_title varchar(110),
   overview varchar(1000),
   popularity varchar(10),
   poster_path varchar(40),
   production_companies varchar(1260),
   production_countries varchar(1040),
   release_date date,
   revenue int,
   runtime varchar(10),
   spoken_languages varchar(770),
   status varchar(20),
   tagline varchar(300),
   title varchar(110),
   video varchar(10),
   vote_average varchar(10),
   vote_count int
);
/*φορτονουμε τα δεδομένα στην βάση μας*/
\copy movies.movies_metadata FROM 'C:/Users/johnm/OneDrive/DBProject/movies_metadata.csv' DELIMITER ',' CSV HEADER;
\copy movies.keywords FROM 'C:/Users/johnm/OneDrive/DBProject/keywords.csv' DELIMITER ',' CSV HEADER;
\copy movies.links FROM 'C:/Users/johnm/OneDrive/DBProject/links.csv' DELIMITER ',' CSV HEADER;
\copy movies.credits FROM 'C:/Users/johnm/OneDrive/DBProject/credits.csv' DELIMITER ',' CSV HEADER;
\copy movies.ratings FROM 'C:/Users/johnm/OneDrive/DBProject/ratings_small.csv' DELIMITER ',' CSV HEADER;

/*primary keys στους πίνακες*/
ALTER TABLE movies.movies_metadata
ADD PRIMARY KEY (id);

ALTER TABLE movies.keywords
ADD PRIMARY KEY (id);

ALTER TABLE movies.credits
ADD PRIMARY KEY (id);

ALTER TABLE movies.links
ADD PRIMARY KEY (movieid);

ALTER TABLE movies.ratings
ADD CONSTRAINT PK_Ratings PRIMARY KEY (userid,movieid);


/*διαγραφή διπλότυπων στον movies_metadata*/
CREATE TABLE movies.movies_metadatanoduplicates as(SELECT *,
         ROW_NUMBER() OVER( PARTITION BY id
        ORDER BY  id ) AS row_num from movies.movies_metadata)

delete from movies.movies_metadatanoduplicates 
where row_num>1

ALTER TABLE movies.movies_metadatanoduplicates
DROP COLUMN row_num;

ALTER TABLE movies.movies_metadatanoduplicates
RENAME TO movies_metadata;



/*διαγραφή διπλότυπων στον keywords*/
CREATE TABLE movies.keywordsnoduplicates as(SELECT *,
         ROW_NUMBER() OVER( PARTITION BY id
        ORDER BY  id ) AS row_num from movies.keywords)

delete from movies.keywordsnoduplicates 
where row_num>1

ALTER TABLE movies.keywordsnoduplicates
DROP COLUMN row_num;

ALTER TABLE movies.keywordsnoduplicates
RENAME TO keywords;


/*διαγραφή διπλότυπων στον credits*/
CREATE TABLE movies.creditsnoduplicates as(SELECT *,
         ROW_NUMBER() OVER( PARTITION BY id
        ORDER BY  id ) AS row_num from movies.credits)

delete from movies.creditsnoduplicates 
where row_num>1

ALTER TABLE movies.creditsnoduplicates
DROP COLUMN row_num;

ALTER TABLE movies.creditsnoduplicates
RENAME TO credits;

/*διαγραφη διπλότυπων στον πίνακα links αλλα αυτά που έχουν λανθασμένο imdbid-παραπομπη στο report.pdf*/
delete 
from movies.links
where imdbid in(select imdbid from(select tmdbid,imdbid
from movies.links
where tmdbid in(select tmdbid from movies.links group by tmdbid
having count(*)>1)) as foo
left outer join(SELECT id,split_part(imdb_id, 'tt', 2)::integer
from movies.movies_metadata) as movies_metadata
on movies_metadata.split_part=foo.imdbid
where id is null)


/*διαγραφη null τιμές*/
delete from movies.links
where tmdbid is null


/*διαγραφη tmdbid που δεν υπάρχουν στο id*/	
delete from movies.links
where tmdbid not in(select id from movies.movies_metadata)




/*διαγραφή movieid που δεν υπάρχουν στον πίνακα links therefore και id στον movies_metadata*/
delete from movies.ratings
where movieid not in(select movieid from movies.links)



/*foreign keys στους πίνακες*/
ALTER TABLE movies.keywords
ADD FOREIGN KEY (id) REFERENCES movies.movies_metadata(id);

ALTER TABLE movies.credits
ADD FOREIGN KEY (id) REFERENCES movies.movies_metadata(id);

ALTER TABLE movies.links
ADD FOREIGN KEY (tmdbid) REFERENCES movies.movies_metadata(id);


ALTER TABLE movies.ratings
ADD FOREIGN KEY (movieid) REFERENCES movies.links(movieid);
	 





