/*Αριθμός ταινιών ανά χρόνο*/
select date_part('year',release_date) as year,count(id)
from movies.movies_metadata
group by year
order by year





/*Αριθμός ταινιών ανά είδος(genre)*/

UPDATE movies.table_test
set genres=replace(genres, '''', '"')/*η και replace(genres,E'\'', E'\"')*/


SELECT y.x->'name' "name",COUNT(id) as number_of_movies
FROM movies.movies_metadata
CROSS JOIN LATERAL (SELECT jsonb_array_elements(movies.movies_metadata.genres::jsonb) x) y
GROUP BY y.x


/*Σε αυτο το κομμάτι εξηγούμε το query που χρησιμοποιήσαμε για να χρησιμοποιήσουμε το genre στο ερώτημα*/
/*Θα μπορούσαμε να φτιάξουμε πίνακες σαν την 5η εργασία με το amenities αλλα,παρατηρήσαμε οτι η μορφή των δεδομένων
που είχε το genre εμοιαζε πολύ σε τύπου json δεδομένα,επεργαστήκαμε λοιπόν τα δεδομένα αυτά απλά αλλάζοντας τα single quotes
σε double quotes και είναι έτοιμα να γίνουν cast σε json/jsonb

Cross Join->παράγει ένα σύνολο απο αποτελέσματα 'οπου είναι ο αριθμός των γραμμών του πρώτου πίνακας πολλαπλασιαμένος
με τις γραμμέςτου δεύτερου πίνακα δηλαδη καρτεσιανό γινόμενο αν δεν χρησιμοποιηθεί where

Lateral->ενα καινούριο εργαλείο της postgreSQL,είναι σαν ένα foreach loop της sql όπου η postgreSQL θα κανει iterate κάθε γραμμή
σε ένα σύνολο αποτελεσμάτων και θα αξολογεί ενα subquery χρησιμοποιώντας την γραμμή ως παράμετρο

jsonb_array_elements->παίρνουμε την κάθε τιμή απο ένα json value array*/ 




/*Αριθμός ταινιών ανά είδος(genre) και ανά χρόνο*/
SELECT y.x->'name' "name",date_part('year',release_date) as year,COUNT(id) as number_of_movies
FROM movies.movies_metadata
CROSS JOIN LATERAL (SELECT jsonb_array_elements(movies.movies_metadata.genres::jsonb) x) y
GROUP BY y.x,year

/*Μέση βαθμολογία (rating) ανά είδος (ταινίας)*/
SELECT y.x->'name' "name",CAST(AVG(rating::float) AS DECIMAL(10,1)) as Average
FROM movies.movies_metadata
CROSS JOIN LATERAL (SELECT jsonb_array_elements(movies.movies_metadata.genres::jsonb) x) y
inner join movies.links
on movies.links.tmdbid=movies.movies_metadata.id
inner join movies.ratings
on movies.links.movieid=movies.ratings.movieid															 
GROUP BY y.x

/*Αριθμός από ratings ανά χρήστη*/
select userid,count(*) as number_of_ratings
from movies.ratings
group by userid
order by userid


/*Μέση βαθμολογία (rating) ανά χρήστη*/
select userid,CAST(AVG(rating::float) AS DECIMAL(10,1)) as Average 
from movies.ratings
group by userid

/*να δημιουργήσετε ένα view table και αποθηκεύστε για κάθε χρήστη τον αριθμό των ratings
που έχει κάνει καθώς και τη μέση βαθμολογία που έχει βάλει*/
CREATE VIEW view_table AS
select userid,count(*) as number_of_ratings,CAST(AVG(rating::float) AS DECIMAL(10,1)) as Average
from movies.ratings
group by userid
order by userid
/*To insight που μπορουμε να παρουμε ειναι τι κριτής είναι,δηλαδή πόσο υψηλά η χαμηλά βαθμολογεί,ποσο αυξάνεται η μέση βαθμολογία ανάλογα με τον αριθμό των κριτικών*/










				 
					 

	
	
	
	
	














