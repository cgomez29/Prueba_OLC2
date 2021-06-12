/* Definición Léxica */
%lex
%%
\s+
 
","                                 return 't_coma';


"for"                               return 't_for';
"let"                               return 't_let';
"some"                              return 't_some';
"every"                             return 't_every';
"if"                                return 't_if';

"or"                                return 't_or';

"and"                               return 't_and';


"eq"                                return 't_eq';
"ne"                                return 't_ne';
"lt"                                return 't_lt';
"le"                                return 't_le';
"gt"                                return 't_gt';
"ge"                                return 't_ge';
"="					                return 't_igual';
"!"                                 return 't_diferente';
"<"					                return 't_menor_que';
">"					                return 't_mayor_que';
"is"                                return 't_is';

"|"                                 return 't_barra';

"to"                                return 't_to';

"+"					                return 't_suma';
"-"					                return 't_resta';

"*"                                 return 't_multiplicacion';
"div"                               return 't_div';
"idiv"                              return 't_idiv';
"mod"                               return 't_mod';

"union"                             return 't_union';


"except"                            return 't_except';

"instance"                          return 't_instance';
"of"                                return 't_of';

"treat"                             return 't_treat';
"as"                                return 't_as';

"castable"                          return 't_castable';

"cast"                              return 't_cast';


"/"					                return 't_diagonal';
":"                                 return 't_dos_puntos';
"."					                return 't_punto';
"@"					                return 't_arroba';
"["					                return 't_corchete_izquierdo';
"]"                                 return 't_corchete_derecho';
"("					                return 't_parentesis_izquierdo';
")"					                return 't_parentesis_derecho';
"{"					                return 't_llave_izquierda';
"}"					                return 't_llave_derecha';


'"'                                 return 't_comillas';
"'"                                 return 't_comilla';
"$"                                 return 't_dolar';

"%"					                return 't_modulo';
"#"					                return 't_numeral';

"return"                            return 't_return';

"in"                                return 't_in';

"satisfies"                         return 't_satisfies';

"then"                              return 't_then';
"else"                              return 't_else';

"child"                             return 't_child';
"descendant"                        return 't_descendant';
"attribute"                         return 't_attribute';
"self"                              return 't_self';
"descendant-or-self"                return 't_descendant-or-self';
"following-sibling"                 return 't_following-sibling';
"following"                         return 't_following';
"namespace"                         return 't_namespace';
"parent"                            return 't_parent';
"ancestor"                          return 't_ancestor';
"preceding-sibling"                 return 't_preceding_sibling';
"preceding-sibling"                 return 't_preceding-sibling';
"preceding"                         return 't_preceding';
"ancestor-or-self"                  return 't_ancestor_or_self';
"function"                          return 't_function';
"map"                               return 't_map';
"array"                             return 't_array';
"empty-sequence"                    return 't_empty-sequence';
"item"                              return 't_item';
"node"                              return 't_node';
"text"                              return 't_text';
"document-node"                     return 't_document-node';
"comment"                           return 't_comment';
"namespace-node"                    return 't_namespace-node';
"processing-instruction"            return 't_processing-instruction';
"schema-attribute"                  return 't_schema-attribute';
"element"                           return 't_element';
"schema-element"                    return 't_schema-element';
"?"                                 return 't_interrogacion';
"Q"                                 return 't_Q';
"x"                                 return 't_doble_comillas';
"y"                                 return 't_doble_comilla';
"not"                               return 't_not';



(([0-9]+"."[0-9]+)|(".[0-9]+"))     return 'DecimalLiteral';
[0-9]+                              return 'IntegerLiteral';
[a-zA-Z_][a-zA-Z0-9_ñÑ]*            return 'StringLiteral';

<<EOF>>				                return 'EOF';

.					                { console.error('Error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', y columna: ' + yylloc.first_column); }

/lex


/* Importacion */


%{
    const { Nodo } = require("../xpath/instrucciones/Nodo");   
    const { Expresion } = require("../xpath/instrucciones/Expresion");    
%}


/* Asociación de operadores y precedencia */


%left 't_coma'
%left 't_or'
%left 't_and'
//%left 't_barra'
%left 't_or'
%left 't_suma' 't_resta'
%left 't_multiplicacion' 't_div' 't_idiv' 't_mod'
%left 't_union' t_barra
%left 't_intersect' 't_except' 
%left 't_interrogacion'
%left 't_diagonal'
%left 't_corchete_izquierdo' 't_corchete_derecho' 't_interrogacion'

%left 'UMINUS'

%start INICIO

%% /* Definición de la gramática */



INICIO :
XPath EOF                    { $$ = $1; return $$; }
    ;


XPath	   :   	Expr	  //{$$ = new Expresion($1, @1.first_line, @1.first_column);}
;


FunctionBody	   :   	EnclosedExpr	
;

EnclosedExpr	   :   	t_llave_izquierda Expr t_llave_derecha	 
    |t_llave_izquierda t_llave_derecha	
;


Expr	   :   	ExprSingle 	Expr_recursivo     
;

Expr_recursivo :
    Expr_recursivo 
    |t_coma ExprSingle          
    |
    ;

ExprSingle	   :
 IfExpr
 |OrExpr             
;

IfExpr	   :   	t_if t_parentesis_izquierdo Expr t_parentesis_derecho t_then ExprSingle t_else ExprSingle 
;

OrExpr	   :   	AndExpr OrExpr_recursivo             
;

OrExpr_recursivo : 
    OrExpr_recursivo 
    |t_or AndExpr                          
    |
    ;

AndExpr	   :   	ComparisonExpr AndExpr_recursivo       
;

AndExpr_recursivo: 
    AndExpr_recursivo 
    |t_and ComparisonExpr
    |
    ;


ComparisonExpr	   : 
    StringConcatExpr ValueComp StringConcatExpr 
    |StringConcatExpr GeneralComp StringConcatExpr 
    |StringConcatExpr NodeComp StringConcatExpr  	
    |StringConcatExpr                                    
;



StringConcatExpr	   :   	RangeExpr StringConcatExpr_recursivo       
;

StringConcatExpr_recursivo : 
    StringConcatExpr_recursivo 
    |t_barra t_barra RangeExpr          
    |t_barra RangeExpr
    |
    ;


 
RangeExpr	   :   	AdditiveExpr t_to AdditiveExpr              
    |AdditiveExpr                                              
;



AdditiveExpr	   :   	MultiplicativeExpr AdditiveExpr_recursivo         
;

AdditiveExpr_recursivo : 
    AdditiveExpr_recursivo  
    |t_suma MultiplicativeExpr
    |t_resta MultiplicativeExpr
    |
    ;


MultiplicativeExpr	   :   	UnionExpr MultiplicativeExpr_recursivo   
;

MultiplicativeExpr_recursivo :
    MultiplicativeExpr_recursivo 
    |t_multiplicacion  UnionExpr
    |t_div UnionExpr
    |t_idiv UnionExpr
    | t_mod UnionExpr
    |
    ;

UnionExpr	   :   	IntersectExceptExpr 
;

IntersectExceptExpr	   :   	InstanceofExpr   
;

InstanceofExpr	   :   	TreatExpr t_instance t_of SequenceType    
    |TreatExpr                                                  
;

TreatExpr	   :   	CastableExpr t_treat t_as SequenceType   
    |CastableExpr 	                                          
;

CastableExpr	   :   CastExpr     
    ;

CastExpr	   :   	ArrowExpr 
;

ArrowExpr	   :   	UnaryExpr ArrowExpr_recursivo  
;

ArrowExpr_recursivo :
    ArrowExpr_recursivo 
    |t_igual t_mayor_que ArrowFunctionSpecifier ArgumentList	
    |
    ;
    
UnaryExpr	   :   	UnaryExpr_recursivo ValueExpr	 
;

UnaryExpr_recursivo : 
    UnaryExpr_recursivo 
    | t_suma
    | t_resta
    |
    ;

ValueExpr	   :   	SimpleMapExpr	
;


GeneralComp	   :   	
    t_igual 
    | t_diferente t_igual 
    | t_menor_que 
    | t_menor_que t_igual 
    | t_mayor_que 
    | t_mayor_que t_igual
    
;


ValueComp	   :   	
    t_eq 
    | t_ne 
    | t_lt 
    | t_le 
    | t_gt 
    | t_ge	
;




NodeComp	   :   	
    t_is 
    | t_menor_que t_menor_que 
    | t_mayor_que t_mayor_que	
;


SimpleMapExpr	   :   	PathExpr SimpleMapExpr_recursivo   
;

SimpleMapExpr_recursivo :
    SimpleMapExpr_recursivo 
    |t_diferente PathExpr
    |
    ;

PathExpr	   :   	t_diagonal RelativePathExpr     
    |t_diagonal                                 {$$ = new Nodo($1, @1.first_line, @1.first_column);}
    |t_diagonal t_diagonal RelativePathExpr
    |t_diagonal t_diagonal                      {$$ = new Nodo('/'+$1, @1.first_line, @1.first_column);}
    | RelativePathExpr                          
    ;

RelativePathExpr	   :   	StepExpr RelativePathExpr_recursivo
;


RelativePathExpr_recursivo : 
    RelativePathExpr_recursivo 
    |RelativePathExpr_recursivo t_diagonal StepExpr
    |RelativePathExpr_recursivo t_diagonal t_diagonal StepExpr
    |
    ;

StepExpr	   :  
    PostfixExpr 
   |AxisStep
;

AxisStep	   :   	
    ReverseStep PredicateList	
    |ForwardStep PredicateList	                
;


ForwardStep	   :   	
    ForwardAxis NodeTest 
    | AbbrevForwardStep	
;



ForwardAxis	   :   	t_child t_dos_puntos t_dos_puntos
| t_descendant t_dos_puntos t_dos_puntos
| t_attribute t_dos_puntos t_dos_puntos
| t_self t_dos_puntos t_dos_puntos
| t_descendant-or-self t_dos_puntos t_dos_puntos
| t_following-sibling t_dos_puntos t_dos_puntos
| t_following t_dos_puntos t_dos_puntos
| t_namespace t_dos_puntos t_dos_puntos	
;

AbbrevForwardStep	   :   	t_arroba NodeTest	
    |NodeTest	
;

ReverseStep	   :   	
    ReverseAxis NodeTest
   |AbbrevReverseStep
;

ReverseAxis	   :   	t_parent t_dos_puntos t_dos_puntos
| t_ancestor t_dos_puntos t_dos_puntos                   
| t_preceding_sibling t_dos_puntos t_dos_puntos
| t_preceding t_dos_puntos t_dos_puntos              
| t_ancestor_or_self t_dos_puntos t_dos_puntos
;

AbbrevReverseStep	   :   	t_punto t_punto	   {$$ = new Nodo('.'+$1, @1.first_line, @1.first_column);}
|t_arroba                                       {$$ = new Nodo($1, @1.first_line, @1.first_column);}
;

NodeTest	   :   	KindTest 
    |NameTest
;

NameTest : 
    StringLiteral 
    | Wildcard
;

Wildcard : t_multiplicacion
    |NCName  t_dos_puntos t_multiplicacion
    |t_multiplicacion t_dos_puntos NCName
    |t_arroba t_multiplicacion
    | t_node t_parentesis_izquierdo t_parentesis_derecho
    ;


PostfixExpr	   :   	PrimaryExpr PostfixExpr_recursivo
;

PostfixExpr_recursivo: 
    PostfixExpr_recursivo 
    | Predicate
    | ArgumentList
    | Lookup
    |
    ;

ArgumentList	   :   	t_parentesis_izquierdo Argument ArgumentList_recursivo t_parentesis_derecho	
    |t_parentesis_izquierdo t_parentesis_derecho	
;

ArgumentList_recursivo : 
    ArgumentList_recursivo 
    |t_coma Argument
    |
    ;


PredicateList	   :   	
    PredicateList Predicate
    |
;

Predicate	   :   	
    t_corchete_izquierdo Expr t_corchete_derecho
    |t_corchete_izquierdo t_arroba Expr t_corchete_derecho
    |t_corchete_izquierdo t_arroba Expr t_igual t_comilla StringLiteral t_comilla  t_corchete_derecho
;

Lookup	   :   	t_interrogacion KeySpecifier	                                                 
;

KeySpecifier	   :   NCName
    |IntegerLiteral 
    | ParenthesizedExpr 
    | t_multiplicacion	
;

ArrowFunctionSpecifier	   :   	
    EQName
    |ParenthesizedExpr
    |VarRef	                                                                 
;

PrimaryExpr	   :   	Literal
|VarRef
| ParenthesizedExpr
| ContextItemExpr
| FunctionItemExpr
| MapConstructor
| ArrayConstructor
| UnaryLookup	
;

Literal	   :   	NumericLiteral  
	| StringLiteral				 
;


NumericLiteral	   :   	IntegerLiteral | DecimalLiteral
;

VarRef : t_dolar VarName
;

VarName : EQName
;

ParenthesizedExpr	   :   	t_parentesis_izquierdo Expr t_parentesis_derecho
    |	t_parentesis_izquierdo t_parentesis_derecho
;

ContextItemExpr	   :   	t_punto	    {$$ = new Nodo($1, @1.first_line, @1.first_column);}
;

Argument	   :   	ExprSingle | ArgumentPlaceholder	
;

ArgumentPlaceholder	   :   	t_interrogacion	
;

FunctionItemExpr	   :   	 InlineFunctionExpr	
;
InlineFunctionExpr	   :   	
    t_function t_parentesis_izquierdo  t_parentesis_derecho t_as SequenceType FunctionBody   
    |t_function t_parentesis_izquierdo t_parentesis_derecho FunctionBody              
;

MapConstructor	   :   	t_map t_llave_izquierda MapConstructorEntry MapConstructor_recursivo t_llave_derecha
    |t_map t_llave_izquierda t_llave_derecha
;

MapConstructor_recursivo :
    MapConstructor_recursivo 
    |t_coma MapConstructorEntry
    |
    ;


MapConstructorEntry	   :   	ExprSingle t_dos_puntos ExprSingle	
;

ArrayConstructor	   :   	SquareArrayConstructor 
    | CurlyArrayConstructor	
;

SquareArrayConstructor	   :   	t_corchete_izquierdo ExprSingle SquareArrayConstructor_recursivo t_corchete_derecho
    |t_corchete_izquierdo t_corchete_derecho
;
SquareArrayConstructor_recursivo :
    SquareArrayConstructor_recursivo 
    |t_coma ExprSingle
    |
    ;

CurlyArrayConstructor	   :   	t_array EnclosedExpr	
;

UnaryLookup	   :   	t_interrogacion KeySpecifier	
;

SequenceType	   :   	t_empty-sequence t_parentesis_izquierdo t_parentesis_derecho
| ItemType OccurrenceIndicator
| ItemType	
;

OccurrenceIndicator	   :   	t_interrogacion | t_multiplicacion | t_suma	
;

ItemType	   :   	KindTest | t_item t_parentesis_izquierdo t_parentesis_derecho | FunctionTest | MapTest | ArrayTest | ParenthesizedItemType	
;


KindTest	   :   	DocumentTest
| ElementTest
| AttributeTest
| PITest
| CommentTest
| TextTest
| NamespaceNodeTest                   
| AnyKindTest	
;

AnyKindTest	   :   	t_node t_parentesis_izquierdo t_parentesis_derecho	
;

DocumentTest	   :   	t_document-node t_parentesis_izquierdo ElementTest t_parentesis_derecho	    
    |t_document-node t_parentesis_izquierdo t_parentesis_derecho	
;

TextTest	   :   	t_text t_parentesis_izquierdo t_parentesis_derecho	
;


CommentTest	   :   	t_comment t_parentesis_izquierdo t_parentesis_derecho	
;

NamespaceNodeTest	   :   	t_namespace-node t_parentesis_izquierdo t_parentesis_derecho	
;

PITest	   :   	
    t_processing-instruction t_parentesis_izquierdo StringLiteral t_parentesis_derecho
    |t_processing-instruction t_parentesis_izquierdo t_parentesis_derecho
;


AttributeTest	   :   	    
    t_attribute t_parentesis_izquierdo AttribNameOrWildcard t_parentesis_derecho
    |t_attribute t_parentesis_izquierdo t_parentesis_derecho
;

AttribNameOrWildcard	   :   	t_multiplicacion	
;



ElementTest	   :                             
    t_element t_parentesis_izquierdo  t_parentesis_derecho    
;


FunctionTest	   :   	AnyFunctionTest
| TypedFunctionTest	
;

AnyFunctionTest	   :   	t_function t_parentesis_izquierdo t_multiplicacion t_parentesis_derecho	
;

TypedFunctionTest	   :   	t_function t_parentesis_izquierdo SequenceType TypedFunctionTest_recursivo t_parentesis_derecho t_as SequenceType
    |t_function t_parentesis_izquierdo t_parentesis_derecho t_as SequenceType	
;

TypedFunctionTest_recursivo :
    TypedFunctionTest_recursivo 
    |t_coma SequenceType
    |
    ;


MapTest	   :   	AnyMapTest
;

AnyMapTest	   :   	t_map t_parentesis_izquierdo t_multiplicacion t_parentesis_derecho	
;


ArrayTest	   :   	AnyArrayTest | TypedArrayTest	
;

AnyArrayTest	   :   	t_array t_parentesis_izquierdo t_multiplicacion t_parentesis_derecho	
;

TypedArrayTest	   :   	t_array t_parentesis_izquierdo SequenceType t_parentesis_derecho
;

ParenthesizedItemType	   :   	t_parentesis_izquierdo ItemType t_parentesis_derecho	
;




QName	   :
   	PrefixedName
    | UnprefixedName
    | StringLiteral
    ;

PrefixedName	   :   	Prefix t_dos_puntos LocalPart
;

UnprefixedName	   :   	LocalPart
;

Prefix	   :   	NCName
;

LocalPart	   :   	NCName
;


NCName	   :   	StringLiteral
;