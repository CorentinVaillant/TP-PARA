#include "./image_funcs.h"
#include "./ppm_loader.h"

/**********************************************************************/
int main(int argc, char **argv) {
  color_image_type *col_img;
  grey_image_type *grey_img;

  if (argc != 3) {
    printf("Usage: togrey <input image> <output image>\n");
    exit(-1);
  }
  char *input_file = argv[1];
  char *output_file = argv[2];

  col_img = loadColorImage(input_file);
  grey_img = createGreyImage(col_img->width, col_img->height);

  int tab[256 * 2];

  double begin = omp_get_wtime();

#pragma omp parallel shared(tab) num_threads(8)
  {
    colorToGrey(col_img, grey_img);
    increaseContraste(grey_img, tab, &tab[256]);
  }
  double end = omp_get_wtime();

  printf("Done in :%fs\n", end-begin);

  saveGreyImage(output_file, grey_img);
}
