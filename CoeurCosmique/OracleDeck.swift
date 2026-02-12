import Foundation

enum OracleDeck {
    static let allCards: [OracleCard] = [
        OracleCard(
            number: 1,
            name: "Humilité",
            keywords: ["modestie", "simplicité", "sagesse"],
            message: "La vraie grandeur se révèle dans la simplicité du cœur.",
            extendedMeaning: "Cette carte t'invite à accueillir les leçons de la vie avec grâce. L'humilité n'est pas une faiblesse — c'est la force de reconnaître que tu fais partie d'un tout plus grand. En te libérant du besoin de paraître, tu découvres la beauté d'être simplement toi-même. Laisse ton ego se reposer et permets à ton âme de guider tes pas.",
            imageName: "oracle-humilite"
        ),
        OracleCard(
            number: 2,
            name: "Énergie",
            keywords: ["vitalité", "élan", "puissance"],
            message: "Un flux d'énergie puissant circule en toi. Canalise-le avec intention.",
            extendedMeaning: "Tu es traversé·e par une vague d'énergie vitale. Cette carte t'encourage à diriger cette force vers ce qui compte vraiment pour toi. Prends soin de ton corps, nourris ton esprit, et laisse cette vitalité t'emporter vers tes rêves. L'énergie que tu dégages influence tout ton entourage — choisis de la rendre lumineuse.",
            imageName: "oracle-energie"
        ),
        OracleCard(
            number: 3,
            name: "Vision",
            keywords: ["clairvoyance", "perspective", "horizon"],
            message: "Lève les yeux au-delà de l'immédiat. Ta vision porte plus loin que tu ne le crois.",
            extendedMeaning: "Cette carte t'invite à élargir ta perspective. Ce que tu vois aujourd'hui n'est qu'une fraction de ce qui est possible. Connecte-toi à ta vision intérieure — cette capacité de voir au-delà des apparences et d'imaginer un futur aligné avec ton âme. Les rêves que tu portes sont des messages du destin.",
            imageName: "oracle-vision"
        ),
        OracleCard(
            number: 4,
            name: "Bénédiction",
            keywords: ["grâce", "don", "sacré"],
            message: "Tu es béni·e. Chaque instant de ta vie porte la trace du sacré.",
            extendedMeaning: "Cette carte te rappelle que des forces bienveillantes veillent sur toi. Les bénédictions ne sont pas toujours spectaculaires — elles se glissent dans un sourire, un rayon de soleil, une parole douce au bon moment. Ouvre les yeux du cœur et reconnais la grâce qui t'entoure. Tu es protégé·e et guidé·e plus que tu ne l'imagines.",
            imageName: "oracle-benediction"
        ),
        OracleCard(
            number: 5,
            name: "Stabilité",
            keywords: ["ancrage", "fondation", "sécurité"],
            message: "Construis sur des bases solides. La stabilité intérieure précède la stabilité extérieure.",
            extendedMeaning: "En ce moment, tu es appelé·e à consolider tes fondations. Avant de t'élancer vers de nouveaux horizons, assure-toi que tes racines sont profondes. La stabilité n'est pas l'immobilisme — c'est la certitude tranquille de savoir qui tu es. Prends le temps de t'ancrer dans tes valeurs et dans ta vérité.",
            imageName: "oracle-stabilite"
        ),
        OracleCard(
            number: 6,
            name: "Magie",
            keywords: ["enchantement", "émerveillement", "miracle"],
            message: "La magie est partout pour qui sait regarder. Crois en l'impossible.",
            extendedMeaning: "Cette carte porte l'énergie de l'émerveillement. Elle te rappelle que la vie est tissée de mystères et de synchronicités. La magie n'est pas réservée aux contes — elle opère chaque jour dans ta vie quand tu ouvres ton cœur à l'inattendu. Laisse-toi surprendre et retrouve ce regard émerveillé de l'enfant que tu portes en toi.",
            imageName: "oracle-magie"
        ),
        OracleCard(
            number: 7,
            name: "Sincérité",
            keywords: ["authenticité", "vérité", "transparence"],
            message: "La sincérité est le langage du cœur. Ose dire ta vérité avec douceur.",
            extendedMeaning: "Cette carte t'invite à l'honnêteté — envers toi-même d'abord, puis envers les autres. La sincérité crée un espace de confiance où les relations profondes peuvent s'épanouir. N'aie pas peur de montrer ta vulnérabilité — elle est ta force. Quand tu parles avec le cœur, tes paroles portent une puissance de guérison.",
            imageName: "oracle-sincerite"
        ),
        OracleCard(
            number: 8,
            name: "Adaptation",
            keywords: ["flexibilité", "résilience", "changement"],
            message: "Comme l'eau, coule avec les événements. Ta souplesse est ta plus grande force.",
            extendedMeaning: "Le changement frappe à ta porte. Cette carte t'encourage à l'accueillir avec souplesse plutôt que de résister. L'adaptation n'est pas de la soumission — c'est l'intelligence du vivant qui sait évoluer pour s'épanouir. Comme le roseau qui plie sans rompre, ta capacité à t'ajuster te rendra plus fort·e que n'importe quelle rigidité.",
            imageName: "oracle-adaptation"
        ),
        OracleCard(
            number: 9,
            name: "Victoire",
            keywords: ["triomphe", "accomplissement", "fierté"],
            message: "La victoire est proche. Reconnais le chemin parcouru et célèbre ta réussite.",
            extendedMeaning: "Cette carte annonce un temps de moisson. Tes efforts portent enfin leurs fruits. Que la victoire soit grande ou discrète, elle mérite d'être célébrée. Ne minimise pas tes accomplissements — chaque pas franchi est une preuve de ton courage. Permets-toi de ressentir la fierté et la joie de ce que tu as accompli.",
            imageName: "oracle-victoire"
        ),
        OracleCard(
            number: 10,
            name: "Beauté",
            keywords: ["grâce", "esthétique", "émerveillement"],
            message: "La beauté est un miroir de l'âme. Vois-la en toi et autour de toi.",
            extendedMeaning: "Cette carte t'invite à cultiver la beauté dans toutes ses formes — dans ton environnement, dans tes relations, dans ta façon d'être. La beauté n'est pas superficielle — elle est l'expression visible de l'harmonie intérieure. Quand tu reconnais la beauté du monde, tu la fais grandir en toi. Et quand tu reconnais ta propre beauté, tu inspires les autres.",
            imageName: "oracle-beaute"
        ),
        OracleCard(
            number: 11,
            name: "Équilibre",
            keywords: ["harmonie", "mesure", "centre"],
            message: "Retrouve ton centre. L'équilibre naît de l'attention portée à chaque dimension de ton être.",
            extendedMeaning: "Corps, cœur, esprit, âme — chaque dimension réclame ton attention. Cette carte te signale qu'un rééquilibrage est nécessaire. Peut-être donnes-tu trop d'énergie dans un domaine au détriment d'un autre. Reviens à ton centre, ajuste tes priorités et rappelle-toi que prendre soin de toi n'est pas égoïste, c'est essentiel.",
            imageName: "oracle-equilibre"
        ),
        OracleCard(
            number: 12,
            name: "Passion",
            keywords: ["feu sacré", "désir", "intensité"],
            message: "Rallume la flamme. Ta passion est le carburant de ton âme.",
            extendedMeaning: "Qu'est-ce qui fait battre ton cœur plus fort ? Cette carte t'appelle à retrouver ou nourrir cette flamme intérieure. La passion n'est pas un luxe — c'est l'énergie vitale qui donne du sens à ton existence. Que ce soit en amour, dans un projet ou une quête personnelle, autorise-toi à désirer ardemment et à poursuivre ce qui t'enflamme.",
            imageName: "oracle-passion"
        ),
        OracleCard(
            number: 13,
            name: "Réflexion",
            keywords: ["introspection", "méditation", "profondeur"],
            message: "Prends le temps de te retourner vers toi. Les réponses sont à l'intérieur.",
            extendedMeaning: "Cette carte t'invite à ralentir et à plonger dans ton monde intérieur. Dans le silence de la réflexion se cachent des trésors de compréhension. Avant de prendre une décision importante, accorde-toi un temps de recul. Médite, écris, contemple — et laisse émerger la clarté que ton mental agité masquait.",
            imageName: "oracle-reflexion"
        ),
        OracleCard(
            number: 14,
            name: "Spiritualité",
            keywords: ["élévation", "connexion divine", "transcendance"],
            message: "Tu es un être spirituel vivant une expérience humaine. Reconnecte-toi au sacré.",
            extendedMeaning: "Cette carte t'appelle à nourrir ta dimension spirituelle. Au-delà du quotidien et de ses urgences, une part de toi aspire à l'élévation. Que ce soit par la prière, la méditation, la nature ou l'art, trouve le chemin qui te reconnecte au divin en toi. La spiritualité n'est pas une fuite — c'est un ancrage dans ce qui est éternel.",
            imageName: "oracle-spiritualite"
        ),
        OracleCard(
            number: 15,
            name: "Reine",
            keywords: ["souveraineté", "grâce", "pouvoir féminin"],
            message: "Tu portes en toi la souveraineté d'une reine. Gouverne ta vie avec grâce et dignité.",
            extendedMeaning: "Cette carte évoque le pouvoir féminin sacré — qu'il s'exprime en homme ou en femme. La Reine incarne l'autorité douce, la grâce dans le leadership, et la force de la compassion. Tu es invité·e à prendre ta place avec assurance, à poser tes limites avec dignité et à diriger ta vie depuis le trône de ton cœur.",
            imageName: "oracle-reine"
        ),
        OracleCard(
            number: 16,
            name: "Paix",
            keywords: ["sérénité", "harmonie", "calme intérieur"],
            message: "La paix que tu cherches existe déjà en toi. Respire et laisse-la se révéler.",
            extendedMeaning: "Au cœur de toute agitation, un espace de paix t'attend. Cette carte te rappelle que la sérénité n'est pas l'absence de problèmes, mais la capacité de rester centré·e malgré eux. Cultive des moments de silence, entoure-toi de douceur, et choisis consciemment la paix à chaque instant. Elle irradiera alors naturellement vers tous ceux qui t'entourent.",
            imageName: "oracle-paix"
        ),
        OracleCard(
            number: 17,
            name: "Patience",
            keywords: ["temps", "maturation", "persévérance"],
            message: "Chaque chose en son temps. Ce qui est semé avec amour fleurira.",
            extendedMeaning: "Tu voudrais peut-être que les choses avancent plus vite, mais cette carte te rappelle que les plus beaux fruits demandent du temps pour mûrir. La patience n'est pas de l'inaction — c'est une confiance active dans le processus de la vie. Continue de nourrir tes rêves avec intention, et laisse le temps faire son œuvre magique.",
            imageName: "oracle-patience"
        ),
        OracleCard(
            number: 18,
            name: "Communication",
            keywords: ["expression", "écoute", "dialogue"],
            message: "Les mots portent le pouvoir de créer et de guérir. Choisis-les avec soin.",
            extendedMeaning: "Cette carte t'invite à prêter attention à ta façon de communiquer — avec les autres et avec toi-même. Les mots sont des semences : ils peuvent nourrir ou blesser. Pratique l'écoute active, exprime tes besoins avec clarté et bienveillance, et n'oublie pas que le silence aussi est une forme de communication profonde.",
            imageName: "oracle-communication"
        ),
        OracleCard(
            number: 19,
            name: "Guérisseuse",
            keywords: ["soin", "réparation", "don de guérison"],
            message: "La guérison est en cours. Tu portes en toi le don de soigner les cœurs.",
            extendedMeaning: "Cette carte reconnaît ta capacité naturelle à apaiser et guérir — toi-même et les autres. La Guérisseuse en toi sait que chaque blessure porte en elle les graines de sa propre guérison. Fais confiance à ce processus. Pose tes mains sur ton cœur, envoie de l'amour à ce qui te fait mal, et laisse la magie de la guérison opérer dans ta vie.",
            imageName: "oracle-guerisseuse"
        ),
        OracleCard(
            number: 20,
            name: "Force",
            keywords: ["puissance", "courage", "détermination"],
            message: "Tu es plus fort·e que tu ne le crois. Rappelle-toi tout ce que tu as déjà traversé.",
            extendedMeaning: "Cette carte honore ta résilience. Tu as surmonté des épreuves que tu ne pensais pas pouvoir traverser, et tu es toujours là. Cette force qui t'habite n'est pas bruyante — elle est profonde, enracinée, inébranlable. Quand le doute surgit, rappelle-toi ce parcours. Tu as tout ce qu'il faut pour affronter ce qui vient.",
            imageName: "oracle-force"
        ),
        OracleCard(
            number: 21,
            name: "Créativité",
            keywords: ["expression", "inspiration", "création"],
            message: "L'énergie créatrice coule en toi. Laisse-la s'exprimer librement.",
            extendedMeaning: "Tu es un canal d'expression unique. Cette carte t'encourage à créer sans jugement — que ce soit à travers l'art, l'écriture, la musique, la cuisine ou toute autre forme. La créativité est un acte sacré qui te reconnecte à l'essence de qui tu es. Ne censure pas tes élans. L'imperfection est la signature de l'authenticité.",
            imageName: "oracle-creativite"
        ),
        OracleCard(
            number: 22,
            name: "Amour",
            keywords: ["tendresse", "union", "cœur"],
            message: "L'amour est la force la plus puissante de l'univers. Il commence par toi.",
            extendedMeaning: "Cette carte rayonne d'une énergie d'amour pur et inconditionnel. Elle te rappelle que l'amour n'est pas seulement un sentiment — c'est une force cosmique qui traverse tout. Commence par t'aimer toi-même avec la même tendresse que tu offres aux autres. Quand ton cœur déborde d'amour, il illumine tout sur son passage.",
            imageName: "oracle-amour"
        ),
        OracleCard(
            number: 23,
            name: "Raison",
            keywords: ["discernement", "logique", "clarté"],
            message: "La sagesse du cœur et la clarté de l'esprit doivent s'unir pour éclairer tes choix.",
            extendedMeaning: "Cette carte t'invite à utiliser ton discernement. Parfois, il est nécessaire de tempérer les élans du cœur avec la lucidité de la raison. Analyse la situation avec objectivité, pèse le pour et le contre, puis prends ta décision en conscience. La raison n'est pas l'ennemi de l'intuition — elle en est le complément précieux.",
            imageName: "oracle-raison"
        ),
        OracleCard(
            number: 24,
            name: "Éveil",
            keywords: ["conscience", "révélation", "lucidité"],
            message: "Un voile se lève. Tu vois maintenant avec les yeux du cœur.",
            extendedMeaning: "Cette carte annonce un saut de conscience. Des vérités que tu pressentais se confirment. Des schémas répétitifs deviennent enfin visibles. Cet éveil peut être déstabilisant, mais il est profondément libérateur. Accueille cette nouvelle lucidité avec gratitude — elle est le signe que tu évolues vers une version plus alignée de toi-même.",
            imageName: "oracle-eveil"
        ),
        OracleCard(
            number: 25,
            name: "Sagesse",
            keywords: ["discernement", "maturité", "connaissance"],
            message: "L'expérience t'a enseigné des leçons précieuses. Honore ta sagesse acquise.",
            extendedMeaning: "Tu as accumulé une sagesse que personne ne peut te retirer. Cette carte te rappelle de faire confiance à ton discernement, forgé par l'expérience et la réflexion. N'attends pas la validation des autres pour honorer ce que tu sais au fond de toi. Ta sagesse intérieure est ta boussole la plus fiable.",
            imageName: "oracle-sagesse"
        ),
        OracleCard(
            number: 26,
            name: "Voyage",
            keywords: ["aventure", "exploration", "mouvement"],
            message: "Un voyage t'attend — intérieur ou extérieur. Laisse-toi porter par l'aventure.",
            extendedMeaning: "Cette carte t'invite au mouvement. Que ce soit un voyage physique vers de nouveaux horizons ou un voyage intérieur vers de nouvelles compréhensions, l'heure est à l'exploration. Sors de ta zone de confort, ouvre-toi à l'inconnu et laisse-toi surprendre. Chaque voyage transforme celui qui le fait.",
            imageName: "oracle-voyage"
        ),
        OracleCard(
            number: 27,
            name: "Succès",
            keywords: ["réussite", "accomplissement", "prospérité"],
            message: "Le succès est déjà en route vers toi. Continue d'avancer avec foi.",
            extendedMeaning: "Cette carte porte une énergie de réussite et d'accomplissement. Tes efforts sont sur le point d'être récompensés. Le succès que tu mérites arrive — peut-être sous une forme que tu n'attends pas. Reste ouvert·e aux opportunités et garde confiance en tes capacités. Tu es aligné·e avec l'énergie de la prospérité.",
            imageName: "oracle-succes"
        ),
        OracleCard(
            number: 28,
            name: "Gardienne",
            keywords: ["protection", "vigilance", "bienveillance"],
            message: "Tu es protégé·e. Une présence bienveillante veille sur toi et tes proches.",
            extendedMeaning: "La Gardienne est une énergie de protection et de veille. Cette carte te rassure : tu n'es pas seul·e dans tes épreuves. Des forces bienveillantes — qu'elles soient spirituelles ou incarnées — veillent sur toi. En même temps, tu es aussi la gardienne de tes propres limites. Protège ton espace sacré avec fermeté et douceur.",
            imageName: "oracle-gardienne"
        ),
        OracleCard(
            number: 29,
            name: "Métamorphose",
            keywords: ["transformation", "mutation", "renaissance"],
            message: "Ce qui se termine fait place à quelque chose de plus grand. Fais confiance au processus.",
            extendedMeaning: "Tu traverses une période de mutation profonde. Comme le papillon dans son cocon, cette phase peut sembler inconfortable, mais elle est essentielle. Ne résiste pas au changement qui s'opère — il t'emmène vers une version plus authentique de toi-même. Chaque fin porte en elle le germe d'un nouveau commencement magnifique.",
            imageName: "oracle-metamorphose"
        ),
        OracleCard(
            number: 30,
            name: "Énigme",
            keywords: ["mystère", "curiosité", "révélation"],
            message: "Accepte de ne pas tout comprendre. Le mystère fait partie de la beauté de la vie.",
            extendedMeaning: "Cette carte t'invite à faire la paix avec l'inconnu. Tout n'a pas besoin d'être expliqué ou compris immédiatement. Certains mystères se révèlent avec le temps, d'autres restent pour nourrir ton émerveillement. Cultive la curiosité plutôt que le besoin de contrôle, et laisse la vie te surprendre avec ses révélations.",
            imageName: "oracle-enigme"
        ),
        OracleCard(
            number: 31,
            name: "Récompense",
            keywords: ["mérite", "moisson", "retour"],
            message: "Ce que tu as semé avec amour porte ses fruits. Accueille ta récompense.",
            extendedMeaning: "Le temps de la moisson est venu. Cette carte confirme que tes efforts, ta patience et ta persévérance sont enfin récompensés. Que cette récompense soit matérielle, émotionnelle ou spirituelle, accueille-la avec gratitude. Tu la mérites pleinement. Et souviens-toi que la plus belle récompense est souvent la transformation que le chemin a opérée en toi.",
            imageName: "oracle-recompense"
        ),
        OracleCard(
            number: 32,
            name: "Chance",
            keywords: ["fortune", "opportunité", "synchronicité"],
            message: "La chance te sourit. Reste attentif·ve aux portes qui s'ouvrent.",
            extendedMeaning: "Cette carte annonce un temps favorable. Les astres s'alignent en ta faveur et des opportunités se présentent. La chance n'est pas un hasard — elle est la rencontre entre ta préparation et le bon moment. Reste vigilant·e, car la porte de la chance ne frappe parfois qu'une fois. Saisis les occasions qui résonnent avec ton cœur.",
            imageName: "oracle-chance"
        ),
        OracleCard(
            number: 33,
            name: "Inspiration",
            keywords: ["muse", "souffle créateur", "illumination"],
            message: "L'inspiration te visite. Accueille-la et laisse-la te transformer.",
            extendedMeaning: "Un souffle créateur traverse ta vie en ce moment. Cette carte t'encourage à capter cette énergie d'inspiration et à la matérialiser. Que ce soit une idée, un projet, une vision — quelque chose demande à naître à travers toi. Ne remets pas à demain ce que l'inspiration t'offre aujourd'hui. Crée, exprime, partage.",
            imageName: "oracle-inspiration"
        ),
        OracleCard(
            number: 34,
            name: "Gratitude",
            keywords: ["reconnaissance", "abondance", "bénédiction"],
            message: "La gratitude transforme ce que tu as en suffisance. Célèbre l'instant présent.",
            extendedMeaning: "Quand tu prends le temps de reconnaître les bénédictions déjà présentes dans ta vie, tu ouvres le canal de l'abondance. Cette carte t'invite à poser un regard neuf sur ton quotidien. Même dans les épreuves se cachent des cadeaux. La gratitude est une alchimie puissante qui change ta vibration et attire vers toi ce qui te correspond.",
            imageName: "oracle-gratitude"
        ),
        OracleCard(
            number: 35,
            name: "Épanouissement",
            keywords: ["floraison", "plénitude", "joie de vivre"],
            message: "Tu es en pleine floraison. Chaque pétale de ton être s'ouvre au monde.",
            extendedMeaning: "Cette carte célèbre ta croissance et ton développement. Comme une fleur qui s'épanouit au soleil, tu déploies progressivement toute ta beauté et tout ton potentiel. Ce n'est pas le moment de te retenir — laisse-toi éclore pleinement. L'épanouissement est le résultat naturel quand tu vis en accord avec ta vérité profonde.",
            imageName: "oracle-epanouissement"
        ),
        OracleCard(
            number: 36,
            name: "Abondance",
            keywords: ["prospérité", "richesse", "flux"],
            message: "L'univers est généreux. Ouvre-toi à recevoir tout ce qui t'est destiné.",
            extendedMeaning: "L'abondance n'est pas seulement matérielle — elle se manifeste dans l'amour, la créativité, les rencontres et les opportunités. Cette carte te signale que tu es dans un cycle d'ouverture et de réception. Crois en ta valeur et en ton mérite. L'univers conspire en ta faveur lorsque tu t'alignes avec ton intention la plus haute.",
            imageName: "oracle-abondance"
        ),
        OracleCard(
            number: 37,
            name: "Libération",
            keywords: ["liberté", "lâcher-prise", "envol"],
            message: "Relâche ta prise. Ce qui est pour toi ne te manquera jamais.",
            extendedMeaning: "Tu t'accroches peut-être à une situation, une personne ou une attente qui te pèse. Cette carte t'encourage à ouvrir les mains et à laisser la vie faire son œuvre. La libération n'est pas de l'abandon — c'est un acte de foi profond. En te libérant de ce qui ne te sert plus, tu crées l'espace pour ce qui te correspond vraiment.",
            imageName: "oracle-liberation"
        ),
        OracleCard(
            number: 38,
            name: "Persévérance",
            keywords: ["ténacité", "endurance", "détermination"],
            message: "Continue d'avancer, même à petits pas. La persévérance sculpte les destins.",
            extendedMeaning: "Cette carte reconnaît la fatigue que tu peux ressentir sur ton chemin. Pourtant, elle te demande de ne pas lâcher maintenant — tu es plus proche de ton but que tu ne le penses. La persévérance n'est pas de la rigidité — c'est la foi en action. Chaque petit pas compte. Chaque effort s'accumule. Le jour de la moisson approche.",
            imageName: "oracle-perseverance"
        ),
        OracleCard(
            number: 39,
            name: "Grâce",
            keywords: ["fluidité", "élégance", "divin"],
            message: "La grâce te porte. Laisse-toi bercer par ce courant doux et puissant.",
            extendedMeaning: "Cette carte porte une énergie de douceur divine. La grâce est cette force invisible qui rend tout plus fluide quand tu cesses de forcer. En ce moment, tu es invité·e à lâcher l'effort et à te laisser porter. Les choses peuvent se faire avec aisance et beauté. Accueille la grâce dans tes gestes, tes paroles et tes pensées.",
            imageName: "oracle-grace"
        ),
        OracleCard(
            number: 40,
            name: "Désir",
            keywords: ["aspiration", "feu intérieur", "élan vital"],
            message: "Tes désirs sont des messages de ton âme. Écoute-les avec respect.",
            extendedMeaning: "Le désir est souvent mal compris — cette carte le réhabilite. Tes désirs profonds ne sont pas des caprices — ils sont la voix de ton âme qui t'indique la direction de ton épanouissement. Ose nommer ce que tu veux vraiment. Ose croire que tu mérites de l'avoir. Le désir est le premier pas de la manifestation.",
            imageName: "oracle-desir"
        ),
        OracleCard(
            number: 41,
            name: "Simplicité",
            keywords: ["essentiel", "dépouillement", "pureté"],
            message: "La beauté se trouve dans la simplicité. Allège ta vie pour retrouver l'essentiel.",
            extendedMeaning: "Cette carte t'invite à faire le tri — dans ton espace, dans tes pensées, dans tes engagements. La simplicité n'est pas un manque — c'est un art de vivre qui libère. En te défaisant du superflu, tu fais de la place pour ce qui nourrit vraiment ton âme. Moins, c'est souvent plus. Retrouve la joie dans les choses simples.",
            imageName: "oracle-simplicite"
        ),
        OracleCard(
            number: 42,
            name: "Élégance",
            keywords: ["raffinement", "noblesse", "beauté intérieure"],
            message: "L'élégance est l'expression de ton âme. Elle se manifeste quand tu es aligné·e avec toi-même.",
            extendedMeaning: "Cette carte célèbre la noblesse de ton être. L'élégance dont il est question ici n'est pas seulement extérieure — c'est celle de l'âme qui se manifeste à travers tes actes, tes paroles et ta façon d'être. Quand tu vis avec intégrité et grâce, tu rayonnes d'une beauté qui transcende les apparences. Sois fier·e de qui tu es.",
            imageName: "oracle-elegance"
        ),
    ]
}
