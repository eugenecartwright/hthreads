#!/bin/bash
cp ` find . -name "*.bit" ` .
mv config_1.bit vector.bit
mv config_3.bit crc.bit
mv config_2.bit sort.bit

mv config_1_hw_acc_1_vector_partial.bit vector0.bit
mv config_1_hw_acc_2_vector_partial.bit vector1.bit
mv config_1_hw_acc_3_vector_partial.bit vector2.bit
mv config_1_hw_acc_4_vector_partial.bit vector3.bit
mv config_1_hw_acc_5_vector_partial.bit vector4.bit
mv config_1_hw_acc_6_vector_partial.bit vector5.bit
mv config_2_hw_acc_1_sort_partial.bit sort0.bit
mv config_2_hw_acc_2_sort_partial.bit sort1.bit
mv config_2_hw_acc_3_sort_partial.bit sort2.bit
mv config_2_hw_acc_4_sort_partial.bit sort3.bit
mv config_2_hw_acc_5_sort_partial.bit sort4.bit
mv config_2_hw_acc_6_sort_partial.bit sort5.bit
mv config_3_hw_acc_1_crc_partial.bit  crc0.bit
mv config_3_hw_acc_2_crc_partial.bit  crc1.bit
mv config_3_hw_acc_3_crc_partial.bit  crc2.bit
mv config_3_hw_acc_4_crc_partial.bit  crc3.bit
mv config_3_hw_acc_5_crc_partial.bit  crc4.bit
mv config_3_hw_acc_6_crc_partial.bit  crc5.bit
