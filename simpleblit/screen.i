    IFND            SCREEN_I

SCREEN_I    SET   1

;********************************************************
; CONSTANT DEFINITIONS
;********************************************************
SCREEN_BPP      equ 4
SCREEN_WIDTH    equ 320
SCREEN_HEIGHT   equ 256
SCREEN_WORDS    equ (SCREEN_WIDTH/8)
SCREEN_PLANE_SZ equ SCREEN_HEIGHT*SCREEN_WORDS

    ENDC  ; SCREEN_I
