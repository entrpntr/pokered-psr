ReadJoypad::
; Poll joypad input.
; Unlike the hardware register, button
; presses are indicated by a set bit.

	ld a, 1 << 5 ; select direction keys
	ld c, 0

	ldh [rJOYP], a
REPT 6
	ldh a, [rJOYP]
ENDR
	ld b, a
	ld a, 1 << 4 ; select button keys
	ldh [rJOYP], a
	ld a, b
	cpl
	and %1111
	swap a
	ld b, a
	push bc
	pop bc
	nop
REPT 5
	ldh a, [rJOYP]
ENDR
	cpl
	and %1111
	or b
	cp D_DOWN | SELECT | B_BUTTON
	call z, RST_38

	ldh [hJoyInput], a

	ld a, 1 << 4 + 1 << 5 ; deselect keys
	ldh [rJOYP], a
	ret

Joypad::
; Update the joypad state variables:
; [hJoyReleased]  keys released since last time
; [hJoyPressed]   keys pressed since last time
; [hJoyHeld] currently pressed keys
	homecall _Joypad
	ret
