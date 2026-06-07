#include <stdio.h>
#include <stdlib.h>

// ======== Math ======== //

typedef struct {
  float x, y, z;
  int cluster;
} Point;

void add_point(Point *p1, Point p2) {
  p1->x += p2.x;
  p1->y += p2.y;
  p1->z += p2.z;
}

int point_equal(Point p1, Point p2) {
  return p1.x == p2.x && p1.y == p2.y && p1.z == p2.z;
}

float dot(Point p1, Point p2) {
  return p1.x * p2.x + p1.y * p2.y + p1.z * p2.z;
}

float dist(Point p1, Point p2) {
  Point vec = {
      p1.x - p2.x,
      p1.y - p2.y,
      p1.z - p2.z,
  };

  return dot(vec, vec);
}

typedef struct {
  Point center;
  int points_count;
  Point point_acc;
} Cluster;

void cluster_add_point(Cluster *inout, Point p) {
  add_point(&inout->point_acc, p);
  inout->points_count++;
}

float cluster_dist(Cluster cluster, Point p) { return dist(cluster.center, p); }

///@brief Compute the barycenter of a cluster,
/// The accumulation point, and the number of points are zeroed.
///@return `true` if the barycenter changed.
int compute_barycenter(Cluster *cluster_inout) {
  Point center = cluster_inout->point_acc;
  center.x /= (float)(cluster_inout->points_count);
  center.y /= (float)(cluster_inout->points_count);
  center.z /= (float)(cluster_inout->points_count);

  int changed = !point_equal(cluster_inout->center, center);

  cluster_inout->center = center;
  cluster_inout->point_acc.x = 0;
  cluster_inout->point_acc.y = 0;
  cluster_inout->point_acc.z = 0;
  cluster_inout->points_count = 0;

  return changed;
}

// ======== Parsing ======== //
int parse_points(FILE *file, Point **points_out) {

  // first line is numbers of points
  int points_count = -1;

  char line[256] = {0};
  if (!fgets(line, 256, file)) {
    fprintf(stderr, "Could not read the first line of the file");
    return -1;
  }
  sscanf(line, "%d", &points_count);
  printf("Number of point : %d\n", points_count);
  // Allocate the good amount of point
  Point *points = malloc(points_count * sizeof(Point));

  for (int i = 0; i < points_count; i++) {
    if (!fgets(line, 256, file)) {
      printf(
          "Declared number of points is not the same as the number of line\n");
      return -1;
    }

    float x, y, z;
    sscanf(line, "%f %f %f", &x, &y, &z);
    points[i].x = x;
    points[i].y = y;
    points[i].z = z;
  }

  *points_out = points;
  return points_count;
}

// ======== Kmeans impl ======== //
int iter = 0;
int kmeans(Point *points, int points_counts, int clusters_count) {

  if (points_counts < clusters_count && clusters_count > 0) {
    fprintf(stderr, "Invalide points counts or cluster count\n");
    return 1;
  }

  // Assign the k first clusters
  Cluster *clusters = malloc(clusters_count * sizeof(Cluster));
  for (int k = 0; k < clusters_count; k++) {
    points[k].cluster = k;
    clusters[k].center = points[k];
    clusters[k].points_count = 1;
    clusters[k].point_acc.x = 0;
    clusters[k].point_acc.y = 0;
    clusters[k].point_acc.z = 0;
  }

  int converged = 0;
  while (!converged) {
    iter++;
    converged = 1;
    for (int i = 0; i < points_counts; i++) {
      Point *p = &points[i];
      // Finding the nearest cluster
      int nearest = 0;
      float min_dist = cluster_dist(clusters[0], *p);

      for (int k = 1; k < clusters_count; k++) {
        float dist = cluster_dist(clusters[k], *p);
        if (min_dist > dist) {
          min_dist = dist;
          nearest = k;
        }
      }

      cluster_add_point(&clusters[nearest], *p);
      p->cluster = nearest;
    }

    // Computing barycenter
    for (int k = 0; k < clusters_count; k++)
      converged = converged && !compute_barycenter(&clusters[k]);
  }

  free(clusters);
  return 0;
}

// ======== Main ========//
int main(int argc, char **argv) {

  // parsing args
  if (argc != 4) {
    printf("usages : \n"
           "%s <file> <cluster count> <nb_t>\n",
           argv[0]);
    return 0;
  }

  FILE *file = fopen(argv[1], "r");
  if (!file) {
    fprintf(stderr, "Could not open file !\n");
    return 1;
  }

  int cluster_count = atoi(argv[2]);

  int nbT = atoi(argv[3]);

  Point *points;
  int nb_points = parse_points(file, &points);
  fclose(file);

  if (nb_points < 0) {
    fprintf(stderr, "failled to parse the file !\n");
    return 2;
  }
  kmeans(points, nb_points, cluster_count);
  printf("iter :%d\n", iter);

#define REGISTER_RESULT
#ifdef REGISTER_RESULT
  char result_filename[256] = {0};
  snprintf(result_filename, 255, "result_%s_%s.json", argv[2], argv[3]);
  FILE *result_register = fopen(result_filename, "w");
  if (!result_register) {
    fprintf(stderr, "Failed to open the %s !\n", result_filename);
    return 3;
  }

  fprintf(result_register, "{ \"points\":[\n");

  for (int i = 0; i < nb_points; i++)
    fprintf(result_register, "{\"cluster\":%d,\"x\":%f,\"y\":%f,\"z\":%f}%s\n",
            points[i].cluster, points[i].x, points[i].y, points[i].z,
            i < nb_points - 1 ? "," : "");

  fprintf(result_register, "]}");

  fclose(result_register);

#endif

  free(points);

  return 0;
}