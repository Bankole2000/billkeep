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
          'https://img.logo.dev/chase.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/bankofamerica.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/wellsfargo.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/citi.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/usbank.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/pnc.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
      'imageUrl': 'https://img.logo.dev/td.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/capitalone.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/ally.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/chime.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/discover.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/hsbc.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/barclays.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/rbc.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/scotiabank.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
      'imageUrl': 'https://img.logo.dev/db.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/bnpparibas.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/credit-suisse.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/santander.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/americanexpress.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/visa.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/mastercard.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/paypal.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/venmo.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/cash.app?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/apple.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/google.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/samsung.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/zellepay.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/safaricom.co.ke?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/mtn.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/alipay.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/wechat.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/paytm.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/phonepe.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/revolut.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/wise.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/n26.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/monzo.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/coinbase.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/binance.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/kraken.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/gemini.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/crypto.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/blockchain.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/metamask.io?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/trustwallet.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/ledger.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/trezor.io?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/exodus.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/bitpay.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/stripe.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/squareup.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/payoneer.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/skrill.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/neteller.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/airtel.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/orange.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/tigo.co.tz?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/ecocash.co.zw?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/robinhood.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/webull.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
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
          'https://img.logo.dev/etoro.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'https://www.etoro.com',
      'isFiatBank': false,
      'isCrypto': true,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'IL',
    },
    {
      'id': 'provider_absa_bank_ghana',
      'name': 'Absa Bank Ghana',
      'description':
          'A leading financial institution serving corporate, retail and SME customers across Ghana.',
      'imageUrl':
          'https://img.logo.dev/www.absa.com.gh?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.absa.com.gh',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'GH',
    },
    {
      'id': 'provider_access_bank',
      'name': 'Access Bank',
      'description':
          'Africa\'s largest bank by customer base providing comprehensive financial services.',
      'imageUrl':
          'https://img.logo.dev/www.accessbankplc.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.accessbankplc.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_alat_by_wema',
      'name': 'ALAT by WEMA',
      'description':
          'Nigeria\'s first fully digital bank providing end-to-end banking services.',
      'imageUrl':
          'https://img.logo.dev/alat.ng?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'alat.ng',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_aso_savings_and_loans',
      'name': 'ASO Savings and Loans',
      'description':
          'A microfinance bank providing accessible financial services to individuals and SMEs.',
      'imageUrl':
          'https://img.logo.dev/www.asoplc.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.asoplc.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_bowen_mfb',
      'name': 'Bowen MFB',
      'description':
          'A microfinance bank offering banking solutions to underserved communities.',
      'imageUrl':
          'https://img.logo.dev/www.bowenmicrofinancebank.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.bowenmicrofinancebank.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_cemcs_mfb',
      'name': 'CEMCS MFB',
      'description':
          'A microfinance bank dedicated to empowering local businesses and individuals.',
      'imageUrl':
          'https://img.logo.dev/www.cemcsmfb.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.cemcsmfb.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_ecobank',
      'name': 'Ecobank',
      'description':
          'The leading pan-African bank with operations in 36 countries across the continent.',
      'imageUrl':
          'https://img.logo.dev/www.ecobank.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.ecobank.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_ekondo_mfb',
      'name': 'Ekondo MFB',
      'description':
          'A microfinance bank providing inclusive financial services to communities.',
      'imageUrl':
          'https://img.logo.dev/www.ekondomfb.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.ekondomfb.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_fidelity_bank',
      'name': 'Fidelity Bank',
      'description':
          'A full-service commercial bank offering innovative banking solutions to customers.',
      'imageUrl':
          'https://img.logo.dev/www.fidelitybank.ng?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.fidelitybank.ng',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_first_atlantic_bank_limited',
      'name': 'First Atlantic Bank Limited',
      'description':
          'A leading commercial bank in Ghana delivering quality banking services.',
      'imageUrl':
          'https://img.logo.dev/www.firstatlanticbank.com.gh?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.firstatlanticbank.com.gh',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'GH',
    },
    {
      'id': 'provider_first_national_bank_ghana',
      'name': 'First National Bank Ghana',
      'description':
          'A subsidiary of FirstRand offering retail, business and corporate banking solutions.',
      'imageUrl':
          'https://img.logo.dev/www.fnbghana.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.fnbghana.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'GH',
    },
    {
      'id': 'provider_first_bank_of_nigeria',
      'name': 'First Bank of Nigeria',
      'description':
          'Nigeria\'s premier financial services provider with a rich heritage since 1894.',
      'imageUrl':
          'https://img.logo.dev/www.firstbanknigeria.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.firstbanknigeria.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_fcmb',
      'name': 'FCMB',
      'description':
          'First City Monument Bank providing retail, commercial and investment banking services.',
      'imageUrl':
          'https://img.logo.dev/www.fcmb.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.fcmb.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_globus_bank',
      'name': 'Globus Bank',
      'description':
          'A Nigerian commercial bank focused on innovative and customer-centric banking solutions.',
      'imageUrl':
          'https://img.logo.dev/www.globusbank.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.globusbank.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_guaranty_trust_bank',
      'name': 'Guaranty Trust Bank',
      'description':
          'A leading African financial institution delivering innovative banking solutions.',
      'imageUrl':
          'https://img.logo.dev/www.gtbank.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.gtbank.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_hasal_mfb',
      'name': 'Hasal MFB',
      'description':
          'A microfinance bank providing financial services to individuals and small businesses.',
      'imageUrl':
          'https://img.logo.dev/www.hasalmfb.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.hasalmfb.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_heritage_bank',
      'name': 'Heritage Bank',
      'description':
          'A Nigerian commercial bank committed to creating, preserving and transferring wealth.',
      'imageUrl':
          'https://img.logo.dev/www.hbng.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.hbng.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_jaiz_bank',
      'name': 'Jaiz Bank',
      'description':
          'Nigeria\'s pioneer non-interest bank operating according to Islamic finance principles.',
      'imageUrl':
          'https://img.logo.dev/www.jaizbank.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.jaizbank.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_keystone_bank',
      'name': 'Keystone Bank',
      'description':
          'A leading commercial bank providing comprehensive banking and financial services.',
      'imageUrl':
          'https://img.logo.dev/www.keystonebankng.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.keystonebankng.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_kuda_bank',
      'name': 'Kuda Bank',
      'description':
          'The money app for Africans offering free transfers and accessible banking services.',
      'imageUrl':
          'https://img.logo.dev/kuda.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'kuda.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_one_finance',
      'name': 'One Finance',
      'description':
          'A digital banking platform providing innovative financial services to customers.',
      'imageUrl':
          'https://img.logo.dev/www.onefinance.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.onefinance.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_paga',
      'name': 'Paga',
      'description':
          'A leading mobile money platform enabling digital payments and financial services.',
      'imageUrl':
          'https://img.logo.dev/www.mypaga.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.mypaga.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_parallex_bank',
      'name': 'Parallex Bank',
      'description':
          'A commercial bank delivering innovative financial solutions to diverse customers.',
      'imageUrl':
          'https://img.logo.dev/www.parallexbank.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.parallexbank.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_paycom',
      'name': 'PayCom',
      'description':
          'A digital payment platform providing seamless payment and banking solutions.',
      'imageUrl':
          'https://img.logo.dev/www.paycomonline.net?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.paycomonline.net',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_polaris_bank',
      'name': 'Polaris Bank',
      'description':
          'A full-service Nigerian commercial bank providing retail and corporate banking services.',
      'imageUrl':
          'https://img.logo.dev/www.polarisbanklimited.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.polarisbanklimited.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_providus_bank',
      'name': 'Providus Bank',
      'description':
          'A commercial bank focused on delivering efficient banking services to businesses.',
      'imageUrl':
          'https://img.logo.dev/www.providusbank.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.providusbank.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_prudencial_bank',
      'name': 'Prudencial Bank',
      'description':
          'A Ghanaian bank offering comprehensive banking and financial services.',
      'imageUrl':
          'https://img.logo.dev/www.prudentialbank.com.gh?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.prudentialbank.com.gh',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'GH',
    },
    {
      'id': 'provider_rubies_mfb',
      'name': 'Rubies MFB',
      'description':
          'A microfinance bank providing accessible financial services to communities.',
      'imageUrl':
          'https://img.logo.dev/www.rubiesmfb.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.rubiesmfb.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_sparkle_mfb',
      'name': 'Sparkle MFB',
      'description':
          'A microfinance bank empowering individuals and businesses with financial solutions.',
      'imageUrl':
          'https://img.logo.dev/www.sparklemfb.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.sparklemfb.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_stanbic_ibtc',
      'name': 'Stanbic IBTC',
      'description':
          'A leading African banking group providing personal, business and corporate banking solutions.',
      'imageUrl':
          'https://img.logo.dev/www.stanbicibtcbank.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.stanbicibtcbank.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_standard_chartered_bank',
      'name': 'Standard Chartered Bank',
      'description':
          'A global bank with deep African roots providing banking and financial services.',
      'imageUrl':
          'https://img.logo.dev/www.sc.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.sc.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'US',
    },
    {
      'id': 'provider_sterling_bank',
      'name': 'Sterling Bank',
      'description':
          'A full-service national commercial bank providing diverse financial services.',
      'imageUrl':
          'https://img.logo.dev/www.sterling.ng?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.sterling.ng',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_suntrust_bank',
      'name': 'Suntrust Bank',
      'description':
          'A Nigerian commercial bank providing innovative banking solutions to customers.',
      'imageUrl':
          'https://img.logo.dev/www.suntrust.ng?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.suntrust.ng',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_taj_bank',
      'name': 'Taj Bank',
      'description':
          'Nigeria\'s leading non-interest bank offering ethical and Shariah-compliant banking.',
      'imageUrl':
          'https://img.logo.dev/www.tajbank.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.tajbank.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_tcf_mfb',
      'name': 'TCF MFB',
      'description':
          'A microfinance bank dedicated to providing financial services to local communities.',
      'imageUrl':
          'https://img.logo.dev/www.tcfmfb.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.tcfmfb.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_titan_trust_bank',
      'name': 'Titan Trust Bank',
      'description':
          'A commercial bank offering comprehensive banking solutions to individuals and businesses.',
      'imageUrl':
          'https://img.logo.dev/www.titantrustbank.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.titantrustbank.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_union_bank_of_nigeria',
      'name': 'Union Bank of Nigeria',
      'description':
          'One of Nigeria\'s oldest banks providing retail, commercial and corporate banking services.',
      'imageUrl':
          'https://img.logo.dev/www.unionbankng.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.unionbankng.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_uba',
      'name': 'UBA',
      'description':
          'Africa\'s global bank providing financial services across 20 countries and 4 continents.',
      'imageUrl':
          'https://img.logo.dev/www.ubagroup.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.ubagroup.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_unity_bank',
      'name': 'Unity Bank',
      'description':
          'A Nigerian commercial bank committed to providing accessible banking services.',
      'imageUrl':
          'https://img.logo.dev/www.unitybankng.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.unitybankng.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_vfd',
      'name': 'VFD',
      'description':
          'A microfinance bank offering innovative digital banking solutions to customers.',
      'imageUrl':
          'https://img.logo.dev/www.vfdgroup.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.vfdgroup.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': true,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_wema_bank',
      'name': 'Wema Bank',
      'description':
          'Nigeria\'s longest-surviving indigenous bank providing comprehensive banking services.',
      'imageUrl':
          'https://img.logo.dev/www.wemabank.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.wemabank.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
    },
    {
      'id': 'provider_zenith_bank',
      'name': 'Zenith Bank',
      'description':
          'Nigeria\'s largest multinational financial services provider.',
      'imageUrl':
          'https://img.logo.dev/www.zenithbank.com?token=pk_NO5TsXoiRdeWPiKGSjsG5w',
      'websiteUrl': 'www.zenithbank.com',
      'isFiatBank': true,
      'isCrypto': false,
      'isMobileMoney': false,
      'isCreditCard': false,
      'countryISO2': 'NG',
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
  }
}
