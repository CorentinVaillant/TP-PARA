#pragma once
#include <stdio.h>
#include <stdlib.h>

#define MAX_NUM_OBJ 100

typedef struct
{
  int num_obj;
  int capacity;
  int weight[MAX_NUM_OBJ];
  int utility[MAX_NUM_OBJ];
} ProblemConf;

void read_problem(char *filename, ProblemConf *out)
{

  out->num_obj = 0;

  char line[256];

  FILE *problem = fopen(filename, "r");
  if (problem == NULL)
  {
    fprintf(stderr, "File %s not found.\n", filename);
    exit(-1);
  }

  while (fgets(line, 256, problem) != NULL)
  {
    switch (line[0])
    {
    case 'c': // capacity
      if (sscanf(&(line[2]), "%d\n", &out->capacity) != 1)
      {
        fprintf(stderr, "Error in file format in line:\n");
        fprintf(stderr, "%s", line);
        exit(-1);
      }
      break;

    case 'o': // graph size
      if (out->num_obj >= MAX_NUM_OBJ)
      {
        fprintf(stderr, "Too many objects (%d): limit is %d\n", out->num_obj, MAX_NUM_OBJ);
        exit(-1);
      }
      if (sscanf(&(line[2]), "%d %d\n", &(out->weight[out->num_obj]), &(out->utility[out->num_obj])) != 2)
      {
        fprintf(stderr, "Error in file format in line:\n");
        fprintf(stderr, "%s", line);
        exit(-1);
      }
      else
        out->num_obj++;
      break;

    default:
      break;
    }
  }
  if (out->num_obj == 0)
  {
    fprintf(stderr, "Could not find any object in the problem file. Exiting.");
    exit(-1);
  }
}
