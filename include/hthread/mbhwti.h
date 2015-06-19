/*****************************************************
**
**    SFSL0 = VAL
**    SFSL1 = ADDR
**    SFSL2 = (0-15)FUNC, (16-21)OPCODE, (22-31)UNUSED
**
**    MFSL0 = VAL
**    MFSL1 = (0-15)FUNC, (16)GO/WAIT, (17-31)UNUSED
**
*****************************************************/

//====================================================
//Specific data structure for applications
//====================================================


//====================================================

// User flags
 #define USE_HETERO_THREAD

//HWTI Command Masks
  //Function definitions
  #define FUNCTION_RESET     		 	0x0000
  #define FUNCTION_WAIT        			0x0001
  #define FUNCTION_USER_SELECT 			0x0002
  #define FUNCTION_START       			0x0003
  // Range 0003 to 7999 reserved for user logic's state machine,  Range 8000 to 9999 reserved for system calls
  #define FUNCTION_HTHREAD_ATTR_INIT            0x8000
  #define FUNCTION_HTHREAD_ATTR_DESTROY         0x8001
  #define FUNCTION_HTHREAD_CREATE               0x8010
  #define FUNCTION_HTHREAD_JOIN                 0x8011
  #define FUNCTION_HTHREAD_SELF			0x8012
  #define FUNCTION_HTHREAD_YIELD 		0x8013
  #define FUNCTION_HTHREAD_EQUAL 		0x8014
  #define FUNCTION_HTHREAD_EXIT 		0x8015
  #define FUNCTION_HTHREAD_EXIT_ERROR 		0x8016
  #define FUNCTION_HTHREAD_MUTEXATTR_INIT 	0x8020
  #define FUNCTION_HTHREAD_MUTEXATTR_DESTROY 	0x8021
  #define FUNCTION_HTHREAD_MUTEXATTR_SETNUM 	0x8022
  #define FUNCTION_HTHREAD_MUTEXATTR_GETNUM 	0x8023
  #define FUNCTION_HTHREAD_MUTEX_INIT		0x8030
  #define FUNCTION_HTHREAD_MUTEX_DESTROY	0x8031
  #define FUNCTION_HTHREAD_MUTEX_LOCK 		0x8032
  #define FUNCTION_HTHREAD_MUTEX_UNLOCK 	0x8033
  #define FUNCTION_HTHREAD_MUTEX_TRYLOCK 	0x8034
  #define FUNCTION_HTHREAD_CONDATTR_INIT 	0x8040
  #define FUNCTION_HTHREAD_CONDATTR_DESTROY 	0x8041
  #define FUNCTION_HTHREAD_CONDATTR_SETNUM 	0x8042
  #define FUNCTION_HTHREAD_CONDATTR_GETNUM 	0x8043
  #define FUNCTION_HTHREAD_COND_INIT 		0x8050
  #define FUNCTION_HTHREAD_COND_DESTROY	 	0x8051
  #define FUNCTION_HTHREAD_COND_SIGNAL 		0x8052
  #define FUNCTION_HTHREAD_COND_BROADCAST 	0x8053
  #define FUNCTION_HTHREAD_COND_WAIT		0x8054
  // Ranged A000 to FFFF reserved for supported library calls

  // user_opcode Constants -- 6 bits
 #define OPCODE_NOOP			0
  // Memory sub-interface specific opcodes
  #define OPCODE_LOAD 			1
  #define OPCODE_STORE 			2
  #define OPCODE_DECLARE 		3
  #define OPCODE_READ 			4
  #define OPCODE_WRITE 			5
  #define OPCODE_ADDRESS 		6
  // Function sub-interface specific opcodes
  #define OPCODE_PUSH 			16
  #define OPCODE_POP 			17
  #define OPCODE_CALL 			18
  #define OPCODE_RETURN 		19

  #define OPCODE_MASK      		 0x0000FC00
  #define FUNC_MASK         		 0xFFFF0000

 

