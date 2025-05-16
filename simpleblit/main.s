;---------- Includes ----------
    INCDIR      "include"
    INCLUDE     "hw.i"
    INCLUDE     "screen.i"

    SECTION code_section,CODE

_main:
    nop
    nop
    jsr         TakeSystem

    lea         bpl_pointers,a1
    move.l      #screen,d0
    move.l      #SCREEN_PLANE_SZ,d1
    move.l      #SCREEN_BPP,d7
    jsr         InitBPLPointers

.mainloop:
    btst        #6,$BFE001
    bne.s       .mainloop

    jsr         ReleaseSystem

    rts

	END