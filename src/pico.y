%{
  /* Aqui, pode-se inserir qualquer codigo C necessario ah compilacao
   * final do parser. Sera copiado tal como esta no inicio do y.tab.c
   * gerado por Yacc.
   */
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include "node.h"

char * novo_tmp();

%}

%union {
    char* cadeia;
    struct _node * no;
}



/*Faltava declarar os tipos dos tokens para o yacc conseguir converter
os mesmos para $$ e $1,$2,... os warnings ao compilar são das regras
ainda não terminadas.*/

%token<cadeia> IDF
%token<no> INT
%token<no> DOUBLE
%token<no> REAL
%token<no> FLOAT
%token<no> CHAR
%token<no> QUOTE
%token<no> DQUOTE
%token<no> LE
%token<no> GE
%token<no> EQ
%token<no> NE
%token<no> AND
%token<no> OR
%token<no> NOT
%token<no> IF
%token<no> THEN
%token<no> ELSE
%token<no> WHILE
%token<cadeia> INT_LIT
%token<cadeia> F_LIT
%token<no> END
%token<no> TRUE
%token<no> FALSE
%token<no> FOR
%token<no> NEXT
%token<no> REPEAT
%token<no> UNTIL
%token<no> CASE
%token<no> CONST

%type<no> code
%type<no> declaracoes
%type<no> declaracao
%type<no> listadeclaracao
%type<no> listadupla
%type<no> tipo
%type<no> tipounico
%type<no> tipolista
%type<no> lvalue
%type<no> listaexpr
%type<no> expbool
%type<no> acoes
%type<no> comando
%type<no> enunciado
%type<no> fiminstcontrole
%type<no> expr
%type<no> '='
%type<no> '('
%type<no> ')'
%type<no> chamaproc



%start code

/* A completar com seus tokens - compilar com 'yacc -d' */

%%
code: declaracoes acoes {
    Node** children = (Node**) malloc(sizeof(Node*) * 2);
            children[0] = $1;
            children[1] = $2;
            struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
            att->local = NULL;
            att->code = NULL;
            $$ = create_node(0, program_node, NULL, att, 2, children);
            syntax_tree = $$;
        }
    | acoes { $$ = $1; syntax_tree = $$;  }
    ;

declaracoes: declaracao ';' { $$ = $1; }
           | declaracoes declaracao ';' {
                    Node** children = (Node**) malloc(sizeof(Node*) * 2);
                    children[0] = $1;
                    children[1] = $2;
                    struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                    att->local = NULL;
                    att->code = NULL;
                    $$ = create_node(0, decl_node, NULL, att, 2, children);
                }
           ;

declaracao: listadeclaracao ':' tipo {
          Node** children = (Node**) malloc(sizeof(Node*) * 2);
                  children[0] = $1;
                  children[1] = $3;
                  struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                  att->local = NULL;
                  att->code = NULL;
                  $$ = create_node(0, decl_node, NULL, att, 2, children);
              }
          ;

listadeclaracao: IDF {
                       struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                       att->local = (char*) malloc((sizeof(char) * strlen($1)) + 1);
                       strcpy(att->local, $1);
                       att->code = NULL;
                       $$ = create_leaf(0, idf_node, $1, att);
                   }
               | IDF ',' listadeclaracao {
                        Node** children = (Node**) malloc(sizeof(Node*) * 2);
                        struct _attr* att_leaf = (struct _attr*) malloc(sizeof(struct _attr));
                        att_leaf->local = (char*) malloc((sizeof(char) * strlen($1)) + 1);
                        strcpy(att_leaf->local, $1);
                        att_leaf->code = NULL;
                        children[0] = create_leaf(0, idf_node, $1, att_leaf);
                        children[1] = $3;
                        struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                        att->local = NULL;
                        att->code = NULL;
                        $$ = create_node(0, decl_list_node, NULL, att, 2, children);
                    }
               ;

tipo: tipounico { $$ = $1; }
    | tipolista { $$ = $1; }
    ;

tipounico: INT {
                 struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                 att->local = NULL;
                 att->code = NULL;
                 att->type = int_type;
                 $$ = create_leaf(0, int_node, NULL, att);
             }
         | DOUBLE {
                 struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                 att->local = NULL;
                 att->code = NULL;
                 att->type = double_type;
                 $$ = create_leaf(0, float_node, NULL, att);
             }
         | FLOAT {
                 struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                 att->local = NULL;
                 att->code = NULL;
                 att->type = float_type;
                 $$ = create_leaf(0, float_node, NULL, att);
             }
         | CHAR {
                 struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                 att->local = NULL;
                 att->code = NULL;
                 att->type = char_type;
                 $$ = create_leaf(0, float_node, NULL, att);
             }
         ;

tipolista: INT '[' listadupla ']' {
         Node** children = (Node**) malloc(sizeof(Node*) * 2);
                 struct _attr* att_leaf = (struct _attr*) malloc(sizeof(struct _attr));
                 att_leaf->local = NULL;
                 att_leaf->code = NULL;
                 children[0] = create_leaf(0, int_node, NULL, att_leaf);
                 children[1] = $3;
                 struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                 att->local = NULL;
                 att->code = NULL;
                 $$ = create_node(0, list_node, NULL, att, 2, children);
             }
         | DOUBLE '[' listadupla ']' {
                 Node** children = (Node**) malloc(sizeof(Node*) * 2);
                 children[0] = create_leaf(0, float_node, NULL, NULL);
                 children[1] = $3;
                 struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                 att->local = NULL;
                 att->code = NULL;
                 $$ = create_node(0, list_node, NULL, att, 2, children);
             }
         | FLOAT '[' listadupla ']' {
                 Node** children = (Node**) malloc(sizeof(Node*) * 2);
                 children[0] = create_leaf(0, float_node, NULL, NULL);
                 children[1] = $3;
                 struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                 att->local = NULL;
                 att->code = NULL;
                 $$ = create_node(0, list_node, NULL, att, 2, children);
             }
         | CHAR '[' listadupla ']' {
                 Node** children = (Node**) malloc(sizeof(Node*) * 2);
                 children[0] = create_leaf(0, char_node, NULL, NULL);
                 children[1] = $3;
                 struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                 att->local = NULL;
                 att->code = NULL;
                 $$ = create_node(0, list_node, NULL, att, 2, children);
             }
         ;

listadupla: INT_LIT ':' INT_LIT {
          Node** children = (Node**) malloc(sizeof(Node*) * 2);
                  children[0] = create_leaf(0, int_node, $1, NULL);
                  children[1] = create_leaf(0, int_node, $3, NULL);
                  struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                  att->local = NULL;
                  att->code = NULL;
                  $$ = create_node(0, list_size_node, NULL, att, 2, children);
              }
          | INT_LIT ':' INT_LIT ',' listadupla {
                  Node** children = (Node**) malloc(sizeof(Node*) * 3);
                  children[0] = create_leaf(0, int_node, $1, NULL);
                  children[1] = create_leaf(0, int_node, $3, NULL);
                  children[2] = $5;
                  struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                  att->local = NULL;
                  att->code = NULL;
                  $$ = create_node(0, list_size_node, NULL, att, 3, children);
              }
          ;

acoes: comando ';'  { $$ = $1; }
     | comando ';' acoes {
             Node** children = (Node**) malloc(sizeof(Node*) * 2);
             children[0] = $1;
             children[1] = $3;
             struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
             att->local = NULL;
             att->code = NULL;
             $$ = create_node(0, program_node, NULL, att, 2, children);
         }
     ;

comando: lvalue '=' expr {
                Node** children = (Node**) malloc(sizeof(Node*) * 2);
                children[0] = $1;
                children[1] = $3;
                struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                att->local = NULL;
                att->code = NULL;
                $$ = create_node(0, attr_node, NULL, att, 2, children);
            }
       | enunciado { $$ = $1; }
       ;

lvalue: IDF {
              struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
              att->local = (char*) malloc((sizeof(char) * strlen($1)) + 1);
              strcpy(att->local, $1);
              att->code = NULL;
              $$ = create_leaf(0, idf_node, $1, att);
          }
      | IDF '[' listaexpr ']' {
              Node** children = (Node**) malloc(sizeof(Node*) * 2);
              children[0] = create_leaf(0, idf_node, $1, NULL);
              children[1] = $3;
              struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
              att->local = NULL;
              att->code = NULL;
              $$ = create_node(0, list_access_node, NULL, att, 2, children);
          }
      ;

listaexpr: expr { $$ = $1; }
         | expr ',' listaexpr {
                 Node** children = (Node**) malloc(sizeof(Node*) * 2);
                 children[0] = $1;
                 children[1] = $3;
                 struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                 att->local = NULL;
                 att->code = NULL;
                 $$ = create_node(0, list_index_node, NULL, att, 2, children);
             }
         ;

expr: expr '+' expr {
            Node** children = (Node**) malloc(sizeof(Node*) * 2);
            children[0] = $1;
            children[1] = $3;
            struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
            att->local = NULL;
            att->code = NULL;
            $$ = create_node(0, plus_node, NULL, att, 2, children);
        }
    | expr '-' expr {
            Node** children = (Node**) malloc(sizeof(Node*) * 2);
            children[0] = $1;
            children[1] = $3;
            struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
            att->local = NULL;
            att->code = NULL;
            $$ = create_node(0, minus_node, NULL, att, 2, children);
        }
    | expr '*' expr {
            Node** children = (Node**) malloc(sizeof(Node*) * 2);
            children[0] = $1;
            children[1] = $3;
            struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
            att->local = novo_tmp();
            att->code = NULL;
            $$ = create_node(0, mult_node, NULL, att, 2, children);
        }
    | expr '/' expr {
            Node** children = (Node**) malloc(sizeof(Node*) * 2);
            children[0] = $1;
            children[1] = $3;
            struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
            att->local = NULL;
            att->code = NULL;
            $$ = create_node(0, div_node, NULL, att, 2, children);
        }
    | '(' expr ')' { $$ = $2; }
    | expr '%' expr {
            Node** children = (Node**) malloc(sizeof(Node*) * 2);
            children[0] = $1;
            children[1] = $3;
            struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
            att->local = NULL;
            att->code = NULL;
            $$ = create_node(0, mod_node, NULL, att, 2, children);
        }
    | INT_LIT  {
            struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
            att->local = (char*) malloc((sizeof(char) * strlen($1)) + 1);
            strcpy(att->local, $1);
            att->code = NULL;
            $$ = create_leaf(0, int_node, $1, att);
        }
    | F_LIT    {
            struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
            att->local = (char*) malloc((sizeof(char) * strlen($1)) + 1);
            strcpy(att->local, $1);
            att->code = NULL;
            $$ = create_leaf(0, float_node, $1, att);
        }
    | lvalue { $$ = $1; }
    | chamaproc { $$ = $1; }
    ;

chamaproc: IDF '(' listaexpr ')' {
         Node** children = (Node**) malloc(sizeof(Node*) * 2);
                 children[0] = create_leaf(0, idf_node, $1, NULL);
                 children[1] = $3;
                 struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                 att->local = NULL;
                 att->code = NULL;
                 $$ = create_node(0, proc_node, NULL, att, 2, children);
             }
         ;

enunciado: expr { $$ = $1; }
         | IF '(' expbool ')' THEN acoes fiminstcontrole {
                 Node** children = (Node**) malloc(sizeof(Node*) * 3);
                 children[0] = $3;
                 children[1] = $6;
                 children[2] = $7;
                 struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                 att->local = NULL;
                 att->code = NULL;
                 $$ = create_node(0, cond_node, NULL, att, 3, children);
             }
         | WHILE '(' expbool ')' '{' acoes '}' {
                 Node** children = (Node**) malloc(sizeof(Node*) * 2);
                 children[0] = $3;
                 children[1] = $6;
                 struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                 att->local = NULL;
                 att->code = NULL;
                 $$ = create_node(0, while_node, NULL, att, 2, children);
             }
         ;

fiminstcontrole: END {
                       struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                       att->local = NULL;
                       att->code = NULL;
                       $$ = create_leaf(0, empty_node, NULL, att);
                   }
               | ELSE acoes END { $$ = $2; }
               ;

expbool: TRUE { $$ = create_leaf(0, true_node, NULL, NULL); }
       | FALSE { $$ = create_leaf(0, false_node, NULL, NULL); }
       | '(' expbool ')' { $$ = $2; }
       | expbool AND expbool {
                Node** children = (Node**) malloc(sizeof(Node*) * 2);
                children[0] = $1;
                children[1] = $3;
                struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                att->local = NULL;
                att->code = NULL;
                $$ = create_node(0, and_node, NULL, att, 2, children);
            }
       | expbool OR expbool {
                Node** children = (Node**) malloc(sizeof(Node*) * 2);
                children[0] = $1;
                children[1] = $3;
                struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                att->local = NULL;
                att->code = NULL;
                $$ = create_node(0, or_node, NULL, att, 2, children);
            }
       | NOT expbool {
                Node** children = (Node**) malloc(sizeof(Node*));
                children[0] = $2;
                struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                att->local = NULL;
                att->code = NULL;
                $$ = create_node(0, not_node, NULL, att, 1, children);
            }
       | expr '>' expr {
                Node** children = (Node**) malloc(sizeof(Node*) * 2);
                children[0] = $1;
                children[1] = $3;
                struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                att->local = NULL;
                att->code = NULL;
                $$ = create_node(0, sup_node, NULL, att, 2, children);
            }
       | expr '<' expr {
                Node** children = (Node**) malloc(sizeof(Node*) * 2);
                children[0] = $1;
                children[1] = $3;
                struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                att->local = NULL;
                att->code = NULL;
                $$ = create_node(0, inf_node, NULL, att, 2, children);
            }
       | expr LE expr {
                Node** children = (Node**) malloc(sizeof(Node*) * 2);
                children[0] = $1;
                children[1] = $3;
                struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                att->local = NULL;
                att->code = NULL;
                $$ = create_node(0, inf_eq_node, NULL, att, 2, children);
            }
       | expr GE expr {
                Node** children = (Node**) malloc(sizeof(Node*) * 2);
                children[0] = $1;
                children[1] = $3;
                struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                att->local = NULL;
                att->code = NULL;
                $$ = create_node(0, sup_eq_node, NULL, att, 2, children);
            }
       | expr EQ expr {
                Node** children = (Node**) malloc(sizeof(Node*) * 2);
                children[0] = $1;
                children[1] = $3;
                struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                att->local = NULL;
                att->code = NULL;
                $$ = create_node(0, eq_node, NULL, att, 2, children);
            }
       | expr NE expr {
                Node** children = (Node**) malloc(sizeof(Node*) * 2);
                children[0] = $1;
                children[1] = $3;
                struct _attr* att = (struct _attr*) malloc(sizeof(struct _attr));
                att->local = NULL;
                att->code = NULL;
                $$ = create_node(0, neq_node, NULL, att, 2, children);
            }
       ;
%%
 /* A partir daqui, insere-se qlqer codigo C necessario.
  */

char* progname;
int lineno;
extern FILE* yyin;
int cont = 0;

char * novo_tmp(){
	char * nome = (char*)malloc(sizeof(char)*256);
	sprintf(nome,"tmp%d", cont++);
	return nome;
}

void echo_node(Node* node, int nchildren, int level)
{
	int i, j;
	
	for (j = 0; j < level; j++) printf("\t");
	printf("%d", node->type);
    printf(" {local: %s; tipo: %d}\n", node->attribute->local, node->attribute->type);
	
    for (i = 0; i < nchildren; i++) {
        if ((node->children[i]->type >= 300 && node->children[i]->type <= 304)
                || (node->children[i]->type >= 401 && node->children[i]->type <= 408)) {
            for (j = 0; j <= level; j++) printf("\t");
            if (node->children[i]->lexeme == NULL) {
                printf("%d {local: %s; tipo: %d}\n",
                    node->children[i]->type,
                    node->children[i]->attribute->local,
                    node->children[i]->attribute->type);
            } else {
                printf("%d (%s) {local: %s; tipo: %d}\n",
                    node->children[i]->type,
                    node->children[i]->lexeme,
                    node->children[i]->attribute->local,
                    node->children[i]->attribute->type);
            }
        } else {
			echo_node(node->children[i], node->children[i]->nb_children, level + 1);
		}
	}
}

int main(int argc, char* argv[]) 
{
    if (argc != 2) {
        printf("uso: %s <input_file>. Try again!\n", argv[0]);
        exit(-1);
    }
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        printf("Uso: %s <input_file>. Could not find %s. Try again!\n", argv[0], argv[1]);
        exit(-1);
    }

	progname = argv[0];

	if (!yyparse()) {
        printf("OKAY.\n");
        echo_node(syntax_tree, syntax_tree->nb_children, 0);
	} else {
	    printf("ERROR.\n");
	}
    return(0);
}

yyerror(char* s) {
    fprintf(stderr, "%s: %s", progname, s);
    fprintf(stderr, "line %d\n", lineno);
}
