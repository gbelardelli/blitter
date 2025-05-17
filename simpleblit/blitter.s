;********************************************************
; INCLUDES
;********************************************************
    INCDIR      "include"
    INCLUDE     "hw.i"
    INCLUDE     "hardware/blit.i"

;********************************************************
; DEFINITIONS
;********************************************************
    XDEF        WaitBlitter
    XDEF        MemClear
    XDEF        MemCopy

    SECTION     code_section,CODE

;********************************************************
; ROUTINES
;********************************************************
WaitBlitter:
    btst.b      #6,DMACONR(a5)     ; OCS have a bug so to avoid a race condition
                                   ; we must read two times the DMACONR registry
                                   ; and discard the first result.
                                   ; Source: Bare-Metal Amiga Programming book, pg: 142
.loop:
    btst.b      #6,DMACONR(a5)
    bne         .loop

    rts

;********************************************************
; MemClear - Simple memory clear
; a1 -> dest
; d1 -> size in words (max 64)
;********************************************************
MemClear:
    bsr.s   WaitBlitter

    move.w  #DEST,BLTCON0(a5)   ; Enable only DEST DMA
                                ; MINTERMS = $0 -> D
    move.w  #0,BLTDMOD(a5)      ; Modulo 0
    move.w  #0,BLTCON1(a5)      ; BLTCON1 = 0
    move.l  a1,BLTDPT(a5)       ; Dest address
    move.w  d1,BLTSIZE(a5)      ; Size in words

    bsr.s   WaitBlitter

    rts


;********************************************************
; MemCopy - Simple A=D copy
; a0 -> src addr
; a1 -> dest addr
; d1 -> size in words (max 64)
;********************************************************
MemCopy:
    bsr.s   WaitBlitter

    move.w  #ABC|ABNC|ANBC|ANBNC|SRCA|DEST,BLTCON0(a5)  ; Enable SRCA and DEST DMA
                                                        ; MINTERMS = $F0 -> A=D
    move.w  #0,BLTAMOD(a5)      ; Channel A Modulo 0
    move.w  #32,BLTDMOD(a5)     ; Channel D Modulo 0
    move.w  #$FFFF,BLTAFWM(a5)  ; Channel A Mask
    move.w  #$FFFF,BLTALWM(a5)  ; Channel A Mask
    move.w  #0,BLTCON1(a5)      ; BLTCON1 = 0
    move.l  a0,BLTAPT(a5)       ; Src address
    move.l  a1,BLTDPT(a5)       ; Dest address
    move.w  d1,BLTSIZE(a5)      ; Size in words

    bsr.s   WaitBlitter

    rts
