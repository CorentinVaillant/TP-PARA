#include <assert.h>
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

void verifyResult(int result, unsigned int size) {

  if (result != size * size)
    printf("\n[ERR ] got : %d instead of %d\n", result, size * size);
  assert(result == size * size && "Result should be size²");
}
///@returns renvoie le temps pris par le calcule
int addSequential(const int *m, unsigned int size, float *time) {
  double start, stop;
  int result = 0;

  start = omp_get_wtime();
  for (unsigned int i = 0; i < size * size; i++)
    result += m[i];
  stop = omp_get_wtime();
  *time = stop - start;
  return result;
}

int addParaSimplePartialSum(const int *m, unsigned int size, unsigned int nbT,
                            float *time) {
  double start, stop;
  int result = 0;

  int *partial_sums = calloc(sizeof(int), nbT);
  start = omp_get_wtime();

#pragma omp parallel num_threads(nbT)
  {
    unsigned int thread_nb = omp_get_thread_num();
#pragma omp for
    for (unsigned int i = 0; i < size * size; i++)
      partial_sums[thread_nb] += m[i];

#pragma omp single
    for (unsigned int i = 0; i < nbT; i++)
      result += partial_sums[i];
  }
  stop = omp_get_wtime();
  *time = stop - start;

  free(partial_sums);

  return result;
}

int addParaAtomicPartialSum(const int *m, unsigned int size, unsigned int nbT,
                            float *time) {
  double start, stop;
  int result = 0;

  start = omp_get_wtime();

#pragma omp parallel num_threads(nbT)
  {
    int partial_sum = 0;
#pragma omp for
    for (unsigned int i = 0; i < size * size; i++)
      partial_sum += m[i];

#pragma omp atomic
    result += partial_sum;
  }
  stop = omp_get_wtime();
  *time = stop - start;

  return result;
}

int addParaOptimizedPartialSum(const int *m, unsigned int size,
                               unsigned int nbT, float *time) {
  double start, stop;
  int result = 0;

  start = omp_get_wtime();

#pragma omp parallel num_threads(nbT) reduction(+ : result)
  {
#pragma omp for
    for (unsigned int i = 0; i < size * size; i++)
      result += m[i];
  }
  stop = omp_get_wtime();
  *time = stop - start;
  return result;
}

enum Methods {
  METHOD_SEQUENTIAL = 0,
  METHOD_SIMPLEREDUC = 1,
  METHOD_ATOMICREDUC = 2,
  METHOD_OPTIREDUC = 3,
};

int main(int argc, char **argv) {

  // -- Parse arguments
  if (argc == 1 || !strncmp("-h\0", argv[1], 3) || argc != 4) {
    printf("Usages : \n"
           "$%s -h # give you usage\n"
           "$%s <Method> <NbT> <SIZE> \n "
           "\t# Method : Method to use : \n "
           "\t\t 0->Sequential\n"
           "\t\t 1->Simple reduction\n"
           "\t\t 2->Atomic reduction\n"
           "\t\t 3->Optimized reduction\n"
           "\t# NbT : Number of threads to use \n "
           "\t# SIZE : Size of the matrix \n ",
           argv[0], argv[0]);
    return 0;
  }

  enum Methods method = atoi(argv[1]);
  unsigned int nbT = atoi(argv[2]);
  unsigned int size = atoi(argv[3]);

  // -- Initialisations
  int *m;
  int result;
  float time = -1.f;
  m = malloc(sizeof(int) * size * size);

  // Init tout à 1
  for (unsigned int i = 0; i < size * size; i++) {
    m[i] = 1;
  }

  printf("{\n");
  printf("\t\"method\": %u,\n\t", method);
  switch (method) {
  case METHOD_SEQUENTIAL:
    printf("\"name\": \"Sequential\",\n");
    result = addSequential(m, size, &time);
    break;
  case METHOD_SIMPLEREDUC:
    printf("\"name\": \"Parallelized, Simple partial sum\",\n");
    result = addParaSimplePartialSum(m, size, nbT, &time);
    break;
  case METHOD_ATOMICREDUC:
    printf("\"name\": \"Parallelized, Atomic partial sum\",\n");
    result = addParaAtomicPartialSum(m, size, nbT, &time);
    break;
  case METHOD_OPTIREDUC:
    printf("\"name\": \"Parallelized, Optimized partial sum\",\n");
    result = addParaOptimizedPartialSum(m, size, nbT, &time);
    break;
  }
  verifyResult(result, size);

  free(m);
  printf("\t\"nbT\": %u,\n", nbT);
  printf("\t\"size\": %u,\n", size);
  printf("\t\"time\": %f\n", time);
  printf("}\n");

  return 0;
}
