# cobol-tarot
Converted from an old Python project, this COBOL Tarot Reader is run in the terminal. Selecting different options allows the user to draw tarot cards from a file and obtain their readings, get their star sign, and the next moon phase.

## Option 1
Input 1 on your keyboard to show "Card of the Day". This function picks a random card for the user to read.

## Option 2
Input 2 on your keyboard to show three card that inform the user of their past, present, and future cards. This function builds upon the single random card and draws three random cards.

## Option 3
Input 3 on your keyboard to return the history of the user's readings by using memory. It will only remember the readings from that particular session. Once they quit, the memory is wiped.

## Option 4
Input 4 and then the current date to find out the current moon phase.

## Option 5
Input 5 then your date of birth to receive your star sign, the associated element, and the attributes.

## Option 6
Input 6 then your star sign to find out your gemstone.

## Option 7
Input 7 on your keyboard to quit the terminal app and close everything down. You will need to follow the directions "To Run" to spin it up again.




# To Compile:
cobc -x TAROT-READER.cbl

# To Run:
./TAROT-READER


# NOTES

Zodiac date ranges were initially stored as a single string (e.g. "November 22 - December 21"). These were split into separate start and end fields in MMDD numeric format to allow the program to compare a user's date of birth against each range.

When December rolls around, the month number resets downward, so DDMM ranges can end up backwards numerically.

Start: 2211, End: 2112, Birthday: 0112
Is 0112 between 2211 and 2112? ❌ Mathematically, 2112 is less than 2211, so the range is broken.