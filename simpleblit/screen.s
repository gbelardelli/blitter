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
    XDEF    WaitVBL
    XDEF    WaitVLine
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
; WaitVLine - Wait specific raster line
; Params:
;   d2.l - Raster line
;********************************************************
WaitVLine:
    movem.l     d0-d2,-(sp)     ; Save regs on stack

    lsl.l       #8,d2
    move.l      #$1FF00,d1      ; Mask bit 8-16
.wait:
    move.l      VPOSR(a5),d0
    and.l       d1,d0
    cmp.l       d2,d0
    bne.s       .wait

    movem.l     (sp)+,d0-d2     ; Reset regs from stack
    rts


;********************************************************
; Wait vertical blank
;********************************************************
WaitVBL:
    movem.l     d2,-(sp)     ; Save regs on stack

    move.l      #304,d2
    bsr         WaitVLine

    movem.l     (sp)+,d2     ; Reset regs from stack
    rts

;********************************************************
; BSS DATA
;********************************************************
    SECTION bss_data,BSS_C

screen:
    ds.b        (SCREEN_PLANE_SZ*SCREEN_BPP)

