       IDENTIFICATION DIVISION.
       PROGRAM-ID. TAROT-READER.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TAROT-FILE ASSIGN TO "cards.dat"
               ORGANISATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD TAROT-FILE.
       01 TAROT-RECORD PIC X(500).

       WORKING-STORAGE SECTION.

       77 WS-EOF PIC X VALUE "N".
       77 WS-CARD-COUNT PIC 9(4) VALUE 0.
       77 WS-RANDOM PIC 9(4).

       01 WS-TAROT-TABLE.
           05 WS-TAROT-ENTRY OCCURS 100 TIMES.
               10 WS-CARD-ID PIC X(5).
               10 WS-CARD-NAME PIC X(50).
               10 WS-CARD-MEANING PIC X(400).
       
       01 WS-ID-FIELD PIC X(5).
       01 WS-NAME-FIELD PIC X(50).
       01 WS-MEANING-FIELD PIC X(400).



       PROCEDURE DIVISION.

       PERFORM LOAD-DECK
       PERFORM CARD-OF-THE-DAY

       STOP RUN.


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

           CARD-OF-THE-DAY.
               COMPUTE WS-RANDOM = FUNCTION RANDOM * WS-CARD-COUNT + 1

               DISPLAY " "
               DISPLAY "Your Card of the Day "
               DISPLAY WS-CARD-NAME (WS-RANDOM)
               DISPLAY WS-CARD-MEANING (WS-RANDOM)
               DISPLAY " ".
