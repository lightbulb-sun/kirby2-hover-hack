HELD_BUTTONS            equ $ffa5
SURFACE                 equ $a04d
A_PRESS_AIRBORNE_FLAG   equ $aff0
OLD_BANK                equ $aff1
CUR_BANK                equ $ffa4
MASK_BUTTON_A           equ 1
BANK_SWITCH_ROUTINE     equ $05dd
MY_BANK                 equ $1f


SECTION "my_code", ROMX[$7e80], BANK[MY_BANK]
original_code:
        ; replace original instructions
        ld      a, d
        xor     e
        and     d
        ld      [hl+], a
        jr      z, .cont1
        ld      [hl+], a
        ld      [hl], $14
        ret
.cont1
        inc     hl
        or      [hl]
        jr      z, .cont2
        dec     [hl]
        dec     hl
        ld      [hl], 0
        ret
.cont2
        ld      [hl], 3
        dec     hl
        ld      [hl], d
        ret

save_new_button_presses::
        call    original_code
        and     MASK_BUTTON_A
        ret     z
.new_a_press
        ld      a, [SURFACE]
        and     a
        jr      z, .airborne
.not_airborne
        xor     a
        jr      .end
.airborne
        ld      a, $ff
.end
        ld      [A_PRESS_AIRBORNE_FLAG], a
        ret


SECTION "my_code2", ROM0[$0039]
check_for_a_press::
        ldh     a, [HELD_BUTTONS]
        and     MASK_BUTTON_A
        ret     z
        jr      check_for_a_press_cont
SECTION "my_code3", ROM0[$004b]
check_for_a_press_cont:
        ld      a, [A_PRESS_AIRBORNE_FLAG]
        and     a
        ret


SECTION "save_new_button_presses", ROM0[$0420]
        ldh     a, [CUR_BANK]
        ld      [OLD_BANK], a
        ld      a, MY_BANK
        call    BANK_SWITCH_ROUTINE
        call    save_new_button_presses
        ld      a, [OLD_BANK]
        call    BANK_SWITCH_ROUTINE
        ret

SECTION "check_for_up_press", ROM0[$361f]
        call    check_for_a_press
        nop

SECTION "occassionally_check_for_up_press", ROM0[$3810]
        and     MASK_BUTTON_A

SECTION "check_for_a_or_up_press_while_airborne", ROMX[$4b1e], BANK[1]
        and     MASK_BUTTON_A
