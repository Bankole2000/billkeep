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
      'imageUrl':
          'https://img.logokit.com/netflix.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.netflix.com',
    },
    {
      'id': 'merchant_spotify',
      'name': 'Spotify',
      'description':
          'Music streaming service with millions of songs and podcasts',
      'imageUrl':
          'https://img.logokit.com/spotify.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.spotify.com',
    },
    {
      'id': 'merchant_disney_plus',
      'name': 'Disney+',
      'description':
          'Streaming service for Disney, Pixar, Marvel, Star Wars content',
      'imageUrl':
          'https://img.logokit.com/disneyplus.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.disneyplus.com',
    },
    {
      'id': 'merchant_hulu',
      'name': 'Hulu',
      'description': 'Streaming platform for TV shows, movies, and live TV',
      'imageUrl':
          'https://img.logokit.com/hulu.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.hulu.com',
    },
    {
      'id': 'merchant_amazon_prime',
      'name': 'Amazon Prime Video',
      'description':
          'Video streaming service with Amazon original shows and movies',
      'imageUrl':
          'https://img.logokit.com/primevideo.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.primevideo.com',
    },
    {
      'id': 'merchant_apple_tv',
      'name': 'Apple TV+',
      'description': 'Apple streaming service with original shows and movies',
      'imageUrl':
          'https://img.logokit.com/apple.com?token=pk_frbb016699d97004807432',
      'website': 'https://tv.apple.com',
    },
    {
      'id': 'merchant_hbo_max',
      'name': 'HBO Max',
      'description':
          'Premium streaming service with HBO and Warner Bros. content',
      'imageUrl':
          'https://img.logokit.com/hbomax.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.hbomax.com',
    },
    {
      'id': 'merchant_youtube_premium',
      'name': 'YouTube Premium',
      'description': 'Ad-free YouTube with background play and YouTube Music',
      'imageUrl':
          'https://img.logokit.com/youtube.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.youtube.com/premium',
    },

    // E-commerce & Retail
    {
      'id': 'merchant_amazon',
      'name': 'Amazon',
      'description': 'Online marketplace for products, groceries, and services',
      'imageUrl':
          'https://img.logokit.com/amazon.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.amazon.com',
    },
    {
      'id': 'merchant_walmart',
      'name': 'Walmart',
      'description':
          'Retail chain offering groceries, electronics, and home goods',
      'imageUrl':
          'https://img.logokit.com/walmart.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.walmart.com',
    },
    {
      'id': 'merchant_target',
      'name': 'Target',
      'description':
          'Department store for clothing, home essentials, and groceries',
      'imageUrl':
          'https://img.logokit.com/target.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.target.com',
    },
    {
      'id': 'merchant_ebay',
      'name': 'eBay',
      'description': 'Online auction and shopping marketplace',
      'imageUrl':
          'https://img.logokit.com/ebay.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.ebay.com',
    },
    {
      'id': 'merchant_etsy',
      'name': 'Etsy',
      'description': 'Marketplace for handmade, vintage, and unique items',
      'imageUrl':
          'https://img.logokit.com/etsy.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.etsy.com',
    },
    {
      'id': 'merchant_bestbuy',
      'name': 'Best Buy',
      'description':
          'Electronics retailer for computers, phones, and appliances',
      'imageUrl':
          'https://img.logokit.com/bestbuy.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.bestbuy.com',
    },

    // Cloud & Tech Services
    {
      'id': 'merchant_aws',
      'name': 'Amazon Web Services',
      'description': 'Cloud computing platform and infrastructure services',
      'imageUrl':
          'https://img.logokit.com/aws.amazon.com?token=pk_frbb016699d97004807432',
      'website': 'https://aws.amazon.com',
    },
    {
      'id': 'merchant_google_cloud',
      'name': 'Google Cloud',
      'description': 'Cloud computing and infrastructure services by Google',
      'imageUrl':
          'https://img.logokit.com/cloud.google.com?token=pk_frbb016699d97004807432',
      'website': 'https://cloud.google.com',
    },
    {
      'id': 'merchant_microsoft_azure',
      'name': 'Microsoft Azure',
      'description': 'Microsoft cloud platform for computing and storage',
      'imageUrl':
          'https://img.logokit.com/azure.microsoft.com?token=pk_frbb016699d97004807432',
      'website': 'https://azure.microsoft.com',
    },
    {
      'id': 'merchant_digitalocean',
      'name': 'DigitalOcean',
      'description': 'Cloud infrastructure provider for developers',
      'imageUrl':
          'https://img.logokit.com/digitalocean.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.digitalocean.com',
    },
    {
      'id': 'merchant_heroku',
      'name': 'Heroku',
      'description': 'Platform-as-a-service for app deployment and hosting',
      'imageUrl':
          'https://img.logokit.com/heroku.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.heroku.com',
    },
    {
      'id': 'merchant_vercel',
      'name': 'Vercel',
      'description': 'Frontend cloud platform for deploying web applications',
      'imageUrl':
          'https://img.logokit.com/vercel.com?token=pk_frbb016699d97004807432',
      'website': 'https://vercel.com',
    },

    // Software & SaaS
    {
      'id': 'merchant_github',
      'name': 'GitHub',
      'description':
          'Code hosting platform for version control and collaboration',
      'imageUrl':
          'https://img.logokit.com/github.com?token=pk_frbb016699d97004807432',
      'website': 'https://github.com',
    },
    {
      'id': 'merchant_microsoft365',
      'name': 'Microsoft 365',
      'description': 'Productivity suite with Office apps and cloud storage',
      'imageUrl':
          'https://img.logokit.com/microsoft.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.microsoft.com',
    },
    {
      'id': 'merchant_adobe',
      'name': 'Adobe Creative Cloud',
      'description': 'Creative software suite for design and media editing',
      'imageUrl':
          'https://img.logokit.com/adobe.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.adobe.com',
    },
    {
      'id': 'merchant_dropbox',
      'name': 'Dropbox',
      'description': 'Cloud storage and file synchronization service',
      'imageUrl':
          'https://img.logokit.com/dropbox.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.dropbox.com',
    },
    {
      'id': 'merchant_zoom',
      'name': 'Zoom',
      'description': 'Video conferencing and online meeting platform',
      'imageUrl':
          'https://img.logokit.com/zoom.us?token=pk_frbb016699d97004807432',
      'website': 'https://zoom.us',
    },
    {
      'id': 'merchant_slack',
      'name': 'Slack',
      'description': 'Team communication and collaboration platform',
      'imageUrl':
          'https://img.logokit.com/slack.com?token=pk_frbb016699d97004807432',
      'website': 'https://slack.com',
    },
    {
      'id': 'merchant_notion',
      'name': 'Notion',
      'description':
          'All-in-one workspace for notes, docs, and project management',
      'imageUrl':
          'https://img.logokit.com/notion.so?token=pk_frbb016699d97004807432',
      'website': 'https://www.notion.so',
    },
    {
      'id': 'merchant_trello',
      'name': 'Trello',
      'description': 'Visual project management tool with kanban boards',
      'imageUrl':
          'https://img.logokit.com/trello.com?token=pk_frbb016699d97004807432',
      'website': 'https://trello.com',
    },
    {
      'id': 'merchant_asana',
      'name': 'Asana',
      'description': 'Work management platform for teams and projects',
      'imageUrl':
          'https://img.logokit.com/asana.com?token=pk_frbb016699d97004807432',
      'website': 'https://asana.com',
    },

    // Food Delivery
    {
      'id': 'merchant_uber_eats',
      'name': 'Uber Eats',
      'description': 'Food delivery service from local restaurants',
      'imageUrl':
          'https://img.logokit.com/ubereats.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.ubereats.com',
    },
    {
      'id': 'merchant_doordash',
      'name': 'DoorDash',
      'description': 'On-demand food delivery and takeout service',
      'imageUrl':
          'https://img.logokit.com/doordash.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.doordash.com',
    },
    {
      'id': 'merchant_grubhub',
      'name': 'Grubhub',
      'description': 'Online food ordering and delivery platform',
      'imageUrl':
          'https://img.logokit.com/grubhub.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.grubhub.com',
    },
    {
      'id': 'merchant_postmates',
      'name': 'Postmates',
      'description': 'Delivery service for food, groceries, and essentials',
      'imageUrl':
          'https://img.logokit.com/postmates.com?token=pk_frbb016699d97004807432',
      'website': 'https://postmates.com',
    },

    // Transportation
    {
      'id': 'merchant_uber',
      'name': 'Uber',
      'description': 'Ride-sharing and transportation network service',
      'imageUrl':
          'https://img.logokit.com/uber.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.uber.com',
    },
    {
      'id': 'merchant_lyft',
      'name': 'Lyft',
      'description': 'Ride-sharing platform for on-demand transportation',
      'imageUrl':
          'https://img.logokit.com/lyft.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.lyft.com',
    },

    // Utilities & Telecom
    {
      'id': 'merchant_att',
      'name': 'AT&T',
      'description': 'Telecommunications and wireless service provider',
      'imageUrl':
          'https://img.logokit.com/att.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.att.com',
    },
    {
      'id': 'merchant_verizon',
      'name': 'Verizon',
      'description': 'Wireless network and telecommunications company',
      'imageUrl':
          'https://img.logokit.com/verizon.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.verizon.com',
    },
    {
      'id': 'merchant_tmobile',
      'name': 'T-Mobile',
      'description': 'Mobile network operator and wireless service',
      'imageUrl':
          'https://img.logokit.com/t-mobile.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.t-mobile.com',
    },
    {
      'id': 'merchant_comcast',
      'name': 'Comcast Xfinity',
      'description': 'Cable TV, internet, and phone service provider',
      'imageUrl':
          'https://img.logokit.com/xfinity.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.xfinity.com',
    },
    {
      'id': 'merchant_spectrum',
      'name': 'Spectrum',
      'description': 'Cable and internet services provider',
      'imageUrl':
          'https://img.logokit.com/spectrum.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.spectrum.com',
    },

    // Fitness & Health
    {
      'id': 'merchant_planet_fitness',
      'name': 'Planet Fitness',
      'description': 'Gym and fitness center membership',
      'imageUrl':
          'https://img.logokit.com/planetfitness.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.planetfitness.com',
    },
    {
      'id': 'merchant_la_fitness',
      'name': 'LA Fitness',
      'description': 'Health club with fitness and wellness programs',
      'imageUrl':
          'https://img.logokit.com/lafitness.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.lafitness.com',
    },
    {
      'id': 'merchant_peloton',
      'name': 'Peloton',
      'description': 'Interactive fitness platform with connected equipment',
      'imageUrl':
          'https://img.logokit.com/onepeloton.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.onepeloton.com',
    },

    // Gaming
    {
      'id': 'merchant_steam',
      'name': 'Steam',
      'description': 'Digital distribution platform for PC games',
      'imageUrl':
          'https://img.logokit.com/steampowered.com?token=pk_frbb016699d97004807432',
      'website': 'https://store.steampowered.com',
    },
    {
      'id': 'merchant_playstation',
      'name': 'PlayStation Network',
      'description': 'Gaming network for PlayStation console users',
      'imageUrl':
          'https://img.logokit.com/playstation.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.playstation.com',
    },
    {
      'id': 'merchant_xbox',
      'name': 'Xbox Live',
      'description': 'Online gaming service for Xbox consoles',
      'imageUrl':
          'https://img.logokit.com/xbox.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.xbox.com',
    },
    {
      'id': 'merchant_nintendo',
      'name': 'Nintendo eShop',
      'description': 'Digital storefront for Nintendo games and content',
      'imageUrl':
          'https://img.logokit.com/nintendo.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.nintendo.com',
    },

    // Insurance
    {
      'id': 'merchant_geico',
      'name': 'GEICO',
      'description': 'Auto insurance and related coverage services',
      'imageUrl':
          'https://img.logokit.com/geico.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.geico.com',
    },
    {
      'id': 'merchant_progressive',
      'name': 'Progressive',
      'description': 'Insurance company for auto, home, and more',
      'imageUrl':
          'https://img.logokit.com/progressive.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.progressive.com',
    },
    {
      'id': 'merchant_state_farm',
      'name': 'State Farm',
      'description': 'Insurance and financial services provider',
      'imageUrl':
          'https://img.logokit.com/statefarm.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.statefarm.com',
    },

    // Payment Services
    {
      'id': 'merchant_paypal',
      'name': 'PayPal',
      'description': 'Online payment processing and money transfer service',
      'imageUrl':
          'https://img.logokit.com/paypal.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.paypal.com',
    },
    {
      'id': 'merchant_venmo',
      'name': 'Venmo',
      'description': 'Mobile payment service for peer-to-peer transfers',
      'imageUrl':
          'https://img.logokit.com/venmo.com?token=pk_frbb016699d97004807432',
      'website': 'https://venmo.com',
    },
    {
      'id': 'merchant_cashapp',
      'name': 'Cash App',
      'description': 'Mobile payment app for sending and receiving money',
      'imageUrl':
          'https://img.logokit.com/cash.app?token=pk_frbb016699d97004807432',
      'website': 'https://cash.app',
    },
    {
      'id': 'merchant_stripe',
      'name': 'Stripe',
      'description': 'Online payment processing for internet businesses',
      'imageUrl':
          'https://img.logokit.com/stripe.com?token=pk_frbb016699d97004807432',
      'website': 'https://stripe.com',
    },

    // Fast Food
    {
      'id': 'merchant_mcdonalds',
      'name': "McDonald's",
      'description': 'Fast food restaurant chain for burgers and fries',
      'imageUrl':
          'https://img.logokit.com/mcdonalds.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.mcdonalds.com',
    },
    {
      'id': 'merchant_starbucks',
      'name': 'Starbucks',
      'description': 'Coffee shop chain and beverage retailer',
      'imageUrl':
          'https://img.logokit.com/starbucks.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.starbucks.com',
    },
    {
      'id': 'merchant_subway',
      'name': 'Subway',
      'description': 'Sandwich restaurant and fast food chain',
      'imageUrl':
          'https://img.logokit.com/subway.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.subway.com',
    },
    {
      'id': 'merchant_chipotle',
      'name': 'Chipotle',
      'description': 'Fast-casual Mexican food restaurant',
      'imageUrl':
          'https://img.logokit.com/chipotle.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.chipotle.com',
    },
    {
      'id': 'merchant_wendys',
      'name': "Wendy's",
      'description': 'Fast food restaurant specializing in burgers',
      'imageUrl':
          'https://img.logokit.com/wendys.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.wendys.com',
    },

    // Hotels & Travel
    {
      'id': 'merchant_airbnb',
      'name': 'Airbnb',
      'description': 'Vacation rental and lodging marketplace',
      'imageUrl':
          'https://img.logokit.com/airbnb.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.airbnb.com',
    },
    {
      'id': 'merchant_booking',
      'name': 'Booking.com',
      'description': 'Hotel and accommodation booking platform',
      'imageUrl':
          'https://img.logokit.com/booking.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.booking.com',
    },
    {
      'id': 'merchant_expedia',
      'name': 'Expedia',
      'description': 'Travel booking site for flights, hotels, and packages',
      'imageUrl':
          'https://img.logokit.com/expedia.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.expedia.com',
    },
    {
      'id': 'merchant_hotels_com',
      'name': 'Hotels.com',
      'description': 'Hotel reservation and booking service',
      'imageUrl':
          'https://img.logokit.com/hotels.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.hotels.com',
    },

    // Education
    {
      'id': 'merchant_coursera',
      'name': 'Coursera',
      'description': 'Online learning platform for courses and degrees',
      'imageUrl':
          'https://img.logokit.com/coursera.org?token=pk_frbb016699d97004807432',
      'website': 'https://www.coursera.org',
    },
    {
      'id': 'merchant_udemy',
      'name': 'Udemy',
      'description': 'Marketplace for online courses and skill development',
      'imageUrl':
          'https://img.logokit.com/udemy.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.udemy.com',
    },
    {
      'id': 'merchant_linkedin_learning',
      'name': 'LinkedIn Learning',
      'description': 'Professional development and online training platform',
      'imageUrl':
          'https://img.logokit.com/linkedin.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.linkedin.com/learning',
    },
    {
      'id': 'merchant_skillshare',
      'name': 'Skillshare',
      'description': 'Online learning community for creative skills',
      'imageUrl':
          'https://img.logokit.com/skillshare.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.skillshare.com',
    },

    // News & Media
    {
      'id': 'merchant_nyt',
      'name': 'The New York Times',
      'description': 'Digital and print newspaper subscription',
      'imageUrl':
          'https://img.logokit.com/nytimes.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.nytimes.com',
    },
    {
      'id': 'merchant_wsj',
      'name': 'The Wall Street Journal',
      'description': 'Business and financial news publication',
      'imageUrl':
          'https://img.logokit.com/wsj.com?token=pk_frbb016699d97004807432',
      'website': 'https://www.wsj.com',
    },
    {
      'id': 'merchant_wapo',
      'name': 'The Washington Post',
      'description': 'News and journalism publication',
      'imageUrl':
          'https://img.logokit.com/washingtonpost.com?token=pk_frbb016699d97004807432',
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
