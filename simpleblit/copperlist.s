;********************************************************
; INCLUDES
;********************************************************
    INCDIR      "include"
    INCLUDE     "hw.i"

    SECTION     graphics_data,DATA_C

;********************************************************
; DEFINITIONS
;********************************************************
    XDEF        copper_list
    XDEF        bpl_pointers

copper_list:
    dc.w        DIWSTRT,$2C81
    dc.w        DIWSTOP,$2CC1
    dc.w        DDFSTRT,$38
    dc.w        DDFSTOP,$D0
    dc.w        BPLCON1,$0
    dc.w        BPLCON2,$0
    dc.w        BPL1MOD,$0
    dc.w        BPL2MOD,$0

                        ;5432109876543210
    dc.w        BPLCON0,%0100001000000000     ; BPLCON0 320x256

bpl_pointers:
    dc.w        $E0,0,$E2,0     ; Plane 0
    dc.w        $E4,0,$E6,0     ; Plane 1
    dc.w        $E8,0,$EA,0     ; Plane 2
    dc.w        $EC,0,$EE,0     ; Plane 3
    dc.w        $F0,0,$F2,0     ; Plane 4
    dc.w        $F4,0,$F6,0     ; Plane 5
    dc.w        $F8,0,$FA,0     ; Plane 6
    dc.w        $FC,0,$FE,0     ; Plane 7

palette:
    INCBIN      "gfx/tile.pal"

    dc.w        $FFFF,$FFFE
