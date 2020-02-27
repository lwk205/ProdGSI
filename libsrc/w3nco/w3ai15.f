      SUBROUTINE  W3AI15 (NBUFA,NBUFB,N1,N2,MINUS)
C$$$  SUBROUTINE DOCUMENTATION BLOCK CCC
C
C SUBR: W3AI15   - CONVERT INTEGERS TO ACSII (ALTERNATE TO ENCODE)
C   AUTHOR: ALLARD, R.         ORG: W342          DATE: JANUARY, 1974
C
C ABSTRACT: CONVERTS A SET OF BINARY NUMBERS TO AN EQUIVALENT SET
C   OF ASCII NUMBER FIELDS IN CORE.  THIS IS AN ALTERNATE PROCEDURE
C   TO THE USE OF THE 360/195 VERSION OF ENCODE.
C
C PROGRAM HISTORY LOG:
C   74-01-15  R.ALLARD
C   89-02-06  R.E.JONES   CHANGE FROM ASSEMBLER TO FORTRAN
C                         THIS SUBROUTINE SHOULD BE REWRITTEN IM
C                         INTEL 8088 ASSEMBLY LANGUAGE
C   90-08-13  R.E.JONES   CHANGE TO CRAY CFT77 FORTRAN
C   12-11-05  B. VUONG    CHANGE VARIABLE ZERO FILL FOR LITTLE-ENDIAN
C
C USAGE: CALL W3AI15 (NBUFA,NBUFB,N1,N2,MINUS)
C
C   INPUT:
C     'NBUFA' - INPUT ARRAY (INTEGER*4)
C     '   N1' - NUMBER OF INTEGERS IN NBUFA TO BE CONVERTED
C     '   N2' - DESIRED CHARACTER WIDTH OF ASCII NUMBER FIELD
C     'MINUS' - CHARACTER TO BE INSERTED IN THE HIGH ORDER POSITION
C               OF A NEGATIVE NUMBER FIELD
C   OUTPUT:
C     'NBUFB' - OUTPUT ARRAY (INTEGER*4)
C
C   EXIT STATES: NONE
C
C   EXTERNAL REFERENCES: NONE
C
C ATTRIBUTES:
C   LANGUAGE: CRAY CFT77 FORTRAN
C   MACHINE:  CRAY Y-MP8/832
C
C$$$
C
C NOTE 1. - IF N2 IS GREATER THAN 4, ALLOW TWO WORDS (EIGHT CHARACTERS)
C     IN THE NBUFB ARRAY FOR EACH ASCII NUMBER FIELD.  A NUMBER FIELD
C     IS LEFT ADJUSTED WITH BLANK FILL TO THE RIGHT IF NEEDED.
C     LIKEWISE, IF N2 IS LESS THAN 4, THE RESULT IS LEFT ADJUSTED
C     WITH BLANK FILL TO THE RIGHT.
C
C NOTE 2. - N2 CAN BE SPECIFIED IN THE RANGE 1-8.  AN EIGHT DIGIT POSI-
C     TIVE INTEGER CAN BE CONVERTED OR A SEVEN DIGIT NEGATIVE INTEGER
C     AND A SIGN.  ZERO FILL IS USED FOR HIGH ORDER POSITIONS IN A
C     NUMBER FIELD.  THE USER SHOULD BE AWARE THAT W3AI15 DOES NOT
C     VERIFY THAT THE VALUE OF N2 IS IN THE CORRECT RANGE.
C
C NOTE 3. - THE MINUS SIGN CAN BE INSERTED AS A LITERAL IN THE CALL
C     SEQUENCE OR DEFINED IN A DATA STATEMENT.  1H- AND 1H+ ARE THE
C     TWO MOST LIKELY NEGATIVE SIGNS.  UNFORTUNATELY THE ASCII PLUS
C     CHARACTER IS THE NEGATIVE SIGN REQUIRED IN MOST TRANSMISSIONS.
C     THE MINUS SIGN WILL ALWAYS BE IN THE HIGH ORDER POSITION OF A
C     NEGATIVE NUMBER FIELD.
C
C NOTE 4. - IF A NUMBER CONTAINS MORE DIGITS THAN THE N2 SPECIFICATION
C     ALLOWS, THE EXCESS HIGH ORDER DIGITS ARE LOST.
C
      INTEGER     ATEMP
      INTEGER     BTEMP
      INTEGER     IDIV(8)
      INTEGER     NBUFA(*)
      INTEGER     NBUFB(*)
      INTEGER*8     ZERO(8)
C
      CHARACTER*1 BLANK
      CHARACTER*1 JTEMP(8)
      CHARACTER*1 MINUS
      CHARACTER*1 NUM(0:9)
C
      LOGICAL     ISIGN
C
      EQUIVALENCE (BTEMP,JTEMP(1))
C
      DATA  BLANK /' '/
      DATA  IDIV  /1,10,100,1000,10000,100000,1000000,10000000/
      DATA  NUM   /'0','1','2','3','4','5','6','7','8','9'/
C     FOR LITTLE_ENDIAN
      DATA  ZERO  /X'2020202020202030',X'2020202020203030',
     &             X'2020202020303030',X'2020202030303030',
     &             X'2020203030303030',X'2020303030303030',
     &             X'2030303030303030',X'3030303030303030'/

C     FOR BIG_ENDIAN
c     DATA  ZERO  /X'3020202020202020',X'3030202020202020',
c    &             X'3030302020202020',X'3030303020202020',
c    &             X'3030303030202020',X'3030303030302020',
c    &             X'3030303030303020',X'3030303030303030'/
C
      DO 100 I = 1,N1
        IF (NBUFA(I).EQ.0) THEN
            NBUFB(I) = ZERO(N2)
            GO TO 100
        ENDIF
          ATEMP = NBUFA(I)
          ISIGN = .FALSE.
          IF (ATEMP.LT.0) THEN
            ISIGN = .TRUE.
            ATEMP = IABS(ATEMP)
          ENDIF
          IF (.NOT.ISIGN) THEN
          DO 10 J = 1,8
            IF (J.LE.N2) THEN
              I1 = MOD(ATEMP/IDIV(N2-J+1),10)
              JTEMP(J) = NUM(I1)
            ELSE
              JTEMP(J) = BLANK
            ENDIF
   10     CONTINUE

          ELSE

          JTEMP(1) = MINUS
          DO 20 J = 2,8
            IF (J.LE.N2) THEN
              I1 = MOD(ATEMP/IDIV(N2-J+1),10)
              JTEMP(J) = NUM(I1)
            ELSE
              JTEMP(J) = BLANK
            ENDIF
   20     CONTINUE
          ENDIF
C
        NBUFB(I) = BTEMP
C
  100 CONTINUE
        RETURN
        END

