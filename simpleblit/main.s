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

    lea         screen,a1           ; Fill screen
    move.l      #5119,d7
.loop:
    move.w      #$FFFF,(a1)+
    dbra        d7,.loop

    lea         screen,a1
    add         #160,a1
    move.w      #83*64+60,d1        ; 249 righe/3 = 83 + 60 word(3 righe)
                                    ; = 83*64+60
    jsr         MemClear

.mainloop:
    btst        #6,$BFE001
    bne.s       .mainloop

    jsr         ReleaseSystem

    rts

	END