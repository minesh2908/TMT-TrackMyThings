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
        '''Track My Things (TMT) reminds you of product warranty expiration dates, ensuring you never miss one.''',
  ),
  const AuthSliderData(
    image: 'assets/images/2.png',
    title: 'Add Product easily',
    body:
        '''Add products and warranties by snapping a photo - the app takes care of the rest!''',
  ),
  const AuthSliderData(
    image: 'assets/images/3.png',
    title: 'Claim Warranty easily',
    body:
        '''Search, find, and access product details instantly when claiming or checking warranty.''',
  ),
];
