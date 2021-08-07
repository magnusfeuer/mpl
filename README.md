The MPL Languae is aimed to be a configuration and implementation language
to be used in Magdan MPL car dashboard computer.

The language is influenced by VRML and C++ and SmallTalk in a nice mix.

MPL is used to bridge and configure plugin objects impemented in C++/C,
MPL can be used to implement it's own objects.

The MPL is a data/event driven system and there are constucts in MPL
to connect input and output events in a dynamic fashion to construct
complicated setups.

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [TODO FOR NEW LANGUAGE IMPLEMENTATION](#todo-for-new-language-implementation)
- [INSTALL AND RUN](#install-and-run)
- [LANGUAGE DOCUMENTATION (DRAFT)](#language-documentation-draft)
    - [Introduction](#introduction)
    - [Subscriptions [ DELETE THIS? Covered by later chapters? ]](#subscriptions--delete-this-covered-by-later-chapters-)
    - [Scripts [ DELETE THIS? Covered by later chapters? ]](#scripts--delete-this-covered-by-later-chapters-)
    - [Classes [ DELETE THIS? Covered by later chapters? ]](#classes--delete-this-covered-by-later-chapters-)
    - [MPL Language syntax and semantics](#mpl-language-syntax-and-semantics)
        - [Introduction and Purpose](#introduction-and-purpose)
        - [Program layout](#program-layout)
    - [Constants](#constants)
        - [Integer constants](#integer-constants)
        - [Float constants](#float-constants)
        - [String constants](#string-constants)
        - [Char constants](#char-constants)
    - [Basic types](#basic-types)
        - [booleans](#booleans)
        - [unsigned char](#unsigned-char)
        - [char](#char)
        - [int](#int)
        - [unsigned int](#unsigned-int)
        - [float](#float)
        - [string](#string)
    - [Type casting](#type-casting)
        - [`float` to `int`](#float-to-int)
        - [`float` to `string`](#float-to-string)
        - [`float` to `bool`](#float-to-bool)
        - [`int` to `float`](#int-to-float)
        - [`int` to `string`](#int-to-string)
        - [`int` to `bool`](#int-to-bool)
        - [`string` to `int`](#string-to-int)
        - [string to bool](#string-to-bool)
        - [string to float](#string-to-float)
    - [Enumerated types](#enumerated-types)
    - [Constructed types](#constructed-types)
        - [Types](#types)
        - [Constructor and Destructor](#constructor-and-destructor)
        - [Arrays](#arrays)
        - [Expressions](#expressions)
        - [Assignment operators](#assignment-operators)
        - [Arithmetic operators](#arithmetic-operators)
        - [Relational operators](#relational-operators)
        - [Bitwise operators](#bitwise-operators)
        - [Logical operators](#logical-operators)
    - [Deep vs. shallow assignment and compare.](#deep-vs-shallow-assignment-and-compare)
    - [Statements](#statements)
        - [`if` statement](#if-statement)
        - [`switch` statement](#switch-statement)
        - [`foreach` statement](#foreach-statement)
        - [`compound` statements](#compound-statements)
        - [Connection statement](#connection-statement)
    - [Events & scripts](#events--scripts)
        - [Script triggers](#script-triggers)
        - [Script executions](#script-executions)
        - [Builtin system functions](#builtin-system-functions)
        - [Builtin math functions](#builtin-math-functions)
        - [Builtin array functions](#builtin-array-functions)
        - [Builtin string functions](#builtin-string-functions)
        - [Builtin event functions](#builtin-event-functions)
        - [Builtin object functions](#builtin-object-functions)
        - [Persistent declarations](#persistent-declarations)
        - [Builtin types](#builtin-types)
    - [The graphics system](#the-graphics-system)
    - [Debugging MPL code](#debugging-mpl-code)
    - [Writing MPL Classes In C++](#writing-mpl-classes-in-c)
- [TODO:](#todo)
    - [1. Simplify and clarify the assignment semantics](#1-simplify-and-clarify-the-assignment-semantics)
    - [2. Clarify and possibly simplify copy semantics](#2-clarify-and-possibly-simplify-copy-semantics)
    - [3. Declarations vs. definitions](#3-declarations-vs-definitions)
    - [4. Collapse event and regular variables:](#4-collapse-event-and-regular-variables)
    - [5. Clarify and possibly simplify class hierarchy script execution order:](#5-clarify-and-possibly-simplify-class-hierarchy-script-execution-order)
    - [6. Clarify Member variable init sequence](#6-clarify-member-variable-init-sequence)
    - [7. Persistence](#7-persistence)
    - [8. Array events](#8-array-events)
    - [9. Simplify external  type and object references](#9-simplify-external--type-and-object-references)
    - [10. Simplify subclass override](#10-simplify-subclass-override)
    - [11. Replace '@' usage](#11-replace--usage)
    - [12. Constructors](#12-constructors)
    - [13. Break and continue keywords](#13-break-and-continue-keywords)
    - [14. Stopping script execution.](#14-stopping-script-execution)
    - [15. Interval declaration](#15-interval-declaration)
    - [16. Range scaling](#16-range-scaling)
    - [17. Persistent declarations](#17-persistent-declarations)
- [FORMAL LANGUAGE DEFINITION (VERY INCOMPELTE)](#formal-language-definition-very-incompelte)
    - [1. Type declarations](#1-type-declarations)
    - [1.1 Structured type](#11-structured-type)
    - [1.2 Scripting](#12-scripting)

<!-- markdown-toc end -->

# TODO FOR NEW LANGUAGE IMPLEMENTATION

* Complete grammar to parse all examples and, possibly, the code in `.m1` files found in the [M1 App](https://github.com/magnusfeuer/m1_app/)
* Resolve type references through a type manager
* Transform parse tree to python classes representing types, instances, expressions, statements, subscriptions, etc.
* Create code-generating backend. LLVM, C/C++ code, or some magic stuff by [Tony](https://github.com/tonyrog)


# INSTALL AND RUN

pip3 install lark
python3 ./mpl_tool.py ./mpl/t5.mpl

Currently the code is parsed (by lark using `mpl.lark`), and the raw parse tree is dumped out.


# LANGUAGE DOCUMENTATION (DRAFT)

## Introduction

MPL is an event declarative language focused on processing data
streams. The MPL language carries some resemblance with a standard
OOPL, but centers around the concept of data subscription and
events. All code execution (except initialization routines) are bound
to variables being updated, either by internal computations or through
external input.

MPL lends itself very well to graphics and parallel computing.


In the graphics case, 2D and 3D (OpenGL) graphics can be displayed as
a direct function of the executed code. Instead of painting graphics,
the shape/form/animation of the graphics is tied to output data that
generated by the program.

A simple example would be to rotate an image on screen. In a
traditional language (such as java script), a loop going through 360
degrees would be created where each iteration painted the image
rotated to the current angle. Sleep statements would be injected to
control the speed of the rotation.

In MPL , the image object’s angle would subscribe to the output from a
timer going from 0 to 5 seconds. Each update to the timer, occurring
every few milliseconds, will modify the angle of the image, which will
trigger a repaint. A complete 360 degree rotation will take five
seconds. Changing the timer’s duration will change the rotational
speed of the image.

This kind of rotation takes exactly one line of MPL code to implement.

As for parallel execution, the natural fine granularity of an MPL
program lends it very well to execute over multiple cores and nodes
without the usual hassles of threading and distribution. The runtime
system will automatically assign triggered scripts (see below) to
available cores and nodes. Since all triggered scripts can execute in
parallel without interfering with each other, all cores of an SMP
system can be utilized.


C++ classes can be instantiated and inherited by the MPL code,
allowing a program to interface with the outside world. There are a
number of built in C++ classes, and a developer can easily add their
own. There is, from an MPL program’s point of view, no difference
between using a C++ implemented class vs. one written in MPL.

**TODO**: Something about the runtime system. Script vs. byte code.

## Subscriptions [ DELETE THIS? Covered by later chapters? ]

The core concept of a subscription allows a variable to be
continuously assigned the result of an expression. As soon as the
evaluated expression changes, the subscribing variable will be updated
accordingly. A subscription can be made on expressions returning
scalar types as well as objects.

Fig 1 below shows a simple subscription setup.

[**TODO**: Figure 1 showing declaration of x and y, and y subscribing to x * 2.]

By setting up multiple levels of subscriptions, where expressions are
chained together, a cascading effect is achieved where a single
updated root variable will affect multiple subscriptions. Fig 2 shows
an example of a subscription tree.

[**TODO**: Figure 2: Schematics showing the following code.

```
event int root;
event int a1 <- root * 2;
event int a2 <- root * 3;
event int b1 <- a1 / 2;
event int b2 <- a1 * 2;
root = 1;
```
]

## Scripts [ DELETE THIS? Covered by later chapters? ]

A script is a block of code executed when a variable is updated
through a direct assignment or when a subscribed expression changes
its result. In its most basic form a script is triggered by the update
of a variable with no additional conditions, as is shown in fig X.

[**TODO**: Figure X showing script x with a printf.]

Scripts can have a conditional expression associated with it,
filtering the script’s trigger to only when the expression evaluates
true. A simple example of a script triggered only when x is updated
with a value greater than 5 is given in fig X.

[**TODO**: Figure X showing script x when x > 5.]

Multiple scripts can be bound to a single variable, each with or
without conditional expressions. An example of two such script are
given in fig X.

[**TODO**: Figure X showing `script x when x < 5 and script x when x >= 5`.]

And, finally, a script can be bound to a boolean expression of
variables, allowing it to trigger only when the given expression of
variables have been updated. Here as well a conditional expression can
be added as a filgter. Fig X below shows a script triggered only when
both x and y have been updated with new values.

[**TODO**: Figure 5 showing `script x && y`]

A script can defined on a global level for global variables, or inside
classes for object member variables.


## Classes [ DELETE THIS? Covered by later chapters? ]

In this document, the term class and type will be used interchangeably.

Classes in MPL are similar to classes of traditional OOPLs, with
member variables, inheritance, scoping, public/private members,
etc. There are, however, two important exceptions.

1. There are no member functions (and hence no polymorphy)
In fact, there are no functions at all in MPL outside some basic
system-provided functions such as strlen(), sqrt(), etc. Instead all
of a class’ functionality is implemented inside scripts triggered by
updated member variables.

2. Each executed script have a finite execution time
There are no goto statements, or non-deterministic loops. This
guarantees that a single script will always finish in a relative short
time, allowing a high degree of code granularity.

All type names must begin with a capital letter [A-Z]. All global
variables, class members and local variables must start with a lower
case letter [a-z].

**TODO: Introduction of additional high-level concepts.**


## MPL Language syntax and semantics


### Introduction and Purpose

Something about the purpose here.


### Program layout

An MPL file (suffixed .mpl) is divided into three sections:

* declarations
* scripts
* statements1

The declarations section contains type definitions and variable
declarations, given in any order.

The scripts section contains scripts bound to globally declared
variables.

The statement section contains code to execute when the file is loaded
by the runtime system.

A file with MPL code can be either a library or application file. One
or more library files can be used by a single application file.The
only syntactic difference between a library and an application file is
that the former has a top level library body:

```
    library <LibraryName> [<version>] {
       <declarations>
       <scripts>
       <statements>
    }
```
An application file will have the same layout, but without the library body:

```
    <declarations>
    <scripts>
    <statements>
```


## Constants

The syntax of constants loosely follows that of C:

### Integer constants

    1
    -1
    4711

Integers can also be expressed in octal by prefixing the value with the numeral 0:

    010	  (Decimal 8)
    07	  (Decimal 7)
    -010  (Decimal -8)

The valid range for an octal character is 0-7.

Hexadecimal constants are expressed through the ‘0x’ prefix:

    0x10   (Decimal 16)
    0xFEDC (Decimal 65244)
    -0x10  (Decimal -16)

The valid range for a hexadecimal character is 0-9,A-F,a-f


### Float constants

A float constant is expressed by a number of digits followed by a ‘.’ and zero or more decimals.

    1.0
    128.256
    -1234


### String constants
String constants are enclosed within double quotes (“).

    “Hello world”


Two string constants can be concatenated with the plus operator:
“Hello “ + “world!”


### Char constants

Char constants are expressed within single quotes (‘):

‘a’


## Basic types

MPL supports the standard basic types, which includes:


### booleans

Can be assigned ‘true’, ‘false’ or an integer, where 0 signifies false and all other values signifies true


### unsigned char

8 bit unsigned integer that can hold a value int the 0..255 range, or a single ascii character.


### char

8 bit signed integer that can hold a value int the -127..127 range, or a single character.



### int

32 bit signed integer that can hold a value in the -2^31..2^31 range.


### unsigned int

32 bit unsigned integer that can hold a  value in the 0..2^32 range.


### float

32 bit floating point value that can hold a value in the 3.4E–38..3.4E+38 range.


### string

Contains a string of arbitrary length. There are a number of built in
operations for string handling. Two strings can be concatenated using
the ‘+’ operator. Adding an integer or float to a string will add the
ASCII value of the right hand side expression to the string.



## Type casting


### `float` to `int`

Assigning a float directly to an int will truncate the decimals.

    int a = 123.7;  // a will be assigned 123


In order to round a float to the nearest int, use the roundf built in
function:

    int a = roundf(123.7);  // a will be assigned 124.


### `float` to `string`

String conversion of a float is done using the sprintf built in
function.

    string str = sprintf(“f%”, 123.456); // str will be assigned “123.456”


### `float` to `bool`

Assigning a float directly to a bool will set the bool to true for all
non-zero values, and false for the value 0.0.

    bool x = 0.1; // x will be set to true
    bool y = 0.0; // y will be set to false


### `int` to `float`

Assigining an int to a float will convert the value:

    float f = 10; // f will be set to 10.0

### `int` to `string`

String conversion of an int is done using the sprintf built in
function.

    int i = sprintf(“%d”, -4711); // str will be assigned -4711


### `int` to `bool`

Assigning an int directly to a bool will set the bool to true for all
nnon-zero values, and false for the value 0.

    bool x = 4711; // x will be set to true
    bool y = 0; // y will be set to false


### `string` to `int`

A string can be converted to an int through the atoi builtin function.

    int x = atoi(“4711”); // x will be set to 4711

The atou builtin function allows the conversion of a string to an
unsigned integer.


### string to bool

???


### string to float

A string can be converted to a float through the atof builtin function.

    float x = atof(“123.456”); // x will be set to 123.456

**TODO: 64 bit int. double**


## Enumerated types

There is also support for enumerated values like:

    enum Fruit { apple, orange, banana };

Please note that enumerated types do not have an inherent integer
values and cannot be cast to ints. An enum can only be compared with
other enums of the same type.


## Constructed types


### Types

To add a new type then the type construct is used:

```
    type Base {
   	    int a;
        unsigned int b;
        float c;
    };
```

The base type can also be derived by:

```
    type Derived : Base {
        int a;
        float d;
    };
```

The type name MUST start with a upper case alpha [A-Z]. And field
names MUST start with a lower case alpha [a-z].  To use a type before
it's define or if it is a external type then the interface must be
used.

```
    interface type Name {
        ([public] declaration)*
    }

	interface library Name <version> {
        ([public] declaration)*
	}
```

  

### Constructor and Destructor

The type (or library) may declare a construktor and a destrutor like:

```
    type Base {
        script Base {  printf("I am born under punshes\n"); }
        script ~Base { printf("I am dead man\n"); }
    };
```

There is also an implicit constructor part. This is the code following
declarations and scripts. This code will be run after the explictit
constructor. Since the File scope do not have a name it is a nice
feature since it allows file to initialize without refering to names.
Constructors are run from base type to derived types. Destructors are
run the other direction from derived type upto the base.


### Arrays

An array is declared as

    MyType foo[10];

This will declare an array of 10 object referrences to objects of type
MyType. To declare an array that will vary in size you use:

    MyType foo[];

An element can then be acces throgh an index operator [] wher foo[0]
is the first element and so on. To extract a sub array then the
extended index operator is used: foo[0:5] will return a sub array
containing the first 6 element from foo. Some nice features of sub
array indexing:

```
    foo[1:5] + foo[0]    // {foo[1],...,foo[5],foo[0]} rotate left
    foo[5:0]  		 // {foo[5],...,foo[0]} reverse
    foo[0:10:2]   	 // {foo[0],foo[2],...,foo[10]}
```

**TODO**: sub indexing is only possible on RHS but will possible on LHS as well

    foo[0:10:2]  = bar[5:1]

would mean

```
    foo[0] = bar[5],
    foo[2] = bar[4];
    foo[4] = bar[3];
    foo[6] = bar[2];
    foo[8] = bar[1];
    foo[10] = bar[0];
```

It will merge a reverse bar into foo on even indices.

### Expressions

Since in MPL everything is an object all "variables" are fields of
nsomething (e.g file/library/object). This means that in the
expression:

     x = 1;

x must be a field name in some object (also for local scopes).  The
expression syntax follow that of C/C++ with the some important
exceptions.


### Assignment operators

The following operators may be used for assigning values to fields.

    =, *=, /=, %=, +=, -=, <<=, >>=, &=, |=, ^=, ++ and --

They follow the same rules as in C/C++.


### Arithmetic operators

    +, -, *, /, %


### Relational operators

    <, <=, >, >=, ==, !=


### Bitwise operators
    
    &, |, ^, << and >>


### Logical operators

    &&, ||, !


## Deep vs. shallow assignment and compare.

| Operator | Description                                                                                                            |
|----------|------------------------------------------------------------------------------------------------------------------------|
| \:=      | Performs an object (shallow) copy. The content of the RHS is copied to the LHS. In the case LHS is nil LHS is created. |
| =        | Performs a reference copy. The RHS will refer to the same object as LHS.                                               |
| =:=      | Does an object compare to see if the content of the two objects are equal.                                             |
| ==       | Does a reference compare to see if the two variables refer to the same object.                                         |
| =!=      | Does an object compare to see if the content of the two objects are different.                                         |
| !=       | !=	Does a reference compare to see if the two variables refer to different objects.                                 |


**Note:** To get a deep copy of an object the builtin copy must be used.
There is alos a clone function that works much like := in the case
where LHS is nil.


## Statements


### `if` statement

    if (expr) statement [else statement]

### `switch` statement

```
   switch (expr) {
      	declarations*
      	statement*
   }
```

### `foreach` statement


```
   foreach var in '[' <expr> ':' <expr> [':' <expr> ] ']' {
  	 declarations*
  	 statements*
   }

   foreach var in <expr> {
  	 declarations*
  	 statements*
   }
```

loop over arrays, includint sub array indexing.


### `compound` statements

   {

  	declarations*

  	statements

   }


### Connection statement

    target <- source

Connects target event with source event, target event will
automatically be updated when source is updated.

    target <- nil

Can be used to "disconnect" a connection.

The target and source must be of the same type and source must be of
output event type and target must be of input event type (declaring
"event float foo" means that foo can be connected both ways.


## Events & scripts

A fundamental concept in MPL is the event. The event is much like a
connector in circuit. You declare a field as an event field like:

    event signed x;

When a field has been declaraed as an event field, that field may be
used to connect to other fields. Values may be access and assigned as
normal fields. To connect a event field with an other event field
the operator <- is used.

```
    event signed x;
	event signed y;

	x <- y;
```

This means that whatever value that is assigned to y will also be
present in x (in the next cycle)

Below is an example where event field are used to build a trivial
adder:

```
    type MyAdder {
        input event float a;
        input event float b;
        output event float result;

        script {
            result = a + b; 
        }
    };
```

This example show that we define two input events `a` and `b`, and

if any of the event values are changed the script is executed and
a result is feed to the result event field.


```
    type MyExpr {
  	    input event float x;
  	    input event float y;
  	    output event float result;

        private MyAdder a;
  	    private MyAdder b;

        // constructor code
  	    a = MyAdder { a <- x, b <- y };
  	    b = MyAdder { a <- a.result, b <- x };

        result <- b.result
  }
```

This example show how to aggregate instances to a new type,
(Calculating the expression (x+y)+x ). The new type use events both as
connection points but also as an interface. The keyword private can be
used to hide internal and implementation specific parts of the type.

The source to connect may also be an expression of events inputs and
field values:

    x <- (y + 1)*z + a;

Where y and z are event outputs and a is regular field in the current
context.


### Script triggers

A trigger expression is used to activate a script when a condition
occurrs.

    script a || b when a < b {  result = 1 };

This script will run when either input event `a` or `b` are updated and
also `a` is less than `b`. If this condition is false the next script is
tested. All scripts are tested and executed if conditions are true.

The script syntax is:

	script [event-trigger-expression] [when expression] { body }

The event tigger expression is a boolean expression where the
identifiers must be of input event types. All input events
must belong to the current object. 

Trigger expression can not access an other objects inputs, but the
when expression can.  As mention above there are to special script
then constructor and the destructot that triggers on construction and
destruction of the object.

	script <type-id> { body }
	script ~<type-id> { body }


### Script executions

The script are executed from derived types and towards the base type
scripts. A derived type may script a base types event variable to take
action. Of course a base type do not know of a derived types input
events and can not script those. This means that if the derived type
execute on a base types event field the derived type can also updated
base type field that will be examined in the base type when executing
the base type scripts.

```
	type Base {
        event signed x;
        event signed y;

       script x {  printf("Base:x %d\n", x); }
       script y {  printf("Base:y %d\n", y); }

    };

    type Derived : Base {
        event signed z;

        script x { y = 10; printf("Derived:x %d\n", x); }
        script z { printf("Derived:z %d\n", z); }
    };

    Derived a = @Derived {};

    a.x = 17;
```
will print:

```
    Derived:x 17
    Base:x 17
    Base:y 10
```

**TODO Ascending or descending type execution of scripts?**


###  Builtin system functions 

    float now()

Return number of seconds since system start

    unsigned inow()


Return number of milliseconds since system start

    unsigned cycle()

 Return number of cycles since system start

    unsigned random()

 Return a random number in range 0..2^31-1

    float randomf()

Return a random number in range 0..1

    string getenv(string name)

Return environment value for name.

    unsigned reboot(void)

Reboot the machine

    unsigned reload_m1(string file, ...)

Load m1 file

    unsigned reload_lib(string sofile, ...)

Load library file (plugin)


###  Builtin math functions 

    float abs(float x)

Absolute value of a floating point number

    signed abs(signed x)

Absolute value of a signed number

    signed sign(float x)

Return the size of x (-1, 0 or 1)

    signed sign(signed x)

Return the size of x (-1, 0 or 1)

    float trunc(float x)

Truncate the fraction part of a floating point value

    float round(float x)

Nearest integral value

    float ceil(float x)

Smallest integral value greater than or equal to x.

    float floor(float x)

Smallest integral value less than or equal to x.

    float sin(float rad)

Sine of x, measured in radians.

    float cos(float rad)

Cosine of x, measured in radians.

    float pi()

The constant value pi.

    float sqrt(float x)

Return square root of a number

    float dist(float x, float y)

Calculate the "distance" beteen x and y. This is
the function sqrt(x*x + y*y) The length of the hypotenuse in
a right triangle. In the 2D/3D case this can be used
to calculate the distance between points as

    dist(X1-X0, Y1-Y0).


### Builtin array functions

     unsigned int size(T a[])

Return the size of an array,

**Note**: 'vector' cannot be a string. (YET?)

    void rotate(T a[], int shift)

Rotate the array elements to the right or left depending on shift
argument.

If shift is less than zero then the elements are rotated backwards e.g
the element a[1] will be located at a[0] while a[0] will be found at
a[size(a)-1] A positive shift will rotate the other way around, while
a shift of zero will leave it untouned.

   

    void reverse(T a[])

Reverse the elementes in the array.

    void sort(T a[])

Sort the array elements in ascending order.

    void sort(T a[], signed field)

Sort the array elements on specific field index

### Builtin string functions

    unsigned printf(string fmt, ...)

Formatted output on stdout. Format options do generally comply to the
"standard printf" see the man page: Some special features of m1 printf
are:

| Token  | Description                         |
|--------|-------------------------------------|
| %p     | Print the object/term symbolically. |
| %b, %B | print element in binary             |

    string sprintf(string format, ...)

Returns the formatted string given in 'format'.

See `printf(3)` for details.

    unsigned strlen(string)

Return the number of characters in the string.

    string strcat(string a, string b)

**Note**: this will be implement as + soon: `return a + b;`

    string substr(string a, unsigned pos, unsigned length)

Return the string starting at pos and span over length characters. if
length=0 then the rest of string is returned.

    signed strchr(string a, char c)

Return first position where c is located in a.  If c is not found in a
then -1 is returned.

    signed atoi(string a)

Convert digits in a to a signed number.

**TODO:** No real error handling. throw?

    unsigned atou(string a)

Convert digits in a to a unsigned number.

**TODO**: No real error handling. throw?

    float atof(string a)

Convert digits in a to a floating point number.

**TODO**: No real error handling. throw?

### Builtin event functions

    bool updated(event <type> x)

Check if event filed has been updated. When script trigger expression
does not fully solve the problem this function comes in handy.

    string sender(event <type> x)

This is a trace debugger function and may only be used with debug
compiled vm (and debug compiled code) When calling sender in a trigger
script it will tell you where the original event came from. The return
value is on form "file:line" and is normally where the assignment was
done.

### Builtin object functions

    object clone(object x)

Produce a shallow copy of object x.

    object copy(object x)

Produce a deep copy of object x.

### Persistent declarations

### Builtin types

    Timer
    Timeout
    ScalarInterpolator
    More?


## The graphics system

* Layer concept described.
* Children
* Coordinate systems
* Screen vs children
* Semi-formal description
* Layer
* Screen
* Shape
* Text
* Image
* Video
* DDS
* PositionInterpolator
* ColorInterpolator

## Debugging MPL code


## Writing MPL Classes In C++

* Introduction/Concept
* Example code
* Macro descriptions.
* How and when C++ code is executed.
* Using C++ classes in MPL.



# TODO:


## 1. Simplify and clarify the assignment semantics

```
x = 1;
*x = 1; // Remove this.
```

Event variable that are assigned within the script of the object they
are members off will always be triggered. Thus:

```
type MyClass { 
    event int x;

    script x {
        printf(“x = %d\n”, x);
        x++;
    }

    script MyClass {
        x = 1;
    }
}
```

will trigger 'script x' indefinitely.

In order to inhibit the trigger mechanism, the inhibit(x) function can
be used. This will stop x from trigger its subscribers until the next
time x is updated.


## 2. Clarify and possibly simplify copy semantics

The only assignment operator, =, is a reference copy. All other copies
are built in functions:

```
a = b;
a = shallow_copy(b);
a = deep_copy(b);
```

## 3. Declarations vs. definitions

Define library management with separate
declarations/definitions. #include “gui.mph” vs. (compiled) gui.mpl



## 4. Collapse event and regular variables:

```
event int x; // Remove the event keyword.
int y;
```

A regular variable should be updated to an event variable when it is
subscribed to or subscribes to another variable.


## 5. Clarify and possibly simplify class hierarchy script execution order:

```
type BaseClass {
  event int x;
  script x { printf(“Base[%d]\n”, x); }
};

type SubClass: BaseClass {
  script x { printf(“Sub[%d]\n”, x); }
}; 
```

The classes will always execute in a bottom-up order, with SubClass'
script running before that of BaseClass'

_The only exception to this rule are constructor scripts, which are
executed top-down. See chapter 12 for details._

If there is an absolute need for top-down execution of regular
scripts, it should be specified in the event variable declaration:

    event reverse int x;

Should be avoided, if possible.


## 6. Clarify Member variable init sequence

```
type BaseClass {
     int x = 1; // Default value
};

type SubClass: BaseClass {
    int @BaseClass.x = 2; // Subclass override.
    script SubClass {
  x = 4;  // Executed after BaseClasss constructor
     }
}
SubClass obj = @SubClass { x = 3; }; // Init list.
```

The init sequence is:

    int x = 1; // Default value

overidden by:

    int @BaseClass.x = 2; // Subclass override.

overridden by:

    SubClass obj = @SubClass { x = 3; }; // Init list.

overridden by:

```
    script SubClass {
  x = 4;
     }
```



## 7. Persistence

Do we do:

```
float persistent “db.x.y.z” my_float;
```

Or do we externalize persistence as we have it today?




## 8. Array events

```
event int arr[];

// Trigger when one or more elements in the array has been updated

script arr {

    Event int updated_elem[];

    int x;

    // Retrieve all elements that have been triggered.
    // Returns empty array (not nil) if nothing is updated.
    //
    updated_elem = updated(arr);

    for x in updated_elem {
        printf(“%d has been triggered\n”, updated_elem);
     }

    // A more stupid way of doing the same thing.
    for x in [0:size(arr)-1] {
        if (is_updated(arr[x])) // Boolean to check if element is updated.
    printf(“%d has been triggered\n”, updated_elem);
    }
}
```

This script will be triggered by:

    arr[1] = 21;

A script to be invoked when the array itself is reassigned is written
like this:

```
event int arr[];

script arr[] {  // Note the []
    Event int updated_elem[];
    int x;

    // In this case all elements will be marked as updated
    updated_elem = updated(arr);
     for x in updated_elem {
        printf(“%d has been triggered\n”, updated_elem);
    }
}
```

This script will be triggered by:

    arr = { 1,2,3,4};


## 9. Simplify external  type and object references


Today: external class references look like this:

    :Module:ModuleType var = @:Module:ModuleType { };

This can be replaced by a c++-like namespace system where external
modules are just another layer of namespaces.

```
    import “module.mph”
    using namespace Module; // Maybe this???


    Module::ModuleType var = Module::ModuleType 
```

Overall, we use :: to reference external modules and types. Members of
objects are addressed through '.':


```
    import “module.mph”

    // Set a global object in the Module code to something new. See chapter 11 for 
    // details on 'new' 
    Module::module_obj = new Module::ModuleType {};

    // Assign a member of the newly allocated object 
    Module::module_obj.memb = 12; 
```


## 10. Simplify subclass override

Today we have:

```
    type BaseClass {
        int x = 1; // Default value
    };

    type SubClass: BaseClass {
        int @BaseClass.x = 2; // Subclass override.
    }
```

To reference base class members, we simply use the '::' prefix:

```
    type BaseClass {
        int x = 1; // Default value
    };

    type SubClass: BaseClass {
        int ::x = 2; // Override BaseClass init where x is set to 1.
        int x = 2; // Shadows BaseClass.x, with warning?

        script SubClass {
   x = 10; // Set SubClass::x.
   ::x = 12; // Set BaseClass::x. If no shadowing, '::' is not needed.
        }
    }
```



## 11. Replace '@' usage

    MyClass obj = @MyClass {};

is replaced with:

    MyClass obj = new MyClass {};

That gives a clearer semantics and also syncs nicely with the '='
being a reference copy.




## 12. Constructors

Today we have:

```
    type BaseClass {
        int x ;
        script BaseClass {
   x = 0;
        } 
    };

    type SubClass: BaseClass {

        script SubClass {
   x = 1;
        }
    }
```

Since the constructor really isn't a trigger script, we can replace it
with an explicit keyword:

```
    type BaseClass {
        int x ;

        constructor {
   x = 0;
        } 
    };
    
    type SubClass: BaseClass {
        constructor {
   x = 1;
        }
    }
```

The constructors are, unlike trigger scripts, executed top down. In
the example above, x would be set to 1 once the Subclass constructor
has run.


## 13. Break and continue keywords

Break and continue keywords will be reserved for loops:

```
    int array[] = { 1,2,3,4,5 };
    int i;

    foreach i in array {
        if (i == 2)
   continue; // Continue with next element

        if (i == 4)
   break; // Break out of the current loop.

        printf(“%d\n, i);
    }
```

This prints out:

    1
    3


## 14. Stopping script execution.

We reserve break-continue for loops, where they are needed, and
introduce a new keyword to interrupt script execution:

skip – Skip the rest of the current script, continue executing scripts
in self and in parents' classes.

To stop any further scripts in self or parent classes, execute
inhibit(variable) before calling skip.

Below is a code example with both skip scenarios.

```
    type BaseClass {
        event int x;
        script x {
   printf(“BaseClass::x = %d\n”, x);
        } 
    };

    type SubClass: BaseClass {

        script x when x != 100 {
   if (x == 2)
       skip;
   if (x == 3) {
       inhibit(x);
       skip;
   }
   printf(“SubClass[1]::x = %d\n”, x);
        }
        
        script x when x != 200
        {
   printf(“SubClass[2]::x = %d\n”, x);
        }
    };
    BaseClass obj = new BaseClass {};
```

Setting:

    obj.x = 1;

will output:

    SubClass[1]::x = 1
    SubClass[2]::x = 1
    BaseClass::x = 1

Setting

    obj.x = 2;

will output:

    SubClass[2]::x = 1
    BaseClass::x = 1

Setting

    obj.x = 3;

will not output anything.


## 15. Interval declaration

    float(0..10) x

Make sure that the field will be with in the range 0 .. 10

## 16. Range scaling

Rescaleing from event output variables can be done like

    x <- y(10..100)

where x and y are declared as a range event fields.

    event float(3 .. 15) y;
    event float(0..1000) x;

The output range must be with in declared target range
i.e `(10..100)` is with in `(0..1000)`

This is a short hand for writing:

```
    x <- @ScalarInterpolator {
        key={3,15},
        keyValue={10,100},fraction<-y
    }.value;
```
 

## 17. Persistent declarations

To allow for simple persistence the persistent key word is
given to any primitive field.
peristent "com.magden.key1" float x = 10;

This declaration will internally do:

```
  float x;

  Db_float _x_db { key="com.magden.key1" };
```

For dynamic keys then a string variable is used instead of a fixed
key:

    persistent my_key signed x;

When no key is given then the key is generated:

    persistent signed y;

Will generate a key on form

    TypeName:TypeName ... .y

Note that this scheme only works for singletons like global library
  variables etc.
  
-------------------



# FORMAL LANGUAGE DEFINITION (VERY INCOMPELTE)

## 1. Type declarations

To create a new object the type must first be declared as.

```
<type-declarator> ::=
       ['extern'] 'type' <type-name> <declarator> ';'
```
The type name <name> SHOULD be on form U(U|L|D|_-)*.

Example:

```
type Rect { signed x, signed y };

type Colorf float[3];
type Pixel  byte[3];
```
When the type is implement in a plugin or in core then extern keyword
is used before the type.

Example:

```
extern type Screen {};
```
## 1.1 Structured type

To define a "class" in MPL then the type name is followed by 
curly brackets to start a block of field declaraions.

```
<declarator> ::= 
    [':' <parent-type-name>] '{' <field-declaration>* <script-declaration>* '}'

<field-declaration> ::=
    <qualifier>* <type> <field-name> ['*'] [<array-decl>]
     ['=' <default-value> ]

<qualifier> ::= 'public' | 'private' | 'input' | 'output' |
   'extern' | 'persistent'

<parent-name> ::= <type-name>

<type> ::=
    'byte' | 'char' | 'signed' | 'unsigned' | 'float' | 'string' |
    <type-name>

<array-decl> ::= '[' <unsigned> ']' [<array-decl>] | '[' ']'
```

Example:

```
extern class PositionInterpolator {
    input float fraction;
    output Point value;
    float key[];
    Point keyValue[];
}
```

## 1.2 Scripting

When input fields in types are connected to output's from other objects
e.g Timers etc, the object is scheduled to run actions.
To run action on input change then a script is used.
Plugin normally impleted the actions in C++.

```
<script-declaration> ::=
    'script' [<field-name> [',' <field-name>]] ['when' <expr>] '{'
        ( <variable-declaration> ';' ) *
    ( <statement> ';' )*
    '}'

<variable-declaration> ::=
    <type> <variable-name> ['*'] [<array-decl>] ['=' <init-expr> ]

<statement> ::=
    <rexpr> '=' <expr> |
    TO BE CONTINUED
```

Example:

```
type ScalarInterpolator {
    float key[];                   // Key Range
    float keyValue[];              // Value Range
    input  float fraction;
    output float value; 

    script fraction {
       unsigned i = RangeIndex(fraction, key);
       float scale    = 1-(key[i+1]-key[i]);
       value = keyValue[i]+scale*(keyValue[i+1]-keyValue[i]);
    }
}
```








