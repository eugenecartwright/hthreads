/** \internal
  * \file       context.S
  * \brief      context switching implementation for microblaze
  *
  * \author     Seth Warn
  *
  * This defines the _context_save_restore and _context_restore routines,
  * which save the current context and load another, or only load another,
  * respectively.
  *
  * A pointer to a mb_context_t should be in reg5 where the current context
  * will be saved.  This is ignored in the _context_restore routine.
  *
  * A pointer to a mb_context_t should be in reg6 where the next context
  * is saved.
  *
  * The microblaze compiler puts function arguments in reg5 - reg10 by
  * convention, so the routines can be called as C functions with the
  * following signatures:
  *   void _context_save_restore(mb_context_t *curr, mb_context_t *next);
  *   void _context_restore(mb_context_t *ignored, mb_context_t *next);
  *
  * _context_save_restore_new and _context_restore_new are also defined.
  * They differ from the other routines in only one way: after the context
  * has been restored, the PC is set to exactly the stored return address,
  * rather than the typical return-from-subroutine behavior (returning to
  * two instructions after the return address).
  *
  * some macros copied from xilkernel's entry.S
  * 
  * These routines do not save or restore registers 11 and 12, and will
  * alter the values in those registers.  That should be safe; as volatile
  * registers:
  *   - If context switching as a result of a syscall, those registers
  *     shouldn't be live.
  *   - If context switching as the result of a preemption, the interrupt
  *     handler will have saved volatile registers including 11 and 12,
  *     and will restore them after switching back to a context.
  *
  * No special-purpose registers other than the MSR are saved.  This may
  * not work correctly with MicroBlaze systems that use those registers.
  */

/* offset of a register within the mb_context_t structure defined
 * in context.h */
#define CTX_REG_OFFSET(regnum) (4*(regnum))

#define NUM_TO_REG(num)                 r ## num

/* Microblaze specific register's index in the context structure */        
#define MSR                             32
        
/* Uses r11 */        
#define CTX_SAVE_REG(regnum)                                                 \
        swi     NUM_TO_REG(regnum), r11, CTX_REG_OFFSET(regnum)

/* Uses r11 */                
#define CTX_RESTORE_REG(regnum)                                              \
        lwi     NUM_TO_REG(regnum), r11, CTX_REG_OFFSET(regnum)

/* Uses r11, stomps r12 */   
#define CTX_SAVE_MSR                                                         \
        mfs     r12, rmsr;                                                   \
        swi     r12, r11, CTX_REG_OFFSET(MSR);

/* Uses r11, stomps r12 */   
#define CTX_RESTORE_MSR                                                      \
        lwi     r12, r11, CTX_REG_OFFSET(MSR);                               \
        mts     rmsr, r12;                                                   \
        bri     4; 


/*
 * Save Context
 */
        .global _context_save_restore
        .section .text
        .align 2
        .ent _save_context
_context_save_restore:
        or      r11, r0, r5;    /* Move context pointer to reg11 */
        CTX_SAVE_REG (1);
        CTX_SAVE_REG (2);
        CTX_SAVE_REG (3);
        CTX_SAVE_REG (4);
        CTX_SAVE_REG (5);
        CTX_SAVE_REG (6);
        CTX_SAVE_REG (7);
        CTX_SAVE_REG (8);
        CTX_SAVE_REG (9);
        CTX_SAVE_REG (10);
        CTX_SAVE_REG (13);
        CTX_SAVE_REG (14);
        CTX_SAVE_REG (15);
        CTX_SAVE_REG (16);
        CTX_SAVE_REG (17);
        CTX_SAVE_REG (18);
        CTX_SAVE_REG (19); 
        CTX_SAVE_REG (20); 
        CTX_SAVE_REG (21);
        CTX_SAVE_REG (22); 
        CTX_SAVE_REG (23); 
        CTX_SAVE_REG (24); 
        CTX_SAVE_REG (25); 
        CTX_SAVE_REG (26); 
        CTX_SAVE_REG (27); 
        CTX_SAVE_REG (28); 
        CTX_SAVE_REG (29); 
        CTX_SAVE_REG (30); 
        CTX_SAVE_REG (31);                                      
        CTX_SAVE_MSR;
        .end _save_context      /* There is no return here; this will
                                   continue on to the restore routine. */


/*
 * Restore Context
 */
        .global _context_restore
        .section .text
        .align 2
        .ent _context_restore
_context_restore:
        or      r11, r0, r6;    /* Move context pointer to reg11 */
        CTX_RESTORE_REG (1);
        CTX_RESTORE_REG (2);
        CTX_RESTORE_REG (3);
        CTX_RESTORE_REG (4);
        CTX_RESTORE_REG (5);
        CTX_RESTORE_REG (6);
        CTX_RESTORE_REG (7);
        CTX_RESTORE_REG (8);
        CTX_RESTORE_REG (9);
        CTX_RESTORE_REG (10);
        CTX_RESTORE_REG (13);
        CTX_RESTORE_REG (14);
        CTX_RESTORE_REG (15);
        CTX_RESTORE_REG (16);
        CTX_RESTORE_REG (17);
        CTX_RESTORE_REG (18);
        CTX_RESTORE_REG (19); 
        CTX_RESTORE_REG (20); 
        CTX_RESTORE_REG (21);
        CTX_RESTORE_REG (22); 
        CTX_RESTORE_REG (23); 
        CTX_RESTORE_REG (24); 
        CTX_RESTORE_REG (25); 
        CTX_RESTORE_REG (26); 
        CTX_RESTORE_REG (27); 
        CTX_RESTORE_REG (28); 
        CTX_RESTORE_REG (29); 
        CTX_RESTORE_REG (30); 
        CTX_RESTORE_REG (31);                                      
        CTX_RESTORE_MSR;
        rtsd    r15, 8;
        nop
        .end _context_restore


        .global _context_save_restore_new
        .section .text
        .align 2
        .ent _context_save_new
_context_save_restore_new:
        or      r11, r0, r5;    /* Move context pointer to reg11 */
        CTX_SAVE_REG (1);
        CTX_SAVE_REG (2);
        CTX_SAVE_REG (3);
        CTX_SAVE_REG (4);
        CTX_SAVE_REG (5);
        CTX_SAVE_REG (6);
        CTX_SAVE_REG (7);
        CTX_SAVE_REG (8);
        CTX_SAVE_REG (9);
        CTX_SAVE_REG (10);
        CTX_SAVE_REG (13);
        CTX_SAVE_REG (14);
        CTX_SAVE_REG (15);
        CTX_SAVE_REG (16);
        CTX_SAVE_REG (17);
        CTX_SAVE_REG (18);
        CTX_SAVE_REG (19); 
        CTX_SAVE_REG (20); 
        CTX_SAVE_REG (21);
        CTX_SAVE_REG (22); 
        CTX_SAVE_REG (23); 
        CTX_SAVE_REG (24); 
        CTX_SAVE_REG (25); 
        CTX_SAVE_REG (26); 
        CTX_SAVE_REG (27); 
        CTX_SAVE_REG (28); 
        CTX_SAVE_REG (29); 
        CTX_SAVE_REG (30); 
        CTX_SAVE_REG (31);                                      
        CTX_SAVE_MSR;
        .end _context_save_new  /* There is no return here; this will
                                   continue on to the restore routine. */


        .global _context_restore_new
        .section .text
        .align 2
        .ent _context_restore_new
_context_restore_new:
        or      r11, r0, r6;    /* Move context pointer to reg11 */
        CTX_RESTORE_REG (1);
        CTX_RESTORE_REG (2);
        CTX_RESTORE_REG (3);
        CTX_RESTORE_REG (4);
        CTX_RESTORE_REG (5);
        CTX_RESTORE_REG (6);
        CTX_RESTORE_REG (7);
        CTX_RESTORE_REG (8);
        CTX_RESTORE_REG (9);
        CTX_RESTORE_REG (10);
        CTX_RESTORE_REG (13);
        CTX_RESTORE_REG (14);
        CTX_RESTORE_REG (15);
        CTX_RESTORE_REG (16);
        CTX_RESTORE_REG (17);
        CTX_RESTORE_REG (18);
        CTX_RESTORE_REG (19); 
        CTX_RESTORE_REG (20); 
        CTX_RESTORE_REG (21);
        CTX_RESTORE_REG (22); 
        CTX_RESTORE_REG (23); 
        CTX_RESTORE_REG (24); 
        CTX_RESTORE_REG (25); 
        CTX_RESTORE_REG (26); 
        CTX_RESTORE_REG (27); 
        CTX_RESTORE_REG (28); 
        CTX_RESTORE_REG (29); 
        CTX_RESTORE_REG (30); 
        CTX_RESTORE_REG (31);                                      
        CTX_RESTORE_MSR;
        rtsd    r15, 0;
        nop
        .end _context_restore_new

