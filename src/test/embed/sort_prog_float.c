unsigned char intermediate[] = {
  0xb8, 0x08, 0x00, 0x50,
  0x00, 0x00, 0x00, 0x00,
  0xb8, 0x08, 0x04, 0x78,
  0x00, 0x00, 0x00, 0x00,
  0xb8, 0x08, 0x04, 0x94,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0xb8, 0x08, 0x04, 0x90,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x31, 0xa0, 0x00, 0x00,
  0x30, 0x40, 0x00, 0x00,
  0x30, 0x20, 0x0b, 0x40,
  0xb9, 0xf4, 0x00, 0xc0,
  0x80, 0x00, 0x00, 0x00,
  0xb9, 0xf4, 0x01, 0xe4,
  0x30, 0xa3, 0x00, 0x00,
  0xb8, 0x00, 0x00, 0x00,
  0xe0, 0x60, 0x07, 0x28,
  0x30, 0x21, 0xff, 0xe4,
  0xf9, 0xe1, 0x00, 0x00,
  0xbc, 0x03, 0x00, 0x14,
  0xb8, 0x00, 0x00, 0x40,
  0xf8, 0x60, 0x06, 0x08,
  0x99, 0xfc, 0x20, 0x00,
  0x80, 0x00, 0x00, 0x00,
  0xe8, 0x60, 0x06, 0x08,
  0xe8, 0x83, 0x00, 0x00,
  0xbe, 0x24, 0xff, 0xec,
  0x30, 0x63, 0x00, 0x04,
  0xb0, 0x00, 0x00, 0x00,
  0x30, 0x60, 0x00, 0x00,
  0xbc, 0x03, 0x00, 0x10,
  0x30, 0xa0, 0x07, 0x20,
  0x99, 0xfc, 0x18, 0x00,
  0x80, 0x00, 0x00, 0x00,
  0x30, 0x60, 0x00, 0x01,
  0xf0, 0x60, 0x07, 0x28,
  0xe9, 0xe1, 0x00, 0x00,
  0xb6, 0x0f, 0x00, 0x08,
  0x30, 0x21, 0x00, 0x1c,
  0xb0, 0x00, 0x00, 0x00,
  0x30, 0x60, 0x00, 0x00,
  0x30, 0x21, 0xff, 0xe4,
  0xf9, 0xe1, 0x00, 0x00,
  0x30, 0xa0, 0x07, 0x20,
  0x30, 0xc0, 0x07, 0x2c,
  0xbc, 0x03, 0x00, 0x0c,
  0x99, 0xfc, 0x18, 0x00,
  0x80, 0x00, 0x00, 0x00,
  0xe8, 0x60, 0x07, 0x24,
  0xb0, 0x00, 0x00, 0x00,
  0x30, 0x80, 0x00, 0x00,
  0xbc, 0x03, 0x00, 0x14,
  0x30, 0xa0, 0x07, 0x24,
  0xbc, 0x04, 0x00, 0x0c,
  0x99, 0xfc, 0x20, 0x00,
  0x80, 0x00, 0x00, 0x00,
  0xe9, 0xe1, 0x00, 0x00,
  0xb6, 0x0f, 0x00, 0x08,
  0x30, 0x21, 0x00, 0x1c,
  0x20, 0x21, 0xff, 0xec,
  0xf9, 0xe1, 0x00, 0x00,
  0x20, 0xc0, 0x07, 0x28,
  0x20, 0xe0, 0x07, 0x28,
  0x06, 0x46, 0x38, 0x00,
  0xbc, 0x72, 0x00, 0x14,
  0xf8, 0x06, 0x00, 0x00,
  0x20, 0xc6, 0x00, 0x04,
  0x06, 0x46, 0x38, 0x00,
  0xbc, 0x92, 0xff, 0xf4,
  0x20, 0xc0, 0x07, 0x28,
  0x20, 0xe0, 0x07, 0x4c,
  0x06, 0x46, 0x38, 0x00,
  0xbc, 0x72, 0x00, 0x14,
  0xf8, 0x06, 0x00, 0x00,
  0x20, 0xc6, 0x00, 0x04,
  0x06, 0x46, 0x38, 0x00,
  0xbc, 0x92, 0xff, 0xf4,
  0xb9, 0xf4, 0x03, 0x24,
  0x80, 0x00, 0x00, 0x00,
  0xb9, 0xf4, 0x04, 0x4c,
  0x80, 0x00, 0x00, 0x00,
  0x20, 0xc0, 0x00, 0x00,
  0x20, 0xe0, 0x00, 0x00,
  0xb9, 0xf4, 0x00, 0xac,
  0x20, 0xa0, 0x00, 0x00,
  0x32, 0x63, 0x00, 0x00,
  0xb9, 0xf4, 0x04, 0x54,
  0x80, 0x00, 0x00, 0x00,
  0xb9, 0xf4, 0x02, 0xf0,
  0x80, 0x00, 0x00, 0x00,
  0xc9, 0xe1, 0x00, 0x00,
  0x30, 0x73, 0x00, 0x00,
  0xb6, 0x0f, 0x00, 0x08,
  0x20, 0x21, 0x00, 0x14,
  0x30, 0xc6, 0xff, 0xff,
  0x11, 0x46, 0x00, 0x00,
  0xbe, 0x06, 0x00, 0x48,
  0x11, 0x00, 0x00, 0x00,
  0x10, 0x85, 0x00, 0x00,
  0x11, 0x68, 0x00, 0x00,
  0xe9, 0x24, 0x00, 0x00,
  0xe8, 0xe4, 0x00, 0x04,
  0x58, 0x67, 0x4a, 0x40,
  0xbc, 0x03, 0x00, 0x14,
  0x11, 0x48, 0x00, 0x00,
  0x31, 0x60, 0x00, 0x01,
  0xf8, 0xe4, 0x00, 0x00,
  0xf9, 0x24, 0x00, 0x04,
  0x31, 0x08, 0x00, 0x01,
  0x16, 0x46, 0x40, 0x00,
  0xbe, 0x32, 0xff, 0xd8,
  0x30, 0x84, 0x00, 0x04,
  0xbe, 0x2b, 0xff, 0xc0,
  0x10, 0xca, 0x00, 0x00,
  0xb6, 0x0f, 0x00, 0x08,
  0x80, 0x00, 0x00, 0x00,
  0x30, 0x21, 0xff, 0xe4,
  0xf9, 0xe1, 0x00, 0x00,
  0xe8, 0xc5, 0x00, 0x04,
  0xe8, 0xa5, 0x00, 0x00,
  0xb9, 0xf4, 0xff, 0x98,
  0x80, 0x00, 0x00, 0x00,
  0xe9, 0xe1, 0x00, 0x00,
  0x30, 0x60, 0x00, 0xff,
  0xb6, 0x0f, 0x00, 0x08,
  0x30, 0x21, 0x00, 0x1c,
  0x30, 0x21, 0xff, 0xe4,
  0xf9, 0xe1, 0x00, 0x00,
  0xb9, 0xf4, 0xff, 0xd0,
  0x30, 0xa0, 0x00, 0x05,
  0xe9, 0xe1, 0x00, 0x00,
  0x10, 0x60, 0x00, 0x00,
  0xb6, 0x0f, 0x00, 0x08,
  0x30, 0x21, 0x00, 0x1c,
  0x30, 0x21, 0xff, 0xe0,
  0x10, 0xc0, 0x00, 0x00,
  0xfa, 0x61, 0x00, 0x1c,
  0xf9, 0xe1, 0x00, 0x00,
  0xb9, 0xf4, 0x00, 0x24,
  0x12, 0x65, 0x00, 0x00,
  0xe8, 0xa0, 0x05, 0xf8,
  0xe8, 0x65, 0x00, 0x28,
  0xbc, 0x03, 0x00, 0x0c,
  0x99, 0xfc, 0x18, 0x00,
  0x80, 0x00, 0x00, 0x00,
  0xb9, 0xf4, 0xfd, 0xf8,
  0x10, 0xb3, 0x00, 0x00,
  0xe8, 0x60, 0x05, 0xf8,
  0x30, 0x21, 0xff, 0xc8,
  0xfb, 0x41, 0x00, 0x30,
  0xfb, 0x61, 0x00, 0x34,
  0xf9, 0xe1, 0x00, 0x00,
  0xfa, 0x61, 0x00, 0x1c,
  0xfa, 0xc1, 0x00, 0x20,
  0xfa, 0xe1, 0x00, 0x24,
  0xfb, 0x01, 0x00, 0x28,
  0xfb, 0x21, 0x00, 0x2c,
  0xeb, 0x03, 0x00, 0x48,
  0x13, 0x65, 0x00, 0x00,
  0xbe, 0x18, 0x00, 0x50,
  0x13, 0x46, 0x00, 0x00,
  0xe8, 0x78, 0x00, 0x04,
  0xeb, 0x38, 0x00, 0x88,
  0x32, 0x63, 0xff, 0xff,
  0xbc, 0x53, 0x00, 0x3c,
  0x60, 0x93, 0x00, 0x04,
  0x30, 0x64, 0x00, 0x08,
  0x12, 0xd8, 0x18, 0x00,
  0xbe, 0x06, 0x00, 0x74,
  0x12, 0xf9, 0x20, 0x00,
  0xbc, 0x19, 0x00, 0xd4,
  0xe8, 0x77, 0x00, 0x80,
  0x16, 0x43, 0xd0, 0x00,
  0xbc, 0x12, 0x01, 0x00,
  0x32, 0x73, 0xff, 0xff,
  0x32, 0xf7, 0xff, 0xfc,
  0xaa, 0x53, 0xff, 0xff,
  0xbe, 0x32, 0xff, 0xe8,
  0x32, 0xd6, 0xff, 0xfc,
  0xe9, 0xe1, 0x00, 0x00,
  0xea, 0x61, 0x00, 0x1c,
  0xea, 0xc1, 0x00, 0x20,
  0xea, 0xe1, 0x00, 0x24,
  0xeb, 0x01, 0x00, 0x28,
  0xeb, 0x21, 0x00, 0x2c,
  0xeb, 0x41, 0x00, 0x30,
  0xeb, 0x61, 0x00, 0x34,
  0xb6, 0x0f, 0x00, 0x08,
  0x30, 0x21, 0x00, 0x38,
  0xe8, 0xb7, 0x00, 0x00,
  0x99, 0xfc, 0x38, 0x00,
  0x80, 0x00, 0x00, 0x00,
  0x32, 0x73, 0xff, 0xff,
  0x32, 0xf7, 0xff, 0xfc,
  0xaa, 0x53, 0xff, 0xff,
  0xbe, 0x12, 0xff, 0xc0,
  0x32, 0xd6, 0xff, 0xfc,
  0xe8, 0x78, 0x00, 0x04,
  0xe8, 0xf6, 0x00, 0x00,
  0x30, 0x63, 0xff, 0xff,
  0x16, 0x43, 0x98, 0x00,
  0xbc, 0x12, 0x00, 0x88,
  0xf8, 0x16, 0x00, 0x00,
  0xbc, 0x07, 0xff, 0xd4,
  0xbe, 0x19, 0x00, 0x6c,
  0x30, 0x80, 0x00, 0x01,
  0xe8, 0x79, 0x01, 0x00,
  0xa6, 0x53, 0x00, 0x1f,
  0xbe, 0x12, 0x00, 0x14,
  0x10, 0x84, 0x00, 0x00,
  0x32, 0x52, 0xff, 0xff,
  0xbe, 0x32, 0xff, 0xfc,
  0x10, 0x84, 0x20, 0x00,
  0x84, 0x64, 0x18, 0x00,
  0xbc, 0x03, 0x00, 0x44,
  0xe8, 0x79, 0x01, 0x04,
  0x84, 0x64, 0x18, 0x00,
  0xbc, 0x23, 0xff, 0x90,
  0xe8, 0xd7, 0x00, 0x00,
  0x99, 0xfc, 0x38, 0x00,
  0x10, 0xbb, 0x00, 0x00,
  0xb8, 0x10, 0xff, 0x90,
  0x32, 0x73, 0xff, 0xff,
  0x32, 0x73, 0xff, 0xff,
  0xaa, 0x53, 0xff, 0xff,
  0xbe, 0x12, 0xff, 0x48,
  0x32, 0x73, 0xff, 0xff,
  0xaa, 0x53, 0xff, 0xff,
  0xbe, 0x32, 0xff, 0xf0,
  0x32, 0x73, 0xff, 0xff,
  0xb8, 0x00, 0xff, 0x34,
  0x99, 0xfc, 0x38, 0x00,
  0x32, 0x73, 0xff, 0xff,
  0xb8, 0x10, 0xff, 0x64,
  0x32, 0xf7, 0xff, 0xfc,
  0xfa, 0x78, 0x00, 0x04,
  0xb8, 0x00, 0xff, 0x7c,
  0xe8, 0x78, 0x00, 0x04,
  0xe8, 0xf6, 0x00, 0x00,
  0x30, 0x63, 0xff, 0xff,
  0x16, 0x43, 0x98, 0x00,
  0xbc, 0x12, 0x00, 0x68,
  0xf8, 0x16, 0x00, 0x00,
  0xbc, 0x07, 0xfe, 0xec,
  0xbc, 0x19, 0x00, 0x4c,
  0xe8, 0x79, 0x01, 0x00,
  0x30, 0x80, 0x00, 0x01,
  0xa6, 0x53, 0x00, 0x1f,
  0xbe, 0x12, 0x00, 0x14,
  0x10, 0x84, 0x00, 0x00,
  0x32, 0x52, 0xff, 0xff,
  0xbe, 0x32, 0xff, 0xfc,
  0x10, 0x84, 0x20, 0x00,
  0x84, 0x64, 0x18, 0x00,
  0xbc, 0x03, 0x00, 0x24,
  0xe8, 0x79, 0x01, 0x04,
  0x84, 0x64, 0x18, 0x00,
  0xbc, 0x23, 0x00, 0x30,
  0xe8, 0xd7, 0x00, 0x00,
  0x99, 0xfc, 0x38, 0x00,
  0x10, 0xbb, 0x00, 0x00,
  0xb8, 0x10, 0xfe, 0xa8,
  0x32, 0x73, 0xff, 0xff,
  0x99, 0xfc, 0x38, 0x00,
  0x32, 0x73, 0xff, 0xff,
  0xb8, 0x10, 0xfe, 0x9c,
  0x32, 0xf7, 0xff, 0xfc,
  0xfa, 0x78, 0x00, 0x04,
  0xb8, 0x00, 0xff, 0x9c,
  0xe8, 0xb7, 0x00, 0x00,
  0x99, 0xfc, 0x38, 0x00,
  0x32, 0x73, 0xff, 0xff,
  0xb8, 0x10, 0xfe, 0x80,
  0x32, 0xf7, 0xff, 0xfc,
  0xb6, 0x11, 0x00, 0x00,
  0x80, 0x00, 0x00, 0x00,
  0xb6, 0x0f, 0x00, 0x08,
  0x80, 0x00, 0x00, 0x00,
  0xb6, 0x0f, 0x00, 0x08,
  0x80, 0x00, 0x00, 0x00,
  0xb8, 0x00, 0x00, 0x00,
  0x30, 0x21, 0xff, 0xb0,
  0xf9, 0xe1, 0x00, 0x00,
  0xf8, 0x61, 0x00, 0x20,
  0xf8, 0x81, 0x00, 0x24,
  0xf8, 0xa1, 0x00, 0x28,
  0xf8, 0xc1, 0x00, 0x2c,
  0xf8, 0xe1, 0x00, 0x30,
  0xf9, 0x01, 0x00, 0x34,
  0xf9, 0x21, 0x00, 0x38,
  0xf9, 0x41, 0x00, 0x3c,
  0xf9, 0x61, 0x00, 0x40,
  0xf9, 0x81, 0x00, 0x44,
  0xfa, 0x21, 0x00, 0x48,
  0x95, 0x60, 0x80, 0x01,
  0xe8, 0xa0, 0x07, 0x04,
  0xe8, 0x60, 0x07, 0x00,
  0xfa, 0x41, 0x00, 0x4c,
  0xf9, 0x61, 0x00, 0x1c,
  0x99, 0xfc, 0x18, 0x00,
  0x80, 0x00, 0x00, 0x00,
  0xe9, 0xe1, 0x00, 0x00,
  0xe9, 0x61, 0x00, 0x1c,
  0xe8, 0x61, 0x00, 0x20,
  0xe8, 0x81, 0x00, 0x24,
  0x94, 0x0b, 0xc0, 0x01,
  0xe8, 0xa1, 0x00, 0x28,
  0xe8, 0xc1, 0x00, 0x2c,
  0xe8, 0xe1, 0x00, 0x30,
  0xe9, 0x01, 0x00, 0x34,
  0xe9, 0x21, 0x00, 0x38,
  0xe9, 0x41, 0x00, 0x3c,
  0xe9, 0x61, 0x00, 0x40,
  0xe9, 0x81, 0x00, 0x44,
  0xea, 0x21, 0x00, 0x48,
  0xea, 0x41, 0x00, 0x4c,
  0xb6, 0x2e, 0x00, 0x00,
  0x30, 0x21, 0x00, 0x50,
  0xf8, 0xa0, 0x07, 0x00,
  0xf8, 0xc0, 0x07, 0x04,
  0xb6, 0x0f, 0x00, 0x08,
  0x80, 0x00, 0x00, 0x00,
  0xe8, 0x60, 0x07, 0x44,
  0x30, 0x21, 0xff, 0xe4,
  0xf9, 0xe1, 0x00, 0x00,
  0xbc, 0x03, 0x00, 0x0c,
  0x99, 0xfc, 0x18, 0x00,
  0x80, 0x00, 0x00, 0x00,
  0xe8, 0x60, 0x07, 0x08,
  0xbc, 0x23, 0x00, 0x00,
  0xe9, 0xe1, 0x00, 0x00,
  0xb6, 0x0f, 0x00, 0x08,
  0x30, 0x21, 0x00, 0x1c,
  0xf8, 0xa0, 0x07, 0x44,
  0xb6, 0x0f, 0x00, 0x08,
  0x80, 0x00, 0x00, 0x00,
  0xb6, 0x0f, 0x00, 0x08,
  0x80, 0x00, 0x00, 0x00,
  0xe8, 0x60, 0x07, 0x10,
  0x30, 0x21, 0xff, 0xe0,
  0xfa, 0x61, 0x00, 0x1c,
  0xf9, 0xe1, 0x00, 0x00,
  0x32, 0x60, 0x07, 0x10,
  0xaa, 0x43, 0xff, 0xff,
  0xbc, 0x12, 0x00, 0x18,
  0x99, 0xfc, 0x18, 0x00,
  0x32, 0x73, 0xff, 0xfc,
  0xe8, 0x73, 0x00, 0x00,
  0xaa, 0x43, 0xff, 0xff,
  0xbc, 0x32, 0xff, 0xf0,
  0xe9, 0xe1, 0x00, 0x00,
  0xea, 0x61, 0x00, 0x1c,
  0xb6, 0x0f, 0x00, 0x08,
  0x30, 0x21, 0x00, 0x20,
  0x30, 0x21, 0xff, 0xf8,
  0xd9, 0xe0, 0x08, 0x00,
  0xb9, 0xf4, 0xfb, 0x0c,
  0x80, 0x00, 0x00, 0x00,
  0xb9, 0xf4, 0xff, 0xb0,
  0x80, 0x00, 0x00, 0x00,
  0xc9, 0xe0, 0x08, 0x00,
  0xb6, 0x0f, 0x00, 0x08,
  0x30, 0x21, 0x00, 0x08,
  0x30, 0x21, 0xff, 0xf8,
  0xd9, 0xe0, 0x08, 0x00,
  0xb9, 0xf4, 0xfa, 0x8c,
  0x80, 0x00, 0x00, 0x00,
  0xc9, 0xe0, 0x08, 0x00,
  0xb6, 0x0f, 0x00, 0x08,
  0x30, 0x21, 0x00, 0x08,
  0x00, 0x00, 0x06, 0x10,
  0x43, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x07, 0x1c,
  0x00, 0x00, 0x06, 0x10,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x05, 0xfc,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x05, 0x70,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x01,
  0x00, 0x00, 0x00, 0x00,
  0xff, 0xff, 0xff, 0xff,
  0x00, 0x00, 0x00, 0x00,
  0xff, 0xff, 0xff, 0xff,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00
};
unsigned int intermediate_len = 1832;
unsigned int sort_handle_offset = 0x00000200;


// Code to copy:
//extern unsigned int sort_handle_offset;
//extern unsigned char intermediate[];
//unsigned int sort_handle = (sort_handle_offset) + (unsigned int)(&intermediate);
