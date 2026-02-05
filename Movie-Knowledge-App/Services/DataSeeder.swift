//
//  DataSeeder.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation
import SwiftData

final class DataSeeder {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Main Seeding

    /// Seed all initial data if database is empty
    func seedDataIfNeeded() {
        // Check if data already exists
        let descriptor = FetchDescriptor<CategoryModel>()
        if let count = try? context.fetchCount(descriptor), count > 0 {
            updateEssentialsCategoryColorIfNeeded()
            print("✓ Data already seeded")
            return
        }

        print("🌱 Seeding initial data...")

        // Seed all categories
        let categories = seedCategories()

        // Seed subcategories for each category
        seedCoreFilmKnowledge(categories[0])
        seedDirectorsAndCreators(categories[1])
        seedGenres(categories[2])
        seedWorldCinema(categories[3])
        seedAwardsAndRecognition(categories[4])
        seedFilmCraft(categories[5])
        seedMovieEras(categories[6])
        seedActorsAndPerformances(categories[7])
        seedFranchisesAndSeries(categories[8])

        try? context.save()
        print("✓ Data seeding complete")
    }

    // MARK: - Category Seeding

    private func updateEssentialsCategoryColorIfNeeded() {
        let descriptor = FetchDescriptor<CategoryModel>(
            predicate: #Predicate { $0.title == "The Essentials" }
        )

        guard let essentials = try? context.fetch(descriptor).first else {
            return
        }

        let targetRed = 0.30
        let targetGreen = 0.72
        let targetBlue = 0.62

        if essentials.colorRed == targetRed,
           essentials.colorGreen == targetGreen,
           essentials.colorBlue == targetBlue {
            return
        }

        essentials.colorRed = targetRed
        essentials.colorGreen = targetGreen
        essentials.colorBlue = targetBlue

        try? context.save()
    }

    private func seedCategories() -> [CategoryModel] {
        let categoryData: [(String, String, String, String?, String, Double, Double, Double)] = [
            ("The Essentials", "Essential movie knowledge every film buff needs", "Foundations every film fan should know", nil, "film.stack", 0.30, 0.72, 0.62),
            ("Directors and Creators", "The visionaries behind the camera", "The visionaries behind the camera", nil, "person.2", 0.55, 0.35, 0.85),
            ("Genres", "Explore every style of storytelling", "From horror to romance and everything between", nil, "rectangle.grid.2x2", 0.25, 0.60, 0.98),
            ("World Cinema", "Films from around the globe", "Stories from every corner of the globe", nil, "globe", 0.98, 0.55, 0.40),
            ("Awards and Recognition", "Celebrating cinematic excellence", "The films that made history", nil, "trophy", 0.95, 0.75, 0.20),
            ("Behind the Scenes", "The art and technique of filmmaking", "How movie magic is made", nil, "video", 0.20, 0.70, 0.45),
            ("Movie Eras", "Journey through cinema history", "A journey through cinematic time", nil, "clock", 0.25, 0.70, 0.70),
            ("Actors and Performances", "The stars who bring stories to life", "The faces that define the screen", nil, "star.fill", 0.98, 0.40, 0.55),
            ("Franchises and Series", "Iconic film series and universes", "Epic sagas and beloved universes", nil, "film", 0.30, 0.55, 0.98)
        ]

        return categoryData.enumerated().map { index, data in
            let category = CategoryModel(
                title: data.0,
                subtitle: data.1,
                journeySubtitle: data.2,
                tag: data.3 ?? "",
                iconName: data.4,
                colorRed: data.5,
                colorGreen: data.6,
                colorBlue: data.7,
                displayOrder: index
            )
            context.insert(category)
            return category
        }
    }

    // MARK: - Core Film Knowledge

    private func seedCoreFilmKnowledge(_ category: CategoryModel) {
        let subCategories: [(String, String, [String])] = [
            ("Film History Basics", "Foundation of cinema from its origins to today", [
                "The first public film screening was in 1895 by the Lumière brothers",
                "The silent era lasted from 1894 to 1929",
                "Technicolor revolutionized cinema in the 1930s",
                "The first 'talkie' was The Jazz Singer in 1927"
            ]),
            ("Famous Films Everyone Should Know", "Essential viewing for every movie lover", [
                "Citizen Kane is often cited as the greatest film ever made",
                "The Godfather trilogy spans three generations",
                "Casablanca was filmed entirely on a studio lot",
                "2001: A Space Odyssey pioneered visual effects"
            ]),
            ("Movie Quotes and Moments", "Iconic lines and unforgettable scenes", [
                "'Here's looking at you, kid' - Casablanca (1942)",
                "'I'll be back' - The Terminator (1984)",
                "'May the Force be with you' - Star Wars (1977)",
                "The shower scene in Psycho used 70 camera setups"
            ]),
            ("Box Office Hits", "The biggest commercial successes in film", [
                "Avatar holds the all-time box office record",
                "Titanic was the first film to gross $1 billion",
                "Avengers: Endgame made $1.2 billion in its opening weekend",
                "Gone with the Wind was the highest-grossing when adjusted for inflation"
            ]),
            ("Award Winners", "Critically acclaimed masterpieces", [
                "Only three films have won all five major Oscars",
                "Walt Disney holds the record with 22 Academy Awards",
                "Katharine Hepburn won four Best Actress Oscars",
                "Ben-Hur, Titanic, and LOTR: ROTK tie for most Oscar wins (11)"
            ]),
            ("Cult Classics", "Beloved films with devoted followings", [
                "The Rocky Horror Picture Show has been in theaters since 1975",
                "The Big Lebowski inspired an annual festival called Lebowski Fest",
                "Blade Runner initially flopped but became a sci-fi classic",
                "The Princess Bride was a box office disappointment turned phenomenon"
            ])
        ]
        seedSubcategories(subCategories, for: category)
    }

    // MARK: - Directors and Creators

    private func seedDirectorsAndCreators(_ category: CategoryModel) {
        let subCategories: [(String, String, [String])] = [
            ("Famous Directors", "Legendary filmmakers who shaped cinema", [
                "Steven Spielberg directed the first summer blockbuster (Jaws)",
                "Alfred Hitchcock was known as the 'Master of Suspense'",
                "Martin Scorsese has made over 25 feature films",
                "Akira Kurosawa influenced countless Western directors"
            ]),
            ("Indie Filmmakers", "Independent voices in film", [
                "The Sundance Film Festival launched many indie careers",
                "Clerks was made for just $27,575",
                "El Mariachi was filmed for $7,000",
                "Christopher Nolan's first film Following cost $6,000"
            ]),
            ("Director Filmographies", "Complete works of master directors", [
                "Stanley Kubrick made only 13 feature films",
                "Quentin Tarantino plans to retire after 10 films",
                "Hayao Miyazaki has directed 11 feature animations",
                "Denis Villeneuve has worked across multiple genres"
            ]),
            ("Signature Styles", "Recognizable techniques and aesthetics", [
                "Wes Anderson is known for symmetrical compositions",
                "David Fincher favors dark, meticulous visuals",
                "Tarantino uses non-linear storytelling",
                "The Coen Brothers blend dark comedy with crime"
            ]),
            ("First Films vs Breakthrough Films", "Career-defining moments", [
                "George Lucas's first film was THX 1138",
                "Nolan's breakthrough was Memento",
                "Spielberg's TV debut led to Duel (1971)",
                "Ridley Scott broke through with Alien"
            ])
        ]
        seedSubcategories(subCategories, for: category)
    }

    // MARK: - Genres

    private func seedGenres(_ category: CategoryModel) {
        let subCategories: [(String, String, [String])] = [
            ("Action", "Thrills, stunts, and adrenaline", [
                "Die Hard redefined the modern action movie",
                "Mad Max: Fury Road won 6 Academy Awards",
                "Jackie Chan performs his own stunts",
                "The Matrix pioneered 'bullet time' effects"
            ]),
            ("Comedy", "Films that make us laugh", [
                "Some Like It Hot is often called the greatest comedy ever",
                "Groundhog Day was added to the National Film Registry",
                "Bridesmaids changed perceptions of female-led comedies",
                "Airplane! averages 3 jokes per minute"
            ]),
            ("Drama", "Emotional storytelling at its finest", [
                "The Shawshank Redemption was a box office disappointment",
                "12 Angry Men takes place almost entirely in one room",
                "Schindler's List was filmed mostly in black and white",
                "Forrest Gump used groundbreaking visual effects"
            ]),
            ("Horror", "Spine-tingling terror", [
                "Psycho was the first film to show a toilet flushing",
                "The Exorcist caused audiences to faint in theaters",
                "Halloween was made for just $300,000",
                "Get Out won the Oscar for Best Original Screenplay"
            ]),
            ("Sci-Fi", "Imagination and technology collide", [
                "Metropolis (1927) influenced sci-fi for generations",
                "Blade Runner has multiple different cuts",
                "Interstellar consulted with real astrophysicists",
                "The Terminator launched James Cameron's career"
            ]),
            ("Romance", "Love stories on screen", [
                "Titanic's love story spans social classes",
                "The Notebook was based on a Nicholas Sparks novel",
                "When Harry Met Sally defined modern rom-coms",
                "Casablanca's script was written as filming progressed"
            ]),
            ("Thriller", "Suspense and tension", [
                "Se7en's twist ending shocked audiences",
                "Silence of the Lambs won all five major Oscars",
                "Zodiac is based on real unsolved murders",
                "Gone Girl's ending sparked major debate"
            ]),
            ("Animation", "Bringing imagination to life", [
                "Snow White was the first full-length animated feature",
                "Toy Story was the first fully CGI animated film",
                "Studio Ghibli has produced over 20 feature films",
                "Spider-Verse revolutionized animation styles"
            ])
        ]
        seedSubcategories(subCategories, for: category)
    }

    // MARK: - World Cinema

    private func seedWorldCinema(_ category: CategoryModel) {
        let subCategories: [(String, String, [String])] = [
            ("Hollywood", "The American film industry", [
                "The Hollywood sign originally said 'Hollywoodland'",
                "The Big Five studios dominated the Golden Age",
                "Hollywood produces about 700 films per year",
                "The Walk of Fame has over 2,700 stars"
            ]),
            ("European Cinema", "Films from across Europe", [
                "Italian Neorealism emerged after World War II",
                "French New Wave revolutionized filmmaking in the 1960s",
                "Ingmar Bergman is Sweden's most celebrated director",
                "British cinema gave us James Bond and Harry Potter"
            ]),
            ("Asian Cinema", "East and South Asian filmmaking", [
                "Bollywood produces more films than Hollywood",
                "Japanese cinema influenced Star Wars and The Matrix",
                "South Korean films won big at the 2020 Oscars",
                "Hong Kong action cinema peaked in the 1980s-90s"
            ]),
            ("Australian Cinema", "Films from Down Under", [
                "Mad Max launched the Australian New Wave",
                "Crocodile Dundee was a global phenomenon",
                "Australia has produced many Hollywood stars",
                "The Australian film industry dates to 1906"
            ]),
            ("Foreign Language Hits", "International crossover successes", [
                "Parasite was the first non-English Best Picture winner",
                "Crouching Tiger, Hidden Dragon earned $213 million",
                "Life Is Beautiful won three Academy Awards",
                "Amélie became a worldwide sensation"
            ]),
            ("International Award Winners", "Global recognition for excellence", [
                "Cannes is the most prestigious film festival",
                "Fellini won four Foreign Language Film Oscars",
                "Venice is the oldest film festival (1932)",
                "Berlin focuses on political and social films"
            ])
        ]
        seedSubcategories(subCategories, for: category)
    }

    // MARK: - Awards and Recognition

    private func seedAwardsAndRecognition(_ category: CategoryModel) {
        let subCategories: [(String, String, [String])] = [
            ("Academy Awards (Oscars)", "Hollywood's biggest night", [
                "The first Oscars ceremony was in 1929",
                "The statuette is officially named the Academy Award of Merit",
                "The ceremony has been hosted at the Dolby Theatre since 2002",
                "Meryl Streep holds the record for most nominations (21)"
            ]),
            ("Cannes Film Festival", "Prestige on the French Riviera", [
                "Cannes was founded in 1946",
                "The Palme d'Or is the highest award",
                "Films premiere at the Grand Théâtre Lumière",
                "The festival runs for about 12 days each May"
            ]),
            ("Golden Globes", "Recognizing film and television", [
                "The Hollywood Foreign Press Association votes on winners",
                "Categories include both film and television",
                "The ceremony is known for its informal atmosphere",
                "Winners receive a globe with a strip of film around it"
            ]),
            ("BAFTAs", "British Academy honors", [
                "BAFTA stands for British Academy of Film and Television Arts",
                "The awards began in 1949",
                "The mask-shaped trophy weighs 3.7 kg",
                "Winners often go on to win the Oscar"
            ]),
            ("Palme d'Or Winners", "Cannes' highest honor", [
                "The first Palme d'Or was awarded in 1955",
                "Parasite won in 2019 before its Oscar success",
                "Ken Loach has won the award twice",
                "Pulp Fiction won in 1994"
            ]),
            ("Best Picture Winners by Year", "Oscar's top prize through history", [
                "Wings was the first Best Picture winner (1927)",
                "Only one sequel has won: The Godfather Part II",
                "All Quiet on the Western Front won twice (1930, 2022)",
                "Moonlight's win announcement was famously botched"
            ])
        ]
        seedSubcategories(subCategories, for: category)
    }

    // MARK: - Behind the Scenes

    private func seedFilmCraft(_ category: CategoryModel) {
        let subCategories: [(String, String, [String])] = [
            ("Cinematography", "The art of capturing images", [
                "Roger Deakins is considered a modern master",
                "1917 was designed to look like one continuous shot",
                "IMAX cameras are used for epic visual sequences",
                "The 'golden hour' creates warm, natural lighting"
            ]),
            ("Screenwriting", "Crafting stories for the screen", [
                "A screenplay is typically 90-120 pages long",
                "One page roughly equals one minute of screen time",
                "William Goldman wrote Butch Cassidy and The Princess Bride",
                "The 'three-act structure' is a common framework"
            ]),
            ("Editing", "Shaping the final cut", [
                "A feature film may have thousands of individual cuts",
                "The Kuleshov effect shows how editing creates meaning",
                "Sound editing and picture editing are separate crafts",
                "The 'assembly cut' is the first rough edit"
            ]),
            ("Sound and Music", "Audio magic in cinema", [
                "John Williams has composed over 100 film scores",
                "Foley artists create everyday sound effects",
                "THX was created by Lucasfilm for sound quality",
                "Hans Zimmer pioneered electronic film scoring"
            ]),
            ("Visual Effects", "Digital wizardry", [
                "ILM was founded for Star Wars in 1975",
                "Jurassic Park pioneered CGI creatures",
                "Avatar pushed motion capture technology forward",
                "The Mandalorian uses LED wall 'Volume' technology"
            ]),
            ("Practical Effects", "Real-world movie magic", [
                "The Nolan brothers prefer practical effects",
                "Stop-motion animation dates back to the 1890s",
                "Miniatures were used extensively before CGI",
                "Tom Savini is a legendary makeup effects artist"
            ])
        ]
        seedSubcategories(subCategories, for: category)
    }

    // MARK: - Movie Eras

    private func seedMovieEras(_ category: CategoryModel) {
        let subCategories: [(String, String, [String])] = [
            ("Silent Era", "Before the talkies", [
                "The silent era lasted from 1894 to 1929",
                "Charlie Chaplin was the highest-paid actor of the era",
                "Intertitles replaced spoken dialogue",
                "Live musicians accompanied screenings"
            ]),
            ("Golden Age of Hollywood", "The studio system's peak", [
                "The Golden Age spanned roughly 1927-1969",
                "Five major studios controlled the industry",
                "Stars were under long-term contracts",
                "The Hays Code regulated content from 1934-1968"
            ]),
            ("1970s New Hollywood", "A creative revolution", [
                "Directors gained unprecedented creative control",
                "The Godfather and Jaws defined the decade",
                "Film schools produced a new generation of talent",
                "Star Wars changed blockbuster filmmaking"
            ]),
            ("1990s Blockbusters", "Event movies and spectacle", [
                "CGI became mainstream with Jurassic Park",
                "Titanic became the highest-grossing film",
                "Independent cinema also flourished",
                "The decade saw the rise of digital filmmaking"
            ]),
            ("2000s Franchises", "The rise of cinematic universes", [
                "Harry Potter and LOTR dominated the decade",
                "Spider-Man launched the superhero era",
                "Pirates of the Caribbean became a surprise hit",
                "The Dark Knight elevated comic book films"
            ]),
            ("Modern Streaming Era", "Cinema in the digital age", [
                "Netflix began streaming in 2007",
                "Original streaming content competes for Oscars",
                "Theatrical windows have shortened dramatically",
                "Global audiences shape content decisions"
            ])
        ]
        seedSubcategories(subCategories, for: category)
    }

    // MARK: - Actors and Performances

    private func seedActorsAndPerformances(_ category: CategoryModel) {
        let subCategories: [(String, String, [String])] = [
            ("Iconic Performances", "Unforgettable roles in cinema", [
                "Marlon Brando revolutionized film acting",
                "Heath Ledger's Joker won a posthumous Oscar",
                "Daniel Day-Lewis won three Best Actor Oscars",
                "Meryl Streep can master any accent"
            ]),
            ("Actor Filmographies", "Complete works of legendary performers", [
                "Tom Hanks has appeared in over 80 films",
                "Samuel L. Jackson holds the box office record",
                "Cate Blanchett works across all genres",
                "Denzel Washington has a 50-year career"
            ]),
            ("Breakout Roles", "Star-making performances", [
                "Jennifer Lawrence broke out in Winter's Bone",
                "Timothée Chalamet rose to fame in Call Me By Your Name",
                "Julia Roberts became a star in Pretty Woman",
                "Leonardo DiCaprio's first Oscar nom came at 19"
            ]),
            ("Method Actors", "Total immersion in character", [
                "Robert De Niro gained 60 lbs for Raging Bull",
                "Christian Bale is known for extreme transformations",
                "Jared Leto stays in character off-set",
                "Joaquin Phoenix lost 52 lbs for Joker"
            ]),
            ("On-Screen Duos", "Legendary partnerships", [
                "Newman and Redford made two classic films together",
                "Hepburn and Tracy appeared in nine films together",
                "DeNiro and Scorsese have made nine films together",
                "Laurel and Hardy were early comedy legends"
            ])
        ]
        seedSubcategories(subCategories, for: category)
    }

    // MARK: - Franchises and Series

    private func seedFranchisesAndSeries(_ category: CategoryModel) {
        let subCategories: [(String, String, [String])] = [
            ("Star Wars", "A galaxy far, far away", [
                "The original trilogy was released 1977-1983",
                "George Lucas sold Lucasfilm to Disney in 2012",
                "The franchise has grossed over $10 billion",
                "'I am your father' is cinema's most famous reveal"
            ]),
            ("Marvel", "Earth's mightiest heroes", [
                "Iron Man (2008) launched the MCU",
                "The Infinity Saga spans 23 films",
                "Avengers: Endgame grossed $2.8 billion",
                "The MCU is the highest-grossing franchise ever"
            ]),
            ("Harry Potter", "The Wizarding World", [
                "The eight films were released 2001-2011",
                "Daniel Radcliffe was cast at age 11",
                "The franchise grossed over $7.7 billion",
                "All films were produced by David Heyman"
            ]),
            ("Lord of the Rings", "Middle-earth adventures", [
                "Peter Jackson directed all six Middle-earth films",
                "Return of the King won 11 Oscars",
                "The trilogy was filmed simultaneously in New Zealand",
                "Extended editions add hours of content"
            ]),
            ("James Bond", "007's legendary missions", [
                "Sean Connery was the first cinematic Bond",
                "The franchise spans over 60 years",
                "Daniel Craig's era redefined the character",
                "There have been 25 official EON films"
            ]),
            ("Fast and Furious", "Family and fast cars", [
                "The franchise started in 2001",
                "Paul Walker appeared in six films",
                "The series has grossed over $7 billion",
                "Vin Diesel is both star and producer"
            ])
        ]
        seedSubcategories(subCategories, for: category)
    }

    // MARK: - Helper Methods

    private func seedSubcategories(_ subCategories: [(String, String, [String])], for category: CategoryModel) {
        for (index, (title, description, keyFacts)) in subCategories.enumerated() {
            let subCategory = SubCategory(
                title: title,
                descriptionText: description,
                displayOrder: index,
                keyFacts: keyFacts,
                estimatedMinutes: 5
            )
            subCategory.parentCategory = category
            context.insert(subCategory)

            // Add placeholder challenge
            let challenge = Challenge(
                questionText: "This lesson is coming soon. Stay tuned!",
                questionType: .trueFalse,
                correctAnswer: "true",
                wrongAnswers: nil,
                explanation: "More content will be added in future updates.",
                difficulty: .easy
            )
            challenge.subCategory = subCategory
            context.insert(challenge)
        }
    }
    
    // MARK: - Director Spotlights
    
    /// Static array of director spotlights for rotation
    static let directorSpotlights: [DirectorSpotlight] = [
        DirectorSpotlight(
            directorName: "Wes Anderson",
            tagline: "Symmetry and whimsy",
            accentColorRed: 0.80,
            accentColorGreen: 0.76,
            accentColorBlue: 0.62,
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
        ),
        DirectorSpotlight(
            directorName: "Christopher Nolan",
            tagline: "Master of time and mind",
            accentColorRed: 0.55,
            accentColorGreen: 0.65,
            accentColorBlue: 0.72,
            startDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 60, to: Date()) ?? Date()
        ),
        DirectorSpotlight(
            directorName: "Greta Gerwig",
            tagline: "Modern storytelling voice",
            accentColorRed: 0.78,
            accentColorGreen: 0.65,
            accentColorBlue: 0.68,
            startDate: Calendar.current.date(byAdding: .day, value: 60, to: Date()) ?? Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 90, to: Date()) ?? Date()
        ),
        DirectorSpotlight(
            directorName: "Denis Villeneuve",
            tagline: "Visionary sci-fi master",
            accentColorRed: 0.60,
            accentColorGreen: 0.58,
            accentColorBlue: 0.68,
            startDate: Calendar.current.date(byAdding: .day, value: 90, to: Date()) ?? Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 120, to: Date()) ?? Date()
        )
    ]
    
    /// Returns the currently active director spotlight
    static func currentDirectorSpotlight() -> DirectorSpotlight? {
        directorSpotlights.first { $0.isActive } ?? directorSpotlights.first
    }
}
