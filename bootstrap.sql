-- word sets. Make sure you have installed/downloaded proper *.dict files (see slides)
CREATE TABLE pg_keywords AS select word from pg_get_keywords();

CREATE TABLE en_us(word text);

COPY en_us FROM PROGRAM
'grep --only-matching --extended-regexp "^\b\w+\b" \
`pg_config --sharedir`/tsearch_data/en_us.dict | sort -u'
WITH (HEADER on);


-- standard wordle distance function
CREATE FUNCTION wordle_std(word TEXT, guess TEXT)
RETURNS TABLE (distance integer, descriptin text)
AS 
$$
WITH chars AS (SELECT 
string_to_table(guess, null) AS g, 
string_to_table(word, NULL) AS w
)
SELECT 2*char_length(word) - sum(CASE
    	WHEN g=w THEN 2
    	WHEN strpos(word, g) > 0 THEN 1
    	ELSE 0
END),
 string_agg(CASE
    WHEN g=w THEN '🟩'
    WHEN strpos(word, g) > 0 THEN '🟨'
    ELSE '⬛'
END, null)
FROM chars
$$
LANGUAGE SQL;

-- fuzzy distance function
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;

CREATE OR REPLACE FUNCTION wordle_fuzzy(word TEXT, guess text) 
RETURNS TABLE (distance integer, descriptin text)
AS $$
	SELECT 4 - difference(word, guess) + levenshtein(metaphone(word,5), metaphone(guess,5)) + levenshtein(word, guess),
	format('soundex diff: %s, metaphone diff: %s, levenshtein diff: %s', 
		4 - difference(word, guess), 
		levenshtein(metaphone(word,5), metaphone(guess,5)), 
		levenshtein(word, guess))
$$
LANGUAGE SQL;

-- digrams distance function
CREATE OR REPLACE FUNCTION get_ngrams(word text, n integer) RETURNS SETOF text
AS $$
	SELECT substr(repeat(' ', n -1 ) || word || repeat(' ', n -1 ), g.i, n)
	FROM generate_series(1, char_length(word)+n-1) g(i);
$$
LANGUAGE SQL;


CREATE OR REPLACE FUNCTION wordle_digrams(word TEXT, guess text) 
RETURNS TABLE (distance integer, descriptin text)
AS $$
	SELECT char_length(word)+2-1 - count(*), array_agg(trim(g)) 
	FROM get_ngrams(word, 2) g(g) JOIN get_ngrams(guess, 2) w(w) ON g=w;
$$
LANGUAGE SQL;