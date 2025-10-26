import 'package:drift/drift.dart';
import 'package:billkeep/database/database.dart';

class DefaultMerchants {
  // List of default merchants with their details
  static final List<Map<String, dynamic>> merchants = [
    // Streaming Services
    {
      'id': 'merchant_netflix',
      'name': 'Netflix',
      'description':
          'Streaming service for movies, TV shows, and original content',
      'imageUrl': 'https://logo.clearbit.com/netflix.com',
      'website': 'https://www.netflix.com',
    },
    {
      'id': 'merchant_spotify',
      'name': 'Spotify',
      'description':
          'Music streaming service with millions of songs and podcasts',
      'imageUrl': 'https://logo.clearbit.com/spotify.com',
      'website': 'https://www.spotify.com',
    },
    {
      'id': 'merchant_disney_plus',
      'name': 'Disney+',
      'description':
          'Streaming service for Disney, Pixar, Marvel, Star Wars content',
      'imageUrl': 'https://logo.clearbit.com/disneyplus.com',
      'website': 'https://www.disneyplus.com',
    },
    {
      'id': 'merchant_hulu',
      'name': 'Hulu',
      'description': 'Streaming platform for TV shows, movies, and live TV',
      'imageUrl': 'https://logo.clearbit.com/hulu.com',
      'website': 'https://www.hulu.com',
    },
    {
      'id': 'merchant_amazon_prime',
      'name': 'Amazon Prime Video',
      'description':
          'Video streaming service with Amazon original shows and movies',
      'imageUrl': 'https://logo.clearbit.com/primevideo.com',
      'website': 'https://www.primevideo.com',
    },
    {
      'id': 'merchant_apple_tv',
      'name': 'Apple TV+',
      'description': 'Apple streaming service with original shows and movies',
      'imageUrl': 'https://logo.clearbit.com/apple.com',
      'website': 'https://tv.apple.com',
    },
    {
      'id': 'merchant_hbo_max',
      'name': 'HBO Max',
      'description':
          'Premium streaming service with HBO and Warner Bros. content',
      'imageUrl': 'https://logo.clearbit.com/hbomax.com',
      'website': 'https://www.hbomax.com',
    },
    {
      'id': 'merchant_youtube_premium',
      'name': 'YouTube Premium',
      'description': 'Ad-free YouTube with background play and YouTube Music',
      'imageUrl': 'https://logo.clearbit.com/youtube.com',
      'website': 'https://www.youtube.com/premium',
    },

    // E-commerce & Retail
    {
      'id': 'merchant_amazon',
      'name': 'Amazon',
      'description': 'Online marketplace for products, groceries, and services',
      'imageUrl': 'https://logo.clearbit.com/amazon.com',
      'website': 'https://www.amazon.com',
    },
    {
      'id': 'merchant_walmart',
      'name': 'Walmart',
      'description':
          'Retail chain offering groceries, electronics, and home goods',
      'imageUrl': 'https://logo.clearbit.com/walmart.com',
      'website': 'https://www.walmart.com',
    },
    {
      'id': 'merchant_target',
      'name': 'Target',
      'description':
          'Department store for clothing, home essentials, and groceries',
      'imageUrl': 'https://logo.clearbit.com/target.com',
      'website': 'https://www.target.com',
    },
    {
      'id': 'merchant_ebay',
      'name': 'eBay',
      'description': 'Online auction and shopping marketplace',
      'imageUrl': 'https://logo.clearbit.com/ebay.com',
      'website': 'https://www.ebay.com',
    },
    {
      'id': 'merchant_etsy',
      'name': 'Etsy',
      'description': 'Marketplace for handmade, vintage, and unique items',
      'imageUrl': 'https://logo.clearbit.com/etsy.com',
      'website': 'https://www.etsy.com',
    },
    {
      'id': 'merchant_bestbuy',
      'name': 'Best Buy',
      'description':
          'Electronics retailer for computers, phones, and appliances',
      'imageUrl': 'https://logo.clearbit.com/bestbuy.com',
      'website': 'https://www.bestbuy.com',
    },

    // Cloud & Tech Services
    {
      'id': 'merchant_aws',
      'name': 'Amazon Web Services',
      'description': 'Cloud computing platform and infrastructure services',
      'imageUrl': 'https://logo.clearbit.com/aws.amazon.com',
      'website': 'https://aws.amazon.com',
    },
    {
      'id': 'merchant_google_cloud',
      'name': 'Google Cloud',
      'description': 'Cloud computing and infrastructure services by Google',
      'imageUrl': 'https://logo.clearbit.com/cloud.google.com',
      'website': 'https://cloud.google.com',
    },
    {
      'id': 'merchant_microsoft_azure',
      'name': 'Microsoft Azure',
      'description': 'Microsoft cloud platform for computing and storage',
      'imageUrl': 'https://logo.clearbit.com/azure.microsoft.com',
      'website': 'https://azure.microsoft.com',
    },
    {
      'id': 'merchant_digitalocean',
      'name': 'DigitalOcean',
      'description': 'Cloud infrastructure provider for developers',
      'imageUrl': 'https://logo.clearbit.com/digitalocean.com',
      'website': 'https://www.digitalocean.com',
    },
    {
      'id': 'merchant_heroku',
      'name': 'Heroku',
      'description': 'Platform-as-a-service for app deployment and hosting',
      'imageUrl': 'https://logo.clearbit.com/heroku.com',
      'website': 'https://www.heroku.com',
    },
    {
      'id': 'merchant_vercel',
      'name': 'Vercel',
      'description': 'Frontend cloud platform for deploying web applications',
      'imageUrl': 'https://logo.clearbit.com/vercel.com',
      'website': 'https://vercel.com',
    },

    // Software & SaaS
    {
      'id': 'merchant_github',
      'name': 'GitHub',
      'description':
          'Code hosting platform for version control and collaboration',
      'imageUrl': 'https://logo.clearbit.com/github.com',
      'website': 'https://github.com',
    },
    {
      'id': 'merchant_microsoft365',
      'name': 'Microsoft 365',
      'description': 'Productivity suite with Office apps and cloud storage',
      'imageUrl': 'https://logo.clearbit.com/microsoft.com',
      'website': 'https://www.microsoft.com',
    },
    {
      'id': 'merchant_adobe',
      'name': 'Adobe Creative Cloud',
      'description': 'Creative software suite for design and media editing',
      'imageUrl': 'https://logo.clearbit.com/adobe.com',
      'website': 'https://www.adobe.com',
    },
    {
      'id': 'merchant_dropbox',
      'name': 'Dropbox',
      'description': 'Cloud storage and file synchronization service',
      'imageUrl': 'https://logo.clearbit.com/dropbox.com',
      'website': 'https://www.dropbox.com',
    },
    {
      'id': 'merchant_zoom',
      'name': 'Zoom',
      'description': 'Video conferencing and online meeting platform',
      'imageUrl': 'https://logo.clearbit.com/zoom.us',
      'website': 'https://zoom.us',
    },
    {
      'id': 'merchant_slack',
      'name': 'Slack',
      'description': 'Team communication and collaboration platform',
      'imageUrl': 'https://logo.clearbit.com/slack.com',
      'website': 'https://slack.com',
    },
    {
      'id': 'merchant_notion',
      'name': 'Notion',
      'description':
          'All-in-one workspace for notes, docs, and project management',
      'imageUrl': 'https://logo.clearbit.com/notion.so',
      'website': 'https://www.notion.so',
    },
    {
      'id': 'merchant_trello',
      'name': 'Trello',
      'description': 'Visual project management tool with kanban boards',
      'imageUrl': 'https://logo.clearbit.com/trello.com',
      'website': 'https://trello.com',
    },
    {
      'id': 'merchant_asana',
      'name': 'Asana',
      'description': 'Work management platform for teams and projects',
      'imageUrl': 'https://logo.clearbit.com/asana.com',
      'website': 'https://asana.com',
    },

    // Food Delivery
    {
      'id': 'merchant_uber_eats',
      'name': 'Uber Eats',
      'description': 'Food delivery service from local restaurants',
      'imageUrl': 'https://logo.clearbit.com/ubereats.com',
      'website': 'https://www.ubereats.com',
    },
    {
      'id': 'merchant_doordash',
      'name': 'DoorDash',
      'description': 'On-demand food delivery and takeout service',
      'imageUrl': 'https://logo.clearbit.com/doordash.com',
      'website': 'https://www.doordash.com',
    },
    {
      'id': 'merchant_grubhub',
      'name': 'Grubhub',
      'description': 'Online food ordering and delivery platform',
      'imageUrl': 'https://logo.clearbit.com/grubhub.com',
      'website': 'https://www.grubhub.com',
    },
    {
      'id': 'merchant_postmates',
      'name': 'Postmates',
      'description': 'Delivery service for food, groceries, and essentials',
      'imageUrl': 'https://logo.clearbit.com/postmates.com',
      'website': 'https://postmates.com',
    },

    // Transportation
    {
      'id': 'merchant_uber',
      'name': 'Uber',
      'description': 'Ride-sharing and transportation network service',
      'imageUrl': 'https://logo.clearbit.com/uber.com',
      'website': 'https://www.uber.com',
    },
    {
      'id': 'merchant_lyft',
      'name': 'Lyft',
      'description': 'Ride-sharing platform for on-demand transportation',
      'imageUrl': 'https://logo.clearbit.com/lyft.com',
      'website': 'https://www.lyft.com',
    },

    // Utilities & Telecom
    {
      'id': 'merchant_att',
      'name': 'AT&T',
      'description': 'Telecommunications and wireless service provider',
      'imageUrl': 'https://logo.clearbit.com/att.com',
      'website': 'https://www.att.com',
    },
    {
      'id': 'merchant_verizon',
      'name': 'Verizon',
      'description': 'Wireless network and telecommunications company',
      'imageUrl': 'https://logo.clearbit.com/verizon.com',
      'website': 'https://www.verizon.com',
    },
    {
      'id': 'merchant_tmobile',
      'name': 'T-Mobile',
      'description': 'Mobile network operator and wireless service',
      'imageUrl': 'https://logo.clearbit.com/t-mobile.com',
      'website': 'https://www.t-mobile.com',
    },
    {
      'id': 'merchant_comcast',
      'name': 'Comcast Xfinity',
      'description': 'Cable TV, internet, and phone service provider',
      'imageUrl': 'https://logo.clearbit.com/xfinity.com',
      'website': 'https://www.xfinity.com',
    },
    {
      'id': 'merchant_spectrum',
      'name': 'Spectrum',
      'description': 'Cable and internet services provider',
      'imageUrl': 'https://logo.clearbit.com/spectrum.com',
      'website': 'https://www.spectrum.com',
    },

    // Fitness & Health
    {
      'id': 'merchant_planet_fitness',
      'name': 'Planet Fitness',
      'description': 'Gym and fitness center membership',
      'imageUrl': 'https://logo.clearbit.com/planetfitness.com',
      'website': 'https://www.planetfitness.com',
    },
    {
      'id': 'merchant_la_fitness',
      'name': 'LA Fitness',
      'description': 'Health club with fitness and wellness programs',
      'imageUrl': 'https://logo.clearbit.com/lafitness.com',
      'website': 'https://www.lafitness.com',
    },
    {
      'id': 'merchant_peloton',
      'name': 'Peloton',
      'description': 'Interactive fitness platform with connected equipment',
      'imageUrl': 'https://logo.clearbit.com/onepeloton.com',
      'website': 'https://www.onepeloton.com',
    },

    // Gaming
    {
      'id': 'merchant_steam',
      'name': 'Steam',
      'description': 'Digital distribution platform for PC games',
      'imageUrl': 'https://logo.clearbit.com/steampowered.com',
      'website': 'https://store.steampowered.com',
    },
    {
      'id': 'merchant_playstation',
      'name': 'PlayStation Network',
      'description': 'Gaming network for PlayStation console users',
      'imageUrl': 'https://logo.clearbit.com/playstation.com',
      'website': 'https://www.playstation.com',
    },
    {
      'id': 'merchant_xbox',
      'name': 'Xbox Live',
      'description': 'Online gaming service for Xbox consoles',
      'imageUrl': 'https://logo.clearbit.com/xbox.com',
      'website': 'https://www.xbox.com',
    },
    {
      'id': 'merchant_nintendo',
      'name': 'Nintendo eShop',
      'description': 'Digital storefront for Nintendo games and content',
      'imageUrl': 'https://logo.clearbit.com/nintendo.com',
      'website': 'https://www.nintendo.com',
    },

    // Insurance
    {
      'id': 'merchant_geico',
      'name': 'GEICO',
      'description': 'Auto insurance and related coverage services',
      'imageUrl': 'https://logo.clearbit.com/geico.com',
      'website': 'https://www.geico.com',
    },
    {
      'id': 'merchant_progressive',
      'name': 'Progressive',
      'description': 'Insurance company for auto, home, and more',
      'imageUrl': 'https://logo.clearbit.com/progressive.com',
      'website': 'https://www.progressive.com',
    },
    {
      'id': 'merchant_state_farm',
      'name': 'State Farm',
      'description': 'Insurance and financial services provider',
      'imageUrl': 'https://logo.clearbit.com/statefarm.com',
      'website': 'https://www.statefarm.com',
    },

    // Payment Services
    {
      'id': 'merchant_paypal',
      'name': 'PayPal',
      'description': 'Online payment processing and money transfer service',
      'imageUrl': 'https://logo.clearbit.com/paypal.com',
      'website': 'https://www.paypal.com',
    },
    {
      'id': 'merchant_venmo',
      'name': 'Venmo',
      'description': 'Mobile payment service for peer-to-peer transfers',
      'imageUrl': 'https://logo.clearbit.com/venmo.com',
      'website': 'https://venmo.com',
    },
    {
      'id': 'merchant_cashapp',
      'name': 'Cash App',
      'description': 'Mobile payment app for sending and receiving money',
      'imageUrl': 'https://logo.clearbit.com/cash.app',
      'website': 'https://cash.app',
    },
    {
      'id': 'merchant_stripe',
      'name': 'Stripe',
      'description': 'Online payment processing for internet businesses',
      'imageUrl': 'https://logo.clearbit.com/stripe.com',
      'website': 'https://stripe.com',
    },

    // Fast Food
    {
      'id': 'merchant_mcdonalds',
      'name': "McDonald's",
      'description': 'Fast food restaurant chain for burgers and fries',
      'imageUrl': 'https://logo.clearbit.com/mcdonalds.com',
      'website': 'https://www.mcdonalds.com',
    },
    {
      'id': 'merchant_starbucks',
      'name': 'Starbucks',
      'description': 'Coffee shop chain and beverage retailer',
      'imageUrl': 'https://logo.clearbit.com/starbucks.com',
      'website': 'https://www.starbucks.com',
    },
    {
      'id': 'merchant_subway',
      'name': 'Subway',
      'description': 'Sandwich restaurant and fast food chain',
      'imageUrl': 'https://logo.clearbit.com/subway.com',
      'website': 'https://www.subway.com',
    },
    {
      'id': 'merchant_chipotle',
      'name': 'Chipotle',
      'description': 'Fast-casual Mexican food restaurant',
      'imageUrl': 'https://logo.clearbit.com/chipotle.com',
      'website': 'https://www.chipotle.com',
    },
    {
      'id': 'merchant_wendys',
      'name': "Wendy's",
      'description': 'Fast food restaurant specializing in burgers',
      'imageUrl': 'https://logo.clearbit.com/wendys.com',
      'website': 'https://www.wendys.com',
    },

    // Hotels & Travel
    {
      'id': 'merchant_airbnb',
      'name': 'Airbnb',
      'description': 'Vacation rental and lodging marketplace',
      'imageUrl': 'https://logo.clearbit.com/airbnb.com',
      'website': 'https://www.airbnb.com',
    },
    {
      'id': 'merchant_booking',
      'name': 'Booking.com',
      'description': 'Hotel and accommodation booking platform',
      'imageUrl': 'https://logo.clearbit.com/booking.com',
      'website': 'https://www.booking.com',
    },
    {
      'id': 'merchant_expedia',
      'name': 'Expedia',
      'description': 'Travel booking site for flights, hotels, and packages',
      'imageUrl': 'https://logo.clearbit.com/expedia.com',
      'website': 'https://www.expedia.com',
    },
    {
      'id': 'merchant_hotels_com',
      'name': 'Hotels.com',
      'description': 'Hotel reservation and booking service',
      'imageUrl': 'https://logo.clearbit.com/hotels.com',
      'website': 'https://www.hotels.com',
    },

    // Education
    {
      'id': 'merchant_coursera',
      'name': 'Coursera',
      'description': 'Online learning platform for courses and degrees',
      'imageUrl': 'https://logo.clearbit.com/coursera.org',
      'website': 'https://www.coursera.org',
    },
    {
      'id': 'merchant_udemy',
      'name': 'Udemy',
      'description': 'Marketplace for online courses and skill development',
      'imageUrl': 'https://logo.clearbit.com/udemy.com',
      'website': 'https://www.udemy.com',
    },
    {
      'id': 'merchant_linkedin_learning',
      'name': 'LinkedIn Learning',
      'description': 'Professional development and online training platform',
      'imageUrl': 'https://logo.clearbit.com/linkedin.com',
      'website': 'https://www.linkedin.com/learning',
    },
    {
      'id': 'merchant_skillshare',
      'name': 'Skillshare',
      'description': 'Online learning community for creative skills',
      'imageUrl': 'https://logo.clearbit.com/skillshare.com',
      'website': 'https://www.skillshare.com',
    },

    // News & Media
    {
      'id': 'merchant_nyt',
      'name': 'The New York Times',
      'description': 'Digital and print newspaper subscription',
      'imageUrl': 'https://logo.clearbit.com/nytimes.com',
      'website': 'https://www.nytimes.com',
    },
    {
      'id': 'merchant_wsj',
      'name': 'The Wall Street Journal',
      'description': 'Business and financial news publication',
      'imageUrl': 'https://logo.clearbit.com/wsj.com',
      'website': 'https://www.wsj.com',
    },
    {
      'id': 'merchant_wapo',
      'name': 'The Washington Post',
      'description': 'News and journalism publication',
      'imageUrl': 'https://logo.clearbit.com/washingtonpost.com',
      'website': 'https://www.washingtonpost.com',
    },
  ];

  /// Seeds default merchants into the database
  /// Only seeds if no merchants exist yet
  static Future<void> seedDefaultMerchants(AppDatabase database) async {
    // Check if merchants already exist
    final existingMerchants = await database.select(database.merchants).get();
    if (existingMerchants.isNotEmpty) {
      return; // Already seeded
    }

    // Insert all default merchants
    for (final merchant in merchants) {
      await database
          .into(database.merchants)
          .insert(
            MerchantsCompanion(
              id: Value(merchant['id'] as String),
              tempId: Value(merchant['id'] as String),
              name: Value(merchant['name'] as String),
              website: Value(merchant['website'] as String),
              description: Value(merchant['description'] as String),
              imageUrl: Value(merchant['imageUrl'] as String?),
              isSynced: const Value(false),
            ),
          );
    }
  }
}
