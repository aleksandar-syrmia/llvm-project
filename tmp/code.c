#include <stdio.h>

void printArray(int arr[], int size) {
    for (int i = 0; i < size; ++i) {
        printf("Element %d: %d\n", i, arr[i]);
    }
}

int sumArray(int arr[], int size) {
    int sum = 0;
    for (int i = 0; i < size; ++i) {
        sum += arr[i];
    }
    return sum;
}

void processData(int data[], int size) {
    int sum = sumArray(data, size);
    printf("Sum of data: %d\n", sum);

    if (sum > 0) {
        printf("Positive sum detected.\n");
    } else {
        printf("Non-positive sum detected.\n");
    }
}

int main() {
    int arr[] = {1, 2, 3, 4, 5};
    int arrSize = sizeof(arr) / sizeof(arr[0]);

    printf("Array contents:\n");
    printArray(arr, arrSize);

    processData(arr, arrSize);

    return 0;
}

