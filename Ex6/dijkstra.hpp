#pragma once

#include <cstddef>

#include <filesystem>

#include <fstream>
#include <iostream>

#include <omp.h>
#include <thread>
#include <utility>
#include <vector>

constexpr int INFINITE = (1 << 30); // a very large positive integer

struct DirectEdge {
  size_t destination_node;
  int weight;
};

using NodeVectorTab = std::vector<std::vector<DirectEdge>>;

class Graph {
  size_t num_nodes;
  size_t num_edges;
  NodeVectorTab nodes;

public:
  Graph(std::filesystem::path path) {

    std::string line;

    std::ifstream graph{};
    graph.open(path);
    graph.seekg(0, std::ios::beg);

    if (!graph.is_open()) {
      std::cerr << path;
      throw std::runtime_error("Could not read the file !");
    }

    while (std::getline(graph, line)) {

#ifdef LOG
      std::clog << "line :" << line << "\n";
#endif
      switch (line[0]) {
      case 'c': // comment
        break;

      case 'p': // graph size
        if (sscanf(&(line[5]), "%zu %zu\n", &num_nodes, &num_edges) != 2) {
          std::cerr << line << std::endl;

          throw std::runtime_error("Error in file format in line:\n");

        } else
          std::clog << "//Graph contains " << num_nodes << " nodes and "
                    << num_edges << " edges\n";

        nodes.resize(num_nodes);
        break;

      case 'a': { // edge definition
        int node1, node2, weight;

        if (sscanf(&(line[2]), "%d %d %d\n", &node1, &node2, &weight) != 3) {
          std::cerr << line << std::endl;
          throw std::runtime_error("Error in file format in line:\n");
        }
        size_t u = static_cast<size_t>(node1 - 1);
        size_t v = static_cast<size_t>(node2 - 1);

        nodes[u].emplace_back(DirectEdge{v, weight});
      } break;
      }
    }
  }

  void debug_print() const {
    for (size_t i = 0; i < nodes.size(); i++) {
      std::clog << "Node " << i << ':';
      for (const auto &e : nodes[i])
        std::clog << " -> " << e.destination_node << " (w=" << e.weight << ')';
      std::clog << '\n';
    }
  }

  int get_distance(size_t node1, size_t node2) const {

    if (node1 == node2)
      return 0;

    for (const auto &edge : nodes[node1]) {
      if (edge.destination_node == node2)
        return edge.weight;
    }
    return INFINITE;
  }

  // Making a custom reduction
  // find on :
  // https://stackoverflow.com/questions/79733444/how-to-do-user-defined-reduction-on-allocatable-array-and-user-reduction-fu
  struct NearestNodeDistPair {
    int shortest_dist = INFINITE;
    int nearest_node = -1;

    bool operator<(NearestNodeDistPair other) {
      return shortest_dist < other.shortest_dist;
    }

    static void init_reduc(NearestNodeDistPair *out, NearestNodeDistPair in) {
      *out = NearestNodeDistPair{};
    }

    static void min_reduc(NearestNodeDistPair *inout, NearestNodeDistPair in) {
      *inout = *inout < in ? *inout : in;
    }
  };

#pragma omp declare reduction(min_dist_node_reduc:NearestNodeDistPair : (      \
        NearestNodeDistPair::min_reduc(&omp_out, omp_in)))                     \
    initializer(NearestNodeDistPair::init_reduc(&omp_priv, omp_orig))

  /// @return the time taken by the algorithm
  double dijkstra(unsigned int nb_thread = 1,
                  std::vector<int> *prev_out = nullptr) const {

    std::vector<int> P;
    P.resize(num_nodes);

    std::vector<int> d;
    d.resize(num_nodes);
    d[0] = 0;

    std::vector<int> prev;
    prev.resize(num_nodes);
    prev[0] = -1;

    double begin = omp_get_wtime();

    nb_thread = nb_thread == 0 ? 8 : nb_thread;

    NearestNodeDistPair nearest_node_dist;

    nearest_node_dist = NearestNodeDistPair{};
    P[0] = 1;
#pragma omp parallel num_threads(nb_thread)
    {

      // Init
#pragma omp for
      for (size_t i = 1; i < num_nodes; i++) {
        prev[i] = -1;
        P[i] = 0;
        d[i] = get_distance(0, i);
      } // Barrier

      // Compute
      for (size_t step = 1; step < num_nodes; step++) {

#pragma omp single
        nearest_node_dist = {INFINITE, -1}; // reset at each iter
                                            // Barrier

        // find the nearest node
#pragma omp for reduction(min_dist_node_reduc : nearest_node_dist)
        for (size_t i = 0; i < num_nodes; i++) {
          if (!P[i] && d[i] < nearest_node_dist.shortest_dist) {
            nearest_node_dist.shortest_dist = d[i];
            nearest_node_dist.nearest_node = i;
          }
        } // barrier

        const int nearest_node = nearest_node_dist.nearest_node;
        if (nearest_node == -1) {
#pragma omp single
          std::cerr << "Warning: Search ended early, the graph might not be "
                       "connected.\n ";
        }

#pragma omp single
        P[nearest_node] = 1;
        // Barrier

        const int d_nearest = d[nearest_node];
#pragma omp for
        for (size_t i = 0; i < num_nodes; i++)
          if (!P[i]) {
            int dist = get_distance(nearest_node, i);
            if (dist < INFINITE && d_nearest + dist < d[i]) {
              auto new_val = d_nearest + dist;
              d[i] = new_val;
              prev[i] = nearest_node;
            }
          } // Barrier
      }
    } // omp parallel

    if (prev_out)
      *prev_out = std::move(prev);

    double end = omp_get_wtime();

    return end - begin;
  }
};
