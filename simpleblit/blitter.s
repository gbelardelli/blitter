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
; a1 -> src
; a2 -> dest
; d1 -> x src
; d2 -> y src
; d3 ->
;********************************************************
CopyAD:

    move.w  #(ABC|ABNC|ANBC|ANBNC|SRCA|DEST),BLTCON0(a5)