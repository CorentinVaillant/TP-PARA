#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

#include "./packing.h"
#include "./pb_loader.h"
int main(int argc, char **argv) {

  if (argc == 1 || !strncmp("-h\0", argv[1], 3) || argc != 3) {
    printf("Usages : \n"
           "$%s -h # give you usage\n"
           "$%s <PbPath> <NbT> \n "
           "\t# PbPath : Path to the problem configuration file \n "
           "\t# NbT    : Number of threads to use \n ",
           argv[0], argv[0]);
    return 0;
  }

  // Reading inputs
  char *pb_filename = argv[1];
  ProblemConf conf;
  read_problem(pb_filename, &conf);

  size_t thread_count = atoi(argv[2]);

  // mesuring time
  double start, stop;
  start = omp_get_wtime();
  int *RES;
  size_t RES_size;
  int max_utility;
  int result =
      resolve_packing(conf, thread_count, &max_utility, &RES, &RES_size);
  stop = omp_get_wtime();

  if (result) {
    return result;
  }

  double time_taken = stop - start;

  // Out as a json file
  printf("{\n"

         "\t\"pb\": \"%s\", \n"
         "\t\"nbT\": %lu, \n"
         "\t\"time\": %f, \n"
         "\t\"maxUtility\": %d \n"
         "}\n",
         pb_filename, thread_count, time_taken, max_utility);

  return 0;
}