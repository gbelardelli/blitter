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

;     lea         screen,a1
;     add         #160,a1
;     move.w      #83*64+60,d1        ; 249 righe/3 = 83 + 60 word(3 righe)
;                                     ; = 83*64+60
;     jsr         MemClear

; .mainloop:
;     btst        #6,$BFE001
;     bne.s       .mainloop

    move.w      #64*64+4,d1
    move.l      #4,d6
    move.l      #40,d5
.loop0:
    lea         tile,a0
    lea         screen,a1
    sub.l       #8,d5
    add.l       d5,a1
    move.l      #2,d7
.loop1:
    jsr         MemCopy
    add         #512,a0
    add.l       #10240,a1
    dbra        d7,.loop1
    dbra        d6,.loop0

.mainloop2:
    btst        #6,$BFE001
    bne.s       .mainloop2

    jsr         ReleaseSystem

    rts

    SECTION graphic,DATA_C
tile:
    INCBIN      "gfx/tile.raw"

	END