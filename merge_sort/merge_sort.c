#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SIZE 100
#define SEPARATOR " "

int *split(char *string, char *separator, int *size) {
  int *array = malloc(MAX_SIZE * sizeof(int));
  char *token = strtok(string, separator);
  int i = 0;
  while (token != NULL) {
    array[i++] = atoi(token);
    token = strtok(NULL, separator);
  }
  *size = i;
  return array;
}

void merge(int *array, int size, int mid) {
  int *left = malloc(mid * sizeof(int));
  int *right = malloc((size - mid) * sizeof(int));
  int i, j, k;
  for (i = 0; i < mid; ++i) {
    left[i] = array[i];
  }
  for (j = 0; j < size - mid; ++j) {
    right[j] = array[mid + j];
  }
  i = 0;
  j = 0;
  k = 0;
  while (i < mid && j < size - mid) {
    if (left[i] < right[j]) {
      array[k++] = left[i++];
    } else {
      array[k++] = right[j++];
    }
  }
  while (i < mid) {
    array[k++] = left[i++];
  }
  while (j < size - mid) {
    array[k++] = right[j++];
  }
  free(left);
  free(right);
}


void merge_sort(int *array, int size) {
  if (size < 2) {
    return;
  }
  int mid = size / 2;
  merge_sort(array, mid);
  merge_sort(array + mid, size - mid);
  merge(array, size, mid);
}

int main(void) {
  char string[MAX_SIZE];
  fgets(string, MAX_SIZE, stdin);
  int size = 0;
  int *array = split(string, SEPARATOR, &size);
  merge_sort(array, size);
  for (int i = 0; i < size; ++i) {
    printf("%d ", array[i]);
  }
  free(array);
  return 0;
}