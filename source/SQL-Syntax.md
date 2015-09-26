# SQL parser syntax

[BNF](https://en.wikipedia.org/wiki/Backus-Naur_Form) token specification
```java
DOCUMENT START
TOKENS
<DEFAULT> SKIP : {
" "
| "\t"
| "\n"
| "\r"
}

/** reserved words **/<DEFAULT> TOKEN : {
<SELECT: ("s" | "S") ("e" | "E") ("l" | "L") ("e" | "E") ("c" | "C") ("t" | "T")>
| <INSERT: ("i" | "I") ("n" | "N") ("s" | "S") ("e" | "E") ("r" | "R") ("t" | "T")>
| <UPDATE: ("u" | "U") ("p" | "P") ("d" | "D") ("a" | "A") ("t" | "T") ("e" | "E")>
| <DELETE: ("d" | "D") ("e" | "E") ("l" | "L") ("e" | "E") ("t" | "T") ("e" | "E")>
| <FROM: ("f" | "F") ("r" | "R") ("o" | "O") ("m" | "M")>
| <WHERE: ("w" | "W") ("h" | "H") ("e" | "E") ("r" | "R") ("e" | "E")>
| <INTO: ("i" | "I") ("n" | "N") ("t" | "T") ("o" | "O")>
| <VALUES: ("v" | "V") ("a" | "A") ("l" | "L") ("u" | "U") ("e" | "E") ("s" | "S")>
| <SET: ("s" | "S") ("e" | "E") ("t" | "T")>
| <ADD: ("a" | "A") ("d" | "D") ("d" | "D")>
| <REMOVE: ("r" | "R") ("e" | "E") ("m" | "M") ("o" | "O") ("v" | "V") ("e" | "E")>
| <AND: ("a" | "A") ("n" | "N") ("d" | "D")>
| <OR: ("o" | "O") ("r" | "R")>
| <NULL: ("N" | "n") ("U" | "u") ("L" | "l") ("L" | "l")>
| <ORDER: ("o" | "O") ("r" | "R") ("d" | "D") ("e" | "E") ("r" | "R")>
| <BY: ("b" | "B") ("y" | "Y")>
| <LIMIT: ("l" | "L") ("i" | "I") ("m" | "M") ("i" | "I") ("t" | "T")>
| <RANGE: ("r" | "R") ("a" | "A") ("n" | "N") ("g" | "G") ("e" | "E")>
| <ASC: ("a" | "A") ("s" | "S") ("c" | "C")>
| <AS: ("a" | "A") ("s" | "S")>
| <DESC: ("d" | "D") ("e" | "E") ("s" | "S") ("c" | "C")>
| <THIS: "@this">
| <RECORD_ATTRIBUTE: <RID_ATTR> | <CLASS_ATTR> | <VERSION_ATTR> | <SIZE_ATTR> | <TYPE_ATTR>>
| <#RID_ATTR: "@rid">
| <#CLASS_ATTR: "@class">
| <#VERSION_ATTR: "@version">
| <#SIZE_ATTR: "@size">
| <#TYPE_ATTR: "@type">
}

/** LITERALS **/<DEFAULT> TOKEN : {
<INTEGER_LITERAL: <DECIMAL_LITERAL> ([| <HEX_LITERAL> (["l","L"]("l","L"].md)?))? | <OCTAL_LITERAL> ([| <#DECIMAL_LITERAL: ["1"-"9"]("l","L"].md)?>) ([| <#HEX_LITERAL: "0" ["x","X"]("0"-"9"].md)*>) ([| <#OCTAL_LITERAL: "0" (["0"-"7"]("0"-"9","a"-"f","A"-"F"].md)+>))**>
| <FLOATING_POINT_LITERAL: <DECIMAL_FLOATING_POINT_LITERAL> | <HEXADECIMAL_FLOATING_POINT_LITERAL>>
| <#DECIMAL_FLOATING_POINT_LITERAL: (["." (["0"-"9"]("0"-"9"].md)+))** (<DECIMAL_EXPONENT>)? ([| "." (["0"-"9"]("f","F","d","D"].md)?))+ (<DECIMAL_EXPONENT>)? ([| (["0"-"9"]("f","F","d","D"].md)?))+ <DECIMAL_EXPONENT> ([| (["0"-"9"]("f","F","d","D"].md)?))+ (<DECIMAL_EXPONENT>)? [| <#DECIMAL_EXPONENT: ["e","E"]("f","F","d","D"]>.md) ([(["0"-"9"]("+","-"].md)?))+>
| <#HEXADECIMAL_FLOATING_POINT_LITERAL: "0" [(["0"-"9","a"-"f","A"-"F"]("x","X"].md))+ (".")? <HEXADECIMAL_EXPONENT> ([| "0" ["x","X"]("f","F","d","D"].md)?) (["." (["0"-"9","a"-"f","A"-"F"]("0"-"9","a"-"f","A"-"F"].md)*))+ <HEXADECIMAL_EXPONENT> ([| <#HEXADECIMAL_EXPONENT: ["p","P"]("f","F","d","D"].md)?>) ([(["0"-"9"]("+","-"].md)?))+>
| <CHARACTER_LITERAL: "\'" (~[| "\\" (["n","t","b","r","f","\\","\'","\""]("\'","\\","\n","\r"].md) | [(["0"-"7"]("0"-"7"].md))? | ["0"-"7"]("0"-"7".md)"0"-"3"]) ["\'">
| <STRING_LITERAL: "\"" (~["\"","\\","\n","\r"]("0"-"7"].md))) | "\\" ([| ["0"-"7"]("n","t","b","r","f","\\","\'","\""].md) ([| ["0"-"3"]("0"-"7"].md)?) ["0"-"7"]("0"-"7".md)"0"-"7"])))** "\"" | "\'" (~[| "\\" (["n","t","b","r","f","\\","\'","\""]("\'","\\","\n","\r"].md) | [(["0"-"7"]("0"-"7"].md))? | ["0"-"7"]("0"-"7".md)"0"-"3"]) ["\'">
}

/* SEPARATORS */<DEFAULT> TOKEN : {
<LPAREN: "(">
| <RPAREN: ")">
| <LBRACE: "{">
| <RBRACE: "}">
| <LBRACKET: "[">
| <RBRACKET: "]("0"-"7"].md))*)">
| <SEMICOLON: ";">
| <COMMA: ",">
| <DOT: ".">
| <AT: "@">
}

/** OPERATORS **/<DEFAULT> TOKEN : {
<EQ: "=">
| <LT: "<">
| <GT: ">">
| <BANG: "!">
| <TILDE: "~">
| <HOOK: "?">
| <COLON: ":">
| <LE: "<=">
| <GE: ">=">
| <NE: "!=">
| <NEQ: "<>">
| <SC_OR: "||">
| <SC_AND: "&&">
| <INCR: "++">
| <DECR: "--">
| <PLUS: "+">
| <MINUS: "-">
| <STAR: "**">
| <SLASH: "/">
| <BIT_AND: "&">
| <BIT_OR: "|">
| <XOR: "^">
| <REM: "%">
| <LSHIFT: "<<">
| <PLUSASSIGN: "+=">
| <MINUSASSIGN: "-=">
| <STARASSIGN: "**=">
| <SLASHASSIGN: "/=">
| <ANDASSIGN: "&=">
| <ORASSIGN: "|=">
| <XORASSIGN: "^=">
| <REMASSIGN: "%=">
| <LSHIFTASSIGN: "<<=">
| <RSIGNEDSHIFTASSIGN: ">>=">
| <RUNSIGNEDSHIFTASSIGN: ">>>=">
| <ELLIPSIS: "...">
| <NOT: ("N" | "n") ("O" | "o") ("T" | "t")>
| <LIKE: ("L" | "l") ("I" | "i") ("K" | "k") ("E" | "e")>
| <IS: "is" | "IS" | "Is" | "iS">
| <IN: "in" | "IN" | "In" | "iN">
| <BETWEEN: ("B" | "b") ("E" | "e") ("T" | "t") ("W" | "w") ("E" | "e") ("E" | "e") ("N" | "n")>
| <CONTAINS: ("C" | "c") ("O" | "o") ("N" | "n") ("T" | "t") ("A" | "a") ("I" | "i") ("N" | "n") ("S" | "s")>
| <CONTAINSALL: ("C" | "c") ("O" | "o") ("N" | "n") ("T" | "t") ("A" | "a") ("I" | "i") ("N" | "n") ("S" | "s") ("A" | "a") ("L" | "l") ("L" | "l")>
| <CONTAINSKEY: ("C" | "c") ("O" | "o") ("N" | "n") ("T" | "t") ("A" | "a") ("I" | "i") ("N" | "n") ("S" | "s") ("K" | "k") ("E" | "e") ("Y" | "y")>
| <CONTAINSVALUE: ("C" | "c") ("O" | "o") ("N" | "n") ("T" | "t") ("A" | "a") ("I" | "i") ("N" | "n") ("S" | "s") ("V" | "v") ("A" | "a") ("L" | "l") ("U" | "u") ("E" | "e")>
| <CONTAINSTEXT: ("C" | "c") ("O" | "o") ("N" | "n") ("T" | "t") ("A" | "a") ("I" | "i") ("N" | "n") ("S" | "s") ("T" | "t") ("E" | "e") ("X" | "x") ("T" | "t")>
| <MATCHES: ("M" | "m") ("A" | "a") ("T" | "t") ("C" | "c") ("H" | "h") ("E" | "e") ("S" | "s")>
| <TRAVERSE: ("T" | "t") ("R" | "r") ("A" | "a") ("V" | "v") ("E" | "e") ("R" | "r") ("S" | "s") ("E" | "e")>
}

<DEFAULT> TOKEN : {
<IDENTIFIER: <LETTER> (<PART_LETTER>)**>
| <#LETTER: [| <#PART_LETTER: ["0"-"9","A"-"Z","_","a"-"z"]("A"-"Z","_","a"-"z"]>.md)>
}

NON-TERMINALS
	Rid	:=	"#" <INTEGER_LITERAL> <COLON> <INTEGER_LITERAL>
		|	<INTEGER_LITERAL> <COLON> <INTEGER_LITERAL>
/** Root production. **/	OrientGrammar	:=	Statement <EOF>
	Statement	:=	( SelectStatement | DeleteStatement | InsertStatement | UpdateStatement )
	SelectStatement	:=	<SELECT> ( Projection )? <FROM> FromClause ( <WHERE> WhereClause )? ( OrderBy )? ( Limit )? ( Range )?
	DeleteStatement	:=	<DELETE> <FROM> <IDENTIFIER> ( <WHERE> WhereClause )?
	UpdateStatement	:=	<UPDATE> ( <IDENTIFIER> | Cluster | IndexIdentifier ) ( ( <SET> UpdateItem ( "," UpdateItem )** ) ) ( <WHERE> WhereClause )?
	UpdateItem	:=	<IDENTIFIER> <EQ> ( <NULL> | <STRING_LITERAL> | Rid | <INTEGER_LITERAL> | <FLOATING_POINT_LITERAL> | <CHARACTER_LITERAL> | <LBRACKET> Rid ( "," Rid )** <RBRACKET> )
	UpdateAddItem	:=	<IDENTIFIER> <EQ> ( <STRING_LITERAL> | Rid | <INTEGER_LITERAL> | <FLOATING_POINT_LITERAL> | <CHARACTER_LITERAL> | <LBRACKET> Rid ( "," Rid )** <RBRACKET> )
	InsertStatement	:=	<INSERT> <INTO> ( <IDENTIFIER> | Cluster ) <LPAREN> <IDENTIFIER> ( "," <IDENTIFIER> ) <RPAREN> <VALUES> <LPAREN> InsertExpression ( "," InsertExpression ) <RPAREN>
	InsertExpression	:=	<NULL>
		|	<STRING_LITERAL>
		|	<INTEGER_LITERAL>
		|	<FLOATING_POINT_LITERAL>
		|	Rid
		|	<CHARACTER_LITERAL>
		|	<LBRACKET> Rid ( "," Rid )** <RBRACKET>
	InputParameter	:=	"?"
	Projection	:=	ProjectionItem ( "," ProjectionItem )**
	ProjectionItem	:=	"**"
		|	( ( <NULL> | <INTEGER_LITERAL> | <STRING_LITERAL> | <FLOATING_POINT_LITERAL> | <CHARACTER_LITERAL> | FunctionCall | DottedIdentifier | RecordAttribute | ThisOperation | InputParameter ) ( <AS> Alias )? )
	FilterItem	:=	<NULL>
		|	Any
		|	All
		|	<INTEGER_LITERAL>
		|	<STRING_LITERAL>
		|	<FLOATING_POINT_LITERAL>
		|	<CHARACTER_LITERAL>
		|	FunctionCall
		|	DottedIdentifier
		|	RecordAttribute
		|	ThisOperation
		|	InputParameter
	Alias	:=	<IDENTIFIER>
	Any	:=	"any()"
	All	:=	"all()"
	RecordAttribute	:=	<RECORD_ATTRIBUTE>
	ThisOperation	:=	<THIS> ( FieldOperator )**
	FunctionCall	:=	<IDENTIFIER> <LPAREN> ( "**" | ( FilterItem ( "," FilterItem )** ) ) <RPAREN> ( FieldOperator )**
	FieldOperator	:=	( <DOT> <IDENTIFIER> <LPAREN> ( FilterItem ( "," FilterItem )** )? <RPAREN> )
		|	( "[<STRING_LITERAL> "](".md)" )
	DottedIdentifier	:=	<IDENTIFIER> ( "[WhereClause "](".md)" )+
		|	<IDENTIFIER> ( FieldOperator )+
		|	<IDENTIFIER> ( <DOT> DottedIdentifier )?
	FromClause	:=	FromItem
	FromItem	:=	Rid
		|	<LBRACKET> Rid ( "," Rid )** <RBRACKET>
		|	Cluster
		|	IndexIdentifier
		|	<IDENTIFIER>
	Cluster	:=	"cluster:" <IDENTIFIER>
	IndexIdentifier	:=	"index:" <IDENTIFIER>
	WhereClause	:=	OrBlock
	OrBlock	:=	AndBlock ( <OR> AndBlock )**
	AndBlock	:=	( NotBlock ) ( <AND> ( NotBlock ) )**
	NotBlock	:=	( <NOT> )? ( ConditionBlock | ParenthesisBlock )
	ParenthesisBlock	:=	<LPAREN> OrBlock <RPAREN>
	ConditionBlock	:=	TraverseCondition
		|	IsNotNullCondition
		|	IsNullCondition
		|	BinaryCondition
		|	BetweenCondition
		|	ContainsCondition
		|	ContainsTextCondition
		|	MatchesCondition
	CompareOperator	:=	EqualsCompareOperator
		|	LtOperator
		|	GtOperator
		|	NeOperator
		|	NeqOperator
		|	GeOperator
		|	LeOperator
		|	InOperator
		|	NotInOperator
		|	LikeOperator
		|	ContainsKeyOperator
		|	ContainsValueOperator
	LtOperator	:=	<LT>
	GtOperator	:=	<GT>
	NeOperator	:=	<NE>
	NeqOperator	:=	<NEQ>
	GeOperator	:=	<GE>
	LeOperator	:=	<LE>
	InOperator	:=	<IN>
	NotInOperator	:=	<NOT> <IN>
	LikeOperator	:=	<LIKE>
	ContainsKeyOperator	:=	<CONTAINSKEY>
	ContainsValueOperator	:=	<CONTAINSVALUE>
	EqualsCompareOperator	:=	<EQ>
	BinaryCondition	:=	FilterItem CompareOperator ( Rid | FilterItem )
	BetweenCondition	:=	FilterItem <BETWEEN> FilterItem <AND> FilterItem
	IsNullCondition	:=	FilterItem <IS> <NULL>
	IsNotNullCondition	:=	FilterItem <IS> <NOT> <NULL>
	ContainsCondition	:=	FilterItem <CONTAINS> <LPAREN> OrBlock <RPAREN>
	ContainsAllCondition	:=	FilterItem <CONTAINSALL> <LPAREN> OrBlock <RPAREN>
	ContainsTextCondition	:=	FilterItem <CONTAINSTEXT> ( <STRING_LITERAL> | DottedIdentifier )
	MatchesCondition	:=	FilterItem <MATCHES> <STRING_LITERAL>
	TraverseCondition	:=	<TRAVERSE> ( <LPAREN> <INTEGER_LITERAL> ( "," <INTEGER_LITERAL> ( "," TraverseFields )? )? <RPAREN> )? <LPAREN> OrBlock <RPAREN>
	TraverseFields	:=	<STRING_LITERAL>
	OrderBy	:=	<ORDER> <BY> <IDENTIFIER> ( "," <IDENTIFIER> )** ( <DESC> | <ASC> )?
	Limit	:=	<LIMIT> <INTEGER_LITERAL>
	Range	:=	<RANGE> Rid ( "," Rid )?

DOCUMENT END
```
