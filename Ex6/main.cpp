#include <cstddef>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>

#include <omp.h>
#include <string>
#include <vector>

#include "./dijkstra.hpp"

/******************************************************************************/
int main(int argc, char **argv) {

  if (argc < 3) {
    std::cerr << "Usage: " << argv[0]
              << " <graph file name> <number of thread to use>\n";
    exit(-1);
  }

  auto nb_t = std::stoul(argv[2]);
  Graph graph(argv[1]);

  std::vector<int> prev_tab;
  auto time = graph.dijkstra(nb_t, &prev_tab);

  constexpr int W = 4;
  std::cout << "//";
  for (size_t i = 0; i < prev_tab.size(); i++) {
    std::cout << std::setw(W) << i << " |";
  }
  std::cout << std::endl << "//";
  for (int p : prev_tab) {
    std::cout << std::setw(W) << p << " |";
  }
  std::cout << std::endl;

  std::cout << "\"time\":" << time << ",\n";

  return 0;
}
