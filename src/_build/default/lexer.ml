# 1 "lexer.mll"
 
    open Parser
    open Lexing
    exception Error of string

    let next_line lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <-
        { pos with pos_bol = lexbuf.lex_curr_pos;
            pos_lnum = pos.pos_lnum + 1
        }

# 15 "lexer.ml"
let __ocaml_lex_tables = {
  Lexing.lex_base =
   "\000\000\222\255\223\255\075\000\225\255\025\000\029\000\029\000\
    \233\255\234\255\235\255\236\255\238\255\239\255\002\000\003\000\
    \008\000\010\000\038\000\039\000\101\000\091\000\103\000\036\000\
    \252\255\041\000\254\255\255\255\025\000\253\255\068\000\050\000\
    \052\000\251\255\064\000\060\000\250\255\057\000\100\000\228\255\
    \091\000\106\000\094\000\106\000\105\000\249\255\093\000\095\000\
    \231\255\101\000\096\000\100\000\105\000\115\000\248\255\101\000\
    \002\000\105\000\102\000\119\000\229\255\106\000\005\000\117\000\
    \113\000\125\000\124\000\129\000\110\000\247\255\111\000\113\000\
    \007\000\125\000\121\000\133\000\132\000\137\000\118\000\246\255\
    \245\255\244\255\241\255\240\255\126\000\126\000\128\000\230\255\
    \142\000\130\000\138\000\141\000\021\000\131\000\133\000\128\000\
    \138\000\146\000\131\000\135\000\227\255\153\000\146\000\137\000\
    \138\000\153\000\138\000\143\000\226\255";
  Lexing.lex_backtrk =
   "\255\255\255\255\255\255\031\000\255\255\030\000\033\000\033\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\013\000\012\000\
    \033\000\018\000\033\000\033\000\033\000\033\000\033\000\033\000\
    \255\255\033\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\023\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255";
  Lexing.lex_default =
   "\001\000\000\000\000\000\255\255\000\000\255\255\255\255\255\255\
    \000\000\000\000\000\000\000\000\000\000\000\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\255\255\000\000\000\000\255\255\000\000\255\255\255\255\
    \255\255\000\000\255\255\255\255\000\000\255\255\255\255\000\000\
    \255\255\255\255\255\255\255\255\255\255\000\000\255\255\255\255\
    \000\000\255\255\255\255\255\255\255\255\255\255\000\000\255\255\
    \255\255\255\255\255\255\255\255\000\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\000\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\000\000\
    \000\000\000\000\000\000\000\000\255\255\255\255\255\255\000\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\000\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\000\000";
  Lexing.lex_trans =
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\027\000\026\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \027\000\016\000\057\000\000\000\000\000\000\000\000\000\000\000\
    \013\000\012\000\009\000\011\000\000\000\010\000\000\000\008\000\
    \004\000\005\000\005\000\005\000\005\000\005\000\005\000\005\000\
    \005\000\005\000\000\000\024\000\015\000\017\000\014\000\083\000\
    \082\000\021\000\019\000\006\000\023\000\081\000\022\000\080\000\
    \018\000\005\000\005\000\005\000\005\000\005\000\005\000\005\000\
    \005\000\005\000\005\000\007\000\020\000\063\000\025\000\073\000\
    \094\000\000\000\093\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\088\000\084\000\070\000\
    \061\000\030\000\028\000\029\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\003\000\031\000\032\000\
    \033\000\037\000\036\000\038\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\003\000\049\000\040\000\
    \034\000\039\000\046\000\042\000\043\000\044\000\045\000\047\000\
    \035\000\041\000\048\000\055\000\050\000\051\000\052\000\053\000\
    \054\000\056\000\058\000\059\000\060\000\062\000\064\000\065\000\
    \066\000\067\000\068\000\069\000\071\000\072\000\074\000\075\000\
    \076\000\077\000\078\000\079\000\085\000\086\000\087\000\089\000\
    \090\000\091\000\092\000\101\000\095\000\096\000\097\000\098\000\
    \099\000\100\000\102\000\103\000\104\000\105\000\106\000\107\000\
    \002\000\108\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000";
  Lexing.lex_check =
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\000\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\000\000\056\000\255\255\255\255\255\255\255\255\255\255\
    \000\000\000\000\000\000\000\000\255\255\000\000\255\255\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\255\255\000\000\000\000\000\000\000\000\014\000\
    \015\000\000\000\000\000\000\000\000\000\016\000\000\000\017\000\
    \000\000\005\000\005\000\005\000\005\000\005\000\005\000\005\000\
    \005\000\005\000\005\000\000\000\000\000\062\000\000\000\072\000\
    \092\000\255\255\092\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\003\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\006\000\007\000\018\000\
    \019\000\023\000\025\000\028\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\003\000\030\000\031\000\
    \032\000\034\000\035\000\037\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\003\000\020\000\021\000\
    \022\000\038\000\040\000\041\000\042\000\043\000\044\000\046\000\
    \022\000\021\000\047\000\049\000\020\000\050\000\051\000\052\000\
    \053\000\055\000\057\000\058\000\059\000\061\000\063\000\064\000\
    \065\000\066\000\067\000\068\000\070\000\071\000\073\000\074\000\
    \075\000\076\000\077\000\078\000\084\000\085\000\086\000\088\000\
    \089\000\090\000\091\000\093\000\094\000\095\000\096\000\097\000\
    \098\000\099\000\101\000\102\000\103\000\104\000\105\000\106\000\
    \000\000\107\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255";
  Lexing.lex_base_code =
   "";
  Lexing.lex_backtrk_code =
   "";
  Lexing.lex_default_code =
   "";
  Lexing.lex_trans_code =
   "";
  Lexing.lex_check_code =
   "";
  Lexing.lex_code =
   "";
}

let rec token lexbuf =
   __ocaml_lex_token_rec lexbuf 0
and __ocaml_lex_token_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 14 "lexer.mll"
                ( token lexbuf )
# 189 "lexer.ml"

  | 1 ->
# 15 "lexer.mll"
                ( next_line lexbuf; token lexbuf )
# 194 "lexer.ml"

  | 2 ->
# 16 "lexer.mll"
                ( VAR )
# 199 "lexer.ml"

  | 3 ->
# 17 "lexer.mll"
                ( POINTVIRGULE )
# 204 "lexer.ml"

  | 4 ->
# 18 "lexer.mll"
                ( DEBUT )
# 209 "lexer.ml"

  | 5 ->
# 19 "lexer.mll"
                ( FIN )
# 214 "lexer.ml"

  | 6 ->
# 20 "lexer.mll"
                ( AVANCE )
# 219 "lexer.ml"

  | 7 ->
# 21 "lexer.mll"
                ( TOURNE )
# 224 "lexer.ml"

  | 8 ->
# 22 "lexer.mll"
                    ( BASPINCEAU )
# 229 "lexer.ml"

  | 9 ->
# 23 "lexer.mll"
                    ( HAUTPINCEAU )
# 234 "lexer.ml"

  | 10 ->
# 24 "lexer.mll"
           ( EGALITE )
# 239 "lexer.ml"

  | 11 ->
# 25 "lexer.mll"
           ( DIFFERENT )
# 244 "lexer.ml"

  | 12 ->
# 26 "lexer.mll"
           ( INFERIEUR )
# 249 "lexer.ml"

  | 13 ->
# 27 "lexer.mll"
           ( SUPERIEUR )
# 254 "lexer.ml"

  | 14 ->
# 28 "lexer.mll"
           ( INFERIEUREGAL )
# 259 "lexer.ml"

  | 15 ->
# 29 "lexer.mll"
           ( SUPERIEUREGAL )
# 264 "lexer.ml"

  | 16 ->
# 30 "lexer.mll"
                ( LPAREN )
# 269 "lexer.ml"

  | 17 ->
# 31 "lexer.mll"
                ( RPAREN )
# 274 "lexer.ml"

  | 18 ->
# 32 "lexer.mll"
                ( EGAL )
# 279 "lexer.ml"

  | 19 ->
# 33 "lexer.mll"
                ( PLUS )
# 284 "lexer.ml"

  | 20 ->
# 34 "lexer.mll"
                ( MOINS )
# 289 "lexer.ml"

  | 21 ->
# 35 "lexer.mll"
                ( MULT )
# 294 "lexer.ml"

  | 22 ->
# 36 "lexer.mll"
                ( DIV )
# 299 "lexer.ml"

  | 23 ->
# 37 "lexer.mll"
                ( SI )
# 304 "lexer.ml"

  | 24 ->
# 38 "lexer.mll"
                ( ALORS )
# 309 "lexer.ml"

  | 25 ->
# 39 "lexer.mll"
                ( SINON )
# 314 "lexer.ml"

  | 26 ->
# 40 "lexer.mll"
                 ( TANTQUE )
# 319 "lexer.ml"

  | 27 ->
# 41 "lexer.mll"
                ( FAIRE )
# 324 "lexer.ml"

  | 28 ->
# 42 "lexer.mll"
                      ( CHANGECOULEUR )
# 329 "lexer.ml"

  | 29 ->
# 43 "lexer.mll"
                        ( CHANGEEPAISSEUR )
# 334 "lexer.ml"

  | 30 ->
let
# 44 "lexer.mll"
                                   n
# 340 "lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 44 "lexer.mll"
                                        ( NOMBRE (int_of_string n) )
# 344 "lexer.ml"

  | 31 ->
let
# 45 "lexer.mll"
                                           s
# 350 "lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 45 "lexer.mll"
                                              ( IDENTIFICATEUR s )
# 354 "lexer.ml"

  | 32 ->
# 46 "lexer.mll"
                ( EOF )
# 359 "lexer.ml"

  | 33 ->
# 47 "lexer.mll"
                ( raise (Error (Lexing.lexeme lexbuf)) )
# 364 "lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_token_rec lexbuf __ocaml_lex_state

;;
