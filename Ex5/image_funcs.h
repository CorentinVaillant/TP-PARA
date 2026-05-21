#pragma once

#include <omp.h>

#include "ppm_loader.h"

/**********************************************************************/

void colorToGrey(color_image_type *col_img, grey_image_type *grey_img) {
#pragma omp for
  for (int i = 0; i < col_img->height; i++)
    for (int j = 0; j < col_img->width; j++) {
      int index = i * col_img->width + j;
      color_pixel_type *pix = &(col_img->pixels[index]);
      grey_img->pixels[index] =
          (299 * pix->r + 587 * pix->g + 114 * pix->b) / 1000;
    }

  // Barrier (before return)
}

/**********************************************************************/

/// @brief increase the contraste of an image
/// @param grey_img the image which will be modified
/// @param H,C 256 int tabs needed for the computation
void increaseContraste(grey_image_type *grey_img, int *H, int *C) {
  unsigned int width = grey_img->width;
  unsigned int height = grey_img->height;
  unsigned int S = width * height;
  unsigned char *px_tab = grey_img->pixels;
#define px(i, j) px_tab[j + width * i]

// Zeroed the tabs
#pragma omp for
  for (size_t i = 0; i < 256; i++) {
    H[i] = 0;
    C[i] = 0;
  }

  // compute H (histogram)
#pragma omp for 
  for (size_t i = 0; i < height; i++)
    for (size_t j = 0; j < width; j++) {
#pragma omp atomic
      H[px(i, j)]++;
    }
// Barrier
#pragma omp single
  {
    // compute C (cumuled H)
    C[0] = H[0];
    for (size_t i = 1; i < 256; i++)
      C[i] = C[i - 1] + H[i];
  }

  // Do the thing
#pragma omp for
  for (size_t i = 0; i < height; i++)
    for (size_t j = 0; j < width; j++)
      px(i, j) = 255 * C[px(i, j)] / S;
  // Barrier

  return;
}