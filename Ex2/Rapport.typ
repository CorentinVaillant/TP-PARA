#set text(lang: "fr")
#set page(paper: "a4")
#set heading(numbering: "1.")
#set page(header: [Paralellisme #h(1fr) Rapport exercice II])
#set page(footer: context [
  _Corentin Vaillant_
  #h(1fr)
  #counter(page).display(
    "1/1",
    both: true,
  )
])
#show link: set text(weight: 700)
#show link: underline

#let data = json("./results.json")
#let github = link("https://github.com/CorentinVaillant/TP-PARA/tree/main/Ex2")[*GitHub*]

#title[
  Paralellisme - Rapport exercice II
]

= Présentation de l’exercice
Dans cette exercice j'ai du programmer en `C` et avec l'aide `OpenMp` un programme additionnant tous les éléments d'une matrice $N times N$.
Le but était surtout de comparer les différentes stratégies de parallélisation du programme.

J'ai donc opter pour une simple Matrice remplie de 1 (_i.e_ $(J_(N))_(i,j) = 1 : forall i, j in [|1, N|]$).

= Calcule du temps
Afin d'éviter les incohérence dû à la mise en cache, j'ai créer un script python [@source-code] qui exécuté le programme avec des arguments d’exécutions différents à chaque fois.

= Explications

== Approche naïve
Pour commencer j'ai implémenter un algorithme séquentielle, avec seulement un parcours de la matrice.

<naive-impl>
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

== Parallélisé, somme partielle simple

Pour cette première implémentation, j'ai utiliser un tableau contenant les sommes partielles, qui sont ensuites réduites sur un seul thread grâce à la directive `#pragma omp single`.

<simple_partial-impl>
```c
///@returns renvoie le temps pris par le calcule
int addParaSimplePartialSum(const int *m, unsigned int size, unsigned int nbT,
                            float *time) {
  double start, stop;
  int result = 0;

  // Tableau des sommes partielles aloué dans la heap.
  int *partial_sums = calloc(sizeof(int), nbT);
  start = omp_get_wtime();

  // sur nbT threads
#pragma omp parallel num_threads(nbT)
  {
    unsigned int thread_nb = omp_get_thread_num();
#pragma omp for
    for (unsigned int i = 0; i < size * size; i++)
      partial_sums[thread_nb] += m[i];

  // réduction des sommes partielles
#pragma omp single
    for (unsigned int i = 0; i < nbT; i++)
      result += partial_sums[i];
  }
  stop = omp_get_wtime();
  *time = stop - start;

  free(partial_sums);

  return result;
}
```

Voici une synthèse des temps en fonction du nombre de thread pour une taille de $30000$ :

*Temps pris par l'implémentation \"somme partielle simple\" en fonction du nombre de thread pour 30000 éléments.*

#columns(2)[
  #table(
    table.header([*Nombre de thread*], [*Temps pris*]),
    columns: 2,
    [#data.at("1").at(-7).nbT], $#data.at("1").at(-7).time s$,
    [#data.at("1").at(-6).nbT], $#data.at("1").at(-6).time s$,
    [#data.at("1").at(-5).nbT], $#data.at("1").at(-5).time s$,
    [#data.at("1").at(-4).nbT], $#data.at("1").at(-4).time s$,
    [#data.at("1").at(-3).nbT], $#data.at("1").at(-3).time s$,
    [#data.at("1").at(-2).nbT], $#data.at("1").at(-2).time s$,
    [#data.at("1").at(-1).nbT], $#data.at("1").at(-1).time s$,
  )
  #colbreak()
  #image("./images/max_simpl_reduc_times.svg")
]

*Temps pris par l'implémentation* (nbT : nombre de thread)

#image("./images/simple_reduc_times.svg", width: 60%)

On peut constater une augmentation du temps en fonction du nombre de thread, cela est probablement du au nombre de thread attendant pour la réduction, avec le bloc `single`.\
De plus la complexité en temps semble quadratique pour tout les nombres de thread.

== Parallélisé, réduction atomique

Pour cette approche j'ai utiliser la directive `#pragma omp atomic` afin de résoudre la somme.

```c
///@returns renvoie le temps pris par le calcule
int addParaAtomicPartialSum(const int *m, unsigned int size, unsigned int nbT,
                            float *time) {
  double start, stop;
  int result = 0;

  start = omp_get_wtime();

#pragma omp parallel num_threads(nbT)
  {
    int partial_sum = 0;
#pragma omp for
    for (unsigned int i = 0; i < size * size; i++)
      partial_sum += m[i];

  // réduction des sommes partielles
#pragma omp atomic
    result += partial_sum;
  }
  stop = omp_get_wtime();
  *time = stop - start;

  return result;
}
```

Voici une synthèse des temps en fonction du nombre de thread pour une taille de $30000$ :


*Temps pris par l'implémentation \"réduction atomique\" en fonction du nombre de thread pour 30000 éléments.*

#columns(2)[
  #table(
    table.header([*Nombre de thread*], [*Temps pris*]),
    columns: 2,
    [#data.at("2").at(-7).nbT], $#data.at("2").at(-7).time s$,
    [#data.at("2").at(-6).nbT], $#data.at("2").at(-6).time s$,
    [#data.at("2").at(-5).nbT], $#data.at("2").at(-5).time s$,
    [#data.at("2").at(-4).nbT], $#data.at("2").at(-4).time s$,
    [#data.at("2").at(-3).nbT], $#data.at("2").at(-3).time s$,
    [#data.at("2").at(-2).nbT], $#data.at("2").at(-2).time s$,
    [#data.at("2").at(-1).nbT], $#data.at("2").at(-1).time s$,
  )
  #colbreak()
  #image("./images/max_atomic_reduc_times.svg")
]

*Temps pris par l'implémentation* (nbT : nombre de thread)

#image("./images/atomic_reduc_times.svg", width: 60%)

On peut constater une nette amélioration par rapport à l'implémentation précédentes, et de plus le temps s'améliore en fonction du nombre de thread, les threads n'ont pas à s'attendre les un les autre afin d'incrémenter le résultat.\
La complexité semble rester quadratique.

== Parallélisé, réduction optimisé

Pour cette dernière implémentation nous avons utiliser la réduction directement fourni par `OpenMp` : `reduction(+ : result)`, qui est donc plus optimiser qu'une "écrite à la main".

```c
///@returns renvoie le temps pris par le calcule
int addParaOptimizedPartialSum(const int *m, unsigned int size,
                               unsigned int nbT, float *time) {
  double start, stop;
  int result = 0;

  start = omp_get_wtime();

  // réduction du résultat en somme sur result.
#pragma omp parallel num_threads(nbT) reduction(+ : result)
  {
#pragma omp for
    for (unsigned int i = 0; i < size * size; i++)
      result += m[i];
  }
  stop = omp_get_wtime();
  *time = stop - start;
  return result;
}
```

Voici une synthèse des temps en fonction du nombre de thread pour une taille de $30000$ :


*Temps pris par l'implémentation \"réduction optimiser\" en fonction du nombre de thread pour 30000 éléments.*

#columns(2)[
  #table(
    table.header([*Nombre de thread*], [*Temps pris*]),
    columns: 2,
    [#data.at("3").at(-7).nbT], $#data.at("3").at(-7).time s$,
    [#data.at("3").at(-6).nbT], $#data.at("3").at(-6).time s$,
    [#data.at("3").at(-5).nbT], $#data.at("3").at(-5).time s$,
    [#data.at("3").at(-4).nbT], $#data.at("3").at(-4).time s$,
    [#data.at("3").at(-3).nbT], $#data.at("3").at(-3).time s$,
    [#data.at("3").at(-2).nbT], $#data.at("3").at(-2).time s$,
    [#data.at("3").at(-1).nbT], $#data.at("3").at(-1).time s$,
  )
  #colbreak()
  #image("./images/max_opti_reduc_times.svg")
]

*Temps pris par l'implémentation* (nbT : nombre de thread)

#image("./images/opti_reduc_times.svg", width: 60%)


On obtient un résultat proche de l'approche précédente, l'implémentation optimiser d'`OpenMp` doit ressembler à celle avec les atomiques.

== Quelques graphes de comparaison

Toutes les mesures on était synthétiser dans un document `Json`, en voici des comparaison graphiques.

=== Temps en fonction du nombre d'élément pour chacune des approche :
(Le nombre de thread pour est fixé à 8 )

#image("./images/impl_comp.svg", width : 80%)

== Temps en fonction du nombre d'élément pour les réduction atomique et optimisé :

(Le nombre de thread pour est fixé à 8 )

#image("./images/impl_comp3.svg", width : 80%)

On voit bien que les deux méthodes sont très proches en termes de performance, l'atomique est plus "bruité" dans ses résultats.


= Annexe <annexe>

== Machine utilisé <machine>
Tous les temps ont était enregistrer sur un ordinateur portable avec un processeur `x86-64` de huit cœurs physique dont deux virtuel par cœurs, cadencé à \~3.5GHz (sur secteur).

== Données récolter
Toutes les mesures effectuer son stocké dans un document _json_ récupérer grâce à la sortie standard du programme, et a un script python, trouvable sur le #github.

== Code <source-code>

L’entièreté du code se trouve sur le #github 
