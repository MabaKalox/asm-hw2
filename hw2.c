#include "matmul.h"
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int read_matrix(int **out_matrix, int *out_w, int *out_h) {
    int err = 0;
    int i;
    int *p;

    if (!out_matrix || !out_w || !out_h) {
        return 1;
    }

    if (scanf("%d %d", out_h, out_w) != 2) {
        err = 2;
        goto exit;
    }

    *out_matrix = malloc((*out_w) * (*out_h) * sizeof(int));
    if (!(*out_matrix)) {
        err = 3;
        goto exit;
    }

    p = *out_matrix;
    for (i = 0; i < (*out_w) * (*out_h); i++, p++) {
        if (scanf(" %d", p) != 1) {
            err = 4;
            goto exit;
        }
    }

exit:
    if (err) {
        free(*out_matrix);
        *out_matrix = NULL;
        *out_h = 0;
        *out_w = 0;
    }

    return err;
}

void pretty_print(const int *matrix, int w, int h) {
    int i, j;
    for (j = 0; j < h; j++) {
        for (i = 0; i < w; i++) {
            fprintf(stderr, "%d ", *(matrix + j * w + i));
        }
        fprintf(stderr, "\n");
    }
}

int main(void) {
    int err = 0;
    int w1, h1 = 0;
    int w2, h2 = 0;
    int out_w, out_h = 0;

    int *matrix1 = NULL;
    int *matrix2 = NULL;
    int *out_matrix = NULL;

    err = read_matrix(&matrix1, &w1, &h1);
    if (err) {
        goto exit;
    }

    err = read_matrix(&matrix2, &w2, &h2);
    if (err) {
        goto exit;
    }

    // Read out all trailing whitespaces
    int ch;
    while ((ch = getchar()) != EOF) {
        if (!isspace((char) ch)) {
            // If before reaching EOF, we found non whitespace char,
            // probably input is malformed, e.g. matrices are bigger
            // then supplied dimensions.
            err = 5;
            goto exit;
        }
    }

//    pretty_print(matrix1, w1, h1);
//    pretty_print(matrix2, w2, h2);

    // Check if multiplication defined for given matrices
    if (w1 != h2) {
        err = 6;
        goto exit;
    }

    out_w = w2;
    out_h = h1;
    out_matrix = malloc(out_w * out_h * sizeof(int));
    if (!out_matrix) {
        err = 7;
        goto exit;
    }

    err = matmul(h1, w1, matrix1, h2, w2, matrix2, out_matrix);
exit:
    if (!err) {
        // print result
        printf("%d %d", out_h, out_w);
        int i;
        for (i = 0; i < out_w * out_h; i++) {
            printf(" %d", out_matrix[i]);
        }
    } else {
        printf("1");
    }
    free(matrix1);
    free(matrix2);
    free(out_matrix);

    return err;
}
