PROGRAM day9
	IMPLICIT NONE

	INTEGER, DIMENSION(100,100) :: map
	INTEGER :: i,j,k,x,y,tmp,this,lower,basin,w = 100, h = 100

	INTEGER :: part1 = 0
	INTEGER, DIMENSION(4) :: dx = [-1, 0, 1, 0], dy = [0, -1, 0, 1]

	INTEGER :: part21, part22, part23
	INTEGER :: basin_count = 0
	INTEGER, DIMENSION(250) :: basin_x, basin_y
	INTEGER :: queue_start, queue_end
	INTEGER, DIMENSION(500) :: queue_x, queue_y

	OPEN(unit=11, file="input", status="old") 
	DO i=1,h,1
		!		    vvv This needs to change to 100 for full input
		READ(unit=11, fmt="(100I1)") map(1:w,i)
	END DO
	CLOSE(11)

! ----------------- PART ONE ---------------------------------

	DO j = 1, h, 1
		DO i = 1, w, 1
			
			lower = 1
			DO k=1, 4, 1
				x = i + dx(k)
				y = j + dy(k)
				IF ((x == 0) .OR. (x == (w + 1)) .OR. (y == 0) .OR. (y == (h + 1))) THEN
					tmp = 10
				ELSE
					tmp = map(x,y)
				ENDIF

				IF (map(i,j) .GE. tmp) THEN
					lower = 0
				ENDIF
			END DO

			IF (lower == 1) THEN
				part1 = part1 + 1 + map(i,j)
				basin_count = basin_count + 1
				basin_x(basin_count) = i
				basin_y(basin_count) = j
			ENDIF
		END DO
	END DO
	
	PRINT *, part1

! ----------------- PART TWO ---------------------------------

	DO basin = 1, basin_count, 1
		queue_start=1
		queue_x(queue_start) = basin_x(basin)
		queue_y(queue_start) = basin_y(basin)
		queue_end=2


		DO WHILE ((queue_start /= queue_end) .AND. (queue_end .LT. 500))
			DO k=1,4,1
				x = queue_x(queue_start) + dx(k)
				y = queue_y(queue_start) + dy(k)

				IF ((x == 0) .OR. (x == (w + 1)) .OR. (y == 0) .OR. (y == (h + 1))) THEN
					tmp = 9
				ELSE
					tmp = map(x,y)
				ENDIF

				IF (tmp /= 9) THEN

					lower = 1

					DO i=1,queue_end,1
						IF ((x == queue_x(i)) .AND. (y == queue_y(i))) THEN
							lower = 0
						ENDIF
					END DO

					IF (lower == 1) THEN
						queue_x(queue_end) = x
						queue_y(queue_end) = y
						queue_end = queue_end + 1
					ENDIF
				ENDIF
			END DO
			queue_start = queue_start + 1

		END DO
		queue_end = queue_end - 1
	       
		IF (queue_end .GT. part21) THEN
			part23 = part22
			part22 = part21
			part21 = queue_end
		ELSE IF (queue_end .GT. part22) THEN
			part23 = part22
			part22 = queue_end
		ELSE IF (queue_end .GT. part23) THEN
			part23 = queue_end
		ENDIF
	END DO

	PRINT *, (part21 * part22 * part23)

END PROGRAM day9

