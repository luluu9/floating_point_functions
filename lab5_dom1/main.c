#include <stdio.h>

float avg_harm(float* arr, unsigned int n);
float exp_sum(float x); // calculates 1 + x/1 + x^2/1*2 + x^3/1*2*3 + ... up to x^19

void sum_vectors(float*, float*, float*);
void int2float(int* integer, float* floatpoint);

float exp_sum_c(float x) {
	float result = 1;
	int denominator = 1;
	float x_i = 1;
	for (int i = 1; i < 20; i++) {
		x_i *= x; // x_i = x^1, x^2...
		denominator *= i; // denominator = 1, 1*2, 1*2*3...
		float division = x_i / denominator;
		result += division;
		printf("%f\n", result);
	}
	return result;
}

int main() {
	float arr[] = { 1.5, 2.0, 3.5 };
	float x;
	x = avg_harm(arr, 3);
	printf("Harmonic mean of arr is %f\n", x);

	x = exp_sum(3.0);
	printf("Exponential sum is %f\n", x);

	char numbers_A[16] = { -128, -127, -126, -125, -124, -123, -122, -121, 120, 121, 122, 123, 124, 125, 126, 127 };
	char numbers_B[16] = { -3, -3, -3, -3, -3, -3, -3, -3, 3, 3, 3, 3, 3, 3, 3, 3 };
	char result[16] = { -3, -3, -3, -3, -3, -3, -3, -3, 3, 3, 3, 3, 3, 3, 3, 3 };
	sum_vectors(result, numbers_A, numbers_B);

	int integers[2] = { -17, 24 };
	float results[4];
	int2float(integers, results);
	printf("\Conversion: %f %f\n", results[0], results[1]);
	return 0;
}