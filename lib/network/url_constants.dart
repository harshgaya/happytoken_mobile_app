class UrlConstants {
  static const BASE_URL = "https://happytokenapi.softplix.com/api/";

  ///authentication
  static const sendOtp = '${BASE_URL}send-otp';
  static const verifyOtp = '${BASE_URL}verify-otp';
  static const sendOtpShop = '${BASE_URL}send-otp-shop';
  static const verifyOtpShop = '${BASE_URL}verify-otp-shop';
  static const addName = '${BASE_URL}addUserName';
  static const generatePreSignedUrl = '${BASE_URL}admin/generatePresignedUrl';

  ///banners and categories
  static const getAllBanners = '${BASE_URL}admin/getAllBanners';
  static const getAllCategory = '${BASE_URL}admin/getAllCategory';

  ///shop
  static const addShopDetails = '${BASE_URL}addShopDetails';
  static const checkShopStatus = '${BASE_URL}checkShopStatus';

  ///user shops
  static const getVerifiedShops = '${BASE_URL}admin/getVerifiedShops';
}
