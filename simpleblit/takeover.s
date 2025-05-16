

;********************************************************
; INCLUDES
;********************************************************
    INCDIR      "include"
    INCLUDE     "hw.i"
    INCLUDE     "funcdef.i"
    INCLUDE     "exec/exec_lib.i"
    INCLUDE     "graphics/graphics_lib.i"
    INCLUDE     "takeover.i"

    SECTION code_section,CODE

;********************************************************
; DEFINITIONS
;********************************************************
    XDEF        TakeSystem
    XDEF        ReleaseSystem

;********************************************************
; VARIABLES
;********************************************************
gfx_name:
    GRAFNAME
    EVEN

gfx_base:
    dc.l    $0
old_dma:
    dc.l    $0
sys_copper:
    dc.l    $0

;********************************************************
; ROUTINES
;********************************************************
TakeSystem:
    move.l      $4.w,a6                 ; ExecBase
    jsr         _LVOForbid(a6)          ; Disable multitasking
    jsr         _LVODisable(a6)         ; Disable interrupts

    lea         gfx_name,a1
    jsr         _LVOOldOpenLibrary(a6)  ; Open graphic library
    move.l      d0,gfx_base

    move.l      d0,a6
    move.l      $26(a6),sys_copper      ; Save system copperlist

    jsr        _LVOOwnBlitter(a6)

    lea         CUSTOM,a5               ; Chip custom base address $DFF000

    move.w      DMACONR(a5),old_dma     ; Save DMA status
    move.w      #$7FFF,DMACON(a5)       ; Disable all DMA channels
    move.w      #DMASET,DMACON(a5)      ; Enable DMA

    move.l      #copper_list,COP1LC(a5) ; Copper list address
    jsr         WaitVBL                 ; Prevent screen flashing
    move.w      d0,COPJMP1(a5)          ; Start Copper

    ; Disable AGA features
    move.w      #0,$1FC(a5)             ; Set FMODE to 16bit
    move.w      #$C00,BPLCON3(a5)       ; Disable 24bit palette
    move.w      #$11,BPLCON4(a5)        ; Enable normal palette

    rts


ReleaseSystem:
    move.l      sys_copper,COP1LC(a5)
    move.w      d0,COPJMP1(a5)          ; Reset system copper list

    or.w        #$8000,old_dma          ; Set bit 15
    move.w      old_dma,DMACON(a5)      ; Set DMA old value

    move.l      gfx_base,a6
    jsr         _LVODisownBlitter(a6)   ; Release Blitter

    move.l      $4.w,a6                 ; ExecBase
    jsr         _LVOPermit(a6)          ; Enable multitasking
    jsr         _LVOEnable(a6)          ; Enable interrupts

    move.l      gfx_base,a1
    jsr         _LVOCloseLibrary(a6)    ; Close graphics library

    rts
