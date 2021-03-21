# (SPaASM) Asemblery - zadanie 1

## Part 1:
**17. task:** program replaces each occurrence of one word with another (words and file are specified by the user).
Argument -h prints information about the program and how to use it. Then program itself starts.

## Part 2:

**7.** Supports files above 64KB. Program reads input (file) character by character.
**12.** Documentation and comments in code in English.

## Program specification

The maximum length of the filename is 12 characters (including extension).
The maximum length of both strings is 100 characters each.
Any `h` at 83h adress in PSP will triger help function.
Output is placed directly in the console (so if the file is bigger than a console window, some output may not be visible).
All macros are in macros.asm file.

## Test cases
**First - replace with word with the same length**
File `test.txt`
Content: `wertyabwertycdwerty`
Word to replace: `we`
Replacement: `WE`
Output: 
>Enter a file name: test.txt
Enter a word to replace: we
Enter a replacement: WE
WErtyabWErtycdWErty
Program is finished  and file is succesufully closed

**Second - replace with shorter word**
File `test.txt`
Content: `wertyabwertycdwerty`
Word to replace: `werty`
Replacement: `a`
Output: 
>Enter a file name: test.txt
Enter a word to replace: werty
Enter a replacement: a
aabacda
Program is finished  and file is succesufully closed

**Third - replace with longer word**
File `test.txt`
Content: `wertyabwertycdwerty`
Word to replace: `werty`
Replacement: `#qwerty#`
Output: 
>Enter a file name: test.txt
Enter a word to replace: werty
Enter a replacement: #qwerty#
\#qwerty#ab#qwerty#cd#qwerty#
Program is finished  and file is succesufully closed

We can see that program succsesfully replaced word at the start, in the middle and at the end of the file.

**Fourth - try to replace non-existing word**
File `test.txt`
Content: `wertyabwertycdwerty`
Word to replace: `A`
Replacement: `a`
Output: 
>Enter a file name: test.txt
Enter a word to replace: A
Enter a replacement: a
wertyabwertycdwerty
Program is finished  and file is succesufully closed

Nothing changed because there was no match.


**Fifth - use longer file (above 64KB)**
File `test2.txt`
Content: 75KB Lorem Ipsum
Word to replace: `a`
Replacement: `*A*`
Output: 
>Enter a file name: test2.txt
Enter a word to replace: a
Enter a replacement: \*A\*
\//Program replaced every 'a' with '\*A\*', only last rows are visible//
Program is finished  and file is succesufully closed
