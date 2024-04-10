#!/bin/bash

files=$(find data/*)
echo '================================================================================'
echo 'load denormalized'
echo '================================================================================'
for file in $files; do
	echo "$file"
	# unzip -p "$file" | sed 's/\\u0000//g'| psql postgresql://postgres:pass@localhost:1366/postgres -c "COPY tweets_jsonb (data) FROM STDIN CSV QUOTE e'\x01' DELIMITER e'\x02';"
done

echo '================================================================================'
echo 'load pg_normalized'
echo '================================================================================'
for file in $files; do
    python3 load_tweets.py --db=postgresql://postgres:pass@localhost:1367 --inputs "$file"
done

echo '================================================================================'
echo 'load pg_normalized_batch'
echo '================================================================================'
for file in $files; do
    python3 -u load_tweets_batch.py --db=postgresql://postgres:pass@localhost:1368/ --inputs $file
done
