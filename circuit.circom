include "circuits/comparators.circom"  //템플릿 사용

template CertNumber()  // 만들 템플릿 선언
{
	signal private input number;     		// input signal 선언
	signal valid; 							// 중간 signal 선언
	signal old;   							// 
	component equal = IsEqual();  			// include 템플릿 사용
	component greater = GreaterEqThan(7);	// bit수 n = 7

	var numlist[13];	// 배열 변수 선언 가능
	var div = 10;
	for (var i=0; i<13; i++) {	// for문 사용 가능
		numlist[12-i] = number % div;
		numlist[12-i] = numlist[12-i] \ (div \ 10);  // 일반적인 나눗셈이 /이 아니라 \임을 주의
		div *= 10;
	}
	
	var sum = 0;
	var multi;
	for (var i=0; i<12; i++) {		// 주민등록번호 유효성 
        multi = i % 8 + 2;			// 검사 알고리즘
		sum += numlist[i] * multi;
	}
	sum = sum % 11;
	sum + numlist[12] --> equal.in[0];  // '-->' : 제약 조건을 생성하지 않고 단순 대입 
	11 --> equal.in[1]					// component를 사용할 때 반드시 입력을 다 준 후 출력 가능
	equal.out ==> valid;				// '==>' : 제약조건과 대입을 동시에 수행함
	
	var year = numlist[0] * 10 + numlist[1];  // 나이 판단 알고리즘
    if (year > 20) year = 120 - year;
    else year = 20 - year;
	year --> greater.in[0];		// year == 19?
	19 --> greater.in[1];		// 마찬가지 두 개의 입력 후
	greater.out ==> old;		// 출력을 signal에 저장 가능

	old * valid === 1;			// '===' : 좌우변이 같아야할 제약 조건 생성
								// 반드시 곱셈꼴로 나타내야함
}

component main = CertNumber();  // 메인 컴포넌트로 선언
