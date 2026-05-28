#include <stdio.h>
#include <stdlib.h>

#include <omp.h>

#include "./dijkstra.hpp"

int num_nodes, num_edges;
// table 'edges' is used to store all edge data
//   (instead of dynamically allocating memory at each edge creation)
struct direct_edge_struct *edges;
// edge_counter is used to allocate entries in table 'edges'
int edge_counter = 0;
// table 'nodes' contains the direct edges out of each node
//  'node[i]' is a linked list to all edges starting from node i

/******************************************************************************/
int main(int argc, char **argv) {

  if (argc < 2) {
    fprintf(stderr, "Usage: dijkstra <graph file name>\n");
    exit(-1);
  } 

  Graph graph(argv[1]);

  graph.debug_print();

  return 0;
}

/******************************************************************************/
