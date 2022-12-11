#include <stdio.h>

float avg_harm(float* arr, unsigned int n);

int main() {
	float arr[] = { 1.5, 2.0, 3.5 };
	float x;
	x = avg_harm(arr, 3);
	printf("Harminic mean of arr is %f\n", x);

	return 0;
}