xxd -i -c 4 vector0.bit  vector0.h
xxd -i -c 4 vector1.bit  vector1.h
xxd -i -c 4 vector2.bit  vector2.h
xxd -i -c 4 vector3.bit  vector3.h
xxd -i -c 4 vector4.bit  vector4.h
xxd -i -c 4 vector5.bit  vector5.h


xxd -i -c 4 sort0.bit  sort0.h
xxd -i -c 4 sort1.bit  sort1.h
xxd -i -c 4 sort2.bit  sort2.h
xxd -i -c 4 sort3.bit  sort3.h
xxd -i -c 4 sort4.bit  sort4.h
xxd -i -c 4 sort5.bit  sort5.h


xxd -i -c 4 crc0.bit  crc0.h
xxd -i -c 4 crc1.bit  crc1.h
xxd -i -c 4 crc2.bit  crc2.h
xxd -i -c 4 crc3.bit  crc3.h
xxd -i -c 4 crc4.bit  crc4.h
xxd -i -c 4 crc5.bit  crc5.h


cat *.h > bit

rm *.h
mv bit bitstream.h
