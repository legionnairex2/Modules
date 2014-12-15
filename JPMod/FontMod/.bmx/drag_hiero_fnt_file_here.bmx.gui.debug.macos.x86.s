	.reference	___bb_blitz_blitz
	.reference	___bb_retro_retro
	.reference	_bbAppArgs
	.reference	_bbEmptyArray
	.reference	_bbEmptyString
	.reference	_bbEnd
	.reference	_bbNullObject
	.reference	_bbOnDebugEnterScope
	.reference	_bbOnDebugEnterStm
	.reference	_bbOnDebugLeaveScope
	.reference	_bbStringClass
	.reference	_bbStringCompare
	.reference	_bbStringConcat
	.reference	_bbStringContains
	.reference	_bbStringSlice
	.reference	_bbStringSplit
	.reference	_bbStringStartsWith
	.reference	_brl_blitz_ArrayBoundsError
	.reference	_brl_filesystem_CloseFile
	.reference	_brl_filesystem_FileType
	.reference	_brl_filesystem_ReadFile
	.reference	_brl_filesystem_StripExt
	.reference	_brl_filesystem_WriteFile
	.reference	_brl_retro_Replace
	.reference	_brl_retro_Trim
	.reference	_brl_standardio_Print
	.reference	_brl_stream_Eof
	.reference	_brl_stream_ReadLine
	.reference	_brl_stream_WriteLine
	.globl	__bb_main
	.globl	_bb_ParseFile
	.globl	_bb_ParseLine
	.globl	_bb_section
	.text	
__bb_main:
	push	%ebp
	mov	%esp,%ebp
	push	%ebx
	sub	$20,%esp
	cmpl	$0,_46
	je	_47
	mov	$0,%eax
	add	$20,%esp
	pop	%ebx
	mov	%ebp,%esp
	pop	%ebp
	ret
_47:
	movl	$1,_46
	movl	%ebp,4(%esp)
	movl	$_42,(%esp)
	calll	*_bbOnDebugEnterScope
	call	___bb_blitz_blitz
	call	___bb_retro_retro
	movl	$_26,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	$_28,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	_bbAppArgs,%eax
	cmpl	$2,20(%eax)
	jne	_29
	movl	%ebp,4(%esp)
	movl	$_33,(%esp)
	calll	*_bbOnDebugEnterScope
	movl	$_30,(%esp)
	calll	*_bbOnDebugEnterStm
	mov	$1,%ebx
	movl	_bbAppArgs,%eax
	cmpl	20(%eax),%ebx
	jb	_32
	call	_brl_blitz_ArrayBoundsError
_32:
	movl	_bbAppArgs,%eax
	movl	24(%eax,%ebx,4),%eax
	movl	%eax,(%esp)
	call	_bb_ParseFile
	calll	*_bbOnDebugLeaveScope
	jmp	_34
_29:
	movl	%ebp,4(%esp)
	movl	$_40,(%esp)
	calll	*_bbOnDebugEnterScope
	movl	$_35,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	$_4,(%esp)
	call	_brl_filesystem_FileType
	cmp	$1,%eax
	jne	_36
	movl	%ebp,4(%esp)
	movl	$_39,(%esp)
	calll	*_bbOnDebugEnterScope
	movl	$_37,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	$_5,(%esp)
	call	_brl_standardio_Print
	movl	$_38,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	$_4,(%esp)
	call	_bb_ParseFile
	calll	*_bbOnDebugLeaveScope
_36:
	calll	*_bbOnDebugLeaveScope
_34:
	movl	$_41,(%esp)
	calll	*_bbOnDebugEnterStm
	call	_bbEnd
	mov	$0,%ebx
	jmp	_18
_18:
	calll	*_bbOnDebugLeaveScope
	mov	%ebx,%eax
	add	$20,%esp
	pop	%ebx
	mov	%ebp,%esp
	pop	%ebp
	ret
_bb_ParseFile:
	push	%ebp
	mov	%esp,%ebp
	sub	$20,%esp
	push	%ebx
	sub	$16,%esp
	movl	8(%ebp),%eax
	movl	%eax,-4(%ebp)
	movl	$_bbNullObject,-8(%ebp)
	movl	$_bbNullObject,-12(%ebp)
	movl	$_bbEmptyString,-16(%ebp)
	movl	$_bbEmptyString,-20(%ebp)
	movl	%ebp,4(%esp)
	movl	$_75,(%esp)
	calll	*_bbOnDebugEnterScope
	movl	$_48,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	-4(%ebp),%eax
	movl	%eax,(%esp)
	call	_brl_filesystem_ReadFile
	movl	%eax,-8(%ebp)
	movl	$_50,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	-8(%ebp),%eax
	cmp	$_bbNullObject,%eax
	setne	%al
	movzbl	%al,%eax
	cmp	$0,%eax
	jne	_51
	movl	%ebp,4(%esp)
	movl	$_53,(%esp)
	calll	*_bbOnDebugEnterScope
	movl	$_52,(%esp)
	calll	*_bbOnDebugEnterStm
	mov	$0,%ebx
	calll	*_bbOnDebugLeaveScope
	jmp	_21
_51:
	movl	$_54,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	$_6,4(%esp)
	movl	-4(%ebp),%eax
	movl	%eax,(%esp)
	call	_brl_filesystem_StripExt
	movl	%eax,(%esp)
	call	_bbStringConcat
	movl	%eax,(%esp)
	call	_brl_filesystem_WriteFile
	movl	%eax,-12(%ebp)
	movl	$_56,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	-12(%ebp),%eax
	cmp	$_bbNullObject,%eax
	setne	%al
	movzbl	%al,%eax
	cmp	$0,%eax
	jne	_57
	movl	%ebp,4(%esp)
	movl	$_59,(%esp)
	calll	*_bbOnDebugEnterScope
	movl	$_58,(%esp)
	calll	*_bbOnDebugEnterStm
	mov	$0,%ebx
	calll	*_bbOnDebugLeaveScope
	jmp	_21
_57:
	movl	$_60,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	$_7,4(%esp)
	movl	-12(%ebp),%eax
	movl	%eax,(%esp)
	call	_brl_stream_WriteLine
	movl	$_61,(%esp)
	calll	*_bbOnDebugEnterStm
	jmp	_8
_10:
	movl	%ebp,4(%esp)
	movl	$_70,(%esp)
	calll	*_bbOnDebugEnterScope
	movl	$_62,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	-8(%ebp),%eax
	movl	%eax,(%esp)
	call	_brl_stream_ReadLine
	movl	%eax,-16(%ebp)
	movl	$_64,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	-16(%ebp),%eax
	movl	%eax,(%esp)
	call	_bb_ParseLine
	movl	%eax,-20(%ebp)
	movl	$_66,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	$_1,4(%esp)
	movl	-20(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbStringCompare
	cmp	$0,%eax
	je	_67
	movl	%ebp,4(%esp)
	movl	$_69,(%esp)
	calll	*_bbOnDebugEnterScope
	movl	$_68,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	-20(%ebp),%eax
	movl	%eax,4(%esp)
	movl	-12(%ebp),%eax
	movl	%eax,(%esp)
	call	_brl_stream_WriteLine
	calll	*_bbOnDebugLeaveScope
_67:
	calll	*_bbOnDebugLeaveScope
_8:
	movl	-8(%ebp),%eax
	movl	%eax,(%esp)
	call	_brl_stream_Eof
	cmp	$0,%eax
	je	_10
_9:
	movl	$_73,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	-12(%ebp),%eax
	movl	%eax,(%esp)
	call	_brl_filesystem_CloseFile
	movl	$_74,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	-8(%ebp),%eax
	movl	%eax,(%esp)
	call	_brl_filesystem_CloseFile
	mov	$0,%ebx
	jmp	_21
_21:
	calll	*_bbOnDebugLeaveScope
	mov	%ebx,%eax
	add	$16,%esp
	pop	%ebx
	mov	%ebp,%esp
	pop	%ebp
	ret
_bb_ParseLine:
	push	%ebp
	mov	%esp,%ebp
	sub	$24,%esp
	push	%ebx
	push	%esi
	push	%edi
	sub	$20,%esp
	movl	8(%ebp),%eax
	movl	%eax,-4(%ebp)
	movl	$_bbEmptyString,-8(%ebp)
	movl	$_bbEmptyArray,-12(%ebp)
	movl	$_bbEmptyString,-16(%ebp)
	movl	$_bbEmptyArray,-20(%ebp)
	mov	%ebp,%eax
	movl	%eax,4(%esp)
	movl	$_112,(%esp)
	calll	*_bbOnDebugEnterScope
	movl	$_81,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	$_1,-8(%ebp)
	movl	$_83,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	-4(%ebp),%eax
	movl	%eax,(%esp)
	call	_brl_retro_Trim
	movl	%eax,-4(%ebp)
	movl	$_84,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	$_11,4(%esp)
	movl	-4(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbStringStartsWith
	cmp	$0,%eax
	je	_85
	mov	%ebp,%eax
	movl	%eax,4(%esp)
	movl	$_109,(%esp)
	calll	*_bbOnDebugEnterScope
	movl	$_86,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	$_12,4(%esp)
	movl	-4(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbStringSplit
	movl	%eax,-12(%ebp)
	movl	$_88,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	$_bbEmptyString,-16(%ebp)
	movl	-12(%ebp),%edi
	mov	%edi,%eax
	add	$24,%eax
	mov	%eax,%esi
	mov	%esi,%eax
	addl	16(%edi),%eax
	movl	%eax,-24(%ebp)
	jmp	_13
_15:
	movl	(%esi),%eax
	movl	%eax,-16(%ebp)
	add	$4,%esi
	cmpl	$_bbNullObject,-16(%ebp)
	je	_13
	mov	%ebp,%eax
	movl	%eax,4(%esp)
	movl	$_106,(%esp)
	calll	*_bbOnDebugEnterScope
	movl	$_94,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	$_16,4(%esp)
	movl	-16(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbStringContains
	cmp	$0,%eax
	je	_95
	mov	%ebp,%eax
	movl	%eax,4(%esp)
	movl	$_103,(%esp)
	calll	*_bbOnDebugEnterScope
	movl	$_96,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	$_16,4(%esp)
	movl	-16(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbStringSplit
	movl	%eax,-20(%ebp)
	movl	$_98,(%esp)
	calll	*_bbOnDebugEnterStm
	mov	$1,%ebx
	movl	-20(%ebp),%eax
	cmpl	20(%eax),%ebx
	jb	_100
	call	_brl_blitz_ArrayBoundsError
_100:
	movl	$_17,4(%esp)
	movl	-20(%ebp),%eax
	movl	24(%eax,%ebx,4),%eax
	movl	%eax,(%esp)
	call	_bbStringConcat
	movl	%eax,4(%esp)
	movl	-8(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbStringConcat
	movl	%eax,-8(%ebp)
	movl	$_101,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	$_1,8(%esp)
	movl	$_102,4(%esp)
	movl	-8(%ebp),%eax
	movl	%eax,(%esp)
	call	_brl_retro_Replace
	movl	%eax,-8(%ebp)
	calll	*_bbOnDebugLeaveScope
_95:
	calll	*_bbOnDebugLeaveScope
_13:
	cmpl	-24(%ebp),%esi
	jne	_15
_14:
	movl	$_108,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	-8(%ebp),%eax
	movl	8(%eax),%eax
	sub	$1,%eax
	movl	%eax,8(%esp)
	movl	$0,4(%esp)
	movl	-8(%ebp),%eax
	movl	%eax,(%esp)
	call	_bbStringSlice
	movl	%eax,-8(%ebp)
	calll	*_bbOnDebugLeaveScope
_85:
	movl	$_111,(%esp)
	calll	*_bbOnDebugEnterStm
	movl	-8(%ebp),%ebx
	jmp	_24
_24:
	calll	*_bbOnDebugLeaveScope
	mov	%ebx,%eax
	add	$20,%esp
	pop	%edi
	pop	%esi
	pop	%ebx
	mov	%ebp,%esp
	pop	%ebp
	ret
	.data	
	.align	4
_46:
	.long	0
_43:
	.asciz	"drag_hiero_fnt_file_here"
_44:
	.asciz	"section"
_45:
	.asciz	"$"
	.align	4
_3:
	.long	_bbStringClass
	.long	2147483647
	.long	4
	.short	99,104,97,114
	.align	4
_bb_section:
	.long	_3
	.align	4
_42:
	.long	1
	.long	_43
	.long	4
	.long	_44
	.long	_45
	.long	_bb_section
	.long	0
_27:
	.asciz	"/Users/jperez_23/MonkeyPro56b/bananas/beaker/angelfont_example/drag_hiero_fnt_file_here.bmx"
	.align	4
_26:
	.long	_27
	.long	6
	.long	1
	.align	4
_28:
	.long	_27
	.long	8
	.long	1
	.align	4
_33:
	.long	3
	.long	0
	.long	0
	.align	4
_30:
	.long	_27
	.long	9
	.long	2
	.align	4
_40:
	.long	3
	.long	0
	.long	0
	.align	4
_35:
	.long	_27
	.long	11
	.long	2
	.align	4
_4:
	.long	_bbStringClass
	.long	2147483647
	.long	9
	.short	99,104,97,108,107,46,102,110,116
	.align	4
_39:
	.long	3
	.long	0
	.long	0
	.align	4
_37:
	.long	_27
	.long	12
	.long	3
	.align	4
_5:
	.long	_bbStringClass
	.long	2147483647
	.long	15
	.short	102,111,117,110,100,32,99,104,97,108,107,46,102,110,116
	.align	4
_38:
	.long	_27
	.long	13
	.long	3
	.align	4
_41:
	.long	_27
	.long	19
	.long	1
_76:
	.asciz	"ParseFile"
_77:
	.asciz	"filename"
_78:
	.asciz	"in"
_79:
	.asciz	":brl.stream.TStream"
_80:
	.asciz	"out"
	.align	4
_75:
	.long	1
	.long	_76
	.long	2
	.long	_77
	.long	_45
	.long	-4
	.long	2
	.long	_78
	.long	_79
	.long	-8
	.long	2
	.long	_80
	.long	_79
	.long	-12
	.long	0
	.align	4
_48:
	.long	_27
	.long	22
	.long	2
	.align	4
_50:
	.long	_27
	.long	23
	.long	2
	.align	4
_53:
	.long	3
	.long	0
	.long	0
	.align	4
_52:
	.long	_27
	.long	23
	.long	14
	.align	4
_54:
	.long	_27
	.long	24
	.long	2
	.align	4
_6:
	.long	_bbStringClass
	.long	2147483647
	.long	4
	.short	46,116,120,116
	.align	4
_56:
	.long	_27
	.long	25
	.long	2
	.align	4
_59:
	.long	3
	.long	0
	.long	0
	.align	4
_58:
	.long	_27
	.long	25
	.long	15
	.align	4
_60:
	.long	_27
	.long	27
	.long	2
	.align	4
_7:
	.long	_bbStringClass
	.long	2147483647
	.long	54
	.short	105,100,44,120,44,121,44,119,105,100,116,104,44,104,101,105
	.short	103,104,116,44,120,111,102,102,115,101,116,44,121,111,102,102
	.short	115,101,116,44,120,97,100,118,97,110,99,101,44,112,97,103
	.short	101,44,99,104,110,108
	.align	4
_61:
	.long	_27
	.long	28
	.long	2
_71:
	.asciz	"before"
_72:
	.asciz	"after"
	.align	4
_70:
	.long	3
	.long	0
	.long	2
	.long	_71
	.long	_45
	.long	-16
	.long	2
	.long	_72
	.long	_45
	.long	-20
	.long	0
	.align	4
_62:
	.long	_27
	.long	29
	.long	3
	.align	4
_64:
	.long	_27
	.long	30
	.long	3
	.align	4
_66:
	.long	_27
	.long	31
	.long	3
	.align	4
_1:
	.long	_bbStringClass
	.long	2147483647
	.long	0
	.align	4
_69:
	.long	3
	.long	0
	.long	0
	.align	4
_68:
	.long	_27
	.long	31
	.long	18
	.align	4
_73:
	.long	_27
	.long	33
	.long	2
	.align	4
_74:
	.long	_27
	.long	34
	.long	2
_113:
	.asciz	"ParseLine"
_114:
	.asciz	"line"
_115:
	.asciz	"result"
	.align	4
_112:
	.long	1
	.long	_113
	.long	2
	.long	_114
	.long	_45
	.long	-4
	.long	2
	.long	_115
	.long	_45
	.long	-8
	.long	0
	.align	4
_81:
	.long	_27
	.long	40
	.long	2
	.align	4
_83:
	.long	_27
	.long	41
	.long	2
	.align	4
_84:
	.long	_27
	.long	42
	.long	2
	.align	4
_11:
	.long	_bbStringClass
	.long	2147483647
	.long	8
	.short	99,104,97,114,32,105,100,61
_110:
	.asciz	"parts"
_105:
	.asciz	"[]$"
	.align	4
_109:
	.long	3
	.long	0
	.long	2
	.long	_110
	.long	_105
	.long	-12
	.long	0
	.align	4
_86:
	.long	_27
	.long	43
	.long	3
	.align	4
_12:
	.long	_bbStringClass
	.long	2147483647
	.long	1
	.short	32
	.align	4
_88:
	.long	_27
	.long	44
	.long	3
_107:
	.asciz	"part"
	.align	4
_106:
	.long	3
	.long	0
	.long	2
	.long	_107
	.long	_45
	.long	-16
	.long	0
	.align	4
_94:
	.long	_27
	.long	45
	.long	4
	.align	4
_16:
	.long	_bbStringClass
	.long	2147483647
	.long	1
	.short	61
_104:
	.asciz	"dec"
	.align	4
_103:
	.long	3
	.long	0
	.long	2
	.long	_104
	.long	_105
	.long	-20
	.long	0
	.align	4
_96:
	.long	_27
	.long	46
	.long	5
	.align	4
_98:
	.long	_27
	.long	47
	.long	5
	.align	4
_17:
	.long	_bbStringClass
	.long	2147483647
	.long	1
	.short	44
	.align	4
_101:
	.long	_27
	.long	48
	.long	5
	.align	4
_102:
	.long	_bbStringClass
	.long	2147483647
	.long	1
	.short	34
	.align	4
_108:
	.long	_27
	.long	52
	.long	3
	.align	4
_111:
	.long	_27
	.long	54
	.long	2
