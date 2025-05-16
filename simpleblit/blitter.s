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
    move.w  #0,BLTDMOD          ; Modulo 0
    move.w  #0,BLTCON1          ; BLTCON1 = 0
    move.l  a1,BLTDPT(a5)       ; Dest address
    move.w  d1,BLTSIZE(a5)      ; Size in words

    bsr.s   WaitBlitter

    rts
