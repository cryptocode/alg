grammar Alg;

file: expr* EOF;

expr
    : literal_expr
    | quoted_expr
    ;

// The order of choice is important; invocation must come before
// list, for instance, to avoid invocations being parsed as lists.
literal_expr
    : atom
    | list
    ;

quoted_expr
    : '\'' literal_expr
    ;

// List of literals not matched by other parenthized expressions
list: '(' expr* ')' ;

atom
    : string
    | number
    | character
    | symbol
    ;

symbol : NAME;
string: STRING;

num_hex: HEX;
num_bin: BIN;
num_int: LONG;
num_oct: OCT;
num_float: FLOAT;

number
    : num_float
    | num_int
    | num_hex
    | num_bin
    | num_oct
    ;

character
    //: named_char
    : u_hex_quad
    | any_char
    ;
any_char: CHAR_ANY ;
u_hex_quad: CHAR_U ;

// Lexer tokens

STRING : '"' ( ~'"' | '\\' '"' )* '"' ;

// FIXME: Doesn't deal with arbitrary read radixes, BigNums
FLOAT
    : ('-'|'+')? [0-9]+ FLOAT_TAIL
    | ('-'|'+')? 'Inf'
    | ('-'|'+')? 'NaN'
    ;

fragment
FLOAT_TAIL
    : FLOAT_DECIMAL FLOAT_EXP
    | FLOAT_DECIMAL
    | FLOAT_EXP
    ;

fragment
FLOAT_DECIMAL
    : '.' [0-9]+
    ;

fragment
FLOAT_EXP
    : [eE] '-'? [0-9]+
    ;

fragment
HEXD: [0-9a-fA-F] ;
HEX: '0' [xX] HEXD+ ;
BIN: '0' [bB] [10]+ ;
OCT: '-'? '0' [0-7]+ ;
LONG: '-'? [0-9] [0-9]*;

CHAR_U
    : '\\' 'u'[0-9D-Fd-f] HEXD HEXD HEXD ;
CHAR_ANY : '\\' . ;

ELLIPSES : '...';// -> skip;
NAME: SYMBOL_HEAD SYMBOL_REST* (':' SYMBOL_REST+)* ELLIPSES?;

fragment
SYMBOL_HEAD
    : ~('0' .. '9'
        | '.' | '\'' | '"' | ':' | '(' | ')'  /// | '[' | ']' | '{' | '}'  // []{} allowed, may be macro reader characters
        | [ \n\r\t,]
        )
    ;

fragment
SYMBOL_REST
    : SYMBOL_HEAD
    | '0'..'9'
    //| '.'
    ;

fragment
WS : [ \n\r\t,] ;

fragment
COMMENT: '//' ~[\r\n]*;

fragment
SEMI_COMMENT: ';' ~[\r\n]*;

// Nested block comments are allowed
BLOCK_COMMENT
    : '/*' (BLOCK_COMMENT|.)*? '*/' -> channel(HIDDEN) ;

TRASH
    : ( WS | COMMENT | SEMI_COMMENT) -> channel(HIDDEN)
    ;
