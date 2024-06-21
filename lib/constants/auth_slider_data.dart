class AuthSliderData {
  const AuthSliderData({
    required this.image,
    required this.body,
    required this.title,
  });
  final String image;
  final String title;
  final String body;
}

List<AuthSliderData> sliderData = [
  const AuthSliderData(
    image: 'assets/images/1.png',
    title: 'Never miss Warranty',
    body:
        '''Warranty tracker app helps you in claiming your product warranty by reminding you of the last date of claiming warrant. So, you never miss your any product warranty.''',
  ),
  const AuthSliderData(
    image: 'assets/images/2.png',
    title: 'Add Product easily',
    body:
        '''You cna easily add any product and its warranty to app by just clicking its picture. Others things will be automatically done.''',
  ),
  const AuthSliderData(
    image: 'assets/images/3.png',
    title: 'Claim Warranty easily',
    body:
        '''At the time of claiming or checking the warranty you just need to search the product and you will have your product with its all details to you''',
  ),
];
