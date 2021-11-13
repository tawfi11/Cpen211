#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#define N 128

int main(void) {
	int index1;
	int index2;
	double count1 = 1.0;
	double count2 = 0.0;
	int count;
	int choice;
	double A[N][N], B[N][N], C[N][N];
	FILE *fp;
	BEGIN: printf("Make a choice\n0: Make NxN random matrix file\n1: Generate NxN 0 matrix file\n2: Perform matrix multiplication\n");
	scanf("%d", &choice);
	if (choice == 0) {
		fp = fopen("arrA.txt", "w");
		if (fp == NULL) {
			printf("ERROR");
			return 0;
		}
		for (index1 = 0; index1 < N; index1++) {
			for (index2 = 0; index2 < N; index2++) {
				count1 = count1 + 0.001;
				fprintf(fp, ".double %.3f\n", count1);
			}
			count1 = count1 - (N / 1000.0);
			count1 = count1 + 1;
		}
		fclose(fp);
		fp = fopen("arrB.txt", "w");
		if (fp == NULL) {
			printf("ERROR");
			return 0;
		}
		count = 0;
		for (index1 = 0; index1 < N * N; index1++) {
			if (count % N == 0) {
				count2 = count2 + 1.0;
			}
			fprintf(fp, ".double %.3f\n", count2);
			count++;
		}
		printf("ArrA and ArrB successfully created!\n");
		fclose(fp);
		goto BEGIN;
	}
	else if(choice == 1){
		fp = fopen("arrZ.txt", "w");
		for (index1 = 0; index1 < N * N; index1++) {
			fprintf(fp, ".double 0.0\n");
		}
		printf("ArrZ successfully created!\n");
		fclose(fp);
		goto BEGIN;
	}
	else {
		int i, j, k;
		printf("Your result is:\n");
		for (index1 = 0; index1 < N; index1++) {
			for (index2 = 0; index2 < N; index2++) {
				count1 = count1 + 0.001;
				A[index1][index2] = count1;
			}
			count1 = count1 - (N / 1000.0);
			count1 = count1 + 1;
		}
		count = 0;
		for (index1 = 0; index1 < N; index1++) {
			
			count2 = count2 + 1.0;
			
			for (index2 = 0; index2 < N; index2++) {
				B[index1][index2] = count2;	
			}
			count++;
		}
		for (i = 0; i < N; i++) {
			for (j = 0; j < N; j++) {
				double sum = 0.0;
				for (k = 0; k < N; k++) {
					sum = sum + A[i][k] * B[k][j];
				}
				C[i][j] = sum;
			}
		}
		for (index1 = 0; index1 < N; index1++) {
			for (index2 = 0; index2 < N; index2++) {
				printf("%.3f, ", C[index1][index2]);
			}
			printf("\n");
		}
		goto BEGIN;
	}
	system("PAUSE");
	return 0;
}