#pragma once

#include <cstddef>

#include <filesystem>

#include <fstream>
#include <iostream>

#include <omp.h>
#include <thread>
#include <vector>

constexpr int INFINITE = (1 << 30); // a very large positive integer

struct DirectEdge {
  size_t destination_node;
  int weight;
  DirectEdge *next;
};

using NodeVectorTab = std::vector<std::vector<DirectEdge>>;

class Graph {
  size_t num_nodes;
  size_t num_edges;
  std::vector<DirectEdge> edges;
  NodeVectorTab nodes;

public:
  Graph(std::filesystem::path path) {

    std::string line;
    int node1, node2, weight;

    std::ifstream graph{};
    graph.open(path);
    graph.seekg(0, std::ios::beg);

    if (!graph.is_open()) {
      std::cerr << path;
      throw std::runtime_error("Could not read the file !");
    }

    size_t edge_counter = 0;
    while (std::getline(graph, line)) {

      std::cout << "line :" << line << "\n";
      std::vector<int> d;
      std::vector<char> P;

      switch (line[0]) {
      case 'c': // comment
        break;

      case 'p': // graph size
        if (sscanf(&(line[5]), "%lu %lu\n", &num_nodes, &num_edges) != 2) {
          std::cerr << line << std::endl;

          throw std::runtime_error("Error in file format in line:\n");

        } else
          std::cout << "Graph contains " << num_nodes << " nodes and "
                    << num_edges << " edges\n";

        edges.resize(num_edges * 2);

        nodes.reserve(num_nodes);
        for (size_t i = 0; i < num_nodes; i++)
          nodes.push_back({});
        break;

      case 'a': // edge definition
        if (sscanf(&(line[2]), "%d %d %d\n", &node1, &node2, &weight) != 3) {
          std::cerr << line << std::endl;
          throw std::runtime_error("Error in file format in line:\n");
          exit(-1);
        }
        node1--;
        node2--; // number nodes from 0
        // distance[node1-1][node2-1] = weight;
        DirectEdge *e = nullptr;
        DirectEdge &new_edge = edges[edge_counter++];
        new_edge.destination_node = node2;
        new_edge.weight = weight;
        new_edge.next = nullptr;
        if (nodes[node1].empty())
          nodes[node1] = {new_edge};
        else {
          e = (nodes[node1].data());
          while (e->next != nullptr)
            e = e->next;
          e->next = &new_edge;
        }
        new_edge = edges[edge_counter++];
        new_edge.destination_node = node1;
        new_edge.weight = weight;
        new_edge.next = nullptr;
        if (nodes[node2].empty())
          nodes[node2] = {new_edge};
        else {
          e = nodes[node2].data();
          while (e->next != nullptr)
            e = e->next;
          e->next = &new_edge;
        }

        break;
      }
    }
  }

  void debug_print() const {
    for(const auto& edge : edges){
        std::cout << edge.destination_node << " ";
    }
    std::cout << "," << std::endl;
  }

  int get_distance(size_t node1, size_t node2) const {

    if (node1 == node2)
      return 0;

    const DirectEdge *edge = nodes[node1].data();
    while (edge != nullptr) {
      if (edge->destination_node == node2)
        return edge->weight;
      edge = edge->next;
    }
    return INFINITE;
  }
};

// double dijkstra(const Graph &graph) {
//   double begin = omp_get_wtime();
//   int shortest_dist;
//   int nearest_node;

//   P[0] = 1;
//   for (int i = 1; i < graph.num_node; i++)
//     P[i] = 0;

//   for (int i = 0; i < graph.num_node; i++)
//     d[i] = get_distance(0, i);

//   for (int step = 1; step < graph.num_node; step++) {
//     // find the nearest node
//     shortest_dist = INFINITE;
//     nearest_node = -1;
//     for (int i = 0; i < graph.num_node; i++) {
//       if (!P[i] && d[i] < shortest_dist) {
//         shortest_dist = d[i];
//         nearest_node = i;
//       }
//     }

//     if (nearest_node == -1) {
//       fprintf(
//           stderr,
//           "Warning: Search ended early, the graph might not be
//           connected.\n");
//       break;
//     }

//     P[nearest_node] = 1;
//     for (int i = 0; i < num_nodes; i++)
//       if (!P[i]) {
//         int dist = get_distance(nearest_node, i);
//         if (dist < INFINITE)
//           if (d[nearest_node] + dist < d[i])
//             d[i] = d[nearest_node] + dist;
//       }
//   }

//   double end = omp_get_wtime();

//   return end - begin;
// }
