--- 
layout: post
title: Spring maintenant payant
wordpress_id: 248
wordpress_url: http://www.dewavrin.info/?p=248
comments: true
categories: 
- java
- tech
tags: []

---

Oui la nouvelle du week-end ou plutot de fin de semaine sur le [changement de licence de Spring](http://newblog.springsource.com/2008/05/27/open-source-open-strategy-the-springsource-manifesto/) **me reste en travers de la gorge**, même si j'en comprends les raisons.

 Mais d'un coup je me sens coupable d'avoir poussé depuis 2004 à l'utilisation de Spring sur plusieurs projets et d'en avoir été le défenseur auprès de certains collègues réticents sur les principes d'injection de dépendances, de conteneur léger et même d'AOP. Sur mes 2 derniers projets, j'ai même introduit Spring Security (anciennement ACEGI) et utilisé Spring MVC pour une petite application interne chez mon employeur précédent. Et oui, le changement de licence s'applique aussi à tous ces projets.Cela me fait maintenant me re-questionner sur l'utilisation de ce framework.

D'abord pourquoi Spring ? Logiquement après avoir lu les livres de Rod Johnson "J2EE design and development" et "J2EE Development without EJB" son utilisation semblait être une vrai alternatives aux Ejb 2.x pour les raisons suivantes :
-  des objets et services métiers n'implémentant aucune interface technique (juste des POJO).
-  l'injection de dépendances favorisant le couplage faible entre les objets.
-  les tests unitaires sans déployer dans le conteneur EJB accélérant ainsi les phases de test.
- la rapidité de démarrage du conteneur Spring pemettant de l'utiliser en dehors d'un serveur application.
Mais Spring est aussi utilisé maintenant pour toutes ses fonctionnalités qui facilitent le développement d'application JavaEE :
-  son intercepteurs transactionnels et son annotation @Transactional
- l'accès aux services des serveurs d'application par simple déclaration  (j2ee:jndi-lookup)
-  la création de proxy sur des Ejb (2.1, 3.0), Web-Services (JAX-RPC et JAXWS) . 
En fait, j'ai en fait toujours été très satisfait de Spring Core et impressionné par sa stabilité et son excellente documentation tout cela en opensource et gratuit. Les applications développées avec étaient même plus portables que les traditionnelles applications J2EE.  Mais la lune de miel a une fin et je pense maintenant que je vais devoir m'intéresser aux alternatives, car je vois mal certains clients payer pour une librairie (cela changera peut-être pour avec Spring dm Server).

 **Les alternatives**

Pour moi la + évidente :
- **JavaEE 5 et les EJB 3**
Et oui avec des conteneurs d'EJB en mode embedded pouvant être utilisés pour les tests et démarrant en quelques lignes de codes ( voir par exemple [OpenEJB ](http://openejb.apache.org)de la fondation Apache ou encore JBoss embedded ).  De + cette solution a l'immense mérite d'être standard.Maintenant techniquement, le mécanisme d'interception d'EJB 3 n'est pas aussi riche que celui proposé par Spring et son support d'AspectJ. Le mécanisme ne permet d'injecter uniquement des Ejbs ou des ressources JNDI. Mais au moins les tests sans déploiement sont possibles, le code simplifié et épuré. De +, Ejb 3.1 apportent aussi son lot de nouveautés comme l'annotation @Singleton ou la non-obligation de créer une interface métier.

- **Guice**

Peut-être un peu jeune et n'est qu'un "IOC container" mais pourquoi pas pour une utilisation pour des applications standalone. 

