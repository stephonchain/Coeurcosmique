import Foundation

enum QuantumOracleDeck {
    static let allCards: [QuantumOracleCard] = [
        // MARK: - I. Les Lois Fondamentales (1-7)
        
        QuantumOracleCard(
            number: 1,
            name: "L'Intrication Éternelle",
            family: .loisFondamentales,
            essence: ["Lien indissoluble", "Amour", "Connexion d'âme"],
            messageProfond: "La distance physique est une illusion. Vous êtes connecté instantanément à une autre âme ou à une situation, peu importe l'éloignement. Ce qui affecte l'un affecte l'autre immédiatement.",
            imageName: "quantum-oracle-01",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous ressentez l'autre à distance, presque physiquement. Impossible de couper le lien mental.",
                betaOther: "Cette personne pense à vous incessamment. Elle se sent liée à vous par une promesse ancienne.",
                linkResult: "Lien d'Âme Sœur ou Flamme Jumelle. Indestructible. La distance physique ne change rien à l'intensité.",
                situation: "Vous ne pouvez pas agir seul, car tout est interconnecté. La situation dépend d'autres acteurs.",
                actionBoxA: "Connectez-vous. Cherchez des alliés. Faites jouer votre réseau. L'union fait la force.",
                nonActionBoxB: "Faites confiance au lien invisible. La télépathie et l'intention suffisent. Ne forcez pas la rencontre.",
                collapseResult: "Une alliance durable et profonde se confirme. Fusion.",
                gravity: "Dépendance affective. Incapacité à exister sans l'autre.",
                darkEnergy: "Votre capacité à aimer inconditionnellement est votre carburant.",
                horizon: "Accepter que nous sommes Un. Cesser de voir l'autre comme un ennemi.",
                wormhole: "Une personne du passé ou une connexion karmique vous tend la main.",
                newGalaxy: "La conscience de l'Unité. Vivre en symbiose avec l'univers."
            )
        ),
        
        QuantumOracleCard(
            number: 2,
            name: "L'Observateur Conscient",
            family: .loisFondamentales,
            essence: ["Manifestation", "Focus", "Création"],
            messageProfond: "La réalité n'existe que parce que vous la regardez. Votre attention fige les possibilités en une seule réalité. Changez votre regard pour changer l'événement.",
            imageName: "quantum-oracle-02",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous analysez trop. Vous êtes spectateur de votre relation au lieu de la vivre.",
                betaOther: "Cette personne vous observe, vous surveille (réseaux sociaux, etc.) sans agir.",
                linkResult: "La relation n'existe que par l'importance que vous lui donnez. C'est une projection mentale.",
                situation: "Rien n'est joué. La réalité attend votre regard pour se figer.",
                actionBoxA: "Visualisez clairement le résultat. Posez une intention ferme. Regardez le problème en face.",
                nonActionBoxB: "Prenez du recul. Observez sans juger. Soyez le témoin silencieux pour comprendre.",
                collapseResult: "Ce sur quoi vous vous concentrez va se manifester. Attention à vos pensées.",
                gravity: "Vos préjugés et croyances limitantes figent votre réalité dans le négatif.",
                darkEnergy: "Votre lucidité. Votre capacité à voir la vérité au-delà des apparences.",
                horizon: "Prendre la responsabilité de votre vie. Cesser de se voir en victime.",
                wormhole: "Une prise de conscience soudaine (Insight) ou une thérapie visuelle.",
                newGalaxy: "La Maîtrise de la Manifestation. Créer sa vie par la pensée."
            )
        ),
        
        QuantumOracleCard(
            number: 3,
            name: "La Superposition",
            family: .loisFondamentales,
            essence: ["Choix multiples", "Potentiel", "Incertitude"],
            messageProfond: "Tout est encore possible. Vous êtes à la croisée des chemins où plusieurs futurs coexistent. Ne forcez pas encore le destin, laissez les options flotter.",
            imageName: "quantum-oracle-03",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous hésitez entre deux personnes ou deux attitudes. Vous êtes ambivalent.",
                betaOther: "Insaisissable. Il/Elle ne sait pas ce qu'il veut et joue sur plusieurs tableaux.",
                linkResult: "\"Situationship\". Rien n'est défini. Tout est flou et multiple.",
                situation: "Carrefour complexe. Plusieurs scénarios coexistent. Potentiel infini mais confus.",
                actionBoxA: "Expérimentez. Testez plusieurs pistes sans vous engager définitivement.",
                nonActionBoxB: "Ne choisissez pas maintenant. Laissez les options ouvertes le temps que la brume se dissipe.",
                collapseResult: "L'incertitude va durer encore un peu. Acceptez le \"et\" plutôt que le \"ou\".",
                gravity: "Dispersion. À vouloir tout être, vous n'êtes rien.",
                darkEnergy: "Adaptabilité totale. Vous êtes un caméléon quantique.",
                horizon: "Accepter de perdre certaines options pour en réaliser une seule.",
                wormhole: "Une opportunité multiple ou un choix inattendu qui combine tout.",
                newGalaxy: "La richesse des possibles. Une vie multidimensionnelle."
            )
        ),
        
        QuantumOracleCard(
            number: 4,
            name: "Le Saut Quantique",
            family: .loisFondamentales,
            essence: ["Changement radical", "Évolution", "Courage"],
            messageProfond: "Il n'y a pas d'étapes intermédiaires requises. Vous êtes prêt pour un changement de niveau de conscience immédiat et soudain. Une transformation majeure arrive.",
            imageName: "quantum-oracle-04",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous êtes prêt(e) à tout quitter pour cette histoire ou à passer à l'étape supérieure.",
                betaOther: "Il/Elle va vous surprendre par un changement d'attitude radical et soudain.",
                linkResult: "Révolution. La relation change de nature instantanément (rupture ou mariage éclair).",
                situation: "Vous êtes au pied du mur. L'évolution linéaire n'est plus possible.",
                actionBoxA: "Osez le risque maximal. Sautez dans le vide. Faites ce qui vous fait peur.",
                nonActionBoxB: "Impossible de rester immobile. Le statu quo est en train de s'effondrer.",
                collapseResult: "Transformation radicale. Vous ne serez plus au même endroit demain.",
                gravity: "La peur de l'inconnu et le besoin de sécurité.",
                darkEnergy: "Votre audace. Le courage de tout réinventer.",
                horizon: "Le moment de \"Vertige\" juste avant le saut. Ne reculez pas.",
                wormhole: "Un événement extérieur violent ou soudain qui vous pousse dans le dos.",
                newGalaxy: "Une nouvelle vie, totalement déconnectée de l'ancienne version de vous."
            )
        ),
        
        QuantumOracleCard(
            number: 5,
            name: "L'Effondrement de l'Onde",
            family: .loisFondamentales,
            essence: ["Décision", "Matérialisation", "Concrétisation"],
            messageProfond: "Le temps de l'hésitation est terminé. L'énergie floue se cristallise en un événement concret. Une vérité va se révéler dans la matière.",
            imageName: "quantum-oracle-05",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous voulez une réponse claire. Vous ne supportez plus le flou.",
                betaOther: "Il/Elle a pris sa décision. Son attitude est désormais figée et concrète.",
                linkResult: "Officialisation ou Rupture nette. La vérité sort du puits.",
                situation: "Le temps des hypothèses est fini. La réalité se matérialise.",
                actionBoxA: "Tranchez. Signez. Décidez. Ancrez les choses dans la matière.",
                nonActionBoxB: "Laissez le destin décider pour vous, mais acceptez le résultat sans discuter.",
                collapseResult: "Concrétisation. Un événement tangible va clore le débat.",
                gravity: "Rigidité mentale. Refus de voir la réalité telle qu'elle s'est figée.",
                darkEnergy: "Pragmatisme. Capacité à bâtir du solide.",
                horizon: "Deuil des \"possibles\" pour accepter le \"réel\".",
                wormhole: "Un contrat, un document officiel, une preuve matérielle.",
                newGalaxy: "Réalisation concrète de vos rêves. Succès matériel."
            )
        ),
        
        QuantumOracleCard(
            number: 6,
            name: "La Résonance Vibratoire",
            family: .loisFondamentales,
            essence: ["Attraction", "Harmonie", "Fréquence"],
            messageProfond: "Vous attirez ce que vous vibrez. Si vous cherchez l'amour ou l'abondance, ajustez votre fréquence intérieure. L'univers répond par écho, pas par choix.",
            imageName: "quantum-oracle-06",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous attirez exactement ce que vous craignez ou ce que vous désirez. Checkez votre vibe.",
                betaOther: "C'est votre miroir parfait. Il réagit à votre fréquence.",
                linkResult: "Écho. Si vous donnez de l'amour, vous recevez de l'amour. Si vous doutez, il doute.",
                situation: "Vous êtes au diapason avec votre environnement. Tout est question d'ambiance.",
                actionBoxA: "Ajustez votre attitude. Souriez et le monde sourira. Fake it till you make it.",
                nonActionBoxB: "Écoutez la musique des événements. Si ça sonne faux, n'y allez pas.",
                collapseResult: "Harmonie retrouvée ou dissonance révélée. Réponse karmique.",
                gravity: "Fréquence basse (plaintes, colère) qui attire la poisse.",
                darkEnergy: "Charisme magnétique.",
                horizon: "Comprendre que l'extérieur n'est que le reflet de l'intérieur.",
                wormhole: "La musique, les mantras, ou un lieu à haute vibration.",
                newGalaxy: "Vivre en alignement parfait. Fluidité absolue."
            )
        ),
        
        QuantumOracleCard(
            number: 7,
            name: "Le Principe d'Incertitude",
            family: .loisFondamentales,
            essence: ["Lâcher-prise", "Mystère", "Foi"],
            messageProfond: "On ne peut pas connaître la destination et la vitesse en même temps. Acceptez de ne pas savoir où vous allez pour profiter de la vitesse de votre évolution.",
            imageName: "quantum-oracle-07",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous cherchez des garanties là où il n'y en a pas. Lâchez le contrôle.",
                betaOther: "Imprévisible. Changeant. Une énigme impossible à résoudre par la logique.",
                linkResult: "Relation mystérieuse, cachée ou sans étiquette.",
                situation: "Brouillard total. Impossible de planifier à long terme.",
                actionBoxA: "Avancez à l'instinct, un pas après l'autre, sans carte.",
                nonActionBoxB: "Acceptez de ne pas savoir. La foi est votre seule lanterne.",
                collapseResult: "Surprise. Le résultat sera différent de toute prévision.",
                gravity: "Le besoin obsessionnel de sécurité et de contrôle.",
                darkEnergy: "La confiance en la vie. La sérénité dans le chaos.",
                horizon: "Sauter sans filet de sécurité.",
                wormhole: "L'intuition pure, les rêves prémonitoires.",
                newGalaxy: "La paix intérieure, quelle que soit la météo extérieure."
            )
        ),
        
        // MARK: - II. La Cosmologie de l'Âme (8-14)
        
        QuantumOracleCard(
            number: 8,
            name: "La Nébuleuse de la Création",
            family: .cosmologieAme,
            essence: ["Naissance", "Projet", "Fertilité"],
            messageProfond: "Vous êtes dans une phase de gestation pure. Les énergies s'assemblent pour donner naissance à quelque chose de nouveau. Protégez vos rêves naissants.",
            imageName: "quantum-oracle-08",
            interpretation: QuantumInterpretation(
                alphaYou: "Cœur tendre, ouvert, naïf. Envie de materner ou de créer.",
                betaOther: "Potentiel immense mais pas encore formé. Immature ou en devenir.",
                linkResult: "Prémices d'une histoire. Tout est à construire. Fertilité (bébé ou projet).",
                situation: "Phase de conception. Brouillon créatif.",
                actionBoxA: "Lancez-vous ! Commencez petit, plantez la graine. Créez.",
                nonActionBoxB: "Protégez vos idées. Ne les exposez pas trop tôt à la critique.",
                collapseResult: "Naissance. Début d'un cycle long et fructueux.",
                gravity: "Manque de structure. Rêver sans faire.",
                darkEnergy: "Imagination débordante. Fertilité.",
                horizon: "Oser donner vie à quelque chose de vulnérable.",
                wormhole: "Un mentor ou une inspiration artistique.",
                newGalaxy: "Devenir le Créateur de sa propre réalité. Artiste de vie."
            )
        ),
        
        QuantumOracleCard(
            number: 9,
            name: "Le Trou Noir",
            family: .cosmologieAme,
            essence: ["Transformation", "Fin", "Renaissance"],
            messageProfond: "N'ayez pas peur du vide. C'est un point de passage obligatoire où l'ancien ego est déchiqueté pour laisser passer la lumière pure de l'autre côté.",
            imageName: "quantum-oracle-09",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous vous perdez dans l'autre. Risque d'absorption ou de dépression.",
                betaOther: "Vampirique (inconsciemment). Traverse une nuit noire de l'âme.",
                linkResult: "Relation intense, transformatrice, mais potentiellement destructrice. Fusion totale.",
                situation: "Impasse. Fin de route. Rien ne semble fonctionner.",
                actionBoxA: "Déconstruisez tout. Acceptez de perdre pour gagner autre chose.",
                nonActionBoxB: "Laissez-vous absorber par le silence. Retraite nécessaire.",
                collapseResult: "Mort symbolique et Renaissance. Grand nettoyage.",
                gravity: "S'accrocher au passé qui est déjà mort.",
                darkEnergy: "Profondeur abyssale. Capacité à survivre au pire.",
                horizon: "Accepter le vide et la solitude comme des enseignants.",
                wormhole: "Un psychologue, un guérisseur, ou une expérience spirituelle forte.",
                newGalaxy: "L'Illumination après l'obscurité. Phénix."
            )
        ),
        
        QuantumOracleCard(
            number: 10,
            name: "L'Horizon des Événements",
            family: .cosmologieAme,
            essence: ["Non-retour", "Engagement", "Destin"],
            messageProfond: "Vous avez franchi une ligne invisible. Il est impossible de revenir en arrière. Acceptez la chute vers votre nouvelle destinée avec confiance.",
            imageName: "quantum-oracle-10",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous êtes sur le point de dire quelque chose d'irréparable (en bien ou mal).",
                betaOther: "Il/Elle est à la limite. Un geste de plus et tout bascule.",
                linkResult: "Le point de non-retour. Engagement solennel ou rupture définitive.",
                situation: "Moment critique. Urgence absolue.",
                actionBoxA: "Franchissez le pas. Engagez-vous à 100%. Plus de retour possible.",
                nonActionBoxB: "Si vous n'êtes pas prêt, reculez immédiatement du bord. Danger.",
                collapseResult: "Le sort en est jeté. Destinée en marche.",
                gravity: "L'hésitation au moment crucial.",
                darkEnergy: "Le courage fataliste (Amor Fati).",
                horizon: "Le grand OUI à la vie, avec tous ses risques.",
                wormhole: "Une crise extérieure qui force la décision.",
                newGalaxy: "Une nouvelle dimension d'existence."
            )
        ),
        
        QuantumOracleCard(
            number: 11,
            name: "La Matière Noire",
            family: .cosmologieAme,
            essence: ["Inconscient", "Soutien invisible", "Structure"],
            messageProfond: "Ce que vous ne voyez pas est ce qui tient votre monde. Des aides invisibles et des forces inconscientes travaillent pour structurer votre vie.",
            imageName: "quantum-oracle-11",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous ressentez des choses que vous ne dites pas. Secret.",
                betaOther: "Mystérieux. Agit en coulisses. Ses motivations sont cachées.",
                linkResult: "Lien karmique, inconscient. On est lié par quelque chose de plus grand que l'amour humain.",
                situation: "Les apparences sont trompeuses. L'essentiel est invisible.",
                actionBoxA: "Enquêtez. Cherchez ce qui est caché. Écoutez votre flair.",
                nonActionBoxB: "Faites confiance au processus invisible. L'univers travaille pour vous dans l'ombre.",
                collapseResult: "Révélation d'une vérité cachée ou soutien inattendu.",
                gravity: "Ignorance de ses propres motivations profondes (Ombre).",
                darkEnergy: "Soutien des ancêtres ou des guides.",
                horizon: "Intégrer sa part d'ombre.",
                wormhole: "L'étude de l'ésotérisme ou de la psychologie.",
                newGalaxy: "Totalité psychique. Être entier."
            )
        ),
        
        QuantumOracleCard(
            number: 12,
            name: "Le Pulsar",
            family: .cosmologieAme,
            essence: ["Signal", "Rythme", "Communication"],
            messageProfond: "Un message clair et répétitif vous est envoyé. Écoutez le rythme de votre cœur ou les signes récurrents. Il est temps d'émettre votre propre vérité.",
            imageName: "quantum-oracle-12",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous envoyez des signaux, peut-être trop ? Besoin d'être vu.",
                betaOther: "Il/Elle tente de communiquer maladroitement. C'est cyclique.",
                linkResult: "Communication à distance, messages, signes. Rythme régulier.",
                situation: "Il y a un message urgent à transmettre ou à recevoir.",
                actionBoxA: "Communiquez ! Dites la vérité. Répétez si nécessaire.",
                nonActionBoxB: "Tendez l'oreille. Le signal est là, il faut juste l'écouter.",
                collapseResult: "Une nouvelle ou une information cruciale arrive.",
                gravity: "Bruit mental. Incapacité à écouter.",
                darkEnergy: "Votre propre voix. Votre fréquence unique.",
                horizon: "Oser dire sa vérité publiquement.",
                wormhole: "Un outil de communication (livre, internet, lettre).",
                newGalaxy: "Devenir un phare pour les autres. Guide."
            )
        ),
        
        QuantumOracleCard(
            number: 13,
            name: "La Supernova",
            family: .cosmologieAme,
            essence: ["Libération", "Éclat", "Catharsis"],
            messageProfond: "Pour briller de toute votre puissance, vous devez accepter d'exploser vos vieilles carapaces. Une libération d'énergie massive est en cours.",
            imageName: "quantum-oracle-13",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous êtes à bout. Envie de tout envoyer valser. Colère saine.",
                betaOther: "Personnalité flamboyante mais instable. Éblouissant.",
                linkResult: "Coup de foudre violent ou dispute éclatante. Ça passe ou ça casse.",
                situation: "Pression maximale. L'explosion est imminente.",
                actionBoxA: "Brillez ! Montrez-vous. Faites votre \"Coming out\". Explosez les limites.",
                nonActionBoxB: "Laissez l'orage passer. Ne jetez pas d'huile sur le feu.",
                collapseResult: "Libération soudaine d'énergie. Grand soulagement après la crise.",
                gravity: "La peur de sa propre puissance ou colère refoulée.",
                darkEnergy: "Éclat. Charisme. Puissance brute.",
                horizon: "Accepter d'être \"trop\" pour certains. Ne plus s'éteindre.",
                wormhole: "Un événement public, une scène, une exposition.",
                newGalaxy: "Rayonnement stellaire. Célébrité ou reconnaissance."
            )
        ),
        
        QuantumOracleCard(
            number: 14,
            name: "Le Vide Quantique",
            family: .cosmologieAme,
            essence: ["Silence", "Paix", "Origine"],
            messageProfond: "Le vide n'est pas \"rien\", c'est le \"tout\" au repos. Reposez-vous dans le silence pour recharger votre batterie d'âme.",
            imageName: "quantum-oracle-14",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous vous sentez vide, détaché. Besoin de solitude.",
                betaOther: "Absent. Indisponible émotionnellement pour le moment.",
                linkResult: "Pause. Silence radio. Ce n'est pas une fin, c'est une respiration.",
                situation: "Rien ne bouge. Calme plat.",
                actionBoxA: "Ne faites rien. L'agitation serait contre-productive. Méditez.",
                nonActionBoxB: "Reposez-vous. Rechargez les batteries.",
                collapseResult: "Paix. Sérénité. La réponse viendra du silence.",
                gravity: "La peur du vide et de l'ennui. Remplir pour ne pas sentir.",
                darkEnergy: "La paix intérieure. La neutralité bienveillante.",
                horizon: "Apprendre à \"Être\" sans \"Faire\".",
                wormhole: "La méditation, le sommeil, la nature.",
                newGalaxy: "Nirvana. État de conscience pure."
            )
        ),
        
        // MARK: - III. Les Paradoxes Temporels (15-21)
        
        QuantumOracleCard(
            number: 15,
            name: "La Dilatation du Temps",
            family: .paradoxesTemporels,
            essence: ["Patience", "Relativité", "Attente"],
            messageProfond: "Le temps est élastique. Ce qui semble lent pour vous est rapide pour l'univers. Ne regardez pas l'horloge, vivez l'instant pour accélérer le processus.",
            imageName: "quantum-oracle-15",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous trouvez le temps long. Impatience douloureuse.",
                betaOther: "Il/Elle prend son temps, avance à son propre rythme (lent).",
                linkResult: "Relation qui s'inscrit dans la durée. Patience requise.",
                situation: "Retards, lenteurs administratives ou blocages temporels.",
                actionBoxA: "Persévérez, mais doucement. Chi va piano va sano.",
                nonActionBoxB: "Attendez. Le fruit n'est pas mûr.",
                collapseResult: "Succès à long terme. La patience sera récompensée.",
                gravity: "L'urgence. Vouloir tout, tout de suite.",
                darkEnergy: "Endurance. Capacité à tenir la distance.",
                horizon: "Accepter le rythme divin, différent du rythme humain.",
                wormhole: "La planification, l'organisation du temps.",
                newGalaxy: "Maîtrise du temps. Sagesse ancienne."
            )
        ),
        
        QuantumOracleCard(
            number: 16,
            name: "Les Lignes de Temps Parallèles",
            family: .paradoxesTemporels,
            essence: ["Choix", "Multivers", "Bifurcation"],
            messageProfond: "Une autre version de vous vit la vie que vous désirez. Connectez-vous à elle par la visualisation pour fusionner vos lignes de temps.",
            imageName: "quantum-oracle-16",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous imaginez \"et si...\" ? Nostalgie d'un autre choix.",
                betaOther: "Il/Elle mène une double vie ou hésite entre deux destins.",
                linkResult: "Carrefour. La relation peut prendre deux directions opposées maintenant.",
                situation: "Choix multiple. Plusieurs versions de votre futur sont accessibles.",
                actionBoxA: "Changez de scénario. Faites l'inverse de d'habitude.",
                nonActionBoxB: "Observez les signes pour savoir quelle ligne suivre.",
                collapseResult: "Une bifurcation majeure. Changement de trajectoire.",
                gravity: "Regrets. Vivre dans le passé ou dans le fantasme.",
                darkEnergy: "Visualisation créatrice.",
                horizon: "Choisir sa réalité en conscience.",
                wormhole: "Technique de \"Saut quantique\" (visualisation).",
                newGalaxy: "Vivre sa meilleure vie (Best Timeline)."
            )
        ),
        
        QuantumOracleCard(
            number: 17,
            name: "Le Passé Réécrit",
            family: .paradoxesTemporels,
            essence: ["Guérison", "Pardon", "Mémoire"],
            messageProfond: "En changeant votre perception d'un événement passé, vous modifiez son impact sur votre présent. Le karma est nettoyé par le pardon quantique.",
            imageName: "quantum-oracle-17",
            interpretation: QuantumInterpretation(
                alphaYou: "Une vieille blessure se réveille. Rancune tenace.",
                betaOther: "Un ex revient. Ou l'autre agit comme un parent du passé.",
                linkResult: "Retrouvailles karmiques. On règle une vieille dette.",
                situation: "Le passé influence le présent. Répétition d'un schéma.",
                actionBoxA: "Corrigez l'erreur. Demandez pardon ou pardonnez.",
                nonActionBoxB: "Laissez le passé où il est. Ne rouvrez pas la plaie.",
                collapseResult: "Guérison. La boucle est bouclée.",
                gravity: "Le rôle de victime. \"C'est la faute de mon enfance\".",
                darkEnergy: "Résilience. Sagesse acquise par l'expérience.",
                horizon: "Le Pardon véritable (libération de soi).",
                wormhole: "Thérapie régressive, psychogénéalogie, écriture.",
                newGalaxy: "Un présent libre, nettoyé des fantômes."
            )
        ),
        
        QuantumOracleCard(
            number: 18,
            name: "Le Futur Probable",
            family: .paradoxesTemporels,
            essence: ["Vision", "Prédiction", "Espoir"],
            messageProfond: "Le futur n'est pas figé, mais une probabilité dominante se dessine. Si elle vous plaît, nourrissez-la. Sinon, changez votre vibration maintenant.",
            imageName: "quantum-oracle-18",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous projetez trop. Vous vivez dans le futur du couple, pas le présent.",
                betaOther: "Il/Elle a des projets pour vous. Visionnaire.",
                linkResult: "Promesses. Fiançailles. On regarde dans la même direction.",
                situation: "Anticipation. Il faut prévoir la suite.",
                actionBoxA: "Planifiez. Semez les graines pour demain. Investissez.",
                nonActionBoxB: "Ne vendez pas la peau de l'ours. Restez prudent.",
                collapseResult: "L'espoir est fondé. Le projet est viable.",
                gravity: "L'anxiété d'anticipation. La peur de demain.",
                darkEnergy: "L'Espérance. La foi en des jours meilleurs.",
                horizon: "Croire sans voir.",
                wormhole: "Un plan d'action, un calendrier, un oracle.",
                newGalaxy: "Réalisation des rêves."
            )
        ),
        
        QuantumOracleCard(
            number: 19,
            name: "Le Trou de Ver",
            family: .paradoxesTemporels,
            essence: ["Raccourci", "Voyage", "Synchronicité"],
            messageProfond: "Une solution inattendue va vous permettre de sauter les étapes. Une connexion soudaine ou un voyage va tout accélérer.",
            imageName: "quantum-oracle-19",
            interpretation: QuantumInterpretation(
                alphaYou: "Envie de brûler les étapes. Coup de tête.",
                betaOther: "Arrive vers vous à toute vitesse. Rencontre imprévue.",
                linkResult: "Accélération fulgurante. Tout va aller très vite.",
                situation: "Une opportunité en or (\"Golden Ticket\") apparaît.",
                actionBoxA: "Prenez le raccourci ! Dites oui tout de suite.",
                nonActionBoxB: "Attention, ça va trop vite. Risque de sortie de route.",
                collapseResult: "Gain de temps énorme. Chance insolente.",
                gravity: "La routine, la bureaucratie, la lourdeur.",
                darkEnergy: "L'opportunisme (positif). Saisir la chance (Kairos).",
                horizon: "Accepter la facilité (tout ne doit pas être dur).",
                wormhole: "Un piston, une connexion influente, un coup de pouce.",
                newGalaxy: "Un saut de niveau social ou spirituel."
            )
        ),
        
        QuantumOracleCard(
            number: 20,
            name: "L'Éternel Présent",
            family: .paradoxesTemporels,
            essence: ["Ancrage", "Maintenant", "Être"],
            messageProfond: "Tout le pouvoir de l'univers réside dans la seconde actuelle. Cessez de fuir vers demain ou hier. Votre puissance est ICI.",
            imageName: "quantum-oracle-20",
            interpretation: QuantumInterpretation(
                alphaYou: "Soyez là. Votre présence physique manque à l'autre.",
                betaOther: "Hédoniste. Il/Elle profite de la vie, ne lui parlez pas de plan sur 10 ans.",
                linkResult: "Plaisir immédiat. Sensualité. Joie simple d'être ensemble.",
                situation: "Urgence de vivre. Pas de problèmes, que des solutions immédiates.",
                actionBoxA: "Faites ce qui vous fait plaisir, là, maintenant.",
                nonActionBoxB: "Arrêtez de ruminer. Coupez le mental.",
                collapseResult: "Ancrage. Stabilité retrouvée.",
                gravity: "La fuite en avant. L'incapacité à se poser.",
                darkEnergy: "La Pleine Conscience (Mindfulness).",
                horizon: "Habiter son corps pleinement.",
                wormhole: "Le sport, le massage, la respiration, la nature.",
                newGalaxy: "L'Éveil spirituel par la présence."
            )
        ),
        
        QuantumOracleCard(
            number: 21,
            name: "L'Entropie",
            family: .paradoxesTemporels,
            essence: ["Désordre", "Lâcher-prise", "Cycle"],
            messageProfond: "Laissez les choses s'effondrer. Le désordre est nécessaire pour qu'un nouvel ordre plus élevé puisse émerger. Ne résistez pas au chaos.",
            imageName: "quantum-oracle-21",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous mettez le bazar. Vous sabotez (inconsciemment).",
                betaOther: "Sa vie est un chaos total. Il/Elle ne peut rien vous offrir de stable.",
                linkResult: "Relation désordonnée, fatigante. Il faut remettre de l'ordre.",
                situation: "Tout s'écroule. Planifier est inutile. C'est la tempête.",
                actionBoxA: "Lâchez prise. Laissez la tour s'effondrer pour reconstruire.",
                nonActionBoxB: "Ne tentez pas de retenir l'eau avec les mains.",
                collapseResult: "Fin d'un système. Désordre nécessaire avant un nouvel ordre.",
                gravity: "L'attachement aux vieilles structures. La peur du changement.",
                darkEnergy: "La capacité à surfer sur le chaos. Improvisation.",
                horizon: "Accepter l'impermanence de toute chose.",
                wormhole: "Le minimalisme. Faire le vide matériel.",
                newGalaxy: "Une reconstruction saine et épurée."
            )
        ),
        
        // MARK: - IV. La Conscience Multidimensionnelle (22-28)
        
        QuantumOracleCard(
            number: 22,
            name: "La Particule Dieu",
            family: .conscienceMulti,
            essence: ["Valeur", "Poids", "Essence"],
            messageProfond: "Vous êtes ce qui donne du sens et du poids à votre vie. Sans votre conscience, rien n'a de substance. Reconnaissez votre valeur divine.",
            imageName: "quantum-oracle-22",
            interpretation: QuantumInterpretation(
                alphaYou: "Retrouvez votre souveraineté. Ne donnez pas votre pouvoir à l'autre.",
                betaOther: "Une âme noble, peut-être un peu distante ou orgueilleuse, mais intègre.",
                linkResult: "Relation d'élévation mutuelle. On se tire vers le haut. Respect sacré.",
                situation: "Question de valeurs fondamentales. L'essentiel est en jeu.",
                actionBoxA: "Affirmez-vous. Dites \"Je Suis\". Ne négociez pas votre valeur.",
                nonActionBoxB: "Restez digne. Le silence est parfois la plus grande preuve de force.",
                collapseResult: "Reconnaissance de votre importance. Succès d'estime.",
                gravity: "Le syndrome de l'imposteur. Se sentir \"petit\".",
                darkEnergy: "La conscience de sa propre divinité intérieure.",
                horizon: "Accepter d'être important(e) et d'avoir un rôle clé.",
                wormhole: "Un acte d'autorité bienveillante.",
                newGalaxy: "L'incarnation pleine de votre Essence."
            )
        ),
        
        QuantumOracleCard(
            number: 23,
            name: "La Dualité Onde-Corpuscule",
            family: .conscienceMulti,
            essence: ["Flexibilité", "Adaptation", "Identité"],
            messageProfond: "Vous êtes à la fois matière (corps) et énergie (esprit). Ne négligez ni l'un ni l'autre. Ancrez votre spiritualité dans le concret.",
            imageName: "quantum-oracle-23",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous jouez un rôle. Conflit entre ce que vous montrez et ce que vous ressentez.",
                betaOther: "Double visage. Tantôt charmant, tantôt froid. Difficile à saisir.",
                linkResult: "Complémentarité ou opposition. Les contraires s'attirent mais se heurtent.",
                situation: "Dilemme. Deux vérités s'affrontent.",
                actionBoxA: "Choisissez une voie et assumez-la, même si elle est incomplète.",
                nonActionBoxB: "Cherchez la synthèse. Ne soyez pas binaire (blanc/noir).",
                collapseResult: "Équilibre trouvé entre le cœur et la raison.",
                gravity: "La séparation intérieure. Le conflit mental/émotionnel.",
                darkEnergy: "La flexibilité. Être fluide comme l'eau.",
                horizon: "Unifier ses polarités (Masculin/Féminin sacrés).",
                wormhole: "Le Tao, le Yoga, la recherche du milieu.",
                newGalaxy: "L'Harmonie intérieure parfaite."
            )
        ),
        
        QuantumOracleCard(
            number: 24,
            name: "Le Spin",
            family: .conscienceMulti,
            essence: ["Direction", "Mouvement", "Chakra"],
            messageProfond: "Votre énergie doit circuler. Si vous vous sentez bloqué, bougez physiquement ou changez de routine pour relancer le \"spin\" de vos électrons.",
            imageName: "quantum-oracle-24",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous tournez en rond. Obsession mentale.",
                betaOther: "Dynamique, sportif, peut-être un peu instable ou vertigineux.",
                linkResult: "Relation cyclique. \"Je t'aime, je te fuis\". Ça bouge beaucoup.",
                situation: "Stagnation par manque d'élan.",
                actionBoxA: "Changez de routine ! Faites quelque chose de nouveau physiquement.",
                nonActionBoxB: "Laissez la roue tourner. Ce qui est en bas remontera.",
                collapseResult: "Reprise du mouvement. Déblocage.",
                gravity: "L'inertie. La flemme spirituelle.",
                darkEnergy: "L'élan vital (Kundalini).",
                horizon: "Mettre son corps en mouvement pour débloquer l'esprit.",
                wormhole: "La danse, le voyage, le sport.",
                newGalaxy: "Un nouveau cycle de vie vertueux."
            )
        ),
        
        QuantumOracleCard(
            number: 25,
            name: "La Lumière Cohérente",
            family: .conscienceMulti,
            essence: ["Clarté", "Intention", "Focus"],
            messageProfond: "Dispersez moins votre énergie. Une intention unique, claire et précise a plus de pouvoir que mille vœux flous. Focalisez-vous.",
            imageName: "quantum-oracle-25",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous êtes intense, peut-être trop direct(e).",
                betaOther: "Focalisé sur sa carrière ou un but précis. Peu disponible pour le flou.",
                linkResult: "Transparence totale. Vérité crue. Pas de secrets possibles.",
                situation: "Besoin de clarté chirurgicale.",
                actionBoxA: "Soyez précis. Demandez exactement ce que vous voulez. Visez juste.",
                nonActionBoxB: "Ne vous dispersez pas. Éliminez le superflu.",
                collapseResult: "Réussite par la concentration. Objectif atteint.",
                gravity: "La confusion. Vouloir courir plusieurs lièvres à la fois.",
                darkEnergy: "La Discipline.",
                horizon: "Trancher ce qui ne sert plus votre but unique.",
                wormhole: "Un plan d'action détaillé. Un coach.",
                newGalaxy: "Maîtrise et Excellence dans un domaine."
            )
        ),
        
        QuantumOracleCard(
            number: 26,
            name: "L'Énergie Noire",
            family: .conscienceMulti,
            essence: ["Croissance", "Espace", "Inconnu"],
            messageProfond: "Vous êtes en pleine expansion. Vous avez besoin de plus d'espace, de liberté. Ne laissez personne vous rétrécir. Poussez les murs.",
            imageName: "quantum-oracle-26",
            interpretation: QuantumInterpretation(
                alphaYou: "Besoin d'air. Vous vous sentez à l'étroit.",
                betaOther: "Une personnalité expansive, ambitieuse, peut-être envahissante.",
                linkResult: "La relation grandit et prend de la place. Projets communs d'envergure.",
                situation: "Le cadre actuel est trop petit.",
                actionBoxA: "Poussez les murs. Osez voir grand. Demandez l'augmentation.",
                nonActionBoxB: "Ne vous ratatinez pas pour plaire aux autres.",
                collapseResult: "Croissance accélérée. Succès.",
                gravity: "La peur de sa propre grandeur (Complexe de Jonas).",
                darkEnergy: "L'Ambition saine. La soif de découverte.",
                horizon: "Sortir de sa zone de confort pour de bon.",
                wormhole: "Un voyage à l'étranger ou une formation de haut niveau.",
                newGalaxy: "Une vie sans limites. Abondance."
            )
        ),
        
        QuantumOracleCard(
            number: 27,
            name: "Le Champ Unifié",
            family: .conscienceMulti,
            essence: ["Unité", "Empathie", "Tout"],
            messageProfond: "Vous n'êtes jamais seul. Vous faites partie d'un tissu immense. Ce que vous faites pour les autres, vous le faites pour vous-même.",
            imageName: "quantum-oracle-27",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous aimez tout le monde. Tendance au sacrifice.",
                betaOther: "Altruiste, humaniste, connecté.",
                linkResult: "Amour universel. Relation spirituelle, presque désincarnée.",
                situation: "Tout est lié. Une action ici aura des répercussions partout.",
                actionBoxA: "Jouez collectif. Intégrez les autres dans la solution.",
                nonActionBoxB: "Faites confiance au réseau. L'aide viendra d'ailleurs.",
                collapseResult: "Harmonie globale. Résolution pacifique.",
                gravity: "L'égoïsme ou l'isolement volontaire.",
                darkEnergy: "L'Empathie.",
                horizon: "Comprendre que \"l'autre\" est une autre version de soi.",
                wormhole: "Le bénévolat, la communauté, le groupe.",
                newGalaxy: "La Conscience Cosmique. Oneness."
            )
        ),
        
        QuantumOracleCard(
            number: 28,
            name: "Le Miroir Quantique",
            family: .conscienceMulti,
            essence: ["Projection", "Ombre", "Vérité"],
            messageProfond: "Le monde extérieur n'est qu'un miroir de votre monde intérieur. Ce qui vous irrite chez l'autre est une part de vous à guérir.",
            imageName: "quantum-oracle-28",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous projetez vos défauts sur l'autre.",
                betaOther: "Il/Elle vous imite ou vous renvoie votre image sans filtre.",
                linkResult: "Relation thérapeutique. L'autre est là pour vous faire travailler sur vous.",
                situation: "Ce que vous voyez à l'extérieur est le reflet de votre intérieur.",
                actionBoxA: "Changez votre attitude intérieure, et la situation changera.",
                nonActionBoxB: "Regardez-vous en face avant de juger la situation.",
                collapseResult: "Prise de conscience brutale mais salutaire.",
                gravity: "Le déni. Refuser de voir sa part de responsabilité.",
                darkEnergy: "L'Introspection radicale.",
                horizon: "Accepter son Ombre (Jung).",
                wormhole: "La psychothérapie, l'écriture, le feedback honnête d'un ami.",
                newGalaxy: "L'Authenticité totale."
            )
        ),
        
        // MARK: - V. Les Anomalies Cosmiques (29-35)
        
        QuantumOracleCard(
            number: 29,
            name: "La Singularité",
            family: .anomaliesCosmiques,
            essence: ["Miracle", "Unicité", "Exception"],
            messageProfond: "Une situation unique se présente, qui défie toute logique. Ne cherchez pas à comprendre avec le mental, vivez l'exceptionnel.",
            imageName: "quantum-oracle-29",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous vivez quelque chose d'unique, d'incompréhensible pour les autres.",
                betaOther: "Une personne \"Alien\", hors norme, géniale ou bizarre.",
                linkResult: "Une histoire d'amour impossible qui devient possible. Miracle.",
                situation: "Cas unique. Les règles habituelles ne s'appliquent pas.",
                actionBoxA: "Innovez. Faites ce qui n'a jamais été fait.",
                nonActionBoxB: "Ne cherchez pas de logique. Accueillez l'exceptionnel.",
                collapseResult: "Un événement rare va tout changer.",
                gravity: "La peur d'être différent, le conformisme.",
                darkEnergy: "L'Originalité. Votre \"Bizarrerie\" est votre force.",
                horizon: "Assumer son unicité face au monde.",
                wormhole: "Une inspiration soudaine, un éclair de génie.",
                newGalaxy: "Devenir un pionnier. Créer sa propre voie."
            )
        ),
        
        QuantumOracleCard(
            number: 30,
            name: "Le Paradoxe",
            family: .anomaliesCosmiques,
            essence: ["Contradiction", "Vérité complexe", "Humour"],
            messageProfond: "Deux vérités contradictoires peuvent être vraies en même temps. Acceptez la complexité de la situation sans chercher à trancher.",
            imageName: "quantum-oracle-30",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous voulez tout et son contraire (liberté et engagement).",
                betaOther: "Une énigme. Il dit blanc et fait noir.",
                linkResult: "Relation complexe, intellectuelle, faite de jeux d'esprit.",
                situation: "Absurde. Cul-de-sac logique.",
                actionBoxA: "Utilisez l'humour. Riez de la situation.",
                nonActionBoxB: "Ne cherchez pas à résoudre le problème, dépassez-le.",
                collapseResult: "Solution inattendue par la voie latérale.",
                gravity: "La rigidité mentale. Le besoin que tout soit carré.",
                darkEnergy: "L'Intelligence fluide.",
                horizon: "Accepter la complexité du monde.",
                wormhole: "Le lâcher-prise intellectuel. Les Koans zen.",
                newGalaxy: "Sagesse supérieure (au-delà du bien et du mal)."
            )
        ),
        
        QuantumOracleCard(
            number: 31,
            name: "L'Étoile à Neutrons",
            family: .anomaliesCosmiques,
            essence: ["Pression", "Force", "Résilience"],
            messageProfond: "La pression que vous subissez est énorme, mais elle vous condense en un diamant indestructible. Tenez bon, votre densité augmente.",
            imageName: "quantum-oracle-31",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous portez le monde sur vos épaules. Épuisement.",
                betaOther: "Une personne dense, difficile à bouger, têtue.",
                linkResult: "Relation lourde, responsabilités, devoirs. Pas très fun mais solide.",
                situation: "Pression énorme. Test de résistance.",
                actionBoxA: "Tenez bon. Ne pliez pas. Soyez un roc.",
                nonActionBoxB: "Ne rajoutez pas de poids. Délestez-vous du superflu.",
                collapseResult: "Résultat obtenu par la force de la persévérance.",
                gravity: "La surcharge mentale et physique. Burnout.",
                darkEnergy: "La Résilience absolue.",
                horizon: "Transformer le charbon en diamant sous la pression.",
                wormhole: "La discipline physique, l'ancrage.",
                newGalaxy: "Une force intérieure inébranlable."
            )
        ),
        
        QuantumOracleCard(
            number: 32,
            name: "La Comète",
            family: .anomaliesCosmiques,
            essence: ["Passage", "Nouvelle", "Éphémère"],
            messageProfond: "Une inspiration ou une personne va passer dans votre vie rapidement. Saisissez le message au vol, car elle ne restera pas.",
            imageName: "quantum-oracle-32",
            interpretation: QuantumInterpretation(
                alphaYou: "Envie de passer à autre chose. Instabilité.",
                betaOther: "Un voyageur. Il/Elle ne restera pas longtemps.",
                linkResult: "Aventure d'un soir ou d'un été. Intense et bref.",
                situation: "Fenêtre de tir étroite. Urgence.",
                actionBoxA: "Saisissez la balle au bond ! Maintenant ou jamais.",
                nonActionBoxB: "Regardez passer le train si vous n'êtes pas prêt à courir.",
                collapseResult: "Un événement rapide va traverser votre ciel.",
                gravity: "L'attachement aux choses qui doivent partir.",
                darkEnergy: "La spontanéité.",
                horizon: "Accepter l'éphémère. Aimer ce qui ne dure pas.",
                wormhole: "Un message, un email, une nouvelle rapide.",
                newGalaxy: "La liberté de mouvement totale. Nomade."
            )
        ),
        
        QuantumOracleCard(
            number: 33,
            name: "L'Éclipse",
            family: .anomaliesCosmiques,
            essence: ["Ombre temporaire", "Révélation", "Alignement"],
            messageProfond: "Si la lumière semble s'éteindre, c'est pour un alignement nécessaire. L'ombre est temporaire et annonce une renaissance majeure.",
            imageName: "quantum-oracle-33",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous ne voyez pas clair. Vous êtes dans l'ombre de l'autre.",
                betaOther: "Cachottier ou traverse une phase sombre.",
                linkResult: "Secrets, non-dits, triangle amoureux (l'un cache l'autre).",
                situation: "Occultation. Il manque des informations cruciales.",
                actionBoxA: "N'agissez pas dans le noir. Attendez la lumière.",
                nonActionBoxB: "Restez discret. Cachez votre jeu pour l'instant.",
                collapseResult: "Révélation imminente. La lumière va revenir.",
                gravity: "La peur du noir, l'ignorance.",
                darkEnergy: "L'Intuition nocturne.",
                horizon: "Faire face à ce qui est caché (secrets de famille).",
                wormhole: "L'analyse des rêves, l'occultisme.",
                newGalaxy: "La Lucidité. Voir ce que les autres ne voient pas."
            )
        ),
        
        QuantumOracleCard(
            number: 34,
            name: "La Poussière d'Étoiles",
            family: .anomaliesCosmiques,
            essence: ["Humilité", "Magie", "Composition"],
            messageProfond: "N'oubliez pas que vous êtes fait de la même matière que les étoiles. Vous portez l'univers en vous. Retrouvez votre noblesse cosmique.",
            imageName: "quantum-oracle-34",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous êtes rêveur, romantique, un peu \"perché\".",
                betaOther: "Doux, fragile, poétique.",
                linkResult: "Relation magique, platonique ou très tendre. Féérie.",
                situation: "Besoin de réenchanter le quotidien.",
                actionBoxA: "Mettez de la beauté dans vos actes. Soyez gentil.",
                nonActionBoxB: "Émerveillez-vous. Contemplez.",
                collapseResult: "Un petit bonheur inattendu. Gratitude.",
                gravity: "Le cynisme, la dureté, le matérialisme froid.",
                darkEnergy: "L'Innocence.",
                horizon: "Reconnaître le sacré dans la matière.",
                wormhole: "L'Art, la poésie, la nature.",
                newGalaxy: "Une vie remplie de sens et de magie quotidienne."
            )
        ),
        
        QuantumOracleCard(
            number: 35,
            name: "Le Vide",
            family: .anomaliesCosmiques,
            essence: ["Nettoyage", "Page blanche", "Disponibilité"],
            messageProfond: "Faites le vide. Débarrassez-vous du superflu. L'univers a horreur du vide et le remplira bientôt de nouveauté.",
            imageName: "quantum-oracle-35",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous avez fait le vide. Disponibilité totale ou solitude pesante.",
                betaOther: "Indifférent ou absent.",
                linkResult: "Tabula Rasa. On efface tout et on recommence (ou on arrête).",
                situation: "Page blanche. Tout est à écrire.",
                actionBoxA: "Nettoyez. Jetez. Triez. Faites de la place.",
                nonActionBoxB: "Ne remplissez pas le vide par peur. Laissez-le exister.",
                collapseResult: "Nouveau départ absolu. Virginité.",
                gravity: "L'accumulation (objets, rancunes).",
                darkEnergy: "La Pureté. Le Minimalisme.",
                horizon: "Le détachement matériel et émotionnel.",
                wormhole: "Le rangement (Marie Kondo spirituel), le jeûne.",
                newGalaxy: "La Liberté absolue."
            )
        ),
        
        // MARK: - VI. Les Forces de Liaison (36-42)
        
        QuantumOracleCard(
            number: 36,
            name: "La Gravité",
            family: .forcesLiaison,
            essence: ["Désir", "Magnétisme", "Inévitable"],
            messageProfond: "Vous ne pouvez pas lutter contre cette attraction. C'est une loi naturelle. Laissez-vous glisser vers ce qui vous attire irrésistiblement.",
            imageName: "quantum-oracle-36",
            interpretation: QuantumInterpretation(
                alphaYou: "Désir obsessionnel. Vous êtes \"tombé\" amoureux.",
                betaOther: "Magnétique, charismatique, irrésistible.",
                linkResult: "Passion physique, attraction fatale. Impossible de se séparer.",
                situation: "Inévitable. Vous glissez vers la solution naturelle.",
                actionBoxA: "Suivez votre désir. C'est votre boussole.",
                nonActionBoxB: "Cessez de lutter contre le courant. Laissez-vous porter.",
                collapseResult: "Réunion. Rapprochement physique.",
                gravity: "La lourdeur, la dépression, l'attachement toxique.",
                darkEnergy: "L'Ancrage. La stabilité.",
                horizon: "Accepter ses désirs sans culpabilité.",
                wormhole: "Le plaisir, la sexualité, la nourriture terrestre.",
                newGalaxy: "L'incarnation heureuse. Aimer la Terre."
            )
        ),
        
        QuantumOracleCard(
            number: 37,
            name: "L'Électromagnétisme",
            family: .forcesLiaison,
            essence: ["Passion", "Protection", "Rayonnement"],
            messageProfond: "Votre cœur est le plus puissant générateur magnétique. Écoutez sa charge électrique plutôt que la logique froide du cerveau.",
            imageName: "quantum-oracle-37",
            interpretation: QuantumInterpretation(
                alphaYou: "Cœur qui bat la chamade. Émotion vive.",
                betaOther: "Chaleureux, aimant, protecteur.",
                linkResult: "Amour sincère, échanges vibrants, chaleur humaine.",
                situation: "Climat électrique (positif ou négatif). Haute énergie.",
                actionBoxA: "Écoutez votre cœur, pas votre tête. Soyez généreux.",
                nonActionBoxB: "Ressentez avant de penser. Est-ce que ça vibre ?",
                collapseResult: "Connexion émotionnelle forte.",
                gravity: "La froideur, la fermeture du cœur, le cynisme.",
                darkEnergy: "La Radiance (Rayonnement).",
                horizon: "Ouvrir son cœur même après une blessure.",
                wormhole: "La compassion, le pardon.",
                newGalaxy: "Devenir un Amour vivant."
            )
        ),
        
        QuantumOracleCard(
            number: 38,
            name: "La Fusion Nucléaire",
            family: .forcesLiaison,
            essence: ["Union", "Alchimie", "Synergie"],
            messageProfond: "En vous unissant à l'autre (ou à une idée), vous ne faites pas une somme (1+1=2) mais une fusion qui dégage une énergie infinie.",
            imageName: "quantum-oracle-38",
            interpretation: QuantumInterpretation(
                alphaYou: "Envie de ne faire qu'un avec l'autre.",
                betaOther: "Partenaire idéal pour construire. Solide.",
                linkResult: "Mariage, Association, PACS. Union productive et puissante.",
                situation: "Synergie. 1+1 = 3.",
                actionBoxA: "Associez-vous. Ne restez pas seul. Fusionnez vos talents.",
                nonActionBoxB: "Cherchez l'allié complémentaire.",
                collapseResult: "Réussite collective. Création d'une troisième force.",
                gravity: "La peur de perdre son identité dans le groupe.",
                darkEnergy: "La Coopération.",
                horizon: "Dépasser l'ego pour servir une cause commune.",
                wormhole: "Le mariage (symbolique ou réel), le contrat.",
                newGalaxy: "L'Œuvre commune. L'héritage."
            )
        ),
        
        QuantumOracleCard(
            number: 39,
            name: "La Fission",
            family: .forcesLiaison,
            essence: ["Rupture nécessaire", "Indépendance", "Énergie"],
            messageProfond: "Parfois, il faut se séparer pour libérer l'énergie stagnante. Cette rupture est génératrice de vie et de mouvement pour les deux parties.",
            imageName: "quantum-oracle-39",
            interpretation: QuantumInterpretation(
                alphaYou: "Besoin d'indépendance impérieux.",
                betaOther: "Distant, coupant, ou toxique qu'il faut quitter.",
                linkResult: "Divorce, rupture, éloignement géographique nécessaire.",
                situation: "Nécessité de diviser pour mieux régner ou de trancher.",
                actionBoxA: "Séparez-vous de ce qui ne va plus. Coupez le cordon.",
                nonActionBoxB: "Prenez vos distances pour y voir clair.",
                collapseResult: "Libération d'énergie par la rupture. Soulagement.",
                gravity: "La dépendance, la peur de la solitude.",
                darkEnergy: "L'Autonomie.",
                horizon: "Savoir dire NON et partir la tête haute.",
                wormhole: "Une décision radicale, un départ.",
                newGalaxy: "La Souveraineté individuelle."
            )
        ),
        
        QuantumOracleCard(
            number: 40,
            name: "La Constellation",
            family: .forcesLiaison,
            essence: ["Communauté", "Appartenance", "Réseau"],
            messageProfond: "Vous n'êtes pas une étoile isolée. Cherchez votre constellation, votre tribu. Ensemble, vous formez un sens que vous n'avez pas seul.",
            imageName: "quantum-oracle-40",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous cherchez votre tribu, pas juste un amant.",
                betaOther: "Un ami fidèle, un membre de la famille d'âme.",
                linkResult: "Amitié amoureuse, cercle social, intégration.",
                situation: "Enjeu collectif. Réseautage.",
                actionBoxA: "Connectez les gens entre eux. Soyez le maillon fort.",
                nonActionBoxB: "Appuyez-vous sur votre réseau. Demandez conseil.",
                collapseResult: "Vous trouvez votre place dans le groupe.",
                gravity: "L'isolement, le sentiment d'être un alien.",
                darkEnergy: "La Fraternité.",
                horizon: "Accepter d'avoir besoin des autres.",
                wormhole: "Les réseaux sociaux, les clubs, les associations.",
                newGalaxy: "Appartenance. Se sentir chez soi dans l'univers."
            )
        ),
        
        QuantumOracleCard(
            number: 41,
            name: "Le Redshift",
            family: .forcesLiaison,
            essence: ["Départ", "Fin de cycle", "Distance saine"],
            messageProfond: "Certaines choses s'éloignent naturellement de votre vie. Ne leur courez pas après. Laissez l'univers s'étendre et vous éloigner de ce qui n'est plus pour vous.",
            imageName: "quantum-oracle-41",
            interpretation: QuantumInterpretation(
                alphaYou: "Vous évoluez, vous changez de fréquence, vous vous détachez.",
                betaOther: "Il/Elle part doucement vers d'autres horizons. Pas de conflit, juste la vie.",
                linkResult: "Fin de cycle naturelle. Éloignement géographique ou spirituel.",
                situation: "Expansion de l'univers personnel. Les chemins divergent.",
                actionBoxA: "Partez. Explorez le lointain. Ne vous retournez pas.",
                nonActionBoxB: "Laissez partir ceux qui doivent partir. Bon vent.",
                collapseResult: "Une page se tourne en douceur.",
                gravity: "La nostalgie. Retenir ce qui veut partir.",
                darkEnergy: "L'Exploration.",
                horizon: "Le voyage (intérieur ou extérieur) sans attache.",
                wormhole: "Le déménagement, le changement de carrière.",
                newGalaxy: "Découverte de nouveaux mondes inconnus."
            )
        ),
        
        QuantumOracleCard(
            number: 42,
            name: "Le Point Zéro",
            family: .forcesLiaison,
            essence: ["Dieu", "Source", "Tout est accompli"],
            messageProfond: "Vous êtes arrivé au centre. Il n'y a rien à faire, juste à être. Vous êtes connecté à la source inépuisable de toute vie. Gratitude absolue.",
            imageName: "quantum-oracle-42",
            interpretation: QuantumInterpretation(
                alphaYou: "Paix totale. Vous n'attendez plus rien, vous êtes complet.",
                betaOther: "Une âme éveillée ou une présence apaisante.",
                linkResult: "Amour inconditionnel. Au-delà des mots et des drames.",
                situation: "Tout est accompli. La boucle est bouclée.",
                actionBoxA: "Soyez. Juste être. Rayonnez votre présence.",
                nonActionBoxB: "Arrêtez de chercher. Vous avez déjà trouvé.",
                collapseResult: "Résolution parfaite. Gratitude.",
                gravity: "L'agitation mentale, le \"faire\" constant.",
                darkEnergy: "La Présence Pure.",
                horizon: "La fusion avec le Divin/Cosmos.",
                wormhole: "La prière, le silence, la contemplation.",
                newGalaxy: "L'Éveil. Je Suis."
            )
        )
    ]
}
