psql --username "postgres" <<-EOSQL
    CREATE TABLE en_us(word text);

    COPY en_us FROM PROGRAM
    'grep --only-matching --extended-regexp "^\b\w+\b" \
    `pg_config --sharedir`/tsearch_data/en_us.dict | sort -u'
    WITH (HEADER on);

    CREATE TABLE fr(word text);

    COPY fr FROM PROGRAM
    'grep --only-matching --extended-regexp "^\b\w+\b" \
    `pg_config --sharedir`/tsearch_data/fr.dict | sort -u'
    WITH (HEADER on);


    CREATE TABLE nl(word text);

    COPY nl FROM PROGRAM
    'grep --only-matching --extended-regexp "^\b\w+\b" \
    `pg_config --sharedir`/tsearch_data/nl.dict | sort -u'
    WITH (HEADER on);

    CREATE TABLE it(word text);

    COPY it FROM PROGRAM
    'grep --only-matching --extended-regexp "^\b\w+\b" \
    `pg_config --sharedir`/tsearch_data/it_it.dict | sort -u'
    WITH (HEADER on);

    CREATE TABLE uk_ua(word text);

    COPY uk_ua FROM PROGRAM
    'grep --only-matching --extended-regexp "^\b\w+\b" \
    `pg_config --sharedir`/tsearch_data/uk_ua.dict | sort -u'
    WITH (HEADER on);

    CREATE TABLE de_ch(word text);

    COPY de_ch FROM PROGRAM
    'grep --only-matching --extended-regexp "^\b\w+\b" \
    `pg_config --sharedir`/tsearch_data/de_ch.dict | sort -u'
    WITH (HEADER on);

EOSQL