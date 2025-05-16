;********************************************************
; INCLUDES
;********************************************************
    INCDIR      "include"
    INCLUDE     "hw.i"
    INCLUDE     "screen.i"

;********************************************************
; DEFINITIONS
;********************************************************
    XDEF    InitBPLPointers
    XDEF    screen

    SECTION code_section,CODE

;********************************************************
; InitBPLPointers - Init pointers to bitplanes
; Params:
;   a1 - Copperlist BPL pointers address
;   d0 - Image address
;   d1 - Size of one playfield plane
;   d7 - Number of bitplanes
;********************************************************
InitBPLPointers:
    movem.l     d0-d1/d7/a1,-(sp)     ; Save regs on stack

    sub.l       #1,d7           ; Iterations number
.loop:
    move.w      d0,6(a1)        ; Copy image address low word
    swap        d0
    move.w      d0,2(a1)
    swap        d0
    add.l       d1,d0
    add.l       #8,a1
    dbra        d7,.loop

    movem.l     (sp)+,d0-d1/d7/a1     ; Reset regs from stack
    rts


;********************************************************
; BSS DATA
;********************************************************
    SECTION bss_data,BSS_C

screen:
    ds.b        (SCREEN_PLANE_SZ*SCREEN_BPP)

