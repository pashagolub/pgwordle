# pgwordle

This is the repo with source code for my talk "Customizing the Wordle Game"

## Use
* Download scripts or clone the repo.
* Execute the `bootstrap.sql`.
* Put these lines into your `.psqlrc` and then use `:wordle` command to play the game:

```
\echo Use ":wordle" to begin the game!
\set wordle '\\i /home/pasha/start.psql'
```

Change the path according to your situation.
