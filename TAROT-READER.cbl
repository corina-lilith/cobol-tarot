       IDENTIFICATION DIVISION.
       PROGRAM-ID. TAROT-READER.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TAROT-FILE ASSIGN TO "cards.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT ZODIAC-FILE ASSIGN TO "zodiac.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD TAROT-FILE.
       01 TAROT-RECORD PIC X(500).
       FD ZODIAC-FILE.
       01 ZODIAC-RECORD PIC X(500).

       WORKING-STORAGE SECTION.

       01 WS-STATE.
           05 WS-EOF            PIC X     VALUE "N".
           05 WS-QUIT           PIC X     VALUE "N".
           05 WS-MENU-CHOICE    PIC X.
           05 WS-CARD-COUNT     PIC 9(4)  VALUE 0.
           05 WS-RANDOM         PIC 9(4).
           05 WS-READING-COUNT  PIC 9     VALUE 1.

       01 WS-TAROT-TABLE.
           05 WS-TAROT-ENTRY OCCURS 100 TIMES.
               10 WS-CARD-ID      PIC X(5).
               10 WS-CARD-NAME    PIC X(50).
               10 WS-CARD-MEANING PIC X(400).

       01 WS-ID-FIELD      PIC X(5).
       01 WS-NAME-FIELD    PIC X(50).
       01 WS-MEANING-FIELD PIC X(400).

       01 WS-ZODIAC-STATE.
           05 WS-ZODIAC-EOF PIC X VALUE "N".
           05 WS-FOUND PIC X VALUE "N".
       
       01 WS-ZODIAC-ID-FIELD       PIC X(5).
       01 WS-ZODIAC-NAME-FIELD     PIC X(15).
       01 WS-ZODIAC-ELEMENT-FIELD  PIC X(12).
       01 WS-ZODIAC-DATE-FIELD     PIC X(30).
       01 WS-ZODIAC-TRAITS-FIELD  PIC X(100).
       01 WS-GEMSTONE-FIELD        PIC X(40).

       01 WS-USER-ZODIAC PIC X(12).

       PROCEDURE DIVISION.
           PERFORM LOAD-DECK
           PERFORM MENU-LOOP UNTIL WS-QUIT = "Y"
           STOP RUN.

       MENU-LOOP.
           PERFORM SHOW-MENU
           PERFORM PROCESS-MENU-CHOICE.

       SHOW-MENU.
           DISPLAY " "
           DISPLAY "=== Tarot Reader ==="
           DISPLAY "1) Card of the Day"
           DISPLAY "2) 3-Card Reading (Past / Present / Future)"
           DISPLAY "6) Enter zodiac to reveal gemstone"
           DISPLAY "7) Quit"
           DISPLAY "Enter your choice: "
           ACCEPT WS-MENU-CHOICE.

       PROCESS-MENU-CHOICE.
           EVALUATE WS-MENU-CHOICE
               WHEN "1"
                   PERFORM CARD-OF-THE-DAY
               WHEN "2"
                   PERFORM NEW-READING
               WHEN "6"
                   PERFORM REVEAL-GEMSTONE
               WHEN "7"
                   MOVE "Y" TO WS-QUIT
                   DISPLAY "Goodbye!"
               WHEN OTHER
                   DISPLAY "Invalid option. Use numbers 1, 2, 6, or 7."
           END-EVALUATE.

       LOAD-DECK.
           OPEN INPUT TAROT-FILE
           PERFORM UNTIL WS-EOF = "Y"
               READ TAROT-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       ADD 1 TO WS-CARD-COUNT
                       UNSTRING TAROT-RECORD
                           DELIMITED BY "|"
                           INTO WS-ID-FIELD
                                WS-NAME-FIELD
                                WS-MEANING-FIELD
                       MOVE WS-ID-FIELD
                           TO WS-CARD-ID (WS-CARD-COUNT)
                       MOVE WS-NAME-FIELD
                           TO WS-CARD-NAME (WS-CARD-COUNT)
                       MOVE WS-MEANING-FIELD
                           TO WS-CARD-MEANING (WS-CARD-COUNT)
               END-READ
           END-PERFORM
           CLOSE TAROT-FILE.

       REVEAL-GEMSTONE.
           DISPLAY " "
           DISPLAY "Enter your zodiac sign (e.g Virgo): "
           ACCEPT WS-USER-ZODIAC

           MOVE "N" TO WS-ZODIAC-EOF
           MOVE "N" TO WS-FOUND

           OPEN INPUT ZODIAC-FILE

           PERFORM UNTIL WS-ZODIAC-EOF = "Y" OR WS-FOUND = "Y"
               READ ZODIAC-FILE
                   AT END
                       MOVE "Y" TO WS-ZODIAC-EOF
                   NOT AT END
                       UNSTRING ZODIAC-RECORD
                           DELIMITED BY "|"
                           INTO WS-ZODIAC-ID-FIELD
                                WS-ZODIAC-NAME-FIELD
                                WS-ZODIAC-ELEMENT-FIELD
                                WS-ZODIAC-DATE-FIELD
                                WS-ZODIAC-TRAITS-FIELD
                                WS-GEMSTONE-FIELD

                       IF WS-ZODIAC-NAME-FIELD = WS-USER-ZODIAC
                           DISPLAY " "
                           DISPLAY "Your gemstone for "
                               WS-ZODIAC-NAME-FIELD "is:"
                           DISPLAY WS-GEMSTONE-FIELD
                           MOVE "Y" TO WS-FOUND
                       END-IF
               END-READ
           END-PERFORM

           CLOSE ZODIAC-FILE

           IF WS-FOUND = "N"
               DISPLAY " "
               DISPLAY "Sorry, I couldn't find that zodiac sign."
               DISPLAY "Please try again (e.g., Capricorn)."
           END-IF

           DISPLAY "-------------------"
           DISPLAY "Press Enter to return to the menu."
           ACCEPT WS-MENU-CHOICE.

       CARD-OF-THE-DAY.
           DISPLAY " "
           DISPLAY "Your Card of the Day"
           DISPLAY "-------------------"
           PERFORM DRAW-ONE-CARD

           DISPLAY "-------------------"
           DISPLAY "Press Enter to return to the menu."
           ACCEPT WS-MENU-CHOICE.

       DISPLAY-READING-LABEL.
           EVALUATE WS-READING-COUNT
               WHEN 1
                   DISPLAY "Past:"
               WHEN 2
                   DISPLAY "Present:"
               WHEN 3
                   DISPLAY "Future:"
           END-EVALUATE.

       DRAW-ONE-CARD.
           COMPUTE WS-RANDOM = FUNCTION RANDOM * WS-CARD-COUNT + 1

           DISPLAY WS-CARD-NAME (WS-RANDOM)
           DISPLAY WS-CARD-MEANING (WS-RANDOM)
           DISPLAY " ".

       NEW-READING.
           DISPLAY " "
           DISPLAY "Your Past, Present, and Future reading"
           DISPLAY "-------------------"

           MOVE 1 TO WS-READING-COUNT

           PERFORM NEW-READING-LOOP
               UNTIL WS-READING-COUNT > 3.

           DISPLAY "-------------------"
           DISPLAY "Press Enter to return to the menu."
           ACCEPT WS-MENU-CHOICE.

       NEW-READING-LOOP.
           PERFORM DISPLAY-READING-LABEL
           PERFORM DRAW-ONE-CARD
           ADD 1 TO WS-READING-COUNT.
