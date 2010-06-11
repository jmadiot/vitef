#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int type = 0;
int borne_champ = 0;
int borne_espece = 0;
int ligne = 0;
char champs[100][50];
char especes[100][50];

// bornes noms : (fem | masc) * chp_lex * esp_suj
int noms[2][100][100];

// bornes adj : (fem | masc) * chp_lex
int adjectifs[2][100];

// bornes verb : chp_lex
int verbes[100];

//initialisation des bornes
void initialize() {
    int i = 0;
    int j = 0;
    for (i=0;i<100;i++)
    {
	verbes[i] = 0;
    	adjectifs[0][i] = 0;
  	adjectifs[1][i] = 0;
    	for(j=0;j<100;j++)
    	{
	    noms[0][i][j] = 0;
	    noms[1][i][j] = 0;
    	}
    }
}

// type :
// -1 : fini
// 0  : nom
// 1  : verbe
// 2  : article
// 3  : pronom
// 4  : adjectif

int verif_parse (int choix, int test) {
    if((choix == 0 && (test < 0 || test > 2)) || (choix && (test < 0 || test > 1)))
    {
	printf("\n\nParse error ! Line %d.\n\n",ligne);
	return 0;
    }
    return 1;
}

// Ajouter un chp_lex ou une espece et chopper le numéro associé

int add_chp (char chp[50]) {
    int i = 0;
    while (i < borne_champ)
    {
	if (strcmp(chp,champs[i]) == 0)
	{
	    return i;
	}
	i++;
    }
    if (i == borne_champ)
    {
	strcpy(champs[i],chp);
	borne_champ++;
	if (borne_champ == 100)
	{
	    printf("\n\nParse error !\n\n");
	}
	return i;
    }
    return -1;
}

int add_esp (char esp[50]) {
    int i = 0;
    while (i < borne_espece)
    {
	if(strcmp(esp,especes[i]) == 0)
	{
	    return i;
	}
	i++;
    }
    if (i == borne_espece)
    {
	strcpy(especes[i],esp);
	borne_espece++;
	if (borne_espece == 100)
	{
	    printf("\n\nParse error !\n\n");
	}
	return i;
    }
    return -1;
}

// Lire une ligne et faire ce qu'il faut

int lecture() {
    ligne++;
    char chp[50];
    char esp[50];
    char mot[50];
    int gre = 0;
    int int_chp = 0;
    char esp_s[50];
    char esp_c[50];
    char chp_s[50];
    char chp_c[50];
    scanf("%d",&type);
    if(type != -1)
    {
	printf("\n");
	switch (type)
	{
	case 0 : // nom
		 scanf("%s %s %d %s",esp,chp,&gre,mot);
		 if (verif_parse(1,gre))
		 {
		     int_chp = add_chp(chp);
		     int int_esp = add_esp(esp);
		     noms[gre][int_chp][int_esp]++;
		     printf("add_nom \"%s\" %d %d %d;",mot,int_esp,int_chp,gre);
		 }
		 else { return 0; }
		 break;
	case 1 : // verbe
		 scanf("%s %s %s %s %s %s",esp_s,esp_c,chp,chp_s,chp_c,mot);
		 int_chp = add_chp(chp);
		 verbes[int_chp]++;
		 int int_esp_s = add_esp(esp_s);
		 int int_esp_c = add_esp(esp_c);
		 int int_chp_s = add_chp(chp_s);
		 int int_chp_c = add_chp(chp_c);
		 printf("add_verbe \"%s\" %d %d %d %d %d;",mot,int_esp_s,int_esp_c,int_chp_s,int_chp_c,int_chp);
		 break;
	case 2 : // article
		 scanf("%d %s",&gre,mot);
		 if(verif_parse(1,gre))
		 {
		     printf("add_article \"%s\" %d;",mot,gre);
		 }
		 else { return 0; }
		 break;
	case 3 : // pronom
		 scanf("%d %s",&gre,mot);
		 if(verif_parse(0,gre))
		 {
		     printf("add_pronom \"%s\" %d;",mot,gre);
		 }
		 else { return 0; }
		 break;
	case 4 : // adjectif
		 scanf("%s %d %s",esp,&gre,mot);
		 if (verif_parse(1,gre))
		 {
		     int int_esp = add_esp (esp);
		     adjectifs[gre][int_esp]++;
		     printf("add_adjectif \"%s\" %d %d;",mot,int_esp,gre);
		 }
		 else { return 0; }
		 break;
	}
        return lecture();
    }
    return 1;
}

int main() {
    initialize();
    printf("#use \"basic_fun.ml\";;\n");
    if (lecture() != 0)
    {
	int i = 0;
	int j = 0;
	int k = 0;
	printf(";\n\nlet nbre_chp = %d;;\nlet nbre_esp = %d;;\n",borne_champ,borne_espece);
	printf("let borne_noms = [|");
// impression des bornes liées aux noms
	for (i=0;i<2;i++)
	{
	    printf("[|");
	    for (j=0;j<borne_champ;j++)
	    {
		printf("[|");
		for (k=0;k<borne_espece;k++)
		{
		    printf("%d",noms[i][j][k]);
		    if (k<borne_espece-1)
		    {
			printf(";");
		    }
		}
		printf("|]");
		if (j<borne_champ-1)
		{
		    printf(";");
		}
	    }
	    printf("|]");
	    if (i < 1)
	    { 
		 printf(";");
	    }
	}
	printf("|];;\nlet borne_adjectifs = [|");
	for (i=0;i<2;i++)
	{
	    printf("[|");
	    for (j=0;j<borne_espece;j++)
	    {
		printf("%d",adjectifs[i][j]);
		if (j<borne_espece-1)
		{
		    printf(";");
		}
	    }
	    printf("|]");
	    if (i<1)
	    {
		printf(";");
	    }
	}
	printf("|];;\nlet borne_verbes = [|");
	for (i=0;i<borne_champ;i++)
	{
	    printf("%d",verbes[i]);
	    if (i < borne_champ - 1)
	    {
		printf(";");
	    }
	}
	printf("|];;\n");
    }
    return 0;
}

