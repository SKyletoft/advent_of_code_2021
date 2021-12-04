HELLO
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77 NUM_1 PIC 9(4).
       77 NUM_2 PIC 9(4).
       77 NUM_3 PIC 9(4).
       PROCEDURE DIVISION.
           DISPLAY "Hello, World!".

           ACCEPT NUM_1.
           DISPLAY NUM_1.

           STOP RUN.
