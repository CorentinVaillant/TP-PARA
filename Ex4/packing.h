#pragma once

#include "./pb_loader.h"
#include <assert.h>
#include <omp.h>
#include <stdlib.h>

#define RESOLVE_PACK_WRONG_COMPUTATION_ERR 1
#define RESOLVE_PACK_ALLOCATION_ERR 2

#define S_INDEX(i, j) (&S[(i) * (C + 1) + (j)])
#define UNWRAP_PTR(ptr)                                                        \
  if (!ptr)                                                                    \
  return RESOLVE_PACK_ALLOCATION_ERR

int resolve_packing(ProblemConf conf, size_t thread_count, int *max_utility_out,
                    int **RES, size_t *RES_size_out) {
  // -- Init tab
  const int N = conf.num_obj;
  const int C = conf.capacity;
  const int *M = conf.weight;
  const int *U = conf.utility;

  int *S = calloc(N * (C + 1), sizeof(int));
  UNWRAP_PTR(S);

#pragma omp parallel num_threads(thread_count)
  {

    for (int i = 0; i < N; i++) {
#pragma omp for
      for (int j = 0; j < C + 1; j++) {
        // init of the first line
        if (i == 0) {
          *S_INDEX(0, j) = M[0] <= j ? U[0] : 0;
        } else {

          // case 1.
          int first = *S_INDEX(i - 1, j);
          int second = first;

          // case 2.
          if (j - M[i] >= 0) {
            int k = j - M[i];
            second = *S_INDEX(i - 1, k) + U[i];
          }

          *S_INDEX(i, j) = first > second ? first : second;
        }
      }
      // Synchronization barrier.
    }
  }

  // -- Getting solutions
  *max_utility_out = *S_INDEX(N - 1, C);
  *RES = calloc(N, sizeof(int));
  *RES_size_out = (size_t)N;
  int *E = *RES;
  int i = N - 1;
  int j = C;

  while (i > 0) {

    if (*S_INDEX(i, j) == *S_INDEX(i - 1, j))
      i--;
    else if (j >= M[i] && *S_INDEX(i, j) == *S_INDEX(i - 1, j - M[i]) + U[i]) {
      E[i] = 1;
      j -= M[i];
      i--;
    } else {
      // Should no append
      return RESOLVE_PACK_WRONG_COMPUTATION_ERR;
    }
  }

  if (*S_INDEX(i, j) != 0)
    E[i] = 1;
  // -- Free tab
  free(S);
  S = NULL;
  return 0;
}
