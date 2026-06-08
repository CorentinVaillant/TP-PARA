#include <float.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include <omp.h>

#ifdef DOUBLE_PRECISION
typedef double Float;
#define Float_abs fabs
#define Float_INFTY INFINITY
#define EPSILON 1e-8
#else
typedef float Float;
#define Float_abs fabsf
#define Float_INFTY INFINITY
#define EPSILON 1e-6f
#endif

// ======== Types ======== //
typedef struct {
  Float x, y, z;
} Vec3;

typedef struct {
  Vec3 pos;
  int cluster;
} Point;

typedef struct {
  Vec3 pos;
} Cluster;

typedef struct {
  Float x, y, z;
  int count;
} Acc;

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
  // Allocate the good amount of point
  Point *points = malloc(points_count * sizeof(Point));

  for (int i = 0; i < points_count; i++) {
    if (!fgets(line, 256, file)) {
      printf(
          "Declared number of points is not the same as the number of line\n");
      return -1;
    }

    Float x, y, z;
    sscanf(line, "%f %f %f", &x, &y, &z);
    points[i].pos.x = x;
    points[i].pos.y = y;
    points[i].pos.z = z;
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
  Acc *acc = calloc(clusters_count, sizeof(Acc));

  for (int k = 0; k < clusters_count; k++) {
    points[k].cluster = k;
    clusters[k].pos = points[k].pos;
  }

  int changed = 1;
  while (changed) {
    iter++;
    for (int i = 0; i < points_counts; i++) {
      Point *p = &points[i];
      // Finding the nearest cluster
      int nearest = 0;
      Float min_dist = Float_INFTY;

      for (int k = 1; k < clusters_count; k++) {
        Float dx = p->pos.x - clusters[k].pos.x;
        Float dy = p->pos.y - clusters[k].pos.y;
        Float dz = p->pos.z - clusters[k].pos.z;

        Float dist = dx * dx + dy * dy + dz * dz;

        if (min_dist > dist) {
          min_dist = dist;
          nearest = k;
        }
      }

      p->cluster = nearest;
      // Accumulation
      acc[nearest].count++;
      acc[nearest].x += p->pos.x;
      acc[nearest].y += p->pos.y;
      acc[nearest].z += p->pos.z;
    }

    changed = 0;

    // Cluster update
    for (int k = 0; k < clusters_count; k++) {
      Float sx = 0, sy = 0, sz = 0;
      int sc = 0;

      sx += acc[k].x;
      sy += acc[k].y;
      sz += acc[k].z;
      sc += acc[k].count;

      if (sc > 0) {
        Vec3 new_center = {
            sx / sc,
            sy / sc,
            sz / sc,
        };

        if (Float_abs(new_center.x - clusters[k].pos.x) > EPSILON ||
            Float_abs(new_center.y - clusters[k].pos.y) > EPSILON ||
            Float_abs(new_center.z - clusters[k].pos.z) > EPSILON)
          changed = 1;

        clusters[k].pos = new_center;
      }
    }
    iter++;
  }

  free(acc);
  free(clusters);
  return 0;
}

// ======== Main ========//
int main(int argc, char **argv) {

  // parsing args
  if (argc != 3) {
    printf("usages : \n"
           "%s <file> <cluster count>\n",
           argv[0]);
    return 0;
  }

  FILE *file = fopen(argv[1], "r");
  if (!file) {
    fprintf(stderr, "Could not open file !\n");
    return 1;
  }

  int cluster_count = atoi(argv[2]);

  Point *points;
  int nb_points = parse_points(file, &points);
  fclose(file);

  if (nb_points < 0) {
    fprintf(stderr, "failled to parse the file !\n");
    return 2;
  }
  double begin = omp_get_wtime();
  kmeans(points, nb_points, cluster_count);
  double end = omp_get_wtime();
  printf("{\"time\":%lf, \"iter\":%d}\n", end - begin, iter);

#ifdef REGISTER_RESULT
  char result_filename[256] = {0};
  snprintf(result_filename, 255, "results/result_%d_%s_%s.json", nb_points,
           argv[2], argv[3]);
  FILE *result_register = fopen(result_filename, "w");
  if (!result_register) {
    fprintf(stderr, "Failed to open the %s !\n", result_filename);
    return 3;
  }

  fprintf(result_register, "{ \"points\":[\n");

  for (int i = 0; i < nb_points; i++)
    fprintf(result_register, "{\"cluster\":%d,\"x\":%f,\"y\":%f,\"z\":%f}%s\n",
            points[i].cluster, points[i].pos.x, points[i].pos.y,
            points[i].pos.z, i < nb_points - 1 ? "," : "");

  fprintf(result_register, "]}");

  fclose(result_register);

#endif

  free(points);

  return 0;
}