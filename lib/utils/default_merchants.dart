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
          'https://img.logo.dev/netflix.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.netflix.com',
    },
    {
      'id': 'merchant_spotify',
      'name': 'Spotify',
      'description':
          'Music streaming service with millions of songs and podcasts',
      'imageUrl':
          'https://img.logo.dev/spotify.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.spotify.com',
    },
    {
      'id': 'merchant_disney_plus',
      'name': 'Disney+',
      'description':
          'Streaming service for Disney, Pixar, Marvel, Star Wars content',
      'imageUrl':
          'https://img.logo.dev/disneyplus.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.disneyplus.com',
    },
    {
      'id': 'merchant_hulu',
      'name': 'Hulu',
      'description': 'Streaming platform for TV shows, movies, and live TV',
      'imageUrl':
          'https://img.logo.dev/hulu.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.hulu.com',
    },
    {
      'id': 'merchant_amazon_prime',
      'name': 'Amazon Prime Video',
      'description':
          'Video streaming service with Amazon original shows and movies',
      'imageUrl':
          'https://img.logo.dev/primevideo.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.primevideo.com',
    },
    {
      'id': 'merchant_apple_tv',
      'name': 'Apple TV+',
      'description': 'Apple streaming service with original shows and movies',
      'imageUrl':
          'https://img.logo.dev/apple.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://tv.apple.com',
    },
    {
      'id': 'merchant_hbo_max',
      'name': 'HBO Max',
      'description':
          'Premium streaming service with HBO and Warner Bros. content',
      'imageUrl':
          'https://img.logo.dev/hbomax.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.hbomax.com',
    },
    {
      'id': 'merchant_youtube_premium',
      'name': 'YouTube Premium',
      'description': 'Ad-free YouTube with background play and YouTube Music',
      'imageUrl':
          'https://img.logo.dev/youtube.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.youtube.com/premium',
    },

    // E-commerce & Retail
    {
      'id': 'merchant_amazon',
      'name': 'Amazon',
      'description': 'Online marketplace for products, groceries, and services',
      'imageUrl':
          'https://img.logo.dev/amazon.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.amazon.com',
    },
    {
      'id': 'merchant_walmart',
      'name': 'Walmart',
      'description':
          'Retail chain offering groceries, electronics, and home goods',
      'imageUrl':
          'https://img.logo.dev/walmart.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.walmart.com',
    },
    {
      'id': 'merchant_target',
      'name': 'Target',
      'description':
          'Department store for clothing, home essentials, and groceries',
      'imageUrl':
          'https://img.logo.dev/target.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.target.com',
    },
    {
      'id': 'merchant_ebay',
      'name': 'eBay',
      'description': 'Online auction and shopping marketplace',
      'imageUrl':
          'https://img.logo.dev/ebay.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.ebay.com',
    },
    {
      'id': 'merchant_etsy',
      'name': 'Etsy',
      'description': 'Marketplace for handmade, vintage, and unique items',
      'imageUrl':
          'https://img.logo.dev/etsy.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.etsy.com',
    },
    {
      'id': 'merchant_bestbuy',
      'name': 'Best Buy',
      'description':
          'Electronics retailer for computers, phones, and appliances',
      'imageUrl':
          'https://img.logo.dev/bestbuy.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.bestbuy.com',
    },

    // Cloud & Tech Services
    {
      'id': 'merchant_aws',
      'name': 'Amazon Web Services',
      'description': 'Cloud computing platform and infrastructure services',
      'imageUrl':
          'https://img.logo.dev/aws.amazon.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://aws.amazon.com',
    },
    {
      'id': 'merchant_google_cloud',
      'name': 'Google Cloud',
      'description': 'Cloud computing and infrastructure services by Google',
      'imageUrl':
          'https://img.logo.dev/cloud.google.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://cloud.google.com',
    },
    {
      'id': 'merchant_microsoft_azure',
      'name': 'Microsoft Azure',
      'description': 'Microsoft cloud platform for computing and storage',
      'imageUrl':
          'https://img.logo.dev/azure.microsoft.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://azure.microsoft.com',
    },
    {
      'id': 'merchant_digitalocean',
      'name': 'DigitalOcean',
      'description': 'Cloud infrastructure provider for developers',
      'imageUrl':
          'https://img.logo.dev/digitalocean.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.digitalocean.com',
    },
    {
      'id': 'merchant_heroku',
      'name': 'Heroku',
      'description': 'Platform-as-a-service for app deployment and hosting',
      'imageUrl':
          'https://img.logo.dev/heroku.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.heroku.com',
    },
    {
      'id': 'merchant_vercel',
      'name': 'Vercel',
      'description': 'Frontend cloud platform for deploying web applications',
      'imageUrl':
          'https://img.logo.dev/vercel.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://vercel.com',
    },

    // Software & SaaS
    {
      'id': 'merchant_github',
      'name': 'GitHub',
      'description':
          'Code hosting platform for version control and collaboration',
      'imageUrl':
          'https://img.logo.dev/github.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://github.com',
    },
    {
      'id': 'merchant_microsoft365',
      'name': 'Microsoft 365',
      'description': 'Productivity suite with Office apps and cloud storage',
      'imageUrl':
          'https://img.logo.dev/microsoft.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.microsoft.com',
    },
    {
      'id': 'merchant_adobe',
      'name': 'Adobe Creative Cloud',
      'description': 'Creative software suite for design and media editing',
      'imageUrl':
          'https://img.logo.dev/adobe.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.adobe.com',
    },
    {
      'id': 'merchant_dropbox',
      'name': 'Dropbox',
      'description': 'Cloud storage and file synchronization service',
      'imageUrl':
          'https://img.logo.dev/dropbox.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.dropbox.com',
    },
    {
      'id': 'merchant_zoom',
      'name': 'Zoom',
      'description': 'Video conferencing and online meeting platform',
      'imageUrl':
          'https://img.logo.dev/zoom.us?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://zoom.us',
    },
    {
      'id': 'merchant_slack',
      'name': 'Slack',
      'description': 'Team communication and collaboration platform',
      'imageUrl':
          'https://img.logo.dev/slack.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://slack.com',
    },
    {
      'id': 'merchant_notion',
      'name': 'Notion',
      'description':
          'All-in-one workspace for notes, docs, and project management',
      'imageUrl':
          'https://img.logo.dev/notion.so?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.notion.so',
    },
    {
      'id': 'merchant_trello',
      'name': 'Trello',
      'description': 'Visual project management tool with kanban boards',
      'imageUrl':
          'https://img.logo.dev/trello.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://trello.com',
    },
    {
      'id': 'merchant_asana',
      'name': 'Asana',
      'description': 'Work management platform for teams and projects',
      'imageUrl':
          'https://img.logo.dev/asana.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://asana.com',
    },

    // Food Delivery
    {
      'id': 'merchant_uber_eats',
      'name': 'Uber Eats',
      'description': 'Food delivery service from local restaurants',
      'imageUrl':
          'https://img.logo.dev/ubereats.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.ubereats.com',
    },
    {
      'id': 'merchant_doordash',
      'name': 'DoorDash',
      'description': 'On-demand food delivery and takeout service',
      'imageUrl':
          'https://img.logo.dev/doordash.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.doordash.com',
    },
    {
      'id': 'merchant_grubhub',
      'name': 'Grubhub',
      'description': 'Online food ordering and delivery platform',
      'imageUrl':
          'https://img.logo.dev/grubhub.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.grubhub.com',
    },
    {
      'id': 'merchant_postmates',
      'name': 'Postmates',
      'description': 'Delivery service for food, groceries, and essentials',
      'imageUrl':
          'https://img.logo.dev/postmates.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://postmates.com',
    },

    // Transportation
    {
      'id': 'merchant_uber',
      'name': 'Uber',
      'description': 'Ride-sharing and transportation network service',
      'imageUrl':
          'https://img.logo.dev/uber.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.uber.com',
    },
    {
      'id': 'merchant_lyft',
      'name': 'Lyft',
      'description': 'Ride-sharing platform for on-demand transportation',
      'imageUrl':
          'https://img.logo.dev/lyft.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.lyft.com',
    },

    // Utilities & Telecom
    {
      'id': 'merchant_att',
      'name': 'AT&T',
      'description': 'Telecommunications and wireless service provider',
      'imageUrl':
          'https://img.logo.dev/att.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.att.com',
    },
    {
      'id': 'merchant_verizon',
      'name': 'Verizon',
      'description': 'Wireless network and telecommunications company',
      'imageUrl':
          'https://img.logo.dev/verizon.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.verizon.com',
    },
    {
      'id': 'merchant_comcast',
      'name': 'Comcast Xfinity',
      'description': 'Cable TV, internet, and phone service provider',
      'imageUrl':
          'https://img.logo.dev/xfinity.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.xfinity.com',
    },
    {
      'id': 'merchant_spectrum',
      'name': 'Spectrum',
      'description': 'Cable and internet services provider',
      'imageUrl':
          'https://img.logo.dev/spectrum.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.spectrum.com',
    },

    // Fitness & Health
    {
      'id': 'merchant_planet_fitness',
      'name': 'Planet Fitness',
      'description': 'Gym and fitness center membership',
      'imageUrl':
          'https://img.logo.dev/planetfitness.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.planetfitness.com',
    },
    {
      'id': 'merchant_la_fitness',
      'name': 'LA Fitness',
      'description': 'Health club with fitness and wellness programs',
      'imageUrl':
          'https://img.logo.dev/lafitness.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.lafitness.com',
    },
    {
      'id': 'merchant_peloton',
      'name': 'Peloton',
      'description': 'Interactive fitness platform with connected equipment',
      'imageUrl':
          'https://img.logo.dev/onepeloton.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.onepeloton.com',
    },

    // Gaming
    {
      'id': 'merchant_steam',
      'name': 'Steam',
      'description': 'Digital distribution platform for PC games',
      'imageUrl':
          'https://img.logo.dev/steampowered.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://store.steampowered.com',
    },
    {
      'id': 'merchant_playstation',
      'name': 'PlayStation Network',
      'description': 'Gaming network for PlayStation console users',
      'imageUrl':
          'https://img.logo.dev/playstation.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.playstation.com',
    },
    {
      'id': 'merchant_xbox',
      'name': 'Xbox Live',
      'description': 'Online gaming service for Xbox consoles',
      'imageUrl':
          'https://img.logo.dev/xbox.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.xbox.com',
    },
    {
      'id': 'merchant_nintendo',
      'name': 'Nintendo eShop',
      'description': 'Digital storefront for Nintendo games and content',
      'imageUrl':
          'https://img.logo.dev/nintendo.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.nintendo.com',
    },

    // Insurance
    {
      'id': 'merchant_geico',
      'name': 'GEICO',
      'description': 'Auto insurance and related coverage services',
      'imageUrl':
          'https://img.logo.dev/geico.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.geico.com',
    },
    {
      'id': 'merchant_progressive',
      'name': 'Progressive',
      'description': 'Insurance company for auto, home, and more',
      'imageUrl':
          'https://img.logo.dev/progressive.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.progressive.com',
    },
    {
      'id': 'merchant_state_farm',
      'name': 'State Farm',
      'description': 'Insurance and financial services provider',
      'imageUrl':
          'https://img.logo.dev/statefarm.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.statefarm.com',
    },

    // Payment Services
    {
      'id': 'merchant_paypal',
      'name': 'PayPal',
      'description': 'Online payment processing and money transfer service',
      'imageUrl':
          'https://img.logo.dev/paypal.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.paypal.com',
    },
    {
      'id': 'merchant_venmo',
      'name': 'Venmo',
      'description': 'Mobile payment service for peer-to-peer transfers',
      'imageUrl':
          'https://img.logo.dev/venmo.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://venmo.com',
    },
    {
      'id': 'merchant_cashapp',
      'name': 'Cash App',
      'description': 'Mobile payment app for sending and receiving money',
      'imageUrl':
          'https://img.logo.dev/cash.app?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://cash.app',
    },
    {
      'id': 'merchant_stripe',
      'name': 'Stripe',
      'description': 'Online payment processing for internet businesses',
      'imageUrl':
          'https://img.logo.dev/stripe.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://stripe.com',
    },

    // Fast Food
    {
      'id': 'merchant_mcdonalds',
      'name': 'McDonald\'s',
      'description': 'Fast food restaurant chain for burgers and fries',
      'imageUrl':
          'https://img.logo.dev/mcdonalds.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.mcdonalds.com',
    },
    {
      'id': 'merchant_starbucks',
      'name': 'Starbucks',
      'description': 'Coffee shop chain and beverage retailer',
      'imageUrl':
          'https://img.logo.dev/starbucks.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.starbucks.com',
    },
    {
      'id': 'merchant_subway',
      'name': 'Subway',
      'description': 'Sandwich restaurant and fast food chain',
      'imageUrl':
          'https://img.logo.dev/subway.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.subway.com',
    },
    {
      'id': 'merchant_chipotle',
      'name': 'Chipotle',
      'description': 'Fast-casual Mexican food restaurant',
      'imageUrl':
          'https://img.logo.dev/chipotle.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.chipotle.com',
    },
    {
      'id': 'merchant_wendys',
      'name': 'Wendy\'s',
      'description': 'Fast food restaurant specializing in burgers',
      'imageUrl':
          'https://img.logo.dev/wendys.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.wendys.com',
    },

    // Hotels & Travel
    {
      'id': 'merchant_airbnb',
      'name': 'Airbnb',
      'description': 'Vacation rental and lodging marketplace',
      'imageUrl':
          'https://img.logo.dev/airbnb.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.airbnb.com',
    },
    {
      'id': 'merchant_booking',
      'name': 'Booking.com',
      'description': 'Hotel and accommodation booking platform',
      'imageUrl':
          'https://img.logo.dev/booking.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.booking.com',
    },
    {
      'id': 'merchant_expedia',
      'name': 'Expedia',
      'description': 'Travel booking site for flights, hotels, and packages',
      'imageUrl':
          'https://img.logo.dev/expedia.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.expedia.com',
    },
    {
      'id': 'merchant_hotels_com',
      'name': 'Hotels.com',
      'description': 'Hotel reservation and booking service',
      'imageUrl':
          'https://img.logo.dev/hotels.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.hotels.com',
    },

    // Education
    {
      'id': 'merchant_coursera',
      'name': 'Coursera',
      'description': 'Online learning platform for courses and degrees',
      'imageUrl':
          'https://img.logo.dev/coursera.org?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.coursera.org',
    },
    {
      'id': 'merchant_udemy',
      'name': 'Udemy',
      'description': 'Marketplace for online courses and skill development',
      'imageUrl':
          'https://img.logo.dev/udemy.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.udemy.com',
    },
    {
      'id': 'merchant_linkedin_learning',
      'name': 'LinkedIn Learning',
      'description': 'Professional development and online training platform',
      'imageUrl':
          'https://img.logo.dev/linkedin.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.linkedin.com/learning',
    },
    {
      'id': 'merchant_skillshare',
      'name': 'Skillshare',
      'description': 'Online learning community for creative skills',
      'imageUrl':
          'https://img.logo.dev/skillshare.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.skillshare.com',
    },

    // News & Media
    {
      'id': 'merchant_nyt',
      'name': 'The New York Times',
      'description': 'Digital and print newspaper subscription',
      'imageUrl':
          'https://img.logo.dev/nytimes.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.nytimes.com',
    },
    {
      'id': 'merchant_wsj',
      'name': 'The Wall Street Journal',
      'description': 'Business and financial news publication',
      'imageUrl':
          'https://img.logo.dev/wsj.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.wsj.com',
    },
    {
      'id': 'merchant_wapo',
      'name': 'The Washington Post',
      'description': 'News and journalism publication',
      'imageUrl':
          'https://img.logo.dev/washingtonpost.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.washingtonpost.com',
    },
    {
      'id': 'merchant_jumia',
      'name': 'Jumia',
      'description': 'Leading pan-African e-commerce platform',
      'imageUrl':
          'https://img.logo.dev/jumia.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.jumia.com',
    },
    {
      'id': 'merchant_konga',
      'name': 'Konga',
      'description': 'Nigerian e-commerce platform and online mall',
      'imageUrl':
          'https://img.logo.dev/konga.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.konga.com',
    },
    {
      'id': 'merchant_jiji',
      'name': 'Jiji',
      'description': 'Online Classified Ads and Marketplace in Africa',
      'imageUrl':
          'https://img.logo.dev/jiji.ng?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'https://www.jiji.ng',
    },
    {
      'id': 'merchant_alibaba',
      'name': 'Alibaba',
      'description': 'Global trade starts here.',
      'imageUrl':
          'https://img.logo.dev/www.alibaba.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.alibaba.com',
    },
    {
      'id': 'merchant_aliexpress',
      'name': 'AliExpress',
      'description': 'Shop smart, live better.',
      'imageUrl':
          'https://img.logo.dev/www.aliexpress.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.aliexpress.com',
    },
    {
      'id': 'merchant_zalando',
      'name': 'Zalando',
      'description': 'Free yourself.',
      'imageUrl':
          'https://img.logo.dev/www.zalando.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.zalando.com',
    },
    {
      'id': 'merchant_taobao',
      'name': 'Taobao',
      'description': 'There\'s nothing you can\'t buy.',
      'imageUrl':
          'https://img.logo.dev/www.taobao.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.taobao.com',
    },
    {
      'id': 'merchant_shein',
      'name': 'Shein',
      'description': 'Everyone can enjoy the beauty of fashion.',
      'imageUrl':
          'https://img.logo.dev/www.shein.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.shein.com',
    },
    {
      'id': 'merchant_temu',
      'name': 'Temu',
      'description': 'Shop like a billionaire.',
      'imageUrl':
          'https://img.logo.dev/www.temu.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.temu.com',
    },
    {
      'id': 'merchant_costco',
      'name': 'Costco',
      'description': 'Your membership pays for itself.',
      'imageUrl':
          'https://img.logo.dev/www.costco.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.costco.com',
    },
    {
      'id': 'merchant_shopee',
      'name': 'Shopee',
      'description': 'Number one shopping app in Southeast Asia and Taiwan.',
      'imageUrl':
          'https://img.logo.dev/www.shopee.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.shopee.com',
    },
    {
      'id': 'merchant_coupang',
      'name': 'Coupang',
      'description': 'Rocket delivery - order today, get it tomorrow.',
      'imageUrl':
          'https://img.logo.dev/www.coupang.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.coupang.com',
    },
    {
      'id': 'merchant_craigslist',
      'name': 'Craigslist',
      'description':
          'Local classifieds and forums for jobs, housing, and community.',
      'imageUrl':
          'https://img.logo.dev/www.craigslist.org?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.craigslist.org',
    },
    {
      'id': 'merchant_twilio',
      'name': 'Twilio',
      'description': 'Build the future of communications.',
      'imageUrl':
          'https://img.logo.dev/www.twilio.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.twilio.com',
    },
    {
      'id': 'merchant_roblox',
      'name': 'Roblox',
      'description': 'Powering imagination.',
      'imageUrl':
          'https://img.logo.dev/www.roblox.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.roblox.com',
    },
    {
      'id': 'merchant_klarna',
      'name': 'Klarna',
      'description': 'Smooth payments.',
      'imageUrl':
          'https://img.logo.dev/www.klarna.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.klarna.com',
    },
    {
      'id': 'merchant_tiktok',
      'name': 'TikTok',
      'description': 'Make your day.',
      'imageUrl':
          'https://img.logo.dev/www.tiktok.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.tiktok.com',
    },
    {
      'id': 'merchant_salesforce',
      'name': 'Salesforce',
      'description': 'We bring companies and customers together.',
      'imageUrl':
          'https://img.logo.dev/www.salesforce.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.salesforce.com',
    },
    {
      'id': 'merchant_mtn',
      'name': 'MTN',
      'description': 'Everywhere you go.',
      'imageUrl':
          'https://img.logo.dev/www.mtn.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.mtn.com',
    },
    {
      'id': 'merchant_airtel',
      'name': 'Airtel',
      'description': 'Smartphones. Dumbphones. No phones.',
      'imageUrl':
          'https://img.logo.dev/www.airtel.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.airtel.com',
    },
    {
      'id': 'merchant_t_mobile',
      'name': 'T-Mobile',
      'description': 'The Un-carrier.',
      'imageUrl':
          'https://img.logo.dev/www.t-mobile.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.t-mobile.com',
    },
    {
      'id': 'merchant_tesla',
      'name': 'Tesla',
      'description':
          'Accelerating the world\'s transition to sustainable energy.',
      'imageUrl':
          'https://img.logo.dev/www.tesla.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.tesla.com',
    },
    {
      'id': 'merchant_spacex',
      'name': 'SpaceX',
      'description': 'Making humanity multiplanetary.',
      'imageUrl':
          'https://img.logo.dev/www.spacex.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.spacex.com',
    },
    {
      'id': 'merchant_shoprite',
      'name': 'Shoprite',
      'description': 'Africa\'s largest food retailer.',
      'imageUrl':
          'https://img.logo.dev/www.shoprite.co.za?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.shoprite.co.za',
    },
    {
      'id': 'merchant_rakuten',
      'name': 'Rakuten',
      'description': 'Innovation and empowerment through technology.',
      'imageUrl':
          'https://img.logo.dev/www.rakuten.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.rakuten.com',
    },
    {
      'id': 'merchant_tmall',
      'name': 'Tmall',
      'description':
          'China\'s largest B2C online retail platform for quality brands.',
      'imageUrl':
          'https://img.logo.dev/www.tmall.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.tmall.com',
    },
    {
      'id': 'merchant_facebook_marketplace',
      'name': 'Facebook Marketplace',
      'description': 'Buy and sell in your community.',
      'imageUrl':
          'https://img.logo.dev/www.facebook.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.facebook.com',
    },
    {
      'id': 'merchant_ubuy',
      'name': 'Ubuy',
      'description': 'International shopping made easy.',
      'imageUrl':
          'https://img.logo.dev/www.ubuy.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.ubuy.com',
    },
    {
      'id': 'merchant_glovo',
      'name': 'Glovo',
      'description': 'Anything you want, delivered.',
      'imageUrl':
          'https://img.logo.dev/www.glovoapp.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.glovoapp.com',
    },
    {
      'id': 'merchant_chowdeck',
      'name': 'Chowdeck',
      'description': 'Food delivery in 30 minutes or less.',
      'imageUrl':
          'https://img.logo.dev/www.chowdeck.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.chowdeck.com',
    },
    {
      'id': 'merchant_bolt',
      'name': 'Bolt',
      'description': 'Request a ride, hop in, and go.',
      'imageUrl':
          'https://img.logo.dev/www.bolt.eu?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.bolt.eu',
    },
    {
      'id': 'merchant_indrive',
      'name': 'Indrive',
      'description': 'You name your price.',
      'imageUrl':
          'https://img.logo.dev/www.indrive.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.indrive.com',
    },
    {
      'id': 'merchant_rida',
      'name': 'Rida',
      'description': 'Your trusted ride-hailing service.',
      'imageUrl':
          'https://img.logo.dev/www.rida.app?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.rida.app',
    },
    {
      'id': 'merchant_twitch',
      'name': 'twitch',
      'description': 'Where streaming means everything.',
      'imageUrl':
          'https://img.logo.dev/www.twitch.tv?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.twitch.tv',
    },
    {
      'id': 'merchant_kfc',
      'name': 'KFC',
      'description': 'It\'s finger lickin\' good.',
      'imageUrl':
          'https://img.logo.dev/www.kfc.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.kfc.com',
    },
    {
      'id': 'merchant_dominos',
      'name': 'Dominos',
      'description': 'Oh yes we did.',
      'imageUrl':
          'https://img.logo.dev/www.dominos.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.dominos.com',
    },
    {
      'id': 'merchant_burger_king',
      'name': 'Burger King',
      'description': 'Have it your way.',
      'imageUrl':
          'https://img.logo.dev/www.burgerking.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.burgerking.com',
    },
    {
      'id': 'merchant_pizza_hut',
      'name': 'Pizza Hut',
      'description': 'No one out pizzas the hut.',
      'imageUrl':
          'https://img.logo.dev/www.pizzahut.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.pizzahut.com',
    },
    {
      'id': 'merchant_dunkin_donuts',
      'name': 'Dunkin\' Donuts',
      'description': 'America runs on Dunkin\'.',
      'imageUrl':
          'https://img.logo.dev/www.dunkindonuts.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.dunkindonuts.com',
    },
    {
      'id': 'merchant_krispy_kreme',
      'name': 'Krispy Kreme',
      'description': 'Made fresh daily.',
      'imageUrl':
          'https://img.logo.dev/www.krispykreme.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.krispykreme.com',
    },
    {
      'id': 'merchant_taco_bell',
      'name': 'Taco Bell',
      'description': 'Live más.',
      'imageUrl':
          'https://img.logo.dev/www.tacobell.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.tacobell.com',
    },
    {
      'id': 'merchant_baskin_robbins',
      'name': 'Baskin-Robbins',
      'description': 'America\'s favorite ice cream.',
      'imageUrl':
          'https://img.logo.dev/www.baskinrobbins.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.baskinrobbins.com',
    },
    {
      'id': 'merchant_tim_hortons',
      'name': 'Tim Hortons',
      'description': 'Always fresh.',
      'imageUrl':
          'https://img.logo.dev/www.timhortons.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.timhortons.com',
    },
    {
      'id': 'merchant_papa_johns',
      'name': 'Papa John\'s',
      'description': 'Better ingredients. Better pizza.',
      'imageUrl':
          'https://img.logo.dev/www.papajohns.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.papajohns.com',
    },
    {
      'id': 'merchant_panda_express',
      'name': 'Panda Express',
      'description': 'Gourmet Chinese food.',
      'imageUrl':
          'https://img.logo.dev/www.pandaexpress.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.pandaexpress.com',
    },
    {
      'id': 'merchant_five_guys',
      'name': 'Five Guys',
      'description': 'Burgers and fries done right.',
      'imageUrl':
          'https://img.logo.dev/www.fiveguys.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.fiveguys.com',
    },
    {
      'id': 'merchant_popeyes',
      'name': 'Popeyes',
      'description': 'Love that chicken from Popeyes.',
      'imageUrl':
          'https://img.logo.dev/www.popeyes.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.popeyes.com',
    },
    {
      'id': 'merchant_arbys',
      'name': 'Arby\'s',
      'description': 'We have the meats.',
      'imageUrl':
          'https://img.logo.dev/www.arbys.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.arbys.com',
    },
    {
      'id': 'merchant_netlify',
      'name': 'Netlify',
      'description': 'Build and deploy the best web experiences.',
      'imageUrl':
          'https://img.logo.dev/www.netlify.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.netlify.com',
    },
    {
      'id': 'merchant_railway',
      'name': 'Railway',
      'description': 'Bring your code, we\'ll handle the rest.',
      'imageUrl':
          'https://img.logo.dev/railway.app?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'railway.app',
    },
    {
      'id': 'merchant_render',
      'name': 'Render',
      'description':
          'Build, deploy, and scale your apps with unparalleled ease.',
      'imageUrl':
          'https://img.logo.dev/render.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'render.com',
    },
    {
      'id': 'merchant_fly_io',
      'name': 'Fly.io',
      'description': 'Deploy app servers close to your users.',
      'imageUrl': 'https://img.logo.dev/fly.io?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'fly.io',
    },
    {
      'id': 'merchant_cloudflare_pages',
      'name': 'Cloudflare Pages',
      'description': 'Lightning-fast frontend deployments on the edge.',
      'imageUrl':
          'https://img.logo.dev/pages.cloudflare.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'pages.cloudflare.com',
    },
    {
      'id': 'merchant_supabase',
      'name': 'Supabase',
      'description': 'The open source Firebase alternative.',
      'imageUrl':
          'https://img.logo.dev/supabase.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'supabase.com',
    },
    {
      'id': 'merchant_firebase',
      'name': 'Firebase',
      'description': 'Make your app the best it can be.',
      'imageUrl':
          'https://img.logo.dev/firebase.google.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'firebase.google.com',
    },
    {
      'id': 'merchant_appwrite',
      'name': 'Appwrite',
      'description': 'Build like a team of hundreds.',
      'imageUrl':
          'https://img.logo.dev/appwrite.io?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'appwrite.io',
    },
    {
      'id': 'merchant_pocketbase',
      'name': 'PocketBase',
      'description': 'Open source backend in one file.',
      'imageUrl':
          'https://img.logo.dev/pocketbase.io?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'pocketbase.io',
    },
    {
      'id': 'merchant_nhost',
      'name': 'Nhost',
      'description': 'The GraphQL backend built with open source.',
      'imageUrl':
          'https://img.logo.dev/nhost.io?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'nhost.io',
    },
    {
      'id': 'merchant_replit',
      'name': 'Replit',
      'description':
          'Build software collaboratively from anywhere in the world.',
      'imageUrl':
          'https://img.logo.dev/replit.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'replit.com',
    },
    {
      'id': 'merchant_github_codespaces',
      'name': 'GitHub Codespaces',
      'description': 'Your instant dev environment in the cloud.',
      'imageUrl':
          'https://img.logo.dev/github.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'github.com',
    },
    {
      'id': 'merchant_gitpod',
      'name': 'Gitpod',
      'description': 'Always ready to code.',
      'imageUrl':
          'https://img.logo.dev/www.gitpod.io?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.gitpod.io',
    },
    {
      'id': 'merchant_stackblitz',
      'name': 'StackBlitz',
      'description':
          'The instant fullstack web IDE for the JavaScript ecosystem.',
      'imageUrl':
          'https://img.logo.dev/stackblitz.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'stackblitz.com',
    },
    {
      'id': 'merchant_codesandbox',
      'name': 'CodeSandbox',
      'description': 'Code, review and deploy in record time.',
      'imageUrl':
          'https://img.logo.dev/codesandbox.io?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'codesandbox.io',
    },
    {
      'id': 'merchant_postman',
      'name': 'Postman',
      'description': 'API platform for building and using APIs.',
      'imageUrl':
          'https://img.logo.dev/www.postman.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.postman.com',
    },
    {
      'id': 'merchant_insomnia',
      'name': 'Insomnia',
      'description': 'Design and debug APIs like a human, not a robot.',
      'imageUrl':
          'https://img.logo.dev/insomnia.rest?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'insomnia.rest',
    },
    {
      'id': 'merchant_hoppscotch',
      'name': 'Hoppscotch',
      'description': 'Open source API development ecosystem.',
      'imageUrl':
          'https://img.logo.dev/hoppscotch.io?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'hoppscotch.io',
    },
    {
      'id': 'merchant_n8n',
      'name': 'n8n',
      'description': 'Workflow automation for technical people.',
      'imageUrl': 'https://img.logo.dev/n8n.io?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'n8n.io',
    },
    {
      'id': 'merchant_zapier',
      'name': 'Zapier',
      'description': 'Automate your work.',
      'imageUrl':
          'https://img.logo.dev/zapier.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'zapier.com',
    },
    {
      'id': 'merchant_make',
      'name': 'Make',
      'description': 'Connect apps and automate workflows.',
      'imageUrl':
          'https://img.logo.dev/www.make.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.make.com',
    },
    {
      'id': 'merchant_planetscale',
      'name': 'PlanetScale',
      'description': 'The database for developers.',
      'imageUrl':
          'https://img.logo.dev/planetscale.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'planetscale.com',
    },
    {
      'id': 'merchant_mongodb_atlas',
      'name': 'MongoDB Atlas',
      'description': 'The multi-cloud developer data platform.',
      'imageUrl':
          'https://img.logo.dev/www.mongodb.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.mongodb.com',
    },
    {
      'id': 'merchant_cockroachdb',
      'name': 'CockroachDB',
      'description': 'The cloud-native distributed SQL database.',
      'imageUrl':
          'https://img.logo.dev/www.cockroachlabs.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.cockroachlabs.com',
    },
    {
      'id': 'merchant_neon',
      'name': 'Neon',
      'description': 'Serverless Postgres built for the cloud.',
      'imageUrl':
          'https://img.logo.dev/neon.tech?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'neon.tech',
    },
    {
      'id': 'merchant_turso',
      'name': 'Turso',
      'description': 'SQLite for production. Powered by libSQL.',
      'imageUrl':
          'https://img.logo.dev/turso.tech?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'turso.tech',
    },
    {
      'id': 'merchant_redis',
      'name': 'Redis',
      'description': 'The real-time data platform.',
      'imageUrl':
          'https://img.logo.dev/redis.io?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'redis.io',
    },
    {
      'id': 'merchant_sanity',
      'name': 'Sanity',
      'description': 'The composable content cloud.',
      'imageUrl':
          'https://img.logo.dev/www.sanity.io?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.sanity.io',
    },
    {
      'id': 'merchant_contentful',
      'name': 'Contentful',
      'description': 'Compose experiences at scale.',
      'imageUrl':
          'https://img.logo.dev/www.contentful.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.contentful.com',
    },
    {
      'id': 'merchant_strapi',
      'name': 'Strapi',
      'description': 'The leading open-source headless CMS.',
      'imageUrl':
          'https://img.logo.dev/strapi.io?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'strapi.io',
    },
    {
      'id': 'merchant_payload',
      'name': 'Payload',
      'description': 'The most powerful TypeScript headless CMS.',
      'imageUrl':
          'https://img.logo.dev/payloadcms.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'payloadcms.com',
    },
    {
      'id': 'merchant_auth0',
      'name': 'Auth0',
      'description': 'Secure access for everyone.',
      'imageUrl':
          'https://img.logo.dev/auth0.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'auth0.com',
    },
    {
      'id': 'merchant_clerk',
      'name': 'Clerk',
      'description': 'More than authentication. Complete user management.',
      'imageUrl':
          'https://img.logo.dev/clerk.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'clerk.com',
    },
    {
      'id': 'merchant_workos',
      'name': 'WorkOS',
      'description': 'Enterprise-ready in days, not months.',
      'imageUrl':
          'https://img.logo.dev/workos.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'workos.com',
    },
    {
      'id': 'merchant_sentry',
      'name': 'Sentry',
      'description': 'Code breaks. Fix it faster.',
      'imageUrl':
          'https://img.logo.dev/sentry.io?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'sentry.io',
    },
    {
      'id': 'merchant_datadog',
      'name': 'Datadog',
      'description': 'See inside any stack, any app, at any scale, anywhere.',
      'imageUrl':
          'https://img.logo.dev/www.datadoghq.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.datadoghq.com',
    },
    {
      'id': 'merchant_new_relic',
      'name': 'New Relic',
      'description': 'Observability for good.',
      'imageUrl':
          'https://img.logo.dev/newrelic.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'newrelic.com',
    },
    {
      'id': 'merchant_mixpanel',
      'name': 'Mixpanel',
      'description': 'Product analytics for data-driven teams.',
      'imageUrl':
          'https://img.logo.dev/mixpanel.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'mixpanel.com',
    },
    {
      'id': 'merchant_github_actions',
      'name': 'GitHub Actions',
      'description': 'Automate your workflow from idea to production.',
      'imageUrl':
          'https://img.logo.dev/github.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'github.com',
    },
    {
      'id': 'merchant_gitlab',
      'name': 'GitLab',
      'description': 'The DevSecOps platform.',
      'imageUrl':
          'https://img.logo.dev/gitlab.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'gitlab.com',
    },
    {
      'id': 'merchant_circleci',
      'name': 'CircleCI',
      'description': 'Build better, ship faster.',
      'imageUrl':
          'https://img.logo.dev/circleci.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'circleci.com',
    },
    {
      'id': 'merchant_travis_ci',
      'name': 'Travis CI',
      'description': 'Test and deploy your code with confidence.',
      'imageUrl':
          'https://img.logo.dev/travis-ci.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'travis-ci.com',
    },
    {
      'id': 'merchant_algolia',
      'name': 'Algolia',
      'description': 'AI-powered search and discovery.',
      'imageUrl':
          'https://img.logo.dev/www.algolia.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.algolia.com',
    },
    {
      'id': 'merchant_meilisearch',
      'name': 'Meilisearch',
      'description': 'Lightning fast, ultra-relevant search engine.',
      'imageUrl':
          'https://img.logo.dev/www.meilisearch.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.meilisearch.com',
    },
    {
      'id': 'merchant_typesense',
      'name': 'Typesense',
      'description': 'Lightning-fast search built for everyone.',
      'imageUrl':
          'https://img.logo.dev/typesense.org?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'typesense.org',
    },
    {
      'id': 'merchant_resend',
      'name': 'Resend',
      'description': 'Email for developers.',
      'imageUrl':
          'https://img.logo.dev/resend.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'resend.com',
    },
    {
      'id': 'merchant_sendgrid',
      'name': 'SendGrid',
      'description': 'Email delivery and marketing campaigns.',
      'imageUrl':
          'https://img.logo.dev/sendgrid.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'sendgrid.com',
    },
    {
      'id': 'merchant_mailgun',
      'name': 'Mailgun',
      'description': 'Email for developers.',
      'imageUrl':
          'https://img.logo.dev/www.mailgun.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.mailgun.com',
    },
    {
      'id': 'merchant_postmark',
      'name': 'Postmark',
      'description': 'Fast and reliable email delivery.',
      'imageUrl':
          'https://img.logo.dev/postmarkapp.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'postmarkapp.com',
    },
    {
      'id': 'merchant_aws_lambda',
      'name': 'AWS Lambda',
      'description': 'Run code without thinking about servers.',
      'imageUrl':
          'https://img.logo.dev/aws.amazon.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'aws.amazon.com',
    },
    {
      'id': 'merchant_docker',
      'name': 'Docker',
      'description': 'Accelerate how you build, share, and run applications.',
      'imageUrl':
          'https://img.logo.dev/www.docker.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.docker.com',
    },
    {
      'id': 'merchant_kubernetes',
      'name': 'Kubernetes',
      'description': 'Production-grade container orchestration.',
      'imageUrl':
          'https://img.logo.dev/kubernetes.io?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'kubernetes.io',
    },
    {
      'id': 'merchant_hugging_face',
      'name': 'Hugging Face',
      'description': 'The AI community building the future.',
      'imageUrl':
          'https://img.logo.dev/huggingface.co?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'huggingface.co',
    },
    {
      'id': 'merchant_openai',
      'name': 'OpenAI',
      'description': 'Creating safe AGI that benefits all of humanity.',
      'imageUrl':
          'https://img.logo.dev/openai.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'openai.com',
    },
    {
      'id': 'merchant_replicate',
      'name': 'Replicate',
      'description': 'Run AI with an API.',
      'imageUrl':
          'https://img.logo.dev/replicate.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'replicate.com',
    },
    {
      'id': 'merchant_paystack',
      'name': 'Paystack',
      'description': 'Modern online and offline payments for Africa.',
      'imageUrl':
          'https://img.logo.dev/paystack.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'paystack.com',
    },
    {
      'id': 'merchant_paddle',
      'name': 'Paddle',
      'description': 'The complete payments, tax, and subscriptions solution.',
      'imageUrl':
          'https://img.logo.dev/www.paddle.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'www.paddle.com',
    },
    {
      'id': 'merchant_readme',
      'name': 'ReadMe',
      'description': 'Beautiful, personalized, interactive developer hubs.',
      'imageUrl':
          'https://img.logo.dev/readme.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'readme.com',
    },
    {
      'id': 'merchant_mintlify',
      'name': 'Mintlify',
      'description': 'Beautiful documentation that converts users.',
      'imageUrl':
          'https://img.logo.dev/mintlify.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'mintlify.com',
    },
    {
      'id': 'merchant_docusaurus',
      'name': 'Docusaurus',
      'description': 'Build optimized websites quickly, focus on your content.',
      'imageUrl':
          'https://img.logo.dev/docusaurus.io?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'website': 'docusaurus.io',
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
      try {
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
      } catch (e) {
        print('Error seeding merchant ${merchant['name']}:');
        print(e);
      }
    }
  }
}
