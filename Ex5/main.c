#include "./image_funcs.h"
#include "./ppm_loader.h"
#include <stdio.h>
#include <stdlib.h>

/**********************************************************************/
int main(int argc, char **argv) {
  color_image_type *col_img;
  grey_image_type *grey_img;

  if (argc != 4) {
    printf("Usage: %s <input image> <output image> <NB_T>\n", argv[0]);
    exit(-1);
  }
  char *input_file = argv[1];
  char *output_file = argv[2];
  int nb_t = atoi(argv[3]);

  col_img = loadColorImage(input_file);
  grey_img = createGreyImage(col_img->width, col_img->height);

  int tab[256 * 2];

  double begin = omp_get_wtime();
#pragma omp parallel shared(tab) num_threads(nb_t)
  {
    colorToGrey(col_img, grey_img);
    increaseContraste(grey_img, tab, &tab[256]);
  }
  double end = omp_get_wtime();

  printf("{\n");
  printf("  \"nb_t\": %d,\n", nb_t);
  printf("  \"time\" :%f\n", end - begin);
  printf("}\n");

  saveGreyImage(output_file, grey_img);
}
