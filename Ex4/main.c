#include "./packing.h"
#include <assert.h>
#include <omp.h>

int main() {
  ProblemConf conf;
  read_problem("./pb/pb1.pb", &conf);

  // -- Init tab
  const int N = conf.num_obj;
  const int C = conf.capacity;
  const int *M = conf.weight;
  const int *U = conf.utility;

  int *S = calloc(N * (C + 1), sizeof(int));
  int *S_index(int i, int j) {
    assert(0 <= i && i < N && "Wrong index");
    assert(0 <= j && j < (C + 1) && "Wrong index");

    return &S[i * (C + 1) + j];
  };

  int *E = calloc(N, sizeof(int));
  // -- Compute the tab
  // First row
  // i = 0
  for (size_t j = 0; j < C + 1; j++) {
    *S_index(0, j) = M[0] <= j ? U[0] : 0;
  }

  for (int i = 1; i < N; i++) {
    for (int j = 0; j < C + 1; j++) {
      // case 1.
      int first = *S_index(i - 1, j);
      int second = first;

      // case 2.
      if (j - M[i] >= 0) {
        size_t k = j - M[i];
        second = *S_index(i - 1, k) + M[i];
      }

      *S_index(i, j) = first > second ? first : second;
    }
  }

  // -- Display the tab
  for (size_t i = 0; i < N; i++) {
    for (size_t j = 0; j < C + 1; j++)
      printf("%d  ", *S_index(i, j));
    printf("\n");
  }

  // -- Free tab
  free(S);
  S = NULL;
  free(E);
  E = NULL;
  return 0;
}
