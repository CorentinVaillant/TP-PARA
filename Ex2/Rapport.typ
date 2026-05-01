#set text(lang: "fr")
#set page(paper: "a4")
#set heading(numbering: "1.")

#show link: set text(fill: blue, weight: 700)
#show link: underline

#title[
  Paralellisme - Rapport exercice II
]

= Présentation de l’exercice
Dans cette exercice nous devions programmer en `C` et avec l'aide `OpenMp` un programme additionnant tous les éléments d'une matrice $N times N$.
Le but était surtout de comparer les différentes stratégies de parallélisation du programme.

Nous avons donc opter pour une simple Matrice remplie de 1 (i.e $(J_(N))_(i,j) = 1 : forall i, j in [1, N]$).

= Calcule du temps
Afin d'éviter les incohérence dû à la mise en cache, j'ai créer un script python [@source-code] qui exécuté le programme avec des arguments d’exécutions différents à chaque fois.

= Explications

== Approche naïve
Pour commencer nous avons implémenter un algorithme séquentielle, avec seulement un parcours de la Matrice.

```c
///@returns renvoie le temps pris par le calcule
int addSequential(const int *m, unsigned int size, float *time) {
  double start, stop;
  int result = 0;

  start = omp_get_wtime();
  for (unsigned int i = 0; i < size * size; i++)
    result += m[i];
  stop = omp_get_wtime();
  *time = stop - start;
  return result;
}
```

Le temps pris sur la machine [@machine] est de $~ 0.86 s$ sur une taille de $30000$.

== 

= Index

== Machine utiliser <machine>
Tous les temps ont était enregistrer sur un ordinateur portable avec un processeur `x86-64` de huit cœurs physique dont deux virtuel par cœurs, cadencé à \~4Ghz.

== Sources <sources>

=== Données récolter 
Toutes les mesures effectuer son stocké dans un document _json_ récupérer grâce à la sortie standard du programme, et a un script python, trouvable sur le *GitHub* /*TODO mettre lien*/ ou en annexe [@annexe].


= Annexe <annexe>

== Syntèse des résultats 
*! METTRE JSON !*

== Code <source-code>
Le script python de test <pytest>
