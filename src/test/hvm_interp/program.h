#define  prog_size  384
unsigned char program_array[prog_size] = {
0x15, 0xc0, 0x00, 0x00,
0x14, 0xc0, 0x01, 0x80,
0x15, 0xb0, 0x00, 0x00,
0x14, 0xb0, 0x00, 0x00,
0x15, 0xb1, 0x00, 0x00,
0x14, 0xb1, 0x00, 0x01,
0x15, 0xb2, 0xff, 0xff,
0x14, 0xb2, 0xff, 0xff,
0x15, 0xb3, 0x00, 0x00,
0x14, 0xb3, 0x00, 0x0c,
0x15, 0xb7, 0x00, 0x00,
0x14, 0xb7, 0x00, 0x10,
0x15, 0xb4, 0xff, 0xff,
0x14, 0xb4, 0xff, 0xfc,
0x15, 0xb5, 0x00, 0x00,
0x14, 0xb5, 0x00, 0x04,
0x15, 0xb6, 0x80, 0x00,
0x14, 0xb6, 0x00, 0x00,
0x15, 0xc1, 0xff, 0xff,
0x14, 0xc1, 0xff, 0xff,
0x15, 0xd0, 0x00, 0x00,
0x14, 0xd0, 0x01, 0x2c,
0x11, 0xb0, 0xd0, 0x00,
0x13, 0x00, 0xc0, 0xb0,
0x00, 0xc0, 0xc0, 0xb5,
0x13, 0x01, 0xc0, 0xb0,
0x00, 0xc0, 0xc0, 0xb5,
0x13, 0x02, 0xc0, 0xb0,
0x00, 0xc0, 0xc0, 0xb5,
0x15, 0xd1, 0xff, 0xff,
0x14, 0xd1, 0xff, 0xec,
0x12, 0x02, 0xc0, 0xd1,
0x15, 0xd3, 0x00, 0x00,
0x14, 0xd3, 0x00, 0x00,
0x15, 0xd0, 0x00, 0x00,
0x14, 0xd0, 0x00, 0xa8,
0x01, 0xd1, 0xd3, 0x02,
0x03, 0xd1, 0xd1, 0xb6,
0x11, 0xd1, 0xd0, 0x00,
0x15, 0xd0, 0x00, 0x00,
0x14, 0xd0, 0x00, 0xc0,
0x11, 0xb0, 0xd0, 0x00,
0x15, 0xd3, 0x00, 0x00,
0x14, 0xd3, 0x00, 0x01,
0x00, 0x00, 0xb0, 0xd3,
0x15, 0xd0, 0x00, 0x00,
0x14, 0xd0, 0x01, 0x0c,
0x11, 0xb0, 0xd0, 0x00,
0x15, 0xd3, 0x00, 0x00,
0x14, 0xd3, 0x00, 0x01,
0x00, 0x00, 0xb0, 0xd3,
0x15, 0xd3, 0x00, 0x00,
0x14, 0xd3, 0x00, 0x01,
0x00, 0x01, 0xb0, 0xd3,
0x02, 0x00, 0x00, 0x01,
0x15, 0xd3, 0x00, 0x00,
0x14, 0xd3, 0x00, 0x01,
0x00, 0x01, 0x01, 0xd3,
0x15, 0xd0, 0x00, 0x00,
0x14, 0xd0, 0x01, 0x0c,
0x00, 0xd1, 0x02, 0xb1,
0x01, 0xd2, 0x01, 0xd1,
0x03, 0xd2, 0xd2, 0xb6,
0x11, 0xd2, 0xd0, 0x00,
0x15, 0xd0, 0x00, 0x00,
0x14, 0xd0, 0x00, 0xd8,
0x11, 0xb0, 0xd0, 0x00,
0x00, 0xc2, 0x00, 0xb0,
0x12, 0x02, 0xc0, 0xb4,
0x00, 0xc0, 0xc0, 0xb4,
0x12, 0x01, 0xc0, 0xb4,
0x00, 0xc0, 0xc0, 0xb4,
0x12, 0x00, 0xc0, 0xb4,
0x00, 0xc0, 0xc0, 0xb4,
0x11, 0xb0, 0xc1, 0x00,
0x13, 0x00, 0xc0, 0xb0,
0x00, 0xc0, 0xc0, 0xb5,
0x15, 0xd1, 0x00, 0x00,
0x14, 0xd1, 0x00, 0x05,
0x13, 0xd1, 0xc0, 0xb0,
0x00, 0xc0, 0xc0, 0xb5,
0x13, 0xc1, 0xc0, 0xb0,
0x00, 0xc0, 0xc0, 0xb5,
0x00, 0xc1, 0xc3, 0xb7,
0x15, 0xd0, 0x00, 0x00,
0x14, 0xd0, 0x00, 0x5c,
0x11, 0xb0, 0xd0, 0x00,
0x12, 0xc1, 0xc0, 0xb4,
0x15, 0xd1, 0x00, 0x00,
0x14, 0xd1, 0x00, 0x08,
0x01, 0xc0, 0xc0, 0xd1,
0x00, 0x00, 0xc2, 0xb0,
0x00, 0xc2, 0x00, 0xb0,
0x12, 0x00, 0xc0, 0xb4,
0x00, 0xc0, 0xc0, 0xb4,
0x11, 0xb0, 0xc1, 0x00};
