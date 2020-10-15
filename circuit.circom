include "circuits/comparators.circom"

template CertNumber()
{
	signal private input number;
	signal valid;
	signal old;
	component equal = IsEqual();
	component greater = GreaterEqThan(7);

	var numlist[13];
	var div = 10;
	for (var i=0; i<13; i++) {
		numlist[12-i] = number % div;
		numlist[12-i] = numlist[12-i] \ (div \ 10);
		div *= 10;
	}
	
	var sum = 0;
	var multi;
	for (var i=0; i<12; i++) {
        multi = i % 8 + 2;
		sum += numlist[i] * multi;
	}
	sum = sum % 11;
	sum + numlist[12] --> equal.in[0];
	11 --> equal.in[1]
	equal.out ==> valid;
	
	var year = numlist[0] * 10 + numlist[1];
    if (year > 20) year = 120 - year;
    else year = 20 - year;
	year --> greater.in[0];
	19 --> greater.in[1];
	greater.out ==> old;

	old * valid === 1;
}

component main = CertNumber();
