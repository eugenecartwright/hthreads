














































































env /bfm_system/bfm_memory/bfm_memory/slave/slave/
force -deposit ssize_mode 2#110

force -deposit fixed_burst_mode  1

force -deposit pipeline_mode(0)  1

force -deposit pipeline_mode(1)  1

force -deposit pipeline_mode(1)  1

force -deposit burst_term_mode 0

env /bfm_system/bfm_memory/bfm_memory/slave/slave/read_req_cmd
change read_cmd(24:31)  2#00000001
env /bfm_system/bfm_memory/bfm_memory/slave/slave/write_req_cmd
change write_cmd(24:31)  2#00000001


env /bfm_system/bfm_memory/bfm_memory/slave/slave/slave_mem
change plb_slave_addr_array(0)  16#0000000010000001
change plb_slave_data_array(0)(0:127) 16#000102030405060708090a0b0c0d0e0f

change plb_slave_addr_array(1)  16#0000000010000011
change plb_slave_data_array(1)(0:127) 16#101112131415161718191a1b1c1d1e1f

change plb_slave_addr_array(2)  16#0000000010000021
change plb_slave_data_array(2)(0:127) 16#202122232425262728292a2b2c2d2e2f

change plb_slave_addr_array(3)  16#0000000010000031
change plb_slave_data_array(3)(0:127) 16#303132333435363738393a3b3c3d3e3f

change plb_slave_addr_array(4)  16#0000000010000041
change plb_slave_data_array(4)(0:127) 16#404142434445464748494a4b4c4d4e4f

change plb_slave_addr_array(5)  16#0000000010000051
change plb_slave_data_array(5)(0:127) 16#505152535455565758595a5b5c5d5e5f

change plb_slave_addr_array(6)  16#0000000010000061
change plb_slave_data_array(6)(0:127) 16#606162636465666768696a6b6c6d6e6f

change plb_slave_addr_array(7)  16#0000000010000071
change plb_slave_data_array(7)(0:127) 16#707172737475767778797a7b7c7d7e7f

change plb_slave_addr_array(8)  16#0000000010000081
change plb_slave_data_array(8)(0:127) 16#808182838485868788898a8b8c8d8e8f

change plb_slave_addr_array(9)  16#0000000010000091
change plb_slave_data_array(9)(0:127) 16#909192939495969798999a9b9c9d9e9f

change plb_slave_addr_array(10)  16#00000000100000A1
change plb_slave_data_array(10)(0:127) 16#a0a1a2a3a4a5a6a7a8a9aaabacadaeaf

change plb_slave_addr_array(11)  16#00000000100000B1
change plb_slave_data_array(11)(0:127) 16#b0b1b2b3b4b5b6b7b8b9babbbcbdbebf

change plb_slave_addr_array(12)  16#00000000100000C1
change plb_slave_data_array(12)(0:127) 16#c0c1c2c3c4c5c6c7c8c9cacbcccdcecf

change plb_slave_addr_array(13)  16#00000000100000D1
change plb_slave_data_array(13)(0:127) 16#d0d1d2d3d4d5d6d7d8d9dadbdcdddedf

change plb_slave_addr_array(14)  16#00000000100000E1
change plb_slave_data_array(14)(0:127) 16#e0e1e2e3e4e5e6e7e8e9eaebecedeeef

change plb_slave_addr_array(15)  16#00000000100000F1
change plb_slave_data_array(15)(0:127) 16#f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff

change plb_slave_addr_array(16)  16#0000000020000001
change plb_slave_data_array(16)(0:127) 16#deadbeefdeadbeefdeadbeefdeadbeef

change plb_slave_addr_array(17)  16#0000000020000011
change plb_slave_data_array(17)(0:127) 16#deadbeefdeadbeefdeadbeefdeadbeef

change plb_slave_addr_array(18)  16#0000000020000021
change plb_slave_data_array(18)(0:127) 16#deadbeefdeadbeefdeadbeefdeadbeef

change plb_slave_addr_array(19)  16#0000000020000031
change plb_slave_data_array(19)(0:127) 16#deadbeefdeadbeefdeadbeefdeadbeef

change plb_slave_addr_array(20)  16#0000000020000041
change plb_slave_data_array(20)(0:127) 16#deadbeefdeadbeefdeadbeefdeadbeef

change plb_slave_addr_array(21)  16#0000000020000051
change plb_slave_data_array(21)(0:127) 16#deadbeefdeadbeefdeadbeefdeadbeef

change plb_slave_addr_array(22)  16#0000000020000061
change plb_slave_data_array(22)(0:127) 16#deadbeefdeadbeefdeadbeefdeadbeef

change plb_slave_addr_array(23)  16#0000000020000071
change plb_slave_data_array(23)(0:127) 16#deadbeefdeadbeefdeadbeefdeadbeef

change plb_slave_addr_array(24)  16#0000000020000081
change plb_slave_data_array(24)(0:127) 16#deadbeefdeadbeefdeadbeefdeadbeef

change plb_slave_addr_array(25)  16#0000000020000091
change plb_slave_data_array(25)(0:127) 16#deadbeefdeadbeefdeadbeefdeadbeef

change plb_slave_addr_array(26)  16#00000000200000A1
change plb_slave_data_array(26)(0:127) 16#deadbeefdeadbeefdeadbeefdeadbeef

change plb_slave_addr_array(27)  16#00000000200000B1
change plb_slave_data_array(27)(0:127) 16#deadbeefdeadbeefdeadbeefdeadbeef

change plb_slave_addr_array(28)  16#00000000200000C1
change plb_slave_data_array(28)(0:127) 16#deadbeefdeadbeefdeadbeefdeadbeef

change plb_slave_addr_array(29)  16#00000000200000D1
change plb_slave_data_array(29)(0:127) 16#deadbeefdeadbeefdeadbeefdeadbeef

change plb_slave_addr_array(30)  16#00000000200000E1
change plb_slave_data_array(30)(0:127) 16#deadbeefdeadbeefdeadbeefdeadbeef

change plb_slave_addr_array(31)  16#00000000200000F1
change plb_slave_data_array(31)(0:127) 16#deadbeefdeadbeefdeadbeefdeadbeef


env /bfm_system/bfm_processor/bfm_processor/master/master/
force -deposit msize_mode 2#110

env /bfm_system/bfm_processor/bfm_processor/master/master/decoder
change cmd0_array(0)(0:3) 2#0101
change addr_array(0)(33)  1

change cmd0_array(1)(0:3) 2#0110
change addr_array(1)  16#0000000030000000
change cmd1_array(1)(11:12)  2#11
change data_array(1)(0:31) 16#13131313
change be_array(1)(0:3)  2#1111

change cmd0_array(2)(0:3) 2#0010
change addr_array(2)  16#0000000030000000
change cmd0_array(2)(4:7)  2#0000
change be_array(2)(0:15)  2#1111000000000000

change cmd0_array(3)(0:3) 2#0001
change addr_array(3)  16#0000000030000000
change cmd0_array(3)(4:7)  2#0000
change be_array(3)(0:15)  2#1111000000000000

change cmd0_array(4)(0:3) 2#0100
change addr_array(4)(34)  1

env /
