-- This Happy file was machine-generated by the BNF converter
{
{-# OPTIONS -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
module ParholOgram where
import AbsholOgram
import LexholOgram
import ErrM
}

%name pProcess Process
%name pListGuardedProcess ListGuardedProcess
%name pListProcess ListProcess
%name pGuardedProcess GuardedProcess
%name pAbstraction Abstraction
%name pConcretion Concretion
%name pListPattern ListPattern
%name pPattern Pattern
%name pQuery Query
%name pSum Sum
%name pListGuardedPattern ListGuardedPattern
%name pGuardedPattern GuardedPattern
%name pTuplePattern TuplePattern
%name pListNestedTuplePattern ListNestedTuplePattern
%name pNestedTuplePattern NestedTuplePattern
%name pSite Site
%name pCode Code
%name pVariable Variable
%name pValue Value
%name pGroundLiteral GroundLiteral
%name pBooleanLiteral BooleanLiteral
%name pCase Case
%name pRec Rec
%name pModels Models
%name pPar Par
%name pZero Zero
%name pLParen LParen
%name pRParen RParen
%name pLMSet LMSet
%name pRMSet RMSet
%name pLAngle LAngle
%name pRAngle RAngle
%name pLBrack LBrack
%name pRBrack RBrack
%name pLCurly LCurly
%name pRCurly RCurly
%name pQuote Quote
%name pBang Bang
%name pWhimper Whimper
%name pAmpersand Ampersand
%name pTilde Tilde
%name pAt At
%name pStar Star
%name pDot Dot
%name pUnderscore Underscore
%name pAssign Assign
%name pCons Cons
%name pLQuote LQuote
%name pRQuote RQuote

-- no lexer declaration
%monad { Err } { thenM } { returnM }
%tokentype { Token }

%token 
 '{' { PT _ (TS "{") }
 '}' { PT _ (TS "}") }
 '@' { PT _ (TS "@") }
 ';' { PT _ (TS ";") }
 '?' { PT _ (TS "?") }
 '(' { PT _ (TS "(") }
 ')' { PT _ (TS ")") }
 '.' { PT _ (TS ".") }
 '!' { PT _ (TS "!") }
 ':=' { PT _ (TS ":=") }
 ',' { PT _ (TS ",") }
 '<<' { PT _ (TS "<<") }
 '>>' { PT _ (TS ">>") }
 '+' { PT _ (TS "+") }
 '*' { PT _ (TS "*") }
 '::' { PT _ (TS "::") }
 '|=' { PT _ (TS "|=") }
 '|' { PT _ (TS "|") }
 '0' { PT _ (TS "0") }
 '{|' { PT _ (TS "{|") }
 '|}' { PT _ (TS "|}") }
 '<' { PT _ (TS "<") }
 '>' { PT _ (TS ">") }
 '[' { PT _ (TS "[") }
 ']' { PT _ (TS "]") }
 '\'' { PT _ (TS "'") }
 '&' { PT _ (TS "&") }
 '~' { PT _ (TS "~") }
 '_' { PT _ (TS "_") }
 'case' { PT _ (TS "case") }
 'false' { PT _ (TS "false") }
 'rec' { PT _ (TS "rec") }
 'true' { PT _ (TS "true") }

L_ident  { PT _ (TV $$) }
L_charac { PT _ (TC $$) }
L_integ  { PT _ (TI $$) }
L_doubl  { PT _ (TD $$) }
L_quoted { PT _ (TL $$) }
L_err    { _ }


%%

Ident   :: { Ident }   : L_ident  { Ident $1 }
Char    :: { Char }    : L_charac { (read $1) :: Char }
Integer :: { Integer } : L_integ  { (read $1) :: Integer }
Double  :: { Double }  : L_doubl  { (read $1) :: Double }
String  :: { String }  : L_quoted { $1 }

Process :: { Process }
Process : 'case' '{' ListGuardedProcess '}' { Selection (reverse $3) } 
  | '{' ListProcess '}' { Composition (reverse $2) }
  | '@' Site { Dereference $2 }


ListGuardedProcess :: { [GuardedProcess] }
ListGuardedProcess : {- empty -} { [] } 
  | ListGuardedProcess GuardedProcess ';' { flip (:) $1 $2 }


ListProcess :: { [Process] }
ListProcess : {- empty -} { [] } 
  | ListProcess Process ';' { flip (:) $1 $2 }


GuardedProcess :: { GuardedProcess }
GuardedProcess : Site Abstraction { Input $1 $2 } 
  | Site Concretion { Output $1 $2 }


Abstraction :: { Abstraction }
Abstraction : '?' '(' ListPattern ')' '.' Process { AgentIn (reverse $3) $6 } 


Concretion :: { Concretion }
Concretion : '!' '(' ListPattern ')' ':=' '(' ListProcess ')' '.' Process { AgentOut (reverse $3) (reverse $7) $10 } 


ListPattern :: { [Pattern] }
ListPattern : {- empty -} { [] } 
  | ListPattern Pattern ',' { flip (:) $1 $2 }


Pattern :: { Pattern }
Pattern : Code { Value $1 } 
  | Query { QueryPattern $1 }


Query :: { Query }
Query : Sum { SumQuery $1 } 
  | '{' ListPattern '}' { ParQuery (reverse $2) }
  | '@' '<<' Pattern '>>' { DropQuery $3 }
  | 'rec' Ident '.' Pattern { RecQuery $2 $4 }


Sum :: { Sum }
Sum : Variable { Variable $1 } 
  | ListGuardedPattern { Summand (reverse $1) }


ListGuardedPattern :: { [GuardedPattern] }
ListGuardedPattern : {- empty -} { [] } 
  | ListGuardedPattern GuardedPattern '+' { flip (:) $1 $2 }


GuardedPattern :: { GuardedPattern }
GuardedPattern : '?' TuplePattern '.' Query { AbsPattern $2 $4 } 
  | '!' TuplePattern ':=' TuplePattern '.' Query { DataPattern $2 $4 $6 }
  | '*' Variable '.' Query { DerefPattern $2 $4 }


TuplePattern :: { TuplePattern }
TuplePattern : Variable { TupleVariable $1 } 
  | '(' ListNestedTuplePattern ')' { TupleList (reverse $2) }
  | Pattern '::' TuplePattern { TupleCons $1 $3 }


ListNestedTuplePattern :: { [NestedTuplePattern] }
ListNestedTuplePattern : {- empty -} { [] } 
  | ListNestedTuplePattern NestedTuplePattern ',' { flip (:) $1 $2 }


NestedTuplePattern :: { NestedTuplePattern }
NestedTuplePattern : Pattern { Base $1 } 
  | TuplePattern { Nesting $1 }


Site :: { Site }
Site : Code { CodeSite $1 } 
  | Variable { VariableSite $1 }


Code :: { Code }
Code : '<<' Process '>>' { Quotation $2 } 


Variable :: { Variable }
Variable : Ident { Identifier $1 } 
  | Underscore { Wildcard $1 }


Value :: { Value }
Value : Code { Codification $1 } 
  | GroundLiteral { Ground $1 }


GroundLiteral :: { GroundLiteral }
GroundLiteral : BooleanLiteral { Boolean $1 } 
  | Char { Char $1 }
  | Integer { Integer $1 }
  | Double { Double $1 }
  | String { String $1 }


BooleanLiteral :: { BooleanLiteral }
BooleanLiteral : 'true' { BooleanTrue } 
  | 'false' { BooleanFalse }


Case :: { Case }
Case : 'case' { CaseIt } 


Rec :: { Rec }
Rec : 'rec' { RecIt } 


Models :: { Models }
Models : '|=' { ModelIt } 


Par :: { Par }
Par : '|' { ParIt } 


Zero :: { Zero }
Zero : '0' { ZeroIt } 


LParen :: { LParen }
LParen : '(' { LParenIt } 


RParen :: { RParen }
RParen : ')' { RParenIt } 


LMSet :: { LMSet }
LMSet : '{|' { LMSetIt } 


RMSet :: { RMSet }
RMSet : '|}' { RMSetIt } 


LAngle :: { LAngle }
LAngle : '<' { LAngleIt } 


RAngle :: { RAngle }
RAngle : '>' { RAngleIt } 


LBrack :: { LBrack }
LBrack : '[' { LBrackIt } 


RBrack :: { RBrack }
RBrack : ']' { RBrackIt } 


LCurly :: { LCurly }
LCurly : '{' { LCurlyIt } 


RCurly :: { RCurly }
RCurly : '}' { RCurlyIt } 


Quote :: { Quote }
Quote : '\'' { QuoteIt } 


Bang :: { Bang }
Bang : '!' { BangIt } 


Whimper :: { Whimper }
Whimper : '?' { WhimperIt } 


Ampersand :: { Ampersand }
Ampersand : '&' { AmpersandIt } 


Tilde :: { Tilde }
Tilde : '~' { TildeIt } 


At :: { At }
At : '@' { AtIt } 


Star :: { Star }
Star : '*' { StarIt } 


Dot :: { Dot }
Dot : '.' { DotIt } 


Underscore :: { Underscore }
Underscore : '_' { UnderscoreIt } 


Assign :: { Assign }
Assign : ':=' { AssignIt } 


Cons :: { Cons }
Cons : '::' { ConsIt } 


LQuote :: { LQuote }
LQuote : '<<' { LQuoteIt } 


RQuote :: { RQuote }
RQuote : '>>' { RQuoteIt } 



{

returnM :: a -> Err a
returnM = return

thenM :: Err a -> (a -> Err b) -> Err b
thenM = (>>=)

happyError :: [Token] -> Err a
happyError ts =
  Bad $ "syntax error at " ++ tokenPos ts ++ 
  case ts of
    [] -> []
    [Err _] -> " due to lexer error"
    _ -> " before " ++ unwords (map prToken (take 4 ts))

myLexer = tokens
}

