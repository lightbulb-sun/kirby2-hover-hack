HELD_BUTTONS            equ $ffa5
SURFACE                 equ $a04d
A_PRESS_AIRBORNE_FLAG   equ $aff0
MASK_BUTTON_A           equ 1


SECTION "my_code", ROM0[$0061]
save_new_button_presses::
        ; replace original instructions
        ld      [hl+], a
        ld      [hl], $14

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


check_for_a_press::
        ldh     a, [HELD_BUTTONS]
        and     MASK_BUTTON_A
        ret     z
        ld      a, [A_PRESS_AIRBORNE_FLAG]
        and     a
        ret


SECTION "save_new_button_presses", ROM0[$0425]
        call    save_new_button_presses

SECTION "check_for_up_press", ROM0[$361f]
        call    check_for_a_press
        nop

SECTION "occassionally_check_for_up_press", ROM0[$3810]
        and     MASK_BUTTON_A

SECTION "check_for_a_or_up_press_while_airborne", ROMX[$4b1e], BANK[1]
        and     MASK_BUTTON_A
