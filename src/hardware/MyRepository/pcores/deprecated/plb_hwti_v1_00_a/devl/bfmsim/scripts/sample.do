


























































































































































































































































































































































































































env /bfm_system/bfm_memory/bfm_memory/slave/slave/
force -deposit ssize_mode 2#101
force -deposit fixed_burst_mode  1


env /bfm_system/bfm_processor/bfm_processor/master/master/
force -deposit msize_mode 2#101

env /bfm_system/bfm_processor/bfm_processor/master/master/decoder
change cmd0_array(0)(0:3) 2#0101
change addr_array(0)(33)  1

change cmd0_array(1)(0:3) 2#0110
change addr_array(1)  16#0000000010000000
change cmd1_array(1)(11:12)  2#11
change data_array(1)(0:63) 16#0000000000000001
change be_array(1)(0:7)  2#11111111

change cmd0_array(2)(0:3) 2#0110
change addr_array(2)  16#0000000010000008
change cmd1_array(2)(11:12)  2#11
change data_array(2)(64:127) 16#0000000200000003
change be_array(2)(8:15)  2#11111111

change cmd0_array(3)(0:3) 2#0110
change addr_array(3)  16#0000000010000010
change cmd1_array(3)(11:12)  2#11
change data_array(3)(0:63) 16#0000000400000005
change be_array(3)(0:7)  2#11111111

change cmd0_array(4)(0:3) 2#0110
change addr_array(4)  16#0000000010000018
change cmd1_array(4)(11:12)  2#11
change data_array(4)(64:127) 16#0000000600000007
change be_array(4)(8:15)  2#11111111

change cmd0_array(5)(0:3) 2#0110
change addr_array(5)  16#0000000010000020
change cmd1_array(5)(11:12)  2#11
change data_array(5)(0:63) 16#0000000800000009
change be_array(5)(0:7)  2#11111111

change cmd0_array(6)(0:3) 2#0110
change addr_array(6)  16#0000000010000028
change cmd1_array(6)(11:12)  2#11
change data_array(6)(64:127) 16#0000000a0000000b
change be_array(6)(8:15)  2#11111111

change cmd0_array(7)(0:3) 2#0110
change addr_array(7)  16#0000000010000030
change cmd1_array(7)(11:12)  2#11
change data_array(7)(0:63) 16#0000000c0000000d
change be_array(7)(0:7)  2#11111111

change cmd0_array(8)(0:3) 2#0110
change addr_array(8)  16#0000000010000038
change cmd1_array(8)(11:12)  2#11
change data_array(8)(64:127) 16#0000000e0000000f
change be_array(8)(8:15)  2#11111111

change cmd0_array(9)(0:3) 2#0110
change addr_array(9)  16#0000000010000040
change cmd1_array(9)(11:12)  2#11
change data_array(9)(0:63) 16#0000001000000011
change be_array(9)(0:7)  2#11111111

change cmd0_array(10)(0:3) 2#0110
change addr_array(10)  16#0000000010000048
change cmd1_array(10)(11:12)  2#11
change data_array(10)(64:127) 16#0000001200000013
change be_array(10)(8:15)  2#11111111

change cmd0_array(11)(0:3) 2#0110
change addr_array(11)  16#0000000010000050
change cmd1_array(11)(11:12)  2#11
change data_array(11)(0:63) 16#0000001400000015
change be_array(11)(0:7)  2#11111111

change cmd0_array(12)(0:3) 2#0110
change addr_array(12)  16#0000000010000058
change cmd1_array(12)(11:12)  2#11
change data_array(12)(64:127) 16#0000001600000017
change be_array(12)(8:15)  2#11111111

change cmd0_array(13)(0:3) 2#0110
change addr_array(13)  16#0000000010000060
change cmd1_array(13)(11:12)  2#11
change data_array(13)(0:63) 16#0000001800000019
change be_array(13)(0:7)  2#11111111

change cmd0_array(14)(0:3) 2#0110
change addr_array(14)  16#0000000010000068
change cmd1_array(14)(11:12)  2#11
change data_array(14)(64:127) 16#0000001a0000001b
change be_array(14)(8:15)  2#11111111

change cmd0_array(15)(0:3) 2#0110
change addr_array(15)  16#0000000010000070
change cmd1_array(15)(11:12)  2#11
change data_array(15)(0:63) 16#0000001c0000001d
change be_array(15)(0:7)  2#11111111

change cmd0_array(16)(0:3) 2#0110
change addr_array(16)  16#0000000010000078
change cmd1_array(16)(11:12)  2#11
change data_array(16)(64:127) 16#0000001e0000001f
change be_array(16)(8:15)  2#11111111

change cmd0_array(17)(0:3) 2#0110
change addr_array(17)  16#0000000010000080
change cmd1_array(17)(11:12)  2#11
change data_array(17)(0:63) 16#0000002000000021
change be_array(17)(0:7)  2#11111111

change cmd0_array(18)(0:3) 2#0110
change addr_array(18)  16#0000000010000088
change cmd1_array(18)(11:12)  2#11
change data_array(18)(64:127) 16#0000002200000023
change be_array(18)(8:15)  2#11111111

change cmd0_array(19)(0:3) 2#0110
change addr_array(19)  16#0000000010000090
change cmd1_array(19)(11:12)  2#11
change data_array(19)(0:63) 16#0000002400000025
change be_array(19)(0:7)  2#11111111

change cmd0_array(20)(0:3) 2#0110
change addr_array(20)  16#0000000010000098
change cmd1_array(20)(11:12)  2#11
change data_array(20)(64:127) 16#0000002600000027
change be_array(20)(8:15)  2#11111111

change cmd0_array(21)(0:3) 2#0110
change addr_array(21)  16#00000000100000a0
change cmd1_array(21)(11:12)  2#11
change data_array(21)(0:63) 16#0000002800000029
change be_array(21)(0:7)  2#11111111

change cmd0_array(22)(0:3) 2#0110
change addr_array(22)  16#00000000100000a8
change cmd1_array(22)(11:12)  2#11
change data_array(22)(64:127) 16#0000002a0000002b
change be_array(22)(8:15)  2#11111111

change cmd0_array(23)(0:3) 2#0110
change addr_array(23)  16#00000000100000b0
change cmd1_array(23)(11:12)  2#11
change data_array(23)(0:63) 16#0000002c0000002d
change be_array(23)(0:7)  2#11111111

change cmd0_array(24)(0:3) 2#0110
change addr_array(24)  16#00000000100000b8
change cmd1_array(24)(11:12)  2#11
change data_array(24)(64:127) 16#0000002e0000002f
change be_array(24)(8:15)  2#11111111

change cmd0_array(25)(0:3) 2#0110
change addr_array(25)  16#00000000100000c0
change cmd1_array(25)(11:12)  2#11
change data_array(25)(0:63) 16#0000003000000031
change be_array(25)(0:7)  2#11111111

change cmd0_array(26)(0:3) 2#0110
change addr_array(26)  16#00000000100000c8
change cmd1_array(26)(11:12)  2#11
change data_array(26)(64:127) 16#0000003200000033
change be_array(26)(8:15)  2#11111111

change cmd0_array(27)(0:3) 2#0110
change addr_array(27)  16#00000000100000d0
change cmd1_array(27)(11:12)  2#11
change data_array(27)(0:63) 16#0000003400000035
change be_array(27)(0:7)  2#11111111

change cmd0_array(28)(0:3) 2#0110
change addr_array(28)  16#00000000100000d8
change cmd1_array(28)(11:12)  2#11
change data_array(28)(64:127) 16#0000003600000037
change be_array(28)(8:15)  2#11111111

change cmd0_array(29)(0:3) 2#0110
change addr_array(29)  16#00000000100000e0
change cmd1_array(29)(11:12)  2#11
change data_array(29)(0:63) 16#0000003800000039
change be_array(29)(0:7)  2#11111111

change cmd0_array(30)(0:3) 2#0110
change addr_array(30)  16#00000000100000e8
change cmd1_array(30)(11:12)  2#11
change data_array(30)(64:127) 16#0000003a0000003b
change be_array(30)(8:15)  2#11111111

change cmd0_array(31)(0:3) 2#0110
change addr_array(31)  16#00000000100000f0
change cmd1_array(31)(11:12)  2#11
change data_array(31)(0:63) 16#0000003c0000003d
change be_array(31)(0:7)  2#11111111

change cmd0_array(32)(0:3) 2#0110
change addr_array(32)  16#00000000100000f8
change cmd1_array(32)(11:12)  2#11
change data_array(32)(64:127) 16#0000003e0000003f
change be_array(32)(8:15)  2#11111111

change cmd0_array(33)(0:3) 2#0010
change addr_array(33)  16#0000000010000000
change cmd0_array(33)(4:7)  2#0000
change be_array(33)(0:7)  2#11111111

change cmd0_array(34)(0:3) 2#0010
change addr_array(34)  16#0000000010000008
change cmd0_array(34)(4:7)  2#0000
change be_array(34)(0:7)  2#11111111

change cmd0_array(35)(0:3) 2#0010
change addr_array(35)  16#0000000010000010
change cmd0_array(35)(4:7)  2#0000
change be_array(35)(0:7)  2#11111111

change cmd0_array(36)(0:3) 2#0010
change addr_array(36)  16#0000000010000018
change cmd0_array(36)(4:7)  2#0000
change be_array(36)(0:7)  2#11111111

change cmd0_array(37)(0:3) 2#0010
change addr_array(37)  16#0000000010000020
change cmd0_array(37)(4:7)  2#0000
change be_array(37)(0:7)  2#11111111

change cmd0_array(38)(0:3) 2#0010
change addr_array(38)  16#0000000010000028
change cmd0_array(38)(4:7)  2#0000
change be_array(38)(0:7)  2#11111111

change cmd0_array(39)(0:3) 2#0010
change addr_array(39)  16#0000000010000030
change cmd0_array(39)(4:7)  2#0000
change be_array(39)(0:7)  2#11111111

change cmd0_array(40)(0:3) 2#0010
change addr_array(40)  16#0000000010000038
change cmd0_array(40)(4:7)  2#0000
change be_array(40)(0:7)  2#11111111

change cmd0_array(41)(0:3) 2#0010
change addr_array(41)  16#0000000010000040
change cmd0_array(41)(4:7)  2#0000
change be_array(41)(0:7)  2#11111111

change cmd0_array(42)(0:3) 2#0010
change addr_array(42)  16#0000000010000048
change cmd0_array(42)(4:7)  2#0000
change be_array(42)(0:7)  2#11111111

change cmd0_array(43)(0:3) 2#0010
change addr_array(43)  16#0000000010000050
change cmd0_array(43)(4:7)  2#0000
change be_array(43)(0:7)  2#11111111

change cmd0_array(44)(0:3) 2#0010
change addr_array(44)  16#0000000010000058
change cmd0_array(44)(4:7)  2#0000
change be_array(44)(0:7)  2#11111111

change cmd0_array(45)(0:3) 2#0010
change addr_array(45)  16#0000000010000060
change cmd0_array(45)(4:7)  2#0000
change be_array(45)(0:7)  2#11111111

change cmd0_array(46)(0:3) 2#0010
change addr_array(46)  16#0000000010000068
change cmd0_array(46)(4:7)  2#0000
change be_array(46)(0:7)  2#11111111

change cmd0_array(47)(0:3) 2#0010
change addr_array(47)  16#0000000010000070
change cmd0_array(47)(4:7)  2#0000
change be_array(47)(0:7)  2#11111111

change cmd0_array(48)(0:3) 2#0010
change addr_array(48)  16#0000000010000078
change cmd0_array(48)(4:7)  2#0000
change be_array(48)(0:7)  2#11111111

change cmd0_array(49)(0:3) 2#0010
change addr_array(49)  16#0000000010000080
change cmd0_array(49)(4:7)  2#0000
change be_array(49)(0:7)  2#11111111

change cmd0_array(50)(0:3) 2#0010
change addr_array(50)  16#0000000010000088
change cmd0_array(50)(4:7)  2#0000
change be_array(50)(0:7)  2#11111111

change cmd0_array(51)(0:3) 2#0010
change addr_array(51)  16#0000000010000090
change cmd0_array(51)(4:7)  2#0000
change be_array(51)(0:7)  2#11111111

change cmd0_array(52)(0:3) 2#0010
change addr_array(52)  16#0000000010000098
change cmd0_array(52)(4:7)  2#0000
change be_array(52)(0:7)  2#11111111

change cmd0_array(53)(0:3) 2#0010
change addr_array(53)  16#00000000100000a0
change cmd0_array(53)(4:7)  2#0000
change be_array(53)(0:7)  2#11111111

change cmd0_array(54)(0:3) 2#0010
change addr_array(54)  16#00000000100000a8
change cmd0_array(54)(4:7)  2#0000
change be_array(54)(0:7)  2#11111111

change cmd0_array(55)(0:3) 2#0010
change addr_array(55)  16#00000000100000b0
change cmd0_array(55)(4:7)  2#0000
change be_array(55)(0:7)  2#11111111

change cmd0_array(56)(0:3) 2#0010
change addr_array(56)  16#00000000100000b8
change cmd0_array(56)(4:7)  2#0000
change be_array(56)(0:7)  2#11111111

change cmd0_array(57)(0:3) 2#0010
change addr_array(57)  16#00000000100000c0
change cmd0_array(57)(4:7)  2#0000
change be_array(57)(0:7)  2#11111111

change cmd0_array(58)(0:3) 2#0010
change addr_array(58)  16#00000000100000c8
change cmd0_array(58)(4:7)  2#0000
change be_array(58)(0:7)  2#11111111

change cmd0_array(59)(0:3) 2#0010
change addr_array(59)  16#00000000100000d0
change cmd0_array(59)(4:7)  2#0000
change be_array(59)(0:7)  2#11111111

change cmd0_array(60)(0:3) 2#0010
change addr_array(60)  16#00000000100000d8
change cmd0_array(60)(4:7)  2#0000
change be_array(60)(0:7)  2#11111111

change cmd0_array(61)(0:3) 2#0010
change addr_array(61)  16#00000000100000e0
change cmd0_array(61)(4:7)  2#0000
change be_array(61)(0:7)  2#11111111

change cmd0_array(62)(0:3) 2#0010
change addr_array(62)  16#00000000100000e8
change cmd0_array(62)(4:7)  2#0000
change be_array(62)(0:7)  2#11111111

change cmd0_array(63)(0:3) 2#0010
change addr_array(63)  16#00000000100000f0
change cmd0_array(63)(4:7)  2#0000
change be_array(63)(0:7)  2#11111111

change cmd0_array(64)(0:3) 2#0010
change addr_array(64)  16#00000000100000f8
change cmd0_array(64)(4:7)  2#0000
change be_array(64)(0:7)  2#11111111

change cmd0_array(65)(0:3) 2#0100
change addr_array(65)(34)  1

change cmd0_array(66)(0:3) 2#0101
change addr_array(66)(33)  1

change cmd0_array(67)(0:3) 2#0110
change addr_array(67)  16#0000000060005c00
change cmd1_array(67)(11:12)  2#11
change data_array(67)(0:31) 16#ffffffff
change be_array(67)(0:3)  2#1111

change cmd0_array(68)(0:3) 2#0110
change addr_array(68)  16#000000006100005c
change cmd1_array(68)(11:12)  2#11
change data_array(68)(96:127) 16#0000007f
change be_array(68)(12:15)  2#1111

change cmd0_array(69)(0:3) 2#0110
change addr_array(69)  16#0000000060005400
change cmd1_array(69)(11:12)  2#11
change data_array(69)(0:31) 16#ffffffff
change be_array(69)(0:3)  2#1111

change cmd0_array(70)(0:3) 2#0010
change addr_array(70)  16#0000000060005c00
change cmd0_array(70)(4:7)  2#0000
change be_array(70)(0:7)  2#11110000

change cmd0_array(71)(0:3) 2#0010
change addr_array(71)  16#0000000060005400
change cmd0_array(71)(4:7)  2#0000
change be_array(71)(0:7)  2#11110000

change cmd0_array(72)(0:3) 2#0001
change addr_array(72)  16#0000000060001800
change cmd0_array(72)(4:7)  2#0000
change be_array(72)(0:7)  2#11110000

change cmd0_array(73)(0:3) 2#0010
change addr_array(73)  16#000000006100005c
change cmd0_array(73)(4:7)  2#0000
change be_array(73)(0:7)  2#00001111

change cmd0_array(74)(0:3) 2#0001
change addr_array(74)  16#0000000060001000
change cmd0_array(74)(4:7)  2#0000
change be_array(74)(0:7)  2#11110000

change cmd0_array(75)(0:3) 2#0001
change addr_array(75)  16#0000000060002000
change cmd0_array(75)(4:7)  2#0000
change be_array(75)(0:7)  2#11110000

change cmd0_array(76)(0:3) 2#0001
change addr_array(76)  16#0000000060001800
change cmd0_array(76)(4:7)  2#0000
change be_array(76)(0:7)  2#11110000

change cmd0_array(77)(0:3) 2#0001
change addr_array(77)  16#0000000061000054
change cmd0_array(77)(4:7)  2#0000
change be_array(77)(0:7)  2#00001111

change cmd0_array(78)(0:3) 2#0100
change addr_array(78)(34)  1

change cmd0_array(79)(0:3) 2#0101
change addr_array(79)(33)  1

change cmd0_array(80)(0:3) 2#0110
change addr_array(80)  16#000000006100025c
change cmd1_array(80)(11:12)  2#11
change data_array(80)(96:127) 16#3000000c
change be_array(80)(12:15)  2#1111

change cmd0_array(81)(0:3) 2#0110
change addr_array(81)  16#000000003000000c
change cmd1_array(81)(11:12)  2#11
change data_array(81)(96:127) 16#00000002
change be_array(81)(12:15)  2#1111

change cmd0_array(82)(0:3) 2#0110
change addr_array(82)  16#0000000030000000
change cmd1_array(82)(11:12)  2#11
change data_array(82)(0:31) 16#00000002
change be_array(82)(0:3)  2#1111

change cmd0_array(83)(0:3) 2#0110
change addr_array(83)  16#0000000030000010
change cmd1_array(83)(11:12)  2#11
change data_array(83)(0:31) 16#10000000
change be_array(83)(0:3)  2#1111

change cmd0_array(84)(0:3) 2#0001
change addr_array(84)  16#0000000060001400
change cmd0_array(84)(4:7)  2#0000
change be_array(84)(0:7)  2#11110000

change cmd0_array(85)(0:3) 2#0010
change addr_array(85)  16#000000006100025c
change cmd0_array(85)(4:7)  2#0000
change be_array(85)(0:7)  2#00001111

change cmd0_array(86)(0:3) 2#0010
change addr_array(86)  16#000000003000000c
change cmd0_array(86)(4:7)  2#0000
change be_array(86)(0:7)  2#00001111

change cmd0_array(87)(0:3) 2#0010
change addr_array(87)  16#0000000030000000
change cmd0_array(87)(4:7)  2#0000
change be_array(87)(0:7)  2#11110000

change cmd0_array(88)(0:3) 2#0010
change addr_array(88)  16#0000000030000010
change cmd0_array(88)(4:7)  2#0000
change be_array(88)(0:7)  2#11110000

change cmd0_array(89)(0:3) 2#0001
change addr_array(89)  16#0000000060001008
change cmd0_array(89)(4:7)  2#0000
change be_array(89)(0:7)  2#11110000

change cmd0_array(90)(0:3) 2#0100
change addr_array(90)(34)  1

change cmd0_array(91)(0:3) 2#0101
change addr_array(91)(33)  1

change cmd0_array(92)(0:3) 2#0001
change addr_array(92)  16#0000000060001008
change cmd0_array(92)(4:7)  2#0000
change be_array(92)(0:7)  2#11110000

change cmd0_array(93)(0:3) 2#0100
change addr_array(93)(34)  1

change cmd0_array(94)(0:3) 2#0101
change addr_array(94)(33)  1

change cmd0_array(95)(0:3) 2#0001
change addr_array(95)  16#0000000060001008
change cmd0_array(95)(4:7)  2#0000
change be_array(95)(0:7)  2#11110000

change cmd0_array(96)(0:3) 2#0100
change addr_array(96)(34)  1

change cmd0_array(97)(0:3) 2#0101
change addr_array(97)(33)  1

change cmd0_array(98)(0:3) 2#0001
change addr_array(98)  16#0000000030000000
change cmd0_array(98)(4:7)  2#0000
change be_array(98)(0:7)  2#11110000

change cmd0_array(99)(0:3) 2#0001
change addr_array(99)  16#0000000030000010
change cmd0_array(99)(4:7)  2#0000
change be_array(99)(0:7)  2#11110000

change cmd0_array(100)(0:3) 2#0001
change addr_array(100)  16#0000000030000014
change cmd0_array(100)(4:7)  2#0000
change be_array(100)(0:7)  2#00001111

change cmd0_array(101)(0:3) 2#0100
change addr_array(101)(34)  1

env /
