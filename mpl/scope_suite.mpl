int n = 5;

type A {
    int a = 6;
	
    type B {
	int b = 11;

	script B { 
	    printf("%d\n", b + a);		// INTE ok (a ligger inte i r�tt scope)
	    printf("%d\n",	b + n);		// OK n �r i library scope / global
	}
    };
};

A:B ab = @A:B { b = 7 };

.M1.halt = 2;
