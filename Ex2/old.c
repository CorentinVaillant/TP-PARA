#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <omp.h>
#include <sys/time.h>
#define SIZE 30000

#define MAX_NB_THREAD 8

void verifyResult(int result, unsigned int size)
{

    if (result != size * size)
        printf("\n[ERR ] got size : %d instead of %d\n", result, size * size);
    assert(result == size * size && "Result should be size²");
}

int main()
{
    // -- Initialisations

    double t, start, stop;

    int *m;
    int result;
    m = malloc(sizeof(int) * SIZE * SIZE);

    // Init tout à 1
    for (unsigned int i = 0; i < SIZE * SIZE; i++)
    {
        m[i] = 1;
    }

    // -- Sequentiel

    printf("Addition sequentiel : \n");
    result = 0;
    start = omp_get_wtime();
    for (unsigned int i = 0; i < SIZE * SIZE; i++)
        result += m[i];
    stop = omp_get_wtime();
    t = stop - start;
    printf("Done in %f\n", t);
    verifyResult(result, SIZE);

    // -- Parallel

    printf("Sequentiel, Simple partial sum : \n");
    printf("NbThread \tTime\n");
    for (unsigned int nbT = 2; nbT <= MAX_NB_THREAD; nbT++)
    {
        result = 0;
        int *partial_sums = calloc(sizeof(int), nbT);
        start = omp_get_wtime();

#pragma omp parallel num_threads(nbT) shared(result)
        {
            unsigned int thread_nb = omp_get_thread_num();
#pragma omp for
            for (unsigned int i = 0; i < SIZE * SIZE; i++)
                partial_sums[thread_nb] += m[i];

#pragma omp single
            for (unsigned int i = 0; i < nbT; i++)
                result += partial_sums[i];
        }
        stop = omp_get_wtime();
        t = stop - start;
        printf("%u \t\t%fs\n", nbT, t);

        verifyResult(result, SIZE);
    }

    printf("Sequentiel, Atomic partial sum : \n");
    printf("NbThread \tTime\n");
    for (unsigned int nbT = 2; nbT <= MAX_NB_THREAD; nbT++)
    {
        result = 0;
        start = omp_get_wtime();

#pragma omp parallel num_threads(nbT) shared(result)
        {
            int partial_sum = 0;
#pragma omp for
            for (unsigned int i = 0; i < SIZE * SIZE; i++)
                partial_sum += m[i];

#pragma omp atomic
            result += partial_sum;
        }
        stop = omp_get_wtime();
        t = stop - start;
        printf("%u \t\t%fs\n", nbT, t);

        verifyResult(result, SIZE);
    }

    printf("Sequentiel, Optimized partial sum : \n");
    printf("NbThread \tTime\n");
    for (unsigned int nbT = 2; nbT <= MAX_NB_THREAD; nbT++)
    {
        result = 0;
        start = omp_get_wtime();

#pragma omp parallel num_threads(nbT) reduction(+ : result)
        {
#pragma omp for
            for (unsigned int i = 0; i < SIZE * SIZE; i++)
                result += m[i];
        }
        stop = omp_get_wtime();
        t = stop - start;
        printf("%u \t\t%fs\n", nbT, t);

        verifyResult(result, SIZE);
    }

    free(m);
    printf("All done !\n");
}
