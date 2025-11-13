import 'package:billkeep/utils/app_enums.dart';
import 'package:drift/drift.dart';
import 'package:billkeep/database/database.dart';

class DefaultWalletProviders {
  // List of default financial providers with their details
  static final List<Map<String, dynamic>> walletProviders = [
    // ==================== TRADITIONAL BANKS (US) ====================
    {
      'id': 'provider_chase',
      'name': 'Chase Bank',
      'description': 'One of the largest banks in the United States',
      'imageUrl':
          'https://img.logokit.com/chase.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.chase.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_bank_of_america',
      'name': 'Bank of America',
      'description': 'Major banking and financial services corporation',
      'imageUrl':
          'https://img.logokit.com/bankofamerica.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.bankofamerica.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_wells_fargo',
      'name': 'Wells Fargo',
      'description': 'Multinational financial services company',
      'imageUrl':
          'https://img.logokit.com/wellsfargo.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.wellsfargo.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_citibank',
      'name': 'Citibank',
      'description': 'Global banking and financial services',
      'imageUrl':
          'https://img.logokit.com/citi.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.citi.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_us_bank',
      'name': 'U.S. Bank',
      'description': 'American banking and financial services company',
      'imageUrl':
          'https://img.logokit.com/usbank.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.usbank.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_pnc',
      'name': 'PNC Bank',
      'description': 'Banking and financial services institution',
      'imageUrl':
          'https://img.logokit.com/pnc.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.pnc.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_td_bank',
      'name': 'TD Bank',
      'description': 'American national bank and financial services',
      'imageUrl':
          'https://img.logokit.com/td.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.td.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_capital_one',
      'name': 'Capital One',
      'description': 'Banking and credit card services',
      'imageUrl':
          'https://img.logokit.com/capitalone.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.capitalone.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_ally_bank',
      'name': 'Ally Bank',
      'description': 'Online-only bank with high-yield savings',
      'imageUrl':
          'https://img.logokit.com/ally.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.ally.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_chime',
      'name': 'Chime',
      'description': 'Mobile-first financial technology company',
      'imageUrl':
          'https://img.logokit.com/chime.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.chime.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_discover',
      'name': 'Discover Bank',
      'description': 'Digital banking and payment services',
      'imageUrl':
          'https://img.logokit.com/discover.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.discover.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'US',
    },

    // ==================== INTERNATIONAL BANKS ====================
    {
      'id': 'provider_hsbc',
      'name': 'HSBC',
      'description': 'Global banking and financial services',
      'imageUrl':
          'https://img.logokit.com/hsbc.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.hsbc.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'GB',
    },
    {
      'id': 'provider_barclays',
      'name': 'Barclays',
      'description': 'British multinational bank',
      'imageUrl':
          'https://img.logokit.com/barclays.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.barclays.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'GB',
    },
    {
      'id': 'provider_rbc',
      'name': 'RBC Royal Bank',
      'description': 'Canadian multinational financial services',
      'imageUrl':
          'https://img.logokit.com/rbc.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.rbc.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'CA',
    },
    {
      'id': 'provider_scotiabank',
      'name': 'Scotiabank',
      'description': 'Canadian multinational banking corporation',
      'imageUrl':
          'https://img.logokit.com/scotiabank.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.scotiabank.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'CA',
    },
    {
      'id': 'provider_deutsche_bank',
      'name': 'Deutsche Bank',
      'description': 'German multinational investment bank',
      'imageUrl':
          'https://img.logokit.com/db.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.db.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'DE',
    },
    {
      'id': 'provider_bnp_paribas',
      'name': 'BNP Paribas',
      'description': 'French international banking group',
      'imageUrl':
          'https://img.logokit.com/bnpparibas.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.bnpparibas.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'FR',
    },
    {
      'id': 'provider_credit_suisse',
      'name': 'Credit Suisse',
      'description': 'Swiss multinational investment bank',
      'imageUrl':
          'https://img.logokit.com/credit-suisse.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.credit-suisse.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'CH',
    },
    {
      'id': 'provider_santander',
      'name': 'Santander',
      'description': 'Spanish multinational financial services',
      'imageUrl':
          'https://img.logokit.com/santander.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.santander.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'ES',
    },

    // ==================== CREDIT CARD ISSUERS ====================
    {
      'id': 'provider_american_express',
      'name': 'American Express',
      'description': 'Premium credit card and financial services',
      'imageUrl':
          'https://img.logokit.com/americanexpress.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.americanexpress.com',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_visa',
      'name': 'Visa',
      'description': 'Global payments technology company',
      'imageUrl':
          'https://img.logokit.com/visa.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.visa.com',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_mastercard',
      'name': 'Mastercard',
      'description': 'Worldwide payment solutions and technology',
      'imageUrl':
          'https://img.logokit.com/mastercard.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.mastercard.com',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'US',
    },

    // ==================== MOBILE MONEY & DIGITAL WALLETS ====================
    {
      'id': 'provider_paypal',
      'name': 'PayPal',
      'description': 'Online payment and money transfer service',
      'imageUrl':
          'https://img.logokit.com/paypal.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.paypal.com',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_venmo',
      'name': 'Venmo',
      'description': 'Peer-to-peer mobile payment service',
      'imageUrl':
          'https://img.logokit.com/venmo.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://venmo.com',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_cash_app',
      'name': 'Cash App',
      'description': 'Mobile payment and investing platform',
      'imageUrl':
          'https://img.logokit.com/cash.app?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://cash.app',
      'isFiatBank': false,
      'isCrypto': true,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_apple_pay',
      'name': 'Apple Pay',
      'description': 'Mobile payment and digital wallet by Apple',
      'imageUrl':
          'https://img.logokit.com/apple.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.apple.com/apple-pay',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_google_pay',
      'name': 'Google Pay',
      'description': 'Digital wallet and payment platform by Google',
      'imageUrl':
          'https://img.logokit.com/google.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://pay.google.com',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_samsung_pay',
      'name': 'Samsung Pay',
      'description': 'Mobile payment and digital wallet by Samsung',
      'imageUrl':
          'https://img.logokit.com/samsung.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.samsung.com/us/samsung-pay',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'KR',
    },
    {
      'id': 'provider_zelle',
      'name': 'Zelle',
      'description': 'Bank-to-bank money transfer service',
      'imageUrl':
          'https://img.logokit.com/zellepay.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.zellepay.com',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_mpesa',
      'name': 'M-Pesa',
      'description': 'Mobile money and payment service in Africa',
      'imageUrl':
          'https://img.logokit.com/safaricom.co.ke?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.safaricom.co.ke/personal/m-pesa',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'KE',
    },
    {
      'id': 'provider_mtn_momo',
      'name': 'MTN Mobile Money',
      'description': 'Mobile financial services in Africa',
      'imageUrl':
          'https://img.logokit.com/mtn.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.mtn.com/what-we-do/mobile-financial-services',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'ZA',
    },
    {
      'id': 'provider_alipay',
      'name': 'Alipay',
      'description': 'Chinese third-party mobile and online payment',
      'imageUrl':
          'https://img.logokit.com/alipay.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://global.alipay.com',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'CN',
    },
    {
      'id': 'provider_wechat_pay',
      'name': 'WeChat Pay',
      'description': 'Mobile payment platform by Tencent',
      'imageUrl':
          'https://img.logokit.com/wechat.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://pay.weixin.qq.com',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'CN',
    },
    {
      'id': 'provider_paytm',
      'name': 'Paytm',
      'description': 'Indian digital payment and financial services',
      'imageUrl':
          'https://img.logokit.com/paytm.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://paytm.com',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'IN',
    },
    {
      'id': 'provider_phonepe',
      'name': 'PhonePe',
      'description': 'Indian digital payments platform',
      'imageUrl':
          'https://img.logokit.com/phonepe.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.phonepe.com',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'IN',
    },
    {
      'id': 'provider_revolut',
      'name': 'Revolut',
      'description': 'Digital banking and financial technology',
      'imageUrl':
          'https://img.logokit.com/revolut.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.revolut.com',
      'isFiatBank': true,
      'isCrypto': true,
      'isMobileMoney': true,
      'isCreditCard': true,
      'countryISO2': 'GB',
    },
    {
      'id': 'provider_wise',
      'name': 'Wise',
      'description': 'International money transfer service',
      'imageUrl':
          'https://img.logokit.com/wise.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://wise.com',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'GB',
    },
    {
      'id': 'provider_n26',
      'name': 'N26',
      'description': 'Digital mobile bank',
      'imageUrl':
          'https://img.logokit.com/n26.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://n26.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': true,
      'countryISO2': 'DE',
    },
    {
      'id': 'provider_monzo',
      'name': 'Monzo',
      'description': 'Digital mobile-only bank',
      'imageUrl':
          'https://img.logokit.com/monzo.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://monzo.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'GB',
    },

    // ==================== CRYPTOCURRENCY PLATFORMS ====================
    {
      'id': 'provider_coinbase',
      'name': 'Coinbase',
      'description': 'Cryptocurrency exchange and wallet platform',
      'imageUrl':
          'https://img.logokit.com/coinbase.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.coinbase.com',
      'isFiatBank': false,
      'isCrypto': true,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_binance',
      'name': 'Binance',
      'description': 'Global cryptocurrency exchange platform',
      'imageUrl':
          'https://img.logokit.com/binance.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.binance.com',
      'isFiatBank': false,
      'isCrypto': true,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': null,
    },
    {
      'id': 'provider_kraken',
      'name': 'Kraken',
      'description': 'Cryptocurrency exchange and trading platform',
      'imageUrl':
          'https://img.logokit.com/kraken.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.kraken.com',
      'isFiatBank': false,
      'isCrypto': true,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_gemini',
      'name': 'Gemini',
      'description': 'Regulated cryptocurrency exchange',
      'imageUrl':
          'https://img.logokit.com/gemini.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.gemini.com',
      'isFiatBank': false,
      'isCrypto': true,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_crypto_com',
      'name': 'Crypto.com',
      'description': 'Cryptocurrency platform and Visa card',
      'imageUrl':
          'https://img.logokit.com/crypto.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://crypto.com',
      'isFiatBank': false,
      'isCrypto': true,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': null,
    },
    {
      'id': 'provider_blockchain_com',
      'name': 'Blockchain.com',
      'description': 'Cryptocurrency wallet and exchange',
      'imageUrl':
          'https://img.logokit.com/blockchain.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.blockchain.com',
      'isFiatBank': false,
      'isCrypto': true,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': null,
    },
    {
      'id': 'provider_metamask',
      'name': 'MetaMask',
      'description': 'Cryptocurrency wallet for Ethereum and tokens',
      'imageUrl':
          'https://img.logokit.com/metamask.io?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://metamask.io',
      'isFiatBank': false,
      'isCrypto': true,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': null,
    },
    {
      'id': 'provider_trust_wallet',
      'name': 'Trust Wallet',
      'description': 'Multi-cryptocurrency mobile wallet',
      'imageUrl':
          'https://img.logokit.com/trustwallet.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://trustwallet.com',
      'isFiatBank': false,
      'isCrypto': true,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': null,
    },
    {
      'id': 'provider_ledger',
      'name': 'Ledger',
      'description': 'Hardware cryptocurrency wallet',
      'imageUrl':
          'https://img.logokit.com/ledger.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.ledger.com',
      'isFiatBank': false,
      'isCrypto': true,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'FR',
    },
    {
      'id': 'provider_trezor',
      'name': 'Trezor',
      'description': 'Hardware wallet for cryptocurrency',
      'imageUrl':
          'https://img.logokit.com/trezor.io?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://trezor.io',
      'isFiatBank': false,
      'isCrypto': true,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'CZ',
    },
    {
      'id': 'provider_exodus',
      'name': 'Exodus',
      'description': 'Multi-cryptocurrency software wallet',
      'imageUrl':
          'https://img.logokit.com/exodus.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.exodus.com',
      'isFiatBank': false,
      'isCrypto': true,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_bitpay',
      'name': 'BitPay',
      'description': 'Bitcoin and cryptocurrency payment processor',
      'imageUrl':
          'https://img.logokit.com/bitpay.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://bitpay.com',
      'isFiatBank': false,
      'isCrypto': true,
      'isMobileMoney': false,
      'isCreditCard': true,
      'countryISO2': 'US',
    },

    // ==================== PAYMENT PROCESSORS ====================
    {
      'id': 'provider_stripe',
      'name': 'Stripe',
      'description': 'Online payment processing for businesses',
      'imageUrl':
          'https://img.logokit.com/stripe.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://stripe.com',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_square',
      'name': 'Square',
      'description': 'Payment and point of sale solutions',
      'imageUrl':
          'https://img.logokit.com/squareup.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://squareup.com',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_payoneer',
      'name': 'Payoneer',
      'description': 'Global payment and money transfer service',
      'imageUrl':
          'https://img.logokit.com/payoneer.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.payoneer.com',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': true,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_skrill',
      'name': 'Skrill',
      'description': 'Digital wallet and payment service',
      'imageUrl':
          'https://img.logokit.com/skrill.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.skrill.com',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'GB',
    },
    {
      'id': 'provider_neteller',
      'name': 'Neteller',
      'description': 'Online payment and money transfer',
      'imageUrl':
          'https://img.logokit.com/neteller.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.neteller.com',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': true,
      'countryISO2': 'GB',
    },

    // ==================== AFRICAN MOBILE MONEY ====================
    {
      'id': 'provider_airtel_money',
      'name': 'Airtel Money',
      'description': 'Mobile money service in Africa and Asia',
      'imageUrl':
          'https://img.logokit.com/airtel.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.airtel.in/bank',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'IN',
    },
    {
      'id': 'provider_orange_money',
      'name': 'Orange Money',
      'description': 'Mobile payment service in Africa',
      'imageUrl':
          'https://img.logokit.com/orange.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.orange.com/en/orange-money',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'FR',
    },
    {
      'id': 'provider_tigo_pesa',
      'name': 'Tigo Pesa',
      'description': 'Mobile money service in Tanzania',
      'imageUrl':
          'https://img.logokit.com/tigo.co.tz?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.tigo.co.tz',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'TZ',
    },
    {
      'id': 'provider_ecocash',
      'name': 'EcoCash',
      'description': 'Mobile money service in Zimbabwe',
      'imageUrl':
          'https://img.logokit.com/ecocash.co.zw?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.ecocash.co.zw',
      'isFiatBank': false,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'ZW',
    },

    // ==================== INVESTMENT PLATFORMS ====================
    {
      'id': 'provider_robinhood',
      'name': 'Robinhood',
      'description': 'Commission-free investing and trading',
      'imageUrl':
          'https://img.logokit.com/robinhood.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://robinhood.com',
      'isFiatBank': false,
      'isCrypto': true,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_webull',
      'name': 'Webull',
      'description': 'Commission-free stock and crypto trading',
      'imageUrl':
          'https://img.logokit.com/webull.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.webull.com',
      'isFiatBank': false,
      'isCrypto': true,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_etoro',
      'name': 'eToro',
      'description': 'Social trading and investment platform',
      'imageUrl':
          'https://img.logokit.com/etoro.com?token=pk_frbb016699d97004807432',
      'websiteUrl': 'https://www.etoro.com',
      'isFiatBank': false,
      'isCrypto': true,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'IL',
    },
  ];

  /// Seeds default providers into the database
  /// Only seeds if no providers exist yet
  static Future<void> seedDefaultProviders(AppDatabase database) async {
    // Check if providers already exist
    final existingProviders = await database
        .select(database.walletProviders)
        .get();
    if (existingProviders.isNotEmpty) {
      return; // Already seeded
    }

    // Insert all default providers
    for (final provider in walletProviders) {
      // Insert the provider
      await database
          .into(database.walletProviders)
          .insert(
            WalletProvidersCompanion(
              id: Value(provider['id'] as String),
              tempId: Value(provider['id'] as String),
              name: Value(provider['name'] as String),
              description: Value(provider['description'] as String?),
              imageUrl: Value(provider['imageUrl'] as String?),
              iconType: Value(IconSelectionType.image.name),
              websiteUrl: Value(provider['websiteUrl'] as String?),
              isFiatBank: Value(provider['isFiatBank'] as bool? ?? false),
              isCrypto: Value(provider['isCrypto'] as bool? ?? false),
              isMobileMoney: Value(provider['isMobileMoney'] as bool? ?? false),
              isCreditCard: Value(provider['isCreditCard'] as bool? ?? false),
              isDefault: const Value(true),
              isSynced: const Value(false),
            ),
          );

      // Insert countryISO2 as metadata if available
      if (provider['countryISO2'] != null) {
        await database
            .into(database.walletProviderMetadata)
            .insert(
              WalletProviderMetadataCompanion(
                providerId: Value(provider['id'] as String),
                key: const Value('countryISO2'),
                value: Value(provider['countryISO2'] as String),
                isSynced: const Value(false),
              ),
            );
      }
    }

    print('Seeded ${walletProviders.length} default providers into database');
  }
}
