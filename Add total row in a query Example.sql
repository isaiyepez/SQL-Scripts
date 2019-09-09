-------------------------WITH GROUP BY---------------------------
SELECT 
	E.Department, 
	E.EmployeeNumber, 
	A.AttendanceMonth, 
	A.NumberAttendance,
	0 as IsNullValue --This column is useful to sort the "Total row" at the end, using the group by
FROM 
	tblEmployee AS E 
JOIN 
	tblAttendance AS A 
on 
	E.EmployeeNumber = A.EmployeeNumber 

UNION

SELECT 
	E.Department, 
	E.EmployeeNumber,
	NULL AS AttendanceMonth,
	SUM(A.NumberAttendance) AS TotalAttendance,
	1 --This will put this select at the bottom of our group
FROM 
	tblEmployee AS E 
JOIN 
	tblAttendance AS A 
on 
	E.EmployeeNumber = A.EmployeeNumber 
GROUP BY
	E.Department, E.EmployeeNumber
ORDER BY 
	Department, EmployeeNumber, IsNullValue, AttendanceMonth --NOTICE: IsNullValue is the third column to sort to put total at the end

