" Vim syntax file
" Language:	KOS
" Maintainer:	Steven Mading (madings@gmail.com)
" Last Change:	4 November 2013

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" KOS script is supposed to be case insensitive.  There's
" a few places where it isn't, but they're bugs not intented
" design choices:
syn case ignore

" define keywords:
syn keyword kosCondFlowWord BREAK UNTIL WAIT WHEN THEN IF ON REBOOT SHUTDOWN RUN CALL skipwhite
syn keyword kosCommandWord LOCK UNLOCK SET DECLARE CLEARSCREEN STAGE ON TOGGLE COPY PARAMETER DELETE FROM TO EDIT LIST LOG PRINT AT RENAME FILE VOLUME SWITCH CLEARSCREEN ADD skipwhite
syn keyword kosTODO contained TODO

syn keyword kosBuiltInBoolean BRAKES GEAR LIGHTS RCS SAS LEGS AG1 AG2 AG3 AG4 AG5 AG6 AG7 AG8 AG9 AG10
syn keyword kosBuiltInVariable STEERING THROTTLE WHEELSTEERING WHEELTHROTTLE ALTITUDE ALT RADAR APOAPSIS PERIAPSIS ETA MISSIONTIME SESSIONTIME TIME WARP ANGULARMOMENTUM ANGULARVEL SURFACESPEED VERTICALSPEED VELOCITY SURFACE ORBIT FACING HEADING GEOPOSITION LATITUDE LONGITUDE MAG NORTH UP PROGRADE RETROGRADE AV BODY MASS MAXTHRUST STATUS STAGE TARGET DISTANCE DIRECTION BEARING HEADING VESSELNAME NEXTNODE skipwhite
syn keyword kosBuiltInFunc R T Q V FLOOR CEILING ROUND SQRT MOD SIN COS TAN ARCSIN ARCCOS ARCTAN ARCTAN2 ABS skipwhite

syn cluster kosBuiltinIdent contains=kosBuiltinBoolean,kosBuiltinVariable,kosBuiltinFunc
" define regex matches;

syn match kosExpr 'placeholder'
syn match kosIdentifier '\<[A-Za-z_][A-Za-z_0-9]*\>'
syn match kosMathOp '\*'
syn match kosMathOp '\^'
syn match kosMathOp '/'
syn match kosMathOp '-'
syn match kosMathOp '+'
syn match kosMathOp '<='
syn match kosMathOp '>='
syn match kosMathOp '!='
syn match kosMathOp '=='
syn match kosMathOp '='
syn match kosMathOp '<'
syn match kosMathOp '>'
syn match kosMathOp 'AND'
syn match kosMathOp 'OR'
syn match kosSpecialChar '\.'
syn match kosSpecialChar ','
syn match kosSpecialChar ':'
syn match kosDelim '{'
syn match kosDelim '}'
syn match kosNumber '\d\d*'
syn match kosNumber '\d\d*.\d\d*'
syn match kosComment '//.*$' contains=kosTODO


" define begin/end regions:
syn region kosParenExpr start='(' end=')' fold transparent
syn region kosString start='"' end='"'
syn region kosCodeBlock start='{' end='}' fold transparent


" Lastly, assign all those things to standard VIM color groups
" so this will work with any color theme other people make:
let b:current_syntax = "kos"
hi def link kosCondFlowWord Keyword
hi def link kosCommandWord  Statement
hi def link kosIdentifier   Identifier
hi def link kosComment      Comment
hi def link kosTODO         Keyword
hi def link kosMathOp       Operator
hi def link kosDelim        Delimiter
hi def link kosSpecialChar  SpecialChar
hi def link kosNumber       Number
hi def link kosString       String
hi def link kosBuiltInIdent Constant
