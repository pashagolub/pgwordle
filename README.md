# pgwordle

This is the repo with source code for my talk "Customizing the Wordle Game"

## Use

### Docker Compose
* Clone the repo and cd into the folder
* `docker compose up -d --force-recreate`
* `docker compose exec postgres psql -U postgres`
* Have fun!

### Custom environment
* Download scripts or clone the repo.
* Execute the `bootstrap.sql` in the target database.
* Put these lines into your `.psqlrc` and then use `:wordle` command to play the game:

```
\echo Use ":wordle" to begin the game!
\set wordle '\\i ~/start.psql'
```

Change the path according to your situation, if home dir doesn't work for you.
