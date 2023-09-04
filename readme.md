# BinCompare

Console app to compare two files in binary mode.

## Syntax
`bincompare <file1> <file2>`

Both parameters are required. For files with spaces use quoting.

## Output
During the comparison a progress indicator is shown, when the file size of both files is the same.

### Sample output

1. Different file size:
	```
	Files differ in size
	00:00:00.0001253
	```

2. Equal file size and equal content:
	```
	Comparing           |#########################################################################################| 100/100
	File size: 1335
	Files are identical
	00:00:00.0005004 (3 Mbytes/s)
	```

3. Equal file size, but differing content:
	```
	Comparing           |#########################################################################################| 100/100
	File size: 1335
	Files are different
	00:00:00.0004631 (3 Mbytes/s)
	```

### Error handling
In the following <file1> and <file2> refer to the actual commandline parameters.
1. Missing parameter(s):
	```
	Not enough parameters
	Syntax: bincompare <file1> <file2>
	```
	
2. First file missing:
	```
	Problem opening file: "<file1>"
	00:00:00.0002607
	```

3. Second file missing:
	```
	Problem opening file: "<file2>"
	00:00:00.0002607
	```
